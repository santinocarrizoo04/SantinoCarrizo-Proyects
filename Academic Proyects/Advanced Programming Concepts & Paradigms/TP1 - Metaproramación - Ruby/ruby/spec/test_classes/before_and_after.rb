require_relative '../../lib/dom/Contrato'

class BeforeAndAfterExample
  include Contrato

  before_and_after_each_call( proc{ puts 'Mensaje anterior 1' }, proc{ puts 'Mensaje posterior 1' })
  before_and_after_each_call( proc{ puts 'Mensaje anterior 2 - UNICO' }) #solo before
  before_and_after_each_call(proc{}, proc{puts 'Mensaje posterior 3 - UNICO'}) #solo after

  def mensaje
    puts '---- Mensaje ultra secreto ----'
    return true
  end

  def metodo_con_un_parametro(param)
    puts "---- El parametro es #{param} ----"
    return true
  end

  def metodo_con_varios_parametros(param, param2, param3)
    puts "---- Los parametros son #{param},#{param2},#{param3} ----"
    return true
  end

end