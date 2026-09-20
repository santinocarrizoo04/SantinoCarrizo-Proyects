package domain

package object tp_hibrido {

  // ITEMS ----------------------------------------------------------------------------------------
  trait Item {}

  case class Arma(danioExtra: Int) extends Item

  case class Comida(porcentajeRecuperacion: Int) extends Item

  case object SistemaDeVuelo extends Item

  case object Montura extends Item

  // VIKINGOS ----------------------------------------------------------------------------------------

  case class VikingoAttr(velocidad: Int, barbarosidad: Int, peso: Int, hambre: Double) {
    require(velocidad > 0, "La velocidad debe ser mayor a 0")
    require(barbarosidad > 0, "La barbarosidad debe ser mayor a 0")
    require(peso > 0, "El peso que puede cargar debe ser mayor a 0")
    require(hambre >= 0 && hambre <= 100, "El hambre debe estar entre 0 y 100")
  }

  case class Vikingo(atributos: VikingoAttr, porcetajeParticipacion: Int = 100, coeficienteHambre: Int = 1,
                     item: Option[Item] = None) extends Participante {

    override def pesoQuePuedeCargar: Int = (atributos.peso / 2) + (2 * atributos.barbarosidad)

    override def aumentarHambre(porcentaje: Int): Vikingo =
      this.copy(atributos = atributos.copy(hambre =
        (coeficienteHambre * (atributos.hambre + atributos.hambre * porcentaje / 100)).min(100)))

    override def velocidad: Int = atributos.velocidad

    override def barbarosidad: Int = atributos.barbarosidad

    override def danio: Int = item match {
      case Some(Arma(danioExtra)) => atributos.barbarosidad + danioExtra
      case _ => atributos.barbarosidad
    }

    override def puedeParticipar(porcentajehambre: Int): Boolean =
      aumentarHambre(porcentajehambre).atributos.hambre < porcetajeParticipacion

    override def tieneItem(itemBuscado: Item): Boolean = item.contains(itemBuscado)

    def comerSiPuede: Vikingo = item match {
      case Some(Comida(porcentajeRecuperacion)) => this.copy(atributos = atributos.copy(hambre = (atributos.hambre + porcentajeRecuperacion).min(100)))
      case _ => this
    }

    def montar(dragon: Dragon): Option[Jinete] = {

      Jinete(this, dragon) match {
        case jinete if dragon.puedeSerMontadoPor(this) => Some(jinete)
        case _ => None
      }
    }

    override def desmontar: Vikingo = this.copy()

  }

  val Hipo: Vikingo = Vikingo(VikingoAttr(velocidad = 100, barbarosidad = 20, peso = 80, hambre = 0.0), item = Some(SistemaDeVuelo))

  val Astrid: Vikingo = Vikingo(VikingoAttr(velocidad = 70, barbarosidad = 30, peso = 90, hambre = 0.0), item = Some(Arma(30)))

  val Patan: Vikingo = Vikingo(VikingoAttr(velocidad = 50, barbarosidad = 50, peso = 150, hambre = 0.0), item = Some(Arma(100)))

  val Patapez: Vikingo = Vikingo(VikingoAttr(velocidad = 100, barbarosidad = 10, peso = 80, hambre = 0.0),
    porcetajeParticipacion = 50, coeficienteHambre = 2, item = Some(Comida(30)))

  // DRAGONES ----------------------------------------------------------------------------------------

  trait Raza {}

  case object FuriaNocturna extends Raza

  case object NadderMortifero extends Raza

  case class Gronckle(pesoMaximo: Int) extends Raza {
    require(pesoMaximo > 0, "El peso maximo debe ser mayor a 0")
  }

  case class DragonAttr(velocidadBase: Int = 60, peso: Int, danio: Int = 1) {
    require(velocidadBase > 0, "La velocidad debe ser mayor a 0")
    require(peso > 0, "El peso debe ser mayor a 0")
    require(danio > 0, "El daño debe ser mayor a 0")
  }

  case class Dragon(raza: Raza, atributos: DragonAttr, requisitosAdicionales: List[RequisitosParaMontar] = List()) {

    def velocidad: Int = {
      raza match {
        case FuriaNocturna => (atributos.velocidadBase * 3 - atributos.peso).max(0)
        case NadderMortifero => (atributos.velocidadBase - atributos.peso).max(0)
        case Gronckle(_) => ((atributos.velocidadBase / 2) - atributos.peso).max(0)
      }
    }

    def danio: Int = {
      raza match {
        case FuriaNocturna => atributos.danio
        case NadderMortifero => 150
        case Gronckle(_) => 5 * atributos.peso
      }
    }

    def puedeSerMontadoPor(vikingo: Vikingo): Boolean = {
      vikingo.atributos.peso <= (atributos.peso * 0.2) && requisitosAdicionales(vikingo)
    }

    def requisitosAdicionales(vikingo: Vikingo): Boolean = {
      raza match {
        case Gronckle(pesoMaximo: Int) => pesoMaximo > vikingo.atributos.peso && requisitosDeTodos(vikingo)
        case NadderMortifero => vikingo.danio <= this.danio && requisitosDeTodos(vikingo)
        case _ => requisitosDeTodos(vikingo)
      }
    }

    def requisitosDeTodos(vikingo: Vikingo): Boolean = requisitosAdicionales.forall(requisito => requisito(vikingo))

  }

  type RequisitosParaMontar = Vikingo => Boolean

  object RequisitoBarbarosidad {
    def apply(minimoBarbarosidad: Int): RequisitosParaMontar =
      (vikingo: Vikingo) => vikingo.atributos.barbarosidad > minimoBarbarosidad
  }

  val requisitoBarbarosidad100: RequisitosParaMontar = RequisitoBarbarosidad(100)

  object RequisitoObjeto {
    def apply(item: Item): RequisitosParaMontar =
      (vikingo: Vikingo) => vikingo.tieneItem(SistemaDeVuelo)
  }

  val requisitoObjetoSistemaVuelo: RequisitosParaMontar = RequisitoObjeto(SistemaDeVuelo)

  // JINETES ----------------------------------------------------------------------------------------

  case class Jinete(vikingo: Vikingo, dragon: Dragon) extends Participante {

    override def pesoQuePuedeCargar: Int = ((dragon.atributos.peso * 0.2) - vikingo.atributos.peso).toInt

    override def danio: Int = vikingo.danio + dragon.danio

    override def velocidad: Int = (dragon.atributos.velocidadBase - vikingo.atributos.peso).max(0)

    override def aumentarHambre(porcentaje: Int): Participante =
      this.copy(vikingo = vikingo.aumentarHambre(5), dragon)

    override def puedeParticipar(porcentajehambre: Int): Boolean = vikingo.puedeParticipar(5)

    override def barbarosidad: Int = vikingo.atributos.barbarosidad

    override def tieneItem(item: Item): Boolean = vikingo.tieneItem(item)
    
    override def desmontar: Vikingo = vikingo.copy()

  }

  // PARTICIPANTES ----------------------------------------------------------------------------------------

  trait Participante {
    def velocidad: Int

    def danio: Int

    def pesoQuePuedeCargar: Int

    def aumentarHambre(porcentaje: Int): Participante

    def puedeParticipar(porcentajehambre: Int): Boolean

    def barbarosidad: Int

    def tieneItem(item: Item): Boolean

    def esMejorQue(otro: Participante)(posta: Posta): Boolean = posta.performance(this) > posta.performance(otro)
    
    def desmontar : Vikingo
  }

  // POSTAS ----------------------------------------------------------------------------------------

  trait Posta {
    def performance(participante: Participante): Int

    def aumentoHambre: Int

    def puedeParticipar(participante: Participante): Boolean = participante.puedeParticipar(aumentoHambre)

    def hacerJugar(listaParticipantes: List[Participante]): List[Participante] = {
      listaParticipantes.map(p => p.aumentarHambre(aumentoHambre))
    }

    def participar(participantes: List[Participante]): List[Participante] = {
      val participantesValidos = participantes.filter(puedeParticipar)

      val participantesLuegoDeJugar = hacerJugar(participantesValidos)

      participantesLuegoDeJugar.sortBy(performance).reverse
    }
  }

  type CriterioParticipacion = Participante => Boolean

  object CriterioPesoMinimo {
    def apply(pesoMinimo: Int): CriterioParticipacion = _.pesoQuePuedeCargar >= pesoMinimo
  }

  val criterioPesoMinimo0kg: CriterioParticipacion = CriterioPesoMinimo(0)
  val criterioPesoMinimo30kg: CriterioParticipacion = CriterioPesoMinimo(30)

  /*class TieneMontura {
    def unapply(participante: Participante): Option[Boolean] = {
      if (participante.tieneItem(Montura)) {
        Some(true)
      } else {
        None
      }

    }
  }*/

  object CriterioTieneItem {
    def apply(item: Item): RequisitosParaMontar =
      _.tieneItem(SistemaDeVuelo)
  }

  val criterioTieneMontura: RequisitosParaMontar = CriterioTieneItem(Montura)


  case class Pesca(criterioPesoMinimo: Option[CriterioParticipacion] = None) extends Posta {
    override def performance(participante: Participante): Int = participante.pesoQuePuedeCargar

    override def aumentoHambre: Int = 5

    override def puedeParticipar(participante: Participante): Boolean = {
      criterioPesoMinimo match {
        case Some(criterio) => participante.puedeParticipar(aumentoHambre) && criterio(participante)
        case None => participante.puedeParticipar(aumentoHambre)
      }
    }
  }

  case class Combate(criterios: List[CriterioParticipacion] = List()) extends Posta {
    override def performance(participante: Participante): Int = participante.danio

    override def aumentoHambre: Int = 10

    override def puedeParticipar(participante: Participante): Boolean =
      participante.puedeParticipar(aumentoHambre) && criterios.forall(criterio => criterio(participante))
  }

  case class Carrera(kilometros: Int, criterioMontura: Option[CriterioParticipacion] = None) extends Posta {
    override def performance(participante: Participante): Int = participante.velocidad

    override def aumentoHambre: Int = kilometros

    override def puedeParticipar(participante: Participante): Boolean = {
      criterioMontura match {
        case Some(criterio) => participante.puedeParticipar(aumentoHambre) && criterio(participante)
        case None => participante.puedeParticipar(aumentoHambre)
      }
    }
  }

  // MEJOR MONTURA ----------------------------------------------------------------------------------------

  def mejorMontura(posta: Posta)(dragones: List[Dragon])(vikingo: Vikingo): Participante = {
    val listaParticipantes: List[Participante] = List(vikingo).concat(dragones.map(dragon => vikingo.montar(dragon).getOrElse(vikingo)))

    val participantesValidos = listaParticipantes.filter(p => posta.puedeParticipar(p))

    val bestMontura: Option[Participante] = posta.participar(participantesValidos).headOption
    
    bestMontura match {
      case Some(jinete: Jinete) => Jinete(vikingo, jinete.dragon)
      case Some(vikingo: Vikingo) => vikingo
      case _ => vikingo
    }
  }

  // TORNEO ----------------------------------------------------------------------------------------

  sealed trait ResultadoTorneo

  case class Ganador(participante: Participante) extends ResultadoTorneo
  case class EquipoGanador(equipo: Equipo) extends ResultadoTorneo
  case object SinGanador extends ResultadoTorneo


  def torneo[A](participantes: List[A], postas: List[Posta], dragones: List[Dragon], regla: ReglaTorneo[A]): ResultadoTorneo = {
    (participantes, postas) match {
      case (_, Nil) => regla.definirGanador(participantes)
      case (Nil, _) => SinGanador
      case (_, _) if participantes.length == 1 => regla.definirGanador(participantes)
      case (_, posta :: restantes) =>
        val preparados = regla.preparar(participantes, dragones, posta)
        val avanzan = regla.avanzan(preparados, posta)
        torneo(avanzan, restantes, dragones, regla)
    }
  }

  // REGLAS TORNEO ----------------------------------------------------------------------------------------

  trait ReglaTorneo[A] {
    def ordenar(participantes: List[A]): List[A] = participantes

    def preparar(participantes: List[A], dragones: List[Dragon], posta: Posta): List[A]

    def avanzan(participantes: List[A], posta: Posta): List[A]

    def definirGanador(participantes: List[A]): ResultadoTorneo

  }

  // Reglas individuales ---------------------------------------------

  trait ReglaTorneoEstandar extends ReglaTorneo[Participante] {
    override def preparar(participantes: List[Participante], dragones: List[Dragon], posta: Posta): List[Participante] = {
      val ordenParticipantes = ordenar(participantes)
      val desmontados : List[Participante] = ordenParticipantes.map(p => p.desmontar)
      val (asignados, _) = desmontados.foldLeft((List.empty[Participante], dragones)) {
        case ((acum, disp), vikingo: Vikingo) =>
          val montura = mejorMontura(posta)(disp)(vikingo)
          val nuevosDragones = montura match {
            case Jinete(_, dragonUsado) => disp.filterNot(dragonDisp  => dragonDisp == dragonUsado)
            case _ => disp
          }
          (acum :+ montura, nuevosDragones)

        case ((acum, disp), jinete: Jinete) => (acum :+ jinete, disp)
      }
      asignados
    }
    
    override def avanzan(participantes: List[Participante], posta: Posta): List[Participante] = {
      val participados = posta.participar(participantes)
      participados.take(participantes.length / 2)
    }

    override def definirGanador(participantes: List[Participante]): ResultadoTorneo = 
      participantes.headOption.map(Ganador).getOrElse(SinGanador)
  }

  case object EstandarClasico extends ReglaTorneoEstandar {
  }

  case class Eliminacion(n: Int) extends ReglaTorneoEstandar {
    override def avanzan(participantes: List[Participante], posta: Posta): List[Participante] =
      val participados = posta.participar(participantes)
      participados.dropRight(n)
  }

  case object TorneoInverso extends ReglaTorneoEstandar {
    override def ordenar(participantes: List[Participante]): List[Participante] = participantes.reverse

    override def definirGanador(participantes: List[Participante]): ResultadoTorneo =
      participantes.lastOption.map(Ganador).getOrElse(SinGanador)
  }

  case object Handicap extends ReglaTorneoEstandar {
    override def ordenar(participantes: List[Participante]): List[Participante] = participantes.reverse
  }

  case class ConBan(condicion: Dragon => Boolean) extends ReglaTorneoEstandar {
    override def preparar(participantes: List[Participante], dragones: List[Dragon], posta: Posta): List[Participante] =
      super.preparar(participantes, dragones.filter(condicion), posta)
  }

  // Reglas por equipos ---------------------------------------------

  type Equipo = List[Participante]

  case object PorEquipos extends ReglaTorneo[Equipo] {
    override def preparar(participantes: List[Equipo], dragones: List[Dragon], posta: Posta): List[Equipo] = {
      val jugadores = participantes.flatten
      val desmontados: List[Participante] = jugadores.map(p => p.desmontar)
      val (preparados, _):(List[Participante],List[Dragon]) = desmontados.foldLeft((List.empty[Participante], dragones)) {
        case ((acum, disp), vikingo: Vikingo) =>
          val montura = mejorMontura(posta)(disp)(vikingo)
          val nuevosDragones = montura match {
            case Jinete(_, dragonUsado) => disp.filterNot(dragonDisp  => dragonDisp == dragonUsado)
            case _ => disp
          }
          (acum :+ montura, nuevosDragones)

        case ((acum, disp), jinete: Jinete) => (acum :+ jinete, disp)
      }

      reagrupar(preparados, participantes.length)
    }

    override def avanzan(participantes: List[Equipo], posta: Posta): List[Equipo] = {
      val participados = posta.participar(participantes.flatten)
      val sobrevivientes = participados.take(participantes.size / 2)
      reagrupar(sobrevivientes, participantes.length)
    }

    override def definirGanador(participantes: List[Equipo]): ResultadoTorneo =
      participantes.maxByOption(_.length).filter(_.nonEmpty).map(EquipoGanador).getOrElse(SinGanador)
    
    def reagrupar(participantes: List[Participante], cantidadEquipos: Int): List[Equipo] = {
      val tamaño = Math.max(1, participantes.length / cantidadEquipos)
      participantes.grouped(tamaño).toList
    }
  }
}