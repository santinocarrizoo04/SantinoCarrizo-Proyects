describe Prueba do
  let(:prueba) { Prueba.new }

  describe '#materia' do
    it 'debería pasar este test' do
      expect(prueba.materia).to be :tadp
    end
  end
end

describe BeforeAndAfterExample do
  let(:baf) { BeforeAndAfterExample.new }

  describe '#Pruebas con before_and_after' do
    it 'Prueba basica sin parametros' do
      expect(baf.mensaje).to be true
    end

    it 'Prueba con un parametro' do
      expect(baf.metodo_con_un_parametro(100)).to be true
    end

    it 'Prueba con varios parametros' do
      expect(baf.metodo_con_varios_parametros(100,200,300)).to be true
    end
    #Testear casos donde deberia tirar error
  end
end

describe InvariantExample do
  let(:inv) { InvariantExample.new }

  describe '#Pruebas con Invariant' do
    it 'Prueba basica sin errores' do
      expect(inv.mensaje).to be 1000
    end

    it 'Prueba poca vida - No cumple con las invariantes' do
      expect{inv.pocaVida}.to raise_error ExcepcionGeneral
    end

    it 'Prueba con mucha fuerza - No cumple con las invariantes' do
      expect{inv.muchaFuerza}.to raise_error ExcepcionGeneral
    end
  end
end

describe PreAndPostConditionsExample do
  let(:pre_post) { PreAndPostConditionsExample.new }

  describe '#Pruebas con Precondiciones y Postcondiciones' do
    it 'Prueba basica con condiciones y sin errores' do
      expect(pre_post.dividir(10,2)).to be 5
    end

    it 'Prueba resta sin condiciones' do
      expect(pre_post.restar(10,2)).to be 8
    end

    it 'Prueba con condiciones y con errores' do
      expect{pre_post.dividir(10,0)}.to raise_error ExcepcionGeneral
    end
  end
end

describe Pila do

  describe '#Pruebas con Pila' do
    it 'Prueba initialize OK' do
      expect(Pila.new(10)).to be_a Pila
    end

    it 'Prueba initialize no cumple INVARANT' do
      expect{Pila.new(-1)}.to raise_error ExcepcionGeneral
    end

    it 'Prueba push OK' do
      pila = Pila.new(10)
      pila.push(1)
      expect(pila.top).to eq(1)
      expect(pila.height).to eq(1)
    end

    it 'Prueba push a una pila FULL' do
      pila = Pila.new(1)
      pila.push(1)
      expect(pila.top).to eq(1)
      expect(pila.height).to eq(1)
      expect{pila.push(1)}.to raise_error ExcepcionGeneral
    end

    it 'Prueba pop' do
      pila = Pila.new(1)
      pila.push(1)
      expect(pila.top).to eq(1)
      expect(pila.height).to eq(1)
      expect(pila.pop).to eq(1)
    end

    it 'Prueba pop vacia' do
      pila = Pila.new(1)
      expect{pila.pop}.to raise_error ExcepcionGeneral
    end

    it 'Prueba top vacia' do
      pila = Pila.new(1)
      expect{pila.top}.to raise_error ExcepcionGeneral
    end

  end
end

describe ExtraTest do

  describe 'Pruebas extra de invariantes, precondiciones y postcondiciones' do

    it 'Prueba initialize OK' do
      expect(ExtraTest.new(1000).saldo).to be 1000
    end

    it 'Prueba initialize en 0' do
      expect(ExtraTest.new(0).saldo).to be 0
    end

    it 'Prueba initialize saldo negativo' do
      expect{ExtraTest.new(-1000)}.to raise_error ExcepcionGeneral
    end

    it 'Prueba depositar OK' do
      cuenta = ExtraTest.new(1000)
      expect(cuenta.depositar(100)).to be 1100
    end

    it 'Prueba depositar 0' do
      cuenta = ExtraTest.new(1000)
      expect{cuenta.depositar(0)}.to raise_error ExcepcionGeneral
    end

    it 'Prueba depositar negativo' do
      cuenta = ExtraTest.new(1000)
      expect{cuenta.depositar(-1000)}.to raise_error ExcepcionGeneral
    end

    it 'Prueba depositar check postcondicion' do
      cuenta = ExtraTest.new(1000)
      monto = 1000
      cuenta.depositar(monto)
      expect(cuenta.saldo >= monto).to be true
    end

    it 'Prueba depositar check postcondicion 2' do
      cuenta = ExtraTest.new(0)
      monto = 1000
      cuenta.depositar(monto)
      expect(cuenta.saldo == monto).to be true
    end

    it 'Prueba retirar OK' do
      cuenta = ExtraTest.new(1000)
      monto = 100
      cuenta.retirar(monto)
      expect(cuenta.saldo).to be 900
    end

    it 'Prueba retirar 0' do
      cuenta = ExtraTest.new(1000)
      monto = 0
      expect{cuenta.retirar(monto)}.to raise_error ExcepcionGeneral
    end

    it 'Prueba retirar mas del saldo' do
      cuenta = ExtraTest.new(1000)
      monto = 100000000
      expect{cuenta.retirar(monto)}.to raise_error ExcepcionGeneral
    end

    it 'Prueba retirar todo' do
      cuenta = ExtraTest.new(1000)
      monto = 1000
      cuenta.retirar(monto)
      expect(cuenta.saldo).to be 0
    end

  end
end