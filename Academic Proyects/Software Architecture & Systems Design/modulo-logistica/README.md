# Módulo Logística 

### Metricas
```
https://modulologistica5.grafana.net/public-dashboards/477329173ca54373adc665d2c9042c21
```
### API REST
```
https://modulo-logistica-entrega-6.onrender.com
```
### Panel de métricas
```
https://modulologisticaentrega4.grafana.net/public-dashboards/477329173ca54373adc665d2c9042c21
```
Se implementan los siguientes endpoints:
- **Agregar una nueva ruta**

```
    - Método: POST
    - URL: https://modulo-logistica-entrega-4.onrender.com/rutas
    - Headers: 
        {
            "Content-Type": "application/json"
        }
    - Request body:
        {
            "colaboradorId": 1,
            "heladeraIdOrigen": 1,
            "heladeraIdDestino": 2
        }
    - Response code: 201 Created
    - Response body:
        {
            "id": 0,
            "colaboradorId": 1,
            "heladeraIdOrigen": 1,
            "heladeraIdDestino": 2
        }
```

- **Eliminar todas las rutas**

```
    - Método: DELETE
    - URL: https://modulo-logistica-entrega-4.onrender.com/rutas
    - Response code: 204 No Content
```

- **Asignar un nuevo traslado a un colaborador**

```
    - Método: POST
    - URL: https://modulo-logistica-entrega-4.onrender.com/traslados
    - Headers: 
        {
            "Content-Type": "application/json"
        }
    - Request body:
        {
            "qrVianda": "unQRQueExiste",
            "status": "CREADO",
            "fechaTraslado": "2024-05-15T21:10:40Z",
            "heladeraOrigen": 1,
            "heladeraDestino": 2,
        }
    - Response code: 201 Created
    - Response body:
        {
            "id": 0,
            "colaboradorId": 1,
            "heladeraIdOrigen": 1,
            "heladeraIdDestino": 2
        }
```

- **Obtener un traslado por su ID**

```
    - Método: GET
    - URL: https://modulo-logistica-entrega-4.onrender.com/traslados/{id}
    - Response code: 200 OK
    - Response body:
        {
            "id": 0,
            "qrVianda": "unQRQueExiste",
            "status": "ENTREGADO",
            "fechaTraslado": "2024-05-15T21:10:40Z",
            "heladeraOrigen": 1,
            "heladeraDestino": 2,
            "colaboradorId": 1
        }
```

- **Obtener todos los traslados de un colaborador por su ID, año y mes**

```
    - Método: GET
    - URL: https://modulo-logistica-entrega-4.onrender.com/traslados/search/findByColaboradorId?id={id}&anio={anio}&mes={mes}
    - Response code: 200 OK
```

- **Modificar el estado de un traslado por su ID**

```
    - Método: PATCH
    - URL: https://modulo-logistica-entrega-4.onrender.com/traslados/{id}
    - Headers: 
        {
            "Content-Type": "application/json"
        }
    - Request body:
        {
            "qrVianda": "unQRQueExiste",
            "status": "EN_VIAJE",
            "fechaTraslado": "2024-05-15T21:10:40Z",
            "heladeraOrigen": 1,
            "heladeraDestino": 2,
            "colaboradorId": 1
        }
    - Response code: 200 OK
```

- **Eliminar todos los traslados**

```
    - Método: DELETE
    - URL: https://modulo-logistica-entrega-4.onrender.com/traslados
    - Response code: 204 No Content
```
