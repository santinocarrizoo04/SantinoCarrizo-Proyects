module Contrato
  def self.included(base)
    base.extend MetodosDeClase
  end
end

module MetodosDeClase

  def before_and_after_each_call(before, after = proc{})
    @previos_globales ||= []
    @posteriores_globales ||= []
    @previos_globales << before
    @posteriores_globales << after
  end

  def method_added(name)
    return if @previos_globales.nil? || @posteriores_globales.nil?

    @dict_precondiciones ||= {}
    @dict_postcondiciones ||= {}

    # ----- Una sola precondicion y una sola postcondicion por metodo -----
    precondicion = self.instance_variable_get(:@precondicion)
    postcondicion = self.instance_variable_get(:@postcondicion)

    agregar_condicion_al_diccionario(name, :pre, @dict_precondiciones, precondicion)
    agregar_condicion_al_diccionario(name, :post, @dict_postcondiciones, postcondicion)

    # ----- Aca self es la clase que implementa los contratos -----
    clase = self

    __non_recursive__ do

      original_method = instance_method(name)

      define_method(name) do |*args, &block|

        # ----- Self en define_method es la instancia de la clase que implementa el contrato -----
        # ----- Self.class es la clase que implementa el contrato --> La llamamos "clase" -----

        nombre_parametros = original_method.parameters.map(&:last)
        clase.definir_getters_params(self, nombre_parametros, args)

        # ----- Precondicion -----
        precondiciones_dict = clase.instance_variable_get(:@dict_precondiciones)
        clase.ejecutar_precondicion_si_tiene(precondiciones_dict,*args, name, self)

        # ----- Invariantes previas -----
        clase.ejecutar_invariantes_previas(clase, self, *args)

        # ----- Metodo original -----
        resultado = original_method.bind(self).call(*args, &block)

        # ----- Invariantes posteriores -----
        clase.ejecutar_invariantes_posteriores(clase, self, resultado)

        # ----- Postcondicion -----
        postcondiciones_dict = clase.instance_variable_get(:@dict_postcondiciones)
        clase.ejecutar_postcondicion_si_tiene(postcondiciones_dict,resultado, name, self)

        resultado
      end
    end

    # ----- Reiniciar las variables de instancia para que no se acumulen -----
    self.instance_variable_set(:@postcondicion, nil)
    self.instance_variable_set(:@precondicion, nil)
  end

  # ----- A partir de aca self es la clase que implementa el contrato -----

  # ----- COMPORTAMIENTO PRINCIPAL -----

  def invariant(&block)

    bloque_explosivo = convertir_a_bloque_explosivo(&block)
    before_and_after_each_call(bloque_explosivo, bloque_explosivo)

  end

  def pre(&block)

    condicion(:pre, &block)

  end

  def post(&block)

    condicion(:post, &block)

  end

  # ----- METODOS SECUNDARIOS -----

  def definir_getters_params(ctx, nombres, args) # Crea getters para todos los parametros de un metodo

    nombres.each_with_index do |nombre, i|
      valor = args[i]
      ctx.define_singleton_method(nombre) { ctx.instance_variable_get("@#{nombre}") || valor }
    end

  end

  def agregar_condicion_al_diccionario(name, tipo ,dict_condiciones, condicion)

    if tipo == :pre && !condicion.nil?
      dict_condiciones[name] = condicion.clone
    elsif tipo == :post && !condicion.nil?
      dict_condiciones[name] = condicion.clone
    end

  end

  # ----- Generalizacion de pre y post -----
  def condicion(tipo, &block)

    # ----- Para que no quede ninguno en nil si tengo solo pre o solo post -----
    @dict_precondiciones ||= {}
    @dict_postcondiciones ||= {}

    # ----- Para que pueda tener pre/post sin invariantes -----
    @previos_globales ||= []
    @posteriores_globales ||= []

    bloque_explosivo = convertir_a_bloque_explosivo(&block)

    if tipo == :pre
      @precondicion = bloque_explosivo
      self.instance_variable_set(:@precondicion, bloque_explosivo)
    elsif tipo == :post
      @postcondicion = bloque_explosivo
      self.instance_variable_set(:@postcondicion, bloque_explosivo)
    end

  end

  def convertir_a_bloque_explosivo(&block) #Generalizacion del bloque explosivo

    bloque_explosivo = proc do |*args|

      unless instance_exec(*args, &block)
        raise ExcepcionGeneral.new
      end

    end

    bloque_explosivo

  end

  def ejecutar_precondicion_si_tiene(dict_condiciones, *args, name, instancia)

    if dict_condiciones.key?(name)
      precond = dict_condiciones[name]
      instancia.instance_exec(*args, &precond)
    end

  end

  def ejecutar_postcondicion_si_tiene(dict_condiciones, resultado, name, instancia)

    if dict_condiciones.key?(name)
      precond = dict_condiciones[name]
      instancia.instance_exec(resultado, &precond)
    end

  end

  def ejecutar_invariantes_previas(clase, instancia, *args)
    clase.instance_variable_get(:@previos_globales).each { |b| instancia.instance_exec(*args, &b) }
  end

  def ejecutar_invariantes_posteriores(clase, instancia, resultado)
    clase.instance_variable_get(:@previos_globales).each { |b| instancia.instance_exec(resultado, &b) }
  end

  # ----- EVITAR LOOP -----

  def __non_recursive__
    return if Thread.current[:__non_recursive__]

    Thread.current[:__non_recursive__] = true
    yield
    Thread.current[:__non_recursive__] = false

  end

end

# ----- EXCEPCIONES -----

class ExcepcionGeneral < StandardError
  def initialize(msg="No cumple con las condiciones")
    super(msg)
  end
end
