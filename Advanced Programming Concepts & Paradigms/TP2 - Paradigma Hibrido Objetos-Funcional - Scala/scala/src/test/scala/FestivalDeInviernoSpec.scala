import org.scalatest.matchers.should.Matchers._
import org.scalatest.freespec.{AnyFreeSpec}
import domain.tp_hibrido._

class FestivalDeInviernoSpec extends AnyFreeSpec {

  "Vikingos, Jinetes y Dragones" - {

    "Creacion de un Vikingo" - {
      "Sin Arma" in {
        val vikingoRandom: Vikingo = Vikingo(VikingoAttr(velocidad = 100, barbarosidad = 20, peso = 80, hambre = 30.0))

        vikingoRandom.danio should be(20)
      }
      "Con Arma" in {
        val vikingoRandom: Vikingo = Vikingo(VikingoAttr(velocidad = 100, barbarosidad = 20, peso = 80, hambre = 30.0), item = Some(Arma(10)))

        vikingoRandom.danio should be(30)
      }
      "Con Sistema de Vuelo" in {
        val vikingoRandom: Vikingo = Vikingo(VikingoAttr(velocidad = 100, barbarosidad = 20, peso = 80, hambre = 30.0), item = Some(SistemaDeVuelo))

        assert(vikingoRandom.tieneItem(SistemaDeVuelo))
      }
      "Con Comida" in {
        val vikingoRandom: Vikingo = Vikingo(VikingoAttr(velocidad = 100, barbarosidad = 20, peso = 80, hambre = 30.0), item = Some(Comida(30)))

        assert(vikingoRandom.comerSiPuede.atributos.hambre == 60.0)
      }
    }
    "Creacion de un Dragon" - {
      "Una Furia Nocturna" in {

        val furiaNocturnaDragon: Dragon = Dragon(FuriaNocturna, DragonAttr(peso = 100))

        assert(furiaNocturnaDragon.velocidad == 80)
        assert(furiaNocturnaDragon.danio == 1)
        assert(furiaNocturnaDragon.atributos.peso == 100)
      }
      "Un Nadder Mortifero" in {

        val nadderMortifero: Dragon = Dragon(NadderMortifero, DragonAttr(peso = 50))

        assert(nadderMortifero.velocidad == 10)
        assert(nadderMortifero.danio == 150)
        assert(nadderMortifero.atributos.peso == 50)
      }
      "Un Gronckle" in {

        val gronckle: Dragon = Dragon(Gronckle(100), DragonAttr(peso = 20))

        assert(gronckle.velocidad == 10)
        assert(gronckle.danio == 100)
        assert(gronckle.atributos.peso == 20)
      }

    }
    "Creacion de un Jinete" - {
      "Vikingo random con 3 dragones distintos" in {

        val vikingoRandom: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 80, peso = 100, hambre = 0.0), item = Some(Arma(10)))

        val vikingoMuyFuerte: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 100000, peso = 100, hambre = 0.0), item = Some(Arma(10)))

        val requisitoObjetoSistemaVueloTest: RequisitosParaMontar = RequisitoObjeto(SistemaDeVuelo)

        val furiaNocturnaSimple: Dragon = Dragon(FuriaNocturna, DragonAttr(peso = 10000, danio = 1000))
        val furiaNocturnaConRequisitoExtra: Dragon = Dragon(FuriaNocturna, DragonAttr(peso = 10000),
                                                              List(requisitoObjetoSistemaVueloTest))

        val nadderMortifero: Dragon = Dragon(NadderMortifero, DragonAttr(peso = 10000))

        val gronckleConMuchoPesoMaximo: Dragon = Dragon(Gronckle(1000), DragonAttr(peso = 10000))
        val gronckleConPocoPesoMaximo: Dragon = Dragon(Gronckle(10), DragonAttr(peso = 10000))


        val jineteExitoso: Option[Jinete] = vikingoRandom.montar(furiaNocturnaSimple)
        val jineteNoExitosoFuriaConRequisito: Option[Jinete] = vikingoRandom.montar(furiaNocturnaConRequisitoExtra)

        val jineteExitosoNadder: Option[Jinete] = vikingoRandom.montar(nadderMortifero)
        val jineteNoExitosoNadder: Option[Jinete] = vikingoMuyFuerte.montar(nadderMortifero)

        val jineteExitosoGronckle: Option[Jinete] = vikingoRandom.montar(gronckleConMuchoPesoMaximo)
        val jineteNoExitosoGronckle: Option[Jinete] = vikingoMuyFuerte.montar(gronckleConPocoPesoMaximo)


        assert(jineteExitoso.get.danio == 1000 + 80 + 10)

        jineteNoExitosoFuriaConRequisito shouldBe None

        assert(jineteExitosoNadder.get.danio == 150 + 90)
        jineteNoExitosoNadder shouldBe None

        assert(jineteExitosoGronckle.get.danio == 50000 + 80 + 10)
        jineteNoExitosoGronckle shouldBe None

      }
    }
  }

  "Postas" - {

    "Comparacion de dos vikingos" - {
      "esMejorQue" in {
        val vikingoMuchoDmg: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 10000, peso = 100, hambre = 30.0), item =Some(Arma(1000)))
        val vikingoPocoDmg: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 10, peso = 100, hambre = 30.0), item =Some(Arma(10)))

        val combate: Combate = Combate()

        vikingoMuchoDmg.esMejorQue(vikingoPocoDmg)(combate) should be(true)
      }
      "postas con criterios" in {
        val vikingoConBarbarosidadAlta: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 10000, peso = 100, hambre = 30.0),item = Some(Arma(1000)))
        val vikingoConBarbarosidadBaja: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 10, peso = 100, hambre = 30.0), item =Some(Arma(10)))

        val vikingoCargaMuchoPeso: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 100, peso = 1000, hambre = 30.0),item = Some(Arma(1000))) //Carga 700
        val vikingoCargaPocoPeso: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 5, peso = 10, hambre = 30.0), item =Some(Arma(10))) //Carga 15

        val combate: Posta = Combate(List(p => p.barbarosidad > 100))

        val pescaSinCriterio : Posta = Pesca()
        val pescaConCriterio: Posta = Combate(List(p => p.pesoQuePuedeCargar > 40))

        val carreraSinCriterio : Posta = Carrera(10)
        val carreraConCriterio : Posta = Carrera(10, Some(p => p.velocidad > 20))

        combate.puedeParticipar(vikingoConBarbarosidadAlta) should be(true)
        combate.puedeParticipar(vikingoConBarbarosidadBaja) should be(false)

        pescaSinCriterio.puedeParticipar(vikingoCargaMuchoPeso) should be(true)
        pescaSinCriterio.puedeParticipar(vikingoCargaPocoPeso) should be(true)

        pescaConCriterio.puedeParticipar(vikingoCargaMuchoPeso) should be(true)
        pescaConCriterio.puedeParticipar(vikingoCargaPocoPeso) should be(false)

      }
      "Participar de una posta" in {
        val vikingoConBarbarosidadAlta1: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 10000, peso = 100, hambre = 30.0),
                                                                        item = Some(Arma(1000)))
        val vikingoConBarbarosidadAlta2: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 9000, peso = 100, hambre = 30.0),
                                                                        item = Some(Arma(1000)))
        val vikingoConBarbarosidadAlta3: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 8000, peso = 100, hambre = 30.0),
                                                                        item = Some(Arma(1000)))
        val vikingoConBarbarosidadBaja: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 5, peso = 100, hambre = 30.0),
                                                                      item = Some(Arma(1000)))

        val vikingoConPesoAlto: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 8000, peso = 100000, hambre = 30.0), item = Some(Arma(1000)))
        val vikingoConPesoBajo: Vikingo = Vikingo(VikingoAttr(velocidad = 20, barbarosidad = 1, peso = 1, hambre = 30.0))

        val combate: Posta = Combate(List(p => p.barbarosidad > 100))

        val criterioPesoMinimo30kg: CriterioParticipacion = CriterioPesoMinimo(100)

        val combate2: Posta = Combate(List(criterioPesoMinimo30kg))


        val listaParticipantes : List[Participante] = List(vikingoConBarbarosidadAlta1, vikingoConBarbarosidadAlta2, vikingoConBarbarosidadAlta3, vikingoConBarbarosidadBaja)

        val listaParticipantes2: List[Participante] = List(vikingoConPesoAlto, vikingoConPesoAlto,vikingoConPesoAlto, vikingoConPesoBajo, vikingoConPesoBajo, vikingoConPesoBajo)

        val resultado = combate.participar(listaParticipantes)
        val resultado2 = combate2.participar(listaParticipantes2)


        assert(resultado.size == 3)
        assert(resultado2.size == 3)
        print(resultado)
      }
      "Mejor Montura" in {
        val vikingoConBarbarosidadAlta1: Vikingo = Vikingo(VikingoAttr(velocidad = 10, barbarosidad = 1000, peso = 10, hambre = 0.0))

        val furiaNocturnaSimple: Dragon = Dragon(FuriaNocturna, DragonAttr(peso = 10000, danio = 1000))
        val furiaNocturnaMedia: Dragon = Dragon(FuriaNocturna, DragonAttr(peso = 10000, danio = 2000))
        val furiaNocturnaMejor: Dragon = Dragon(FuriaNocturna, DragonAttr(peso = 10000, danio = 3000))
        val nadderMortifero: Dragon = Dragon(NadderMortifero, DragonAttr(peso = 10000))

        val combate: Posta = Combate()
        val listaDragones: List[Dragon] = List(furiaNocturnaSimple, furiaNocturnaMedia, furiaNocturnaMejor, nadderMortifero)

        val resultado = mejorMontura(Combate())(listaDragones)(vikingoConBarbarosidadAlta1)

        assert(resultado.danio == 1000 + 3000)
        print(resultado)

      }

    }

  }
  "El Torneo" - {

    val vikingo1 = Vikingo(VikingoAttr(100, 50, 70, 0.0))
    val vikingo2 = Vikingo(VikingoAttr(90, 60, 60, 0.0))
    val vikingo3 = Vikingo(VikingoAttr(80, 40, 80, 0.0))
    val vikingo4 = Vikingo(VikingoAttr(70, 55, 85, 0.0))
    val dragones = List(
      Dragon(FuriaNocturna, DragonAttr(peso = 100)),
      Dragon(NadderMortifero, DragonAttr(peso = 80)),
      Dragon(Gronckle(150), DragonAttr(peso = 90))
    )
    val postas = List(Combate(), Carrera(10), Pesca())

    "Torneo con regla estándar" in {
      val resultado = torneo(List(vikingo1, vikingo2, vikingo3, vikingo4), postas, dragones, EstandarClasico)

      resultado shouldBe a [Ganador]
      assert(resultado == Ganador(vikingo2))

    }

    "Torneo con regla de eliminación" in {
      val resultado = torneo(List(vikingo1, vikingo2, vikingo3, vikingo4), postas, dragones, Eliminacion(1))

      resultado shouldBe a [Ganador]
      assert(resultado == Ganador(vikingo2))
    }

    "Torneo inverso" in {
      val resultado = torneo(List(vikingo1, vikingo2, vikingo3, vikingo4), postas, dragones, TorneoInverso)

      resultado shouldBe a [Ganador]
      assert(resultado == Ganador(vikingo2))

    }

    "Torneo con handicap" in {
      val resultado = torneo(List(vikingo1, vikingo2, vikingo3, vikingo4), postas, dragones, Handicap)

      resultado shouldBe a [Ganador]
      assert(resultado == Ganador(vikingo2))

    }

    "Torneo con ban de dragones" in {
      val banSoloFuria = ConBan(_.raza == FuriaNocturna)
      val resultado = torneo(List(vikingo1, vikingo2), postas, dragones, banSoloFuria)

      resultado shouldBe a [Ganador]
      assert(resultado == Ganador(vikingo2))
    }

    "Torneo por equipos" in {
      val equipo1 = List(vikingo1, vikingo2)
      val equipo2 = List(vikingo3, vikingo4)
      
      val equipoGanador = List(vikingo2)

      val resultado = torneo(List(equipo1, equipo2), postas, dragones, PorEquipos)

      resultado shouldBe a [EquipoGanador]
      assert(resultado == EquipoGanador(equipoGanador))
    }

    "Torneo con todos descalificados termina sin ganador" in {
      val sinParticipantes: List[Participante] = List()
      val resultado = torneo(sinParticipantes, postas, dragones, EstandarClasico)

      resultado shouldBe SinGanador
    }
    "Torneo con un solo vikingo devuelve ese ganador" in {
      val vikingoUnico = Vikingo(VikingoAttr(velocidad = 80, barbarosidad = 40, peso = 70, hambre = 0.0))
      val vikingoFullHambre = Vikingo(VikingoAttr(velocidad = 80, barbarosidad = 40, peso = 70, hambre = 100.0))

      val resultado = torneo(List(vikingoUnico, vikingoFullHambre), postas, dragones, EstandarClasico)

      resultado shouldBe Ganador(vikingoUnico)
    }
  }

}