require_relative '../../lib/dom/Contrato'

class InvariantExample
  include Contrato

  attr_accessor :vida, :fuerza

  def initialize
    @vida = 1000
    @fuerza = 99
  end

  invariant {vida >= 10}
  invariant {fuerza > 0 && fuerza < 100}

  def mensaje
    puts "---- La vida es #{vida} ----"
    return vida
  end

  def pocaVida
    @vida = 1
    puts "---- La vida es #{vida} ----"
  end

  def muchaFuerza
    @fuerza = 1000
    puts "---- La fuerza es #{fuerza} ----"
  end

end