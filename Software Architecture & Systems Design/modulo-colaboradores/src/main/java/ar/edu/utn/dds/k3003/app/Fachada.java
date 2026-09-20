package ar.edu.utn.dds.k3003.app;

import ar.edu.utn.dds.k3003.clients.HeladeraProxy;
import ar.edu.utn.dds.k3003.clients.IncidenteProxy;
import ar.edu.utn.dds.k3003.clients.TelegramProxy;
import ar.edu.utn.dds.k3003.facades.FachadaLogistica;
import ar.edu.utn.dds.k3003.facades.FachadaColaboradores;
import ar.edu.utn.dds.k3003.facades.FachadaViandas;
import ar.edu.utn.dds.k3003.facades.dtos.ColaboradorDTO;
import ar.edu.utn.dds.k3003.facades.dtos.FormaDeColaborarEnum;
import ar.edu.utn.dds.k3003.model.Colaborador;
import ar.edu.utn.dds.k3003.model.dtos.*;
import ar.edu.utn.dds.k3003.model.enums.MisFormasDeColaborar;
import ar.edu.utn.dds.k3003.repositorios.ColaboradorMapper;
import ar.edu.utn.dds.k3003.repositorios.ColaboradorRepository;

import java.util.ArrayList;
import java.util.List;
import java.util.concurrent.atomic.AtomicLong;

import io.micrometer.prometheusmetrics.PrometheusMeterRegistry;
import lombok.Getter;
import lombok.Setter;
import io.micrometer.core.instrument.Counter;

import javax.persistence.EntityManager;

@Getter
@Setter
public class Fachada implements FachadaColaboradores{

    private ColaboradorRepository colaboradorRepository;
    private ColaboradorMapper colaboradorMapper;
    private Double viandasDistribuidasPeso, viandasDonadasPeso, dineroDonadoPeso, arregloPeso;
    private FachadaViandas viandasFachada;
    private FachadaLogistica logisticaFachada;
    private HeladeraProxy heladerasFachada;
    private IncidenteProxy incidenteFachada;
    private TelegramProxy telegramFachada;
    private static AtomicLong seqId = new AtomicLong();

    private PrometheusMeterRegistry registry;
    private Counter cantidadColaboradores;
    private Counter puntosTotal;

    public Fachada(EntityManager entityManager){
        this.colaboradorRepository = new ColaboradorRepository(entityManager);
        this.colaboradorMapper = new ColaboradorMapper();
    }

    public Fachada(){
    }

    public MiColaboradorDTO agregarJPA(MiColaboradorDTO colaboradorDTO) {
        Colaborador colaborador = new Colaborador();
        colaborador.setNombre(colaboradorDTO.getNombre());
        colaborador.setFormas(colaboradorDTO.getFormas());
        colaborador.setPuntos((double)0);
        colaborador.setDineroDonado((double)0);
        colaborador.setHeladerasReparadas((double)0);
        colaborador.setChatID(null);

        Colaborador colaboradorRta = this.colaboradorRepository.saveJPA(colaborador);
        cantidadColaboradores.increment();
        return colaboradorMapper.map(colaboradorRta);
    }
    public MiColaboradorDTO buscarXIdJPA(Long colaboradorId){
        Colaborador colab = colaboradorRepository.findByIdJPA(colaboradorId);
        return colaboradorMapper.map(colab);
    }

    public MiColaboradorDTO modificarJPA(
            Long colaboradorId, List<MisFormasDeColaborar> nuevasFormasDeColaborar){
        colaboradorRepository.modificarFormasDeJPA(colaboradorId, nuevasFormasDeColaborar);
        return this.buscarXIdJPA(colaboradorId);
    }

    public Double puntosJPA(Long colaboradorId, Integer anio, Integer mes) {

        var viandasDistribuidas = logisticaFachada.trasladosDeColaborador(colaboradorId, mes, anio).size();
        var viandasDonadas = viandasFachada.viandasDeColaborador(colaboradorId, mes, anio).size();

        Colaborador colaborador = colaboradorRepository.findByIdJPA(colaboradorId);

        var dineroDonado = colaborador.getDineroDonado();
        var heladerasReparadas = colaborador.getHeladerasReparadas();

        Double puntosCalculados =
                (this.viandasDistribuidasPeso * viandasDistribuidas)
                        + (this.viandasDonadasPeso * viandasDonadas)
                        + (this.dineroDonadoPeso * dineroDonado)
                        + (this.arregloPeso *  heladerasReparadas);

        colaboradorRepository.setPuntos(colaboradorId, puntosCalculados);
        puntosTotal.increment(puntosCalculados);
        return puntosCalculados;
    }

