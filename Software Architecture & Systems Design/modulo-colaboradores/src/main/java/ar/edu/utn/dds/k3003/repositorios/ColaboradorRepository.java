package ar.edu.utn.dds.k3003.repositorios;

import ar.edu.utn.dds.k3003.model.Colaborador;
import ar.edu.utn.dds.k3003.model.dtos.IncidenteDTO;
import ar.edu.utn.dds.k3003.model.dtos.NotificacionDTO;
import ar.edu.utn.dds.k3003.model.enums.MisFormasDeColaborar;

import javax.persistence.EntityManager;
import javax.persistence.TypedQuery;
import java.util.*;
import java.util.concurrent.atomic.AtomicLong;

public class ColaboradorRepository {

  private static AtomicLong seqId = new AtomicLong();
  private EntityManager entityManager;
  public ColaboradorRepository(EntityManager entityManager) {
    this.entityManager = entityManager;
  }

  public ColaboradorRepository() {}
  public Colaborador saveJPA(Colaborador colaborador){
    entityManager.getTransaction().begin();
    entityManager.persist(colaborador);
    entityManager.getTransaction().commit();
    return colaborador;
  }
  public Colaborador findByIdJPA(Long id) {
    entityManager.getTransaction().begin();
    Colaborador colaborador = entityManager.find(Colaborador.class, id);
    entityManager.getTransaction().commit();

    return colaborador;
  }

  public void modificarFormasDeJPA(Long id, List<MisFormasDeColaborar> formas){
    entityManager.getTransaction().begin();
    Colaborador colaborador = entityManager.find(Colaborador.class, id);
    colaborador.setFormas(formas);
    entityManager.getTransaction().commit();
  }

  public void setPuntos(Long id, Double puntos){
    entityManager.getTransaction().begin();
    Colaborador colaborador = entityManager.find(Colaborador.class, id);
    colaborador.setPuntos(puntos);
    entityManager.getTransaction().commit();
  }

  public void setDinero(Long id, Double dineroTotal){
    entityManager.getTransaction().begin();
    Colaborador colaborador = entityManager.find(Colaborador.class, id);
    colaborador.setDineroDonado(dineroTotal);
    entityManager.getTransaction().commit();
  }

  public List<Colaborador> getColaboradoresByIdList(List<Long> ids){
    TypedQuery<Colaborador> query = entityManager.createQuery(
            "SELECT c FROM Colaborador c WHERE c.id IN :ids", Colaborador.class);
    query.setParameter("ids", ids);
    return query.getResultList();
  }

  public void sumarHeladeraReparadaById(Long id){
    entityManager.getTransaction().begin();
    Colaborador colaborador = entityManager.find(Colaborador.class, id);
    colaborador.setHeladerasReparadas(colaborador.getHeladerasReparadas() + 1);
    entityManager.getTransaction().commit();
  }

  public void guardarIncidente(IncidenteDTO incidenteDTO){
    entityManager.getTransaction().begin();
    entityManager.persist(incidenteDTO);
    entityManager.getTransaction().commit();
  }

  public void guardarEvento(NotificacionDTO notificacionDTO){
    entityManager.getTransaction().begin();
    entityManager.persist(notificacionDTO);
    entityManager.getTransaction().commit();
  }
}
