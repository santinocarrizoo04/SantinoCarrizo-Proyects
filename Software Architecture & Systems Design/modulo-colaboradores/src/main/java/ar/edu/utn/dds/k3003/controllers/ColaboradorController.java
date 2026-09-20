package ar.edu.utn.dds.k3003.controllers;

import ar.edu.utn.dds.k3003.app.Fachada;
import ar.edu.utn.dds.k3003.model.Colaborador;
import ar.edu.utn.dds.k3003.model.dtos.*;
import ar.edu.utn.dds.k3003.repositorios.ColaboradorMapper;
import io.javalin.http.Context;
import io.javalin.http.HttpStatus;
import java.io.IOException;
import java.util.NoSuchElementException;

public class ColaboradorController {
    private final Fachada fachada;
    private ColaboradorMapper colaboradorMapper;

    public ColaboradorController(Fachada fachada) {
        this.fachada = fachada;
        this.colaboradorMapper =  new ColaboradorMapper();
    }

    public void agregar(Context ctx){
        var colabDTO = ctx.bodyAsClass(MiColaboradorDTO.class);

        var rtaDTO = this.fachada.agregarJPA(colabDTO);

        ctx.status(HttpStatus.CREATED);
        ctx.json(rtaDTO);
    }

    public void buscar(Context ctx){
        String parametroString = ctx.pathParam("colaboradorID");
        Long colabID = Long.parseLong(parametroString);
        try{
            Colaborador colabBuscado = colaboradorMapper.pam(fachada.buscarXIdJPA(colabID));
            ctx.status(HttpStatus.OK);
            ctx.json(colabBuscado);
        }
        catch (NoSuchElementException ex) {
            ctx.status(HttpStatus.NOT_FOUND);
            ctx.result("No se encontro al colaborador de id: " + colabID);
        }
    }

    public void cambiarFormas(Context ctx){
        String parametroString = ctx.pathParam("colabID");
        Long colabID = Long.parseLong(parametroString);
        var formasBody = ctx.bodyAsClass(FormasDeColaborarDTO.class);
        try {
            var rtaDTO = fachada.modificarJPA(colabID, formasBody.getFormas());

            ctx.status(HttpStatus.OK);
            ctx.result("Formas cambiadas correctamente");
            ctx.json(rtaDTO);
        }
        catch (NoSuchElementException ex){
            ctx.status(HttpStatus.NOT_FOUND);
            ctx.result("No se encontro al colaborador de id: " + colabID);
        }
    }

    public void puntos(Context ctx){

        var anio = ctx.queryParamAsClass("anio", Integer.class).get();
        var mes = ctx.queryParamAsClass("mes", Integer.class).get();
        String parametroString = ctx.pathParam("colaboradorID");
        Long colabID = Long.parseLong(parametroString);

        try {
            var puntosDelColab = this.fachada.puntosJPA(colabID, anio, mes);
            PuntosDeColaboradorDTO puntosDTOrta = new PuntosDeColaboradorDTO();
            puntosDTOrta.setPuntos(puntosDelColab);
            ctx.status(HttpStatus.OK);
            ctx.json(puntosDTOrta);
        }
        catch(NoSuchElementException ex){
            ctx.status(HttpStatus.NOT_FOUND);
            ctx.result("No se encontro al colaborador de id: " + colabID);
        }
    }

    public void actualizar(Context ctx){
        var puntosBody = ctx.bodyAsClass(PuntosDTO.class);
        this.fachada.actualizarPesosPuntosJPA(puntosBody.getPesosDonados(), puntosBody.getViandasDistribuidas(),
                puntosBody.getViandasDonadas(), puntosBody.getArregloPeso());
        ctx.status(HttpStatus.OK);
        ctx.result("Formula actualizada correctamente");
    }

    public void falla(Context ctx) throws IOException {
        var incidenteDTO = ctx.bodyAsClass(IncidenteDTO.class);
        fachada.guardarIncidente(incidenteDTO);
    }

    public void donacionDinero(Context ctx){
        var idString = ctx.pathParam("colabID");
        Long id = Long.parseLong(idString);
        var dineroBody = ctx.bodyAsClass(DineroDTO.class);

        var resultado = this.fachada.donarDinero(id, dineroBody);

        if(resultado){
            ctx.status(HttpStatus.OK);
            ctx.json(dineroBody);
        }
        else{
            ctx.status(HttpStatus.UNAUTHORIZED);
            ctx.result("El colaborador no es donador");
        }
    }

    public void evento(Context ctx) throws IOException {

        var evento = ctx.bodyAsClass(NotificacionDTO.class);
        fachada.guardarNotificacion(evento);
        fachada.evento(evento);
    }

    public void arreglarHeladera(Context ctx) throws IOException {
        var idString = ctx.pathParam("colabID");
        Long id = Long.parseLong(idString);
        var incidenteBody = ctx.bodyAsClass(IncidenteDTO.class);

       fachada.arreglarFalla(id, incidenteBody);
    }
    public void nuevoColabConChat(Context ctx) throws IOException {
        var colaboradorConChatBody = ctx.bodyAsClass(ColaboradorConChatDTO.class);

        fachada.nuevoColaboradorConChat(colaboradorConChatBody);
    }
}
