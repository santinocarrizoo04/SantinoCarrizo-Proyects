require_relative '../../lib/dom/Contrato'

class ExtraTest
  include Contrato

  attr_accessor :saldo

  invariant { saldo >= 0 }

  def initialize(saldo)
    @saldo = saldo
  end

  pre { monto > 0 }
  post { saldo >= monto }
  def depositar(monto)
    @saldo += monto
    consultar_saldo
  end

  pre { cantidad > 0 && cantidad <= saldo }
  def retirar(cantidad)
    @saldo -= cantidad
    consultar_saldo
  end

  def consultar_saldo
    @saldo
  end

end