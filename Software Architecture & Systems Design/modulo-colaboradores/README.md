# Modulo Colaboradores

### API REST

https://modulo-colaboradores-entrega-6.onrender.com

### Panel de métricas

https://santinocarrizo04.grafana.net/public-dashboards/6637eee80ebb4f6282798e7048bf3bf1

### Endpoints
- **Agregar un nuevo Colaborador**

```
    - Método: POST
    - URL: https://modulo-colaboradores-entrega-6.onrender.com/colaboradores
    - Request body:
        {
            "nombre": "Santino",
            "formas": ["DONADOR", "TRANSPORTADOR"]
        }
    - Response code: 201 Created
    - Response body:
        {
            "id": 2,
            "nombre": "Santino",
            "formas": ["DONADOR","TRANSPORTADOR"]
        }
```
- **Obtener un Colaborador por ID**

```
    - Método: GET
    - URL: https://modulo-colaboradores-entrega-6.onrender.com/colaboradores/{colaboradorID}
    - Response code: 200 OK
    - Response body:
        {
            "id": 1,
            "nombre": "Santino",
            "puntos": 0.0,
            "formas": ["TECNICO"],
            "dineroDonado": 0.0,
            "heladerasReparadas": 0.0,
            "chatID": null
        }
```
- **Modificar las formas de colaborar por ID**

```
    - Método: PATCH
    - URL: https://modulo-colaboradores-entrega-6.onrender.com/colaboradores/{colaboradorID}
    - Request body:
        {
            "formas": ["TECNICO", "DONADORDEDINERO"]
        }
    - Response code: 200 OK
    - Response body:
        {
            "id": 1,
            "nombre": "Santino",
            "formas": ["TECNICO", "DONADORDEDINERO"]
        }
```
- **Establecer los coeficientes de la formula de puntos**

```
    - Método: PUT
    - URL: https://modulo-colaboradores-entrega-6.onrender.com/formula
    - Request body:
        {
            "pesosDonados" : 1,
            "viandasDistribuidas" : 1,
            "viandasDonadas" : 1,
            "arregloPeso": 1
        }
    - Response code: 200 OK
    - Response body:
        "Formula actualizada correctamente"
```
- **Donacion de dinero de un colaborador**

```
    - Método: POST
    - URL: https://modulo-colaboradores-entrega-6.onrender.com/dinero/{colaboradorID}
    - Request body:
        {
            "dineroDonado": 1000
        }
    - Response code: 200 OK
    - Response body:
        {
            "dineroDonado": 1000
        }
```
- **Calcular los puntos de un colaborador**

```
    - Método: GET
    - URL: https://modulo-colaboradores-entrega-5.onrender.com/colaboradores/1/puntos?anio=2024&mes=5
    - Response code: 200 OK
    - Response body:
        {
            "puntos": 10
        }
```
- **Enviar una notificacion a los colaboradores suscriptos a un evento de una heladera**

```
    - Método: POST
    - URL: https://modulo-colaboradores-entrega-5.onrender.com/evento
    - Request body:
        {
            "idColab" : [1,2, 3],
            "msg" : "Hola"
        }
```
- **Informar de un incidente**

```
    - Método: POST
    - URL: https://modulo-colaboradores-entrega-5.onrender.com/fallas
    - Request body:
        {
            "id" : 1,
            "tipoIncidente" : "FALLA_TECNICA",
            "heladeraId" : 1,
            "estadoIncidente" : "ACTIVO",
            "excedeTemperatura" : false,
            "excesoTemperatura" : 0,
            "tiempoSinRespuesta" : 0,
            "fechaCreacion" : "2024-05-15T21:10:40"
        }
```
- **Resolver un incidente de una heladera y arreglarla**

```
    - Método: POST
    - URL: https://modulo-colaboradores-entrega-5.onrender.com/arreglarHeladera/{colaboradorID}
    - Request body:
        {
            "id" : 1,
            "tipoIncidente" : "FALLA_TECNICA",
            "heladeraId" : 1,
            "estadoIncidente" : "RESUELTO",
            "excedeTemperatura" : false,
            "excesoTemperatura" : 0,
            "tiempoSinRespuesta" : 0,
            "fechaCreacion" : "2024-05-15T21:10:40"
        }
```

