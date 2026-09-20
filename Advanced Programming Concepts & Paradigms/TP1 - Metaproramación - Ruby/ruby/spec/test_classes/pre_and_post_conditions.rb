require_relative '../../lib/dom/Contrato'

class PreAndPostConditionsExample
  include Contrato

  pre  {divisor != 0 }
  post { |result| result * divisor == dividendo }
  def dividir(dividendo, divisor)
    dividendo / divisor
  end

  def restar(minuendo, sustraendo)
    minuendo - sustraendo
  end
end