    public boolean donarDinero(Long id , DineroDTO dineroDonado){

        Double donacion = dineroDonado.getDineroDonado();

        Colaborador colaborador = colaboradorRepository.findByIdJPA(id);
        if(colaborador.getFormas().contains(MisFormasDeColaborar.DONADORDEDINERO)){
            Double dineroNuevo = colaborador.getDineroDonado() + donacion;
            colaboradorRepository.setDinero(id,dineroNuevo);
            return true;
        }else{
            return false;
        }
    }

    public void actualizarPesosPuntosJPA(
            Double pesosDonados,
            Double viandasDistribuidas,
            Double viandasDonadas,
            Double reparacionJPA) {
        this.setViandasDistribuidasPeso(viandasDistribuidas);
        this.setViandasDonadasPeso(viandasDonadas);
        this.setDineroDonadoPeso(pesosDonados);
        this.setArregloPeso(reparacionJPA);
    }

    public void evento(NotificacionDTO notificacionDTO){

        List<Long> ids = notificacionDTO.getIdColab();
        List<Colaborador> colaboradores = colaboradorRepository.getColaboradoresByIdList(ids);

        for(Colaborador colaborador : colaboradores){
            telegramFachada.notificar(colaborador.getChatID(), new MensajeDTO(notificacionDTO.getMsg()));
        }
    }

    public void arreglarFalla(Long id, IncidenteDTO incidenteDTO){

        this.incidenteFachada.actualizar(incidenteDTO.getId(), incidenteDTO);
        this.heladerasFachada.cambiarEstadoActivo(incidenteDTO.getHeladeraId());

        colaboradorRepository.sumarHeladeraReparadaById(id);
    }
    public void nuevoColaboradorConChat(ColaboradorConChatDTO colaboradorConChatDTO){
        Colaborador colaborador = new Colaborador();
        colaborador.setNombre(colaboradorConChatDTO.getNombre());
        colaborador.setFormas(colaboradorConChatDTO.getFormas());
        colaborador.setPuntos((double)0);
        colaborador.setDineroDonado((double)0);
        colaborador.setHeladerasReparadas((double)0);
        colaborador.setChatID(colaboradorConChatDTO.getChatID());

        colaboradorRepository.saveJPA(colaborador);
        cantidadColaboradores.increment();
    }

    public void guardarIncidente(IncidenteDTO incidenteDTO){
        colaboradorRepository.guardarIncidente(incidenteDTO);
    }

    public void guardarNotificacion(NotificacionDTO notificacionDTO){
        colaboradorRepository.guardarEvento(notificacionDTO);
    }





    // Metodos de metricas y Overrides
    public void setRegistry(PrometheusMeterRegistry registry){
        this.registry = registry;

        this.cantidadColaboradores = Counter.builder("app.colaboradores.counter").
                description("Cantidad de colaboradores").register(registry);
        this.puntosTotal = Counter.builder("app.puntos.totales").
                description("Cantidad de puntos totales").register(registry);
    }
    @Override
    public void setLogisticaProxy(FachadaLogistica logistica) {
        this.logisticaFachada = logistica;
    }

    @Override
    public void setViandasProxy(FachadaViandas viandas) {
        this.viandasFachada = viandas;
    }

    @Override
    public ColaboradorDTO agregar(ColaboradorDTO colaboradorDTO){
        return colaboradorDTO;
    }
    @Override
    public ColaboradorDTO buscarXId(Long colaboradorId) {
        List<FormaDeColaborarEnum> formas = new ArrayList<>();
        return new ColaboradorDTO("",formas);
    }
    @Override
        public ColaboradorDTO modificar(Long colaboradorId, List<FormaDeColaborarEnum> nuevasFormasDeColaborar) {
        return this.buscarXId(colaboradorId);
    }
    @Override
    public void actualizarPesosPuntos(Double pesosDonados, Double viandasDistribuidas, Double viandasDonadas,
                                  Double tarjetasRepartidas, Double heladerasActivas){
        this.setViandasDistribuidasPeso(viandasDistribuidas);
        this.setViandasDonadasPeso(viandasDonadas);
        this.setDineroDonadoPeso(pesosDonados);
    }
    @Override
    public Double puntos(Long colaboradorId) {
        return (double)0;
    }
}