USE GD1C2025 -- Usa la DB GD1C2025
GO

-- CREACION DE TABLAS DE DIMENSIONES DEL MODELO DIMENSIONAL DESARROLLADO --------------------------------------------------------------------

CREATE TABLE LOS_BASEADOS.BI_dimension_tiempo(
	idTiempo DECIMAL(18,0) NOT NULL IDENTITY(1,1),
	anio DECIMAL(18,0) NOT NULL,
	cuatrimestre DECIMAL(18,0) NOT NULL,
	mes DECIMAL(18,0) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_dimension_ubicacion (
	idUbicacion DECIMAL(18,0) NOT NULL IDENTITY(1,1),
	idProvincia TINYINT NOT NULL,
	provincia NVARCHAR(255) NOT NULL,
	idLocalidad SMALLINT NOT NULL,
	localidad NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_dimension_sucursal (
	idSucursal DECIMAL(18,0) NOT NULL IDENTITY(1,1),
	numeroSucursal BIGINT NOT NULL,
	direccion NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_dimension_rango_etario(
	idRangoEtario DECIMAL(18,0) NOT NULL IDENTITY(1,1),
	rango NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_dimension_turno_venta(
	idTurnoVenta DECIMAL(18,0) NOT NULL IDENTITY(1,1),
	turno NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_dimension_tipo_material(
	idBiTipoMaterial DECIMAL(18,0) NOT NULL IDENTITY(1,1),
    idTipoMaterial INT NOT NULL,
	tipo NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_dimension_modelo_sillon(
	idBiModeloSillon DECIMAL(18,0) NOT NULL IDENTITY(1,1),
    codigoModelo BIGINT NOT NULL,
	descripcion NVARCHAR(255) NOT NULL,
    precio DECIMAL(18,2) NOT NULL,
    modelo NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_dimension_estado_pedido(
	idBiEstadoPedido DECIMAL(18,0) NOT NULL IDENTITY(1,1),
    idEstado TINYINT NOT NULL,
	estado NVARCHAR(255) NOT NULL
);
GO

-- CREACION DE TABLAS DE HECHOS DEL MODELO DIMENSIONAL DESARROLLADO --------------------------------------------------------------------

CREATE TABLE LOS_BASEADOS.BI_hecho_pedido(
	idTiempo DECIMAL(18,0) NOT NULL,
    idTurnoVenta DECIMAL(18,0) NOT NULL,
    idUbicacion DECIMAL(18,0) NOT NULL,
	idSucursal DECIMAL(18,0) NOT NULL,
    idBiEstadoPedido DECIMAL(18,0) NOT NULL,
    cant_pedidos DECIMAL(18,0) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_hecho_venta(
	idTiempo DECIMAL(18,0) NOT NULL,
    idRangoEtario DECIMAL(18,0) NOT NULL,
    idUbicacion DECIMAL(18,0) NOT NULL,
	idSucursal DECIMAL(18,0) NOT NULL,
    idBiModeloSillon DECIMAL(18,0) NOT NULL,
    total_ventas DECIMAL(12,2) NOT NULL,
    cant_ventas_totales DECIMAL(18,0) NOT NULL,
	tiempo_total_fabricacion DECIMAL(12,2) NOT NULL,
	cant_ventas DECIMAL(18,0) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_hecho_compra(
	idTiempo DECIMAL(18,0) NOT NULL,
    idUbicacion DECIMAL(18,0) NOT NULL,
	idSucursal DECIMAL(18,0) NOT NULL,
    idBiTipoMaterial DECIMAL(18,0) NOT NULL,
    total_compras DECIMAL(12,2) NOT NULL,
    cant_compras DECIMAL(18,0) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_hecho_envio(
	idTiempo DECIMAL(18,0) NOT NULL,
    idUbicacionCliente DECIMAL(18,0) NOT NULL,
	idSucursal DECIMAL(18,0) NOT NULL,
    cant_envios_cumplidos DECIMAL(18,0) NOT NULL,
    cant_envios_total DECIMAL(18,0) NOT NULL,
    total_costo_envio DECIMAL(12,2) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.BI_hecho_venta_por_ubi_y_cuatri(
	idTiempo DECIMAL(18,0) NOT NULL,
    idUbicacion DECIMAL(18,0) NOT NULL,
	idSucursal DECIMAL(18,0) NOT NULL,
    total_ventas DECIMAL(12,2) NOT NULL,
    cant_ventas DECIMAL(18,0) NOT NULL
);
GO

-- CREACION DE CONSTRAINTS DE LAS TABLAS (PKS, FKS)--------------------------------------------------------------------

-- CREACION DE UNA PRIMARY KEY PARA UNA TABLA DE DIMENSIONES
ALTER TABLE LOS_BASEADOS.BI_dimension_estado_pedido ADD CONSTRAINT PK_idBiEstadoPedido PRIMARY KEY(idBiEstadoPedido);
GO

ALTER TABLE LOS_BASEADOS.BI_dimension_turno_venta ADD CONSTRAINT PK_idTurnoVenta PRIMARY KEY(idTurnoVenta);
GO

ALTER TABLE LOS_BASEADOS.BI_dimension_tiempo ADD CONSTRAINT PK_idTiempo PRIMARY KEY(idTiempo);
GO
ALTER TABLE LOS_BASEADOS.BI_dimension_tiempo ADD CONSTRAINT UNIQUE_tiempo UNIQUE(anio,cuatrimestre,mes) 
GO

ALTER TABLE LOS_BASEADOS.BI_dimension_tipo_material ADD CONSTRAINT PK_idBiTipoMaterial PRIMARY KEY(idBiTipoMaterial);
GO

ALTER TABLE LOS_BASEADOS.BI_dimension_rango_etario ADD CONSTRAINT PK_idRangoEtario PRIMARY KEY(idRangoEtario);
GO

ALTER TABLE LOS_BASEADOS.BI_dimension_ubicacion ADD CONSTRAINT PK_idUbicacion PRIMARY KEY(idUbicacion);
GO

ALTER TABLE LOS_BASEADOS.BI_dimension_sucursal ADD CONSTRAINT PK_idSucursal PRIMARY KEY(idSucursal);
GO

ALTER TABLE LOS_BASEADOS.BI_dimension_modelo_sillon ADD CONSTRAINT PK_idBiModeloSillon PRIMARY KEY(idBiModeloSillon);
GO

--CREACION DE UNA PRIMARY KEY PARA UNA TABLA DE HECHOS
ALTER TABLE LOS_BASEADOS.BI_hecho_envio ADD CONSTRAINT PK_hechoEnvio PRIMARY KEY(idTiempo, idUbicacionCliente, idSucursal);
GO
--CREACION DE LAS FOREIGN KEY PARA UNA TABLA DE HECHOS QUE REFERENCIAN A LAS TABLAS DE DIMENSIONES
ALTER TABLE LOS_BASEADOS.BI_hecho_envio ADD CONSTRAINT FK_hechoEnvio_idTiempo FOREIGN KEY(idTiempo) REFERENCES LOS_BASEADOS.BI_dimension_tiempo(idTiempo);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_envio ADD CONSTRAINT FK_hechoEnvio_idUbicacion FOREIGN KEY(idUbicacionCliente) REFERENCES LOS_BASEADOS.BI_dimension_ubicacion(idUbicacion);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_envio ADD CONSTRAINT FK_hechoEnvio_idSucursal FOREIGN KEY(idSucursal) REFERENCES LOS_BASEADOS.BI_dimension_sucursal(idSucursal);
GO

ALTER TABLE LOS_BASEADOS.BI_hecho_pedido ADD CONSTRAINT PK_hechoPedido PRIMARY KEY(idTiempo, idUbicacion, idTurnoVenta, idBiEstadoPedido, idSucursal);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_pedido ADD CONSTRAINT FK_hechoPedido_idTiempo FOREIGN KEY(idTiempo) REFERENCES LOS_BASEADOS.BI_dimension_tiempo(idTiempo);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_pedido ADD CONSTRAINT FK_hechoPedido_idUbicacion FOREIGN KEY(idUbicacion) REFERENCES LOS_BASEADOS.BI_dimension_ubicacion(idUbicacion);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_pedido ADD CONSTRAINT FK_hechoPedido_idSucursal FOREIGN KEY(idSucursal) REFERENCES LOS_BASEADOS.BI_dimension_sucursal(idSucursal);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_pedido ADD CONSTRAINT FK_hechoPedido_idTurnoVenta FOREIGN KEY(idTurnoVenta) REFERENCES LOS_BASEADOS.BI_dimension_turno_venta(idTurnoVenta);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_pedido ADD CONSTRAINT FK_hechoPedido_idBiEstadoPedido FOREIGN KEY(idBiEstadoPedido) REFERENCES LOS_BASEADOS.BI_dimension_estado_pedido(idBiEstadoPedido);
GO

ALTER TABLE LOS_BASEADOS.BI_hecho_venta ADD CONSTRAINT PK_hechoVenta PRIMARY KEY(idTiempo, idUbicacion, idRangoEtario, idBiModeloSillon, idSucursal);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_venta ADD CONSTRAINT FK_hechoVenta_idTiempo FOREIGN KEY(idTiempo) REFERENCES LOS_BASEADOS.BI_dimension_tiempo(idTiempo);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_venta ADD CONSTRAINT FK_hechoVenta_idUbicacion FOREIGN KEY(idUbicacion) REFERENCES LOS_BASEADOS.BI_dimension_ubicacion(idUbicacion);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_venta ADD CONSTRAINT FK_hechoVenta_idSucursal FOREIGN KEY(idSucursal) REFERENCES LOS_BASEADOS.BI_dimension_sucursal(idSucursal);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_venta ADD CONSTRAINT FK_hechoVenta_idRangoEtario FOREIGN KEY(idRangoEtario) REFERENCES LOS_BASEADOS.BI_dimension_rango_etario(idRangoEtario);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_venta ADD CONSTRAINT FK_hechoVenta_idBiModeloSillon FOREIGN KEY(idBiModeloSillon) REFERENCES LOS_BASEADOS.BI_dimension_modelo_sillon(idBiModeloSillon);
GO

ALTER TABLE LOS_BASEADOS.BI_hecho_compra ADD CONSTRAINT PK_hechoCompra PRIMARY KEY(idTiempo, idUbicacion, idBiTipoMaterial, idSucursal);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_compra ADD CONSTRAINT FK_hechoCompra_idTiempo FOREIGN KEY(idTiempo) REFERENCES LOS_BASEADOS.BI_dimension_tiempo(idTiempo);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_compra ADD CONSTRAINT FK_hechoCompra_idUbicacion FOREIGN KEY(idUbicacion) REFERENCES LOS_BASEADOS.BI_dimension_ubicacion(idUbicacion);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_compra ADD CONSTRAINT FK_hechoCompra_idSucursal FOREIGN KEY(idSucursal) REFERENCES LOS_BASEADOS.BI_dimension_sucursal(idSucursal);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_compra ADD CONSTRAINT FK_hechoCompra_idTipoMaterial FOREIGN KEY(idBiTipoMaterial) REFERENCES LOS_BASEADOS.BI_dimension_tipo_material(idBiTipoMaterial);
GO

ALTER TABLE LOS_BASEADOS.BI_hecho_venta_por_ubi_y_cuatri ADD CONSTRAINT PK_hechoVentaPorUbiYCuatri PRIMARY KEY(idTiempo, idUbicacion, idSucursal);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_venta_por_ubi_y_cuatri ADD CONSTRAINT FK_hechoVentaPorUbiYCuatri_idTiempo FOREIGN KEY(idTiempo) REFERENCES LOS_BASEADOS.BI_dimension_tiempo(idTiempo);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_venta_por_ubi_y_cuatri ADD CONSTRAINT FK_hechoVentaPorUbiYCuatri_idUbicacion FOREIGN KEY(idUbicacion) REFERENCES LOS_BASEADOS.BI_dimension_ubicacion(idUbicacion);
GO
ALTER TABLE LOS_BASEADOS.BI_hecho_venta_por_ubi_y_cuatri ADD CONSTRAINT FK_hechoVentaPorUbiYCuatri_idSucursal FOREIGN KEY(idSucursal) REFERENCES LOS_BASEADOS.BI_dimension_sucursal(idSucursal);
GO

-- CREACION DE FUNCIONES AUXILIARES PARA LA MIGRACION --------------------------------------------------------------------

-- DADO UN MES, DEVUELVE EL CUATRIMESTRE AL QUE PERTENECE
CREATE FUNCTION LOS_BASEADOS.obtener_cuatrimestre (@MES INT)
RETURNS INT 
BEGIN
	DECLARE @CUATRIMESTRE INT;
	IF @MES IN (1,2,3,4) set @CUATRIMESTRE = 1
	ELSE IF @MES IN (5,6,7,8) set @CUATRIMESTRE = 2
	ELSE IF @MES IN (9,10,11,12) set @CUATRIMESTRE=3
	RETURN @CUATRIMESTRE
END
GO

-- DADO UN ANIO, MES, CUATRIMESTRE Y UNA FECHA, DEVUELVE 1 SI COINCIDEN Y 0 SI NO COINCIDEN
CREATE FUNCTION LOS_BASEADOS.comparar_fecha(@ANIO INT,@MES INT,@CUATRI INT,@FECHA DATETIME2)
RETURNS INT
AS
BEGIN 
	RETURN CASE 
	WHEN YEAR(@FECHA) = @ANIO 
        AND LOS_BASEADOS.obtener_cuatrimestre(MONTH(@FECHA)) = @CUATRI
        AND MONTH(@FECHA) = @MES
        THEN 1
        ELSE 0
	END
END
GO

-- DADA UNA HORA, DEVUELVE EL TURNO DE VENTA AL QUE PERTENECE
CREATE FUNCTION LOS_BASEADOS.obtener_turno_venta (@HORA INT)
RETURNS NVARCHAR(255)
AS
BEGIN
    DECLARE @turno NVARCHAR(255)

    IF @HORA BETWEEN 8 AND 13
        SET @turno = '08:00 - 14:00'
    ELSE IF @HORA BETWEEN 14 AND 20
        SET @turno = '14:00 - 20:00'
    ELSE
        SET @turno = 'Fuera de horario'

    RETURN @turno
END
GO

-- DADO UN TURNO Y UNA FECHA, DEVUELVE 1 SI LA FECHA PERTENECE AL TURNO Y 0 SI NO PERTENECE
CREATE FUNCTION LOS_BASEADOS.comparar_turno(@TURNO VARCHAR(255),@FECHA DATETIME2)
RETURNS INT
AS
BEGIN
	RETURN CASE 
	WHEN LOS_BASEADOS.obtener_turno_venta(DATEPART(HOUR, @FECHA)) = @TURNO 
        THEN 1
        ELSE 0
	END
END
GO

-- DADO UN DIA, MES Y ANIO (FECHA DE NACIMIENTO) DEVUELVE EL RANGO ETARIO AL QUE PERTENECE
CREATE FUNCTION LOS_BASEADOS.obtener_rango_etario(@DIA INT, @MES INT, @ANIO INT)
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @fechaNacimiento DATE = DATEFROMPARTS(@anio, @mes, @dia);
    DECLARE @edad INT = DATEDIFF(YEAR, @fechaNacimiento, GETDATE());

    IF DATEADD(YEAR, @edad, @fechaNacimiento) > CAST(GETDATE() AS DATE)
        SET @edad = @edad - 1;

    DECLARE @rango VARCHAR(10);

    IF @edad < 25
        SET @rango = '<25';
    ELSE IF @edad BETWEEN 25 AND 35
        SET @rango = '25-35';
    ELSE IF @edad BETWEEN 36 AND 50
        SET @rango = '35-50';
    ELSE
        SET @rango = '>50';

    RETURN @rango;
END
GO

-- DADO UN RANGO ETARIO Y UNA FECHA DE NACIMIENTO, DEVUELVE 1 SI LA FECHA PERTENECE AL RANGO Y 0 SI NO PERTENECE
CREATE FUNCTION LOS_BASEADOS.comparar_rango_etario(@RANGO VARCHAR(255),@FECHANAC DATETIME2(6))
RETURNS INT
AS
BEGIN
	RETURN CASE 
	WHEN LOS_BASEADOS.obtener_rango_etario(DATEPART(DAY, @FECHANAC),DATEPART(MONTH, @FECHANAC),DATEPART(YEAR, @FECHANAC)) = @RANGO 
        THEN 1
        ELSE 0
	END
END
GO

-- CREACION DE PROCEDURES PARA MIGRAR DATOS DEL MODELO RELACIONAL A LAS TABLAS DE DIMENSIONES ----------------------------

-- MIGRA DESDE LOCALIDADES Y PROVINCIAS
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_dimension_ubicaciones
AS
BEGIN
	INSERT LOS_BASEADOS.BI_dimension_ubicacion(idProvincia, provincia, idLocalidad, localidad)
	SELECT p.idProvincia, p.provincia, l.idLocalidad, l.localidad
	FROM LOS_BASEADOS.provincia p 
	JOIN LOS_BASEADOS.localidad l ON l.idProvincia = p.idProvincia
END
GO

-- MIGRA DESDE SUCURSALES
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_dimension_sucursal
AS
BEGIN
	INSERT LOS_BASEADOS.BI_dimension_sucursal(numeroSucursal, direccion)
	SELECT s.numeroSucursal, s.direccion
	FROM LOS_BASEADOS.sucursal s
END
GO

-- INSERTA LOS RANGOS ESTABLECIDOS EN EL ENUNCIADO
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_dimension_rango_etario
AS
BEGIN
	INSERT INTO LOS_BASEADOS.BI_dimension_rango_etario(rango)
    VALUES ('<25'),('25-35'), ('35-50'),('>50')
END
GO

-- MIGRA DESDE TIPO_MATERIAL
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_dimension_tipo_material
AS
BEGIN
	INSERT INTO LOS_BASEADOS.BI_dimension_tipo_material(idTipoMaterial, tipo)
    SELECT idTipoMaterial, tipo
	FROM LOS_BASEADOS.tipo_material
END
GO

-- MIGRA DESDE ESTADO (ESTADO DEL PEDIDO)
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_dimension_estado_pedido
AS
BEGIN
	insert into LOS_BASEADOS.BI_dimension_estado_pedido(idEstado, estado)
    SELECT idEstado, estado
	FROM LOS_BASEADOS.estado
END
GO

-- INSERTA LOS TURNOS ESTABLECIDOS EN EL ENUNCIADO 
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_dimension_turno_venta
AS
BEGIN
	INSERT INTO LOS_BASEADOS.BI_dimension_turno_venta(turno)
    VALUES ('08:00 - 14:00'),('14:00 - 20:00')
END
GO

-- MIGRA DESDE MODELO_SILLON
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_dimension_modelo_sillon
AS
BEGIN
	INSERT INTO LOS_BASEADOS.BI_dimension_modelo_sillon(codigoModelo, descripcion, modelo, precio)
    SELECT codigoModelo, descripcion, modelo, precio
	FROM LOS_BASEADOS.modelo_sillon
END
GO

-- MIGRA DESDE LAS TABLAS QUE TIENEN FECHAS Y SE RELACIONAN CON LOS HECHOS (ENVIO, COMPRA, PEDIDO, FACTURA)
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_dimension_tiempo
AS
BEGIN
	INSERT INTO LOS_BASEADOS.BI_dimension_tiempo(anio, cuatrimestre, mes)
    SELECT DISTINCT YEAR(e.fechaEntrega), LOS_BASEADOS.obtener_cuatrimestre(MONTH(e.fechaEntrega)), MONTH(e.fechaEntrega)
	FROM LOS_BASEADOS.envio e
	UNION
    SELECT DISTINCT YEAR(c.fecha), LOS_BASEADOS.obtener_cuatrimestre(MONTH(c.fecha)),MONTH(c.fecha)
	FROM LOS_BASEADOS.compra c
	UNION
    SELECT DISTINCT YEAR(p.fecha), LOS_BASEADOS.obtener_cuatrimestre(MONTH(p.fecha)), MONTH(p.fecha)
	FROM LOS_BASEADOS.pedido p
	UNION
    SELECT DISTINCT YEAR(f.fecha), LOS_BASEADOS.obtener_cuatrimestre(MONTH(f.fecha)),MONTH(f.fecha)
	FROM LOS_BASEADOS.factura f
END
GO

-- CREACION DE PROCEDURES PARA MIGRAR LOS DATOS DEL MODELO RELACIONAL A LAS TABLAS DE HECHOS -------------------------------------

-- MIGRA DESDE COMPRA (JOINEA CON OTRAS TABLAS PARA LOS DATOS RESTANTES)
-- CANTIDAD Y TOTAL DE COMPRAS POR TIEMPO, UBICACION (DE LA SUCURSAL), SUCURSAL Y TIPO DE MATERIAL
-- 513 Rows = 3 (Tipo Material) * 19 (Tiempo) * 9 (Sucursal) && SUM(TOTAL_COMPRAS) = SUM(TOTAL) DE LA TABLA COMPRAS DEL MODELO ANTERIOR
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_hecho_compra
AS
BEGIN
    INSERT LOS_BASEADOS.BI_hecho_compra(idTiempo, idUbicacion, idSucursal, idBiTipoMaterial, cant_compras, total_compras)
	SELECT tiempo.idTiempo,ubi.idUbicacion,ds.idSucursal,dtm.idBiTipoMaterial, 
		SUM(CASE WHEN tipo_mat.tipo = dtm.tipo AND COALESCE(detalle_compra.subtotal, 0) != 0 THEN 1 ELSE 0 END) AS cantidad_compras,
		SUM(CASE WHEN tipo_mat.tipo = dtm.tipo THEN COALESCE(detalle_compra.subtotal, 0) ELSE 0 END) AS total_compras
	FROM LOS_BASEADOS.BI_dimension_tiempo tiempo
	CROSS JOIN LOS_BASEADOS.BI_dimension_sucursal ds
	CROSS JOIN LOS_BASEADOS.BI_dimension_tipo_material dtm

	JOIN LOS_BASEADOS.sucursal sucursal ON sucursal.numeroSucursal = ds.numeroSucursal
	JOIN LOS_BASEADOS.localidad localidad ON sucursal.idLocalidad = localidad.idLocalidad
	JOIN LOS_BASEADOS.BI_dimension_ubicacion ubi ON sucursal.idLocalidad = ubi.idLocalidad AND localidad.idProvincia = ubi.idProvincia

	LEFT JOIN LOS_BASEADOS.compra compra ON compra.numeroSucursal = ds.numeroSucursal 
				AND LOS_BASEADOS.comparar_fecha(tiempo.anio, tiempo.mes, tiempo.cuatrimestre, compra.fecha) = 1

	LEFT JOIN LOS_BASEADOS.detalle_compra detalle_compra ON compra.idCompra = detalle_compra.idCompra
	LEFT JOIN LOS_BASEADOS.material material ON material.idMaterial = detalle_compra.idMaterial
	LEFT JOIN LOS_BASEADOS.tipo_material tipo_mat ON material.idTipoMaterial = tipo_mat.idTipoMaterial

	GROUP BY tiempo.idTiempo, ubi.idUbicacion, ds.idSucursal, dtm.idBiTipoMaterial
	ORDER BY tiempo.idTiempo, ubi.idUbicacion, ds.idSucursal, dtm.idBiTipoMaterial
END
GO

-- MIGRA DESDE ENVIO (JOINEA CON OTRAS TABLAS PARA LOS DATOS RESTANTES)
-- CANTIDAD DE ENVIOS (CUMPLIDOS Y TOTAL) Y MONTO TOTAL DE ENVIOS POR TIEMPO, UBICACION (DEL CLIENTE) Y SUCURSAL
-- 17308 Rows (SUM CANT_ENVIOS = 17408 = CANT ROWS DE LA TABLA ENVIOS DEL MODELO ANTERIOR)
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_hecho_envio
AS
BEGIN
	INSERT LOS_BASEADOS.BI_hecho_envio(idTiempo, idUbicacionCliente, idSucursal, cant_envios_total, total_costo_envio, cant_envios_cumplidos)
	SELECT tiempo.idTiempo, ubi.idUbicacion ,ds.idSucursal, count(*), sum(envio.total), 
			SUM(CASE WHEN envio.fechaEntrega = envio.fechaProgramada THEN 1 ELSE 0 END)
	FROM LOS_BASEADOS.envio envio
	JOIN LOS_BASEADOS.factura factura ON envio.idFactura = factura.idFactura
	JOIN LOS_BASEADOS.cliente c ON c.idCliente = factura.idCliente
	JOIN LOS_BASEADOS.sucursal sucursal ON sucursal.numeroSucursal= factura.numeroSucursal
	JOIN LOS_BASEADOS.localidad localidad ON localidad.idLocalidad=c.idLocalidad
	JOIN LOS_BASEADOS.localidad localidadSuc ON localidadSuc.idLocalidad = sucursal.idLocalidad

	JOIN LOS_BASEADOS.BI_dimension_tiempo tiempo ON LOS_BASEADOS.comparar_fecha(tiempo.anio,tiempo.mes,tiempo.cuatrimestre,envio.fechaEntrega)=1
	JOIN LOS_BASEADOS.BI_dimension_ubicacion ubi ON c.idLocalidad=ubi.idLocalidad AND localidad.idProvincia=ubi.idProvincia
	JOIN LOS_BASEADOS.BI_dimension_sucursal ds ON ds.numeroSucursal = sucursal.numeroSucursal
	GROUP BY tiempo.idTiempo, ubi.idUbicacion, ds.idSucursal
END
GO

-- MIGRA DESDE PEDIDO (JOINEA CON OTRAS TABLAS PARA LOS DATOS RESTANTES)
-- CANTIDAD DE PEDIDOS POR TIEMPO, UBICACION, SUCURSAL, TURNO DE VENTA Y ESTADO DEL PEDIDO
-- 1026 Rows = 19 (Tiempo) * 9 (Sucursal) * 2 (Turno) * 3 (Estado) && SUM(CANT_PEDIDOS) = 20509 = ROWS DE LA TABLA PEDIDO
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_hecho_pedido
AS
BEGIN
    INSERT LOS_BASEADOS.BI_hecho_pedido(idTiempo,idTurnoVenta,idSucursal,idUbicacion,idBiEstadoPedido,cant_pedidos)
	SELECT tiempo.idTiempo, turn.idTurnoVenta, ds.idSucursal, ubi.idUbicacion, est_ped.idBiEstadoPedido, 
			SUM(CASE WHEN pedido.numeroPedido IS NOT NULL THEN 1 ELSE 0 END) cant_pedidos
	FROM LOS_BASEADOS.BI_dimension_tiempo tiempo
	JOIN LOS_BASEADOS.BI_dimension_turno_venta turn ON 1=1
	JOIN LOS_BASEADOS.BI_dimension_estado_pedido est_ped ON 1=1
	JOIN LOS_BASEADOS.BI_dimension_sucursal ds ON 1=1
	LEFT JOIN LOS_BASEADOS.sucursal sucursal ON sucursal.numeroSucursal = ds.numeroSucursal
	LEFT JOIN LOS_BASEADOS.localidad localidad ON localidad.idLocalidad = sucursal.idLocalidad
	LEFT JOIN LOS_BASEADOS.BI_dimension_ubicacion ubi ON localidad.idLocalidad = ubi.idLocalidad AND localidad.idProvincia = ubi.idProvincia
	LEFT JOIN LOS_BASEADOS.pedido pedido ON pedido.numeroSucursal = sucursal.numeroSucursal
		AND pedido.idEstado = est_ped.idEstado AND LOS_BASEADOS.comparar_fecha(tiempo.anio, tiempo.mes, tiempo.cuatrimestre, pedido.fecha) = 1
		AND LOS_BASEADOS.comparar_turno(turn.turno, pedido.fecha) = 1
	GROUP BY tiempo.idTiempo, turn.idTurnoVenta, ds.idSucursal, ubi.idUbicacion, est_ped.idBiEstadoPedido
END
GO

-- MIGRA DESDE FACTURA (JOINEA CON OTRAS TABLAS PARA LOS DATOS RESTANTES)
-- CANTIDAD Y MONTO TOTAL DE VENTAS POR TIEMPO, UBICACION, SUCURSAL, RANGO ETARIO DEL CLIENTE Y MODELO DEL SILLON 
-- 3584 ROWS - SUM(total) = SUM(SUBTOTAL) DE LA TABLA DETALLE FACTURA --> (SIN CONSIDERAR EL COSTO DE ENVIO, SOLO LOS DETALLES)
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_hecho_venta
AS
BEGIN
	INSERT LOS_BASEADOS.BI_hecho_venta(idTiempo,idUbicacion,idSucursal,idRangoEtario,idBiModeloSillon,total_ventas,cant_ventas_totales,tiempo_total_fabricacion, cant_ventas)
	SELECT tiempo.idTiempo,ubi.idUbicacion, ds.idSucursal, dre.idRangoEtario, dms.idBiModeloSillon, SUM(df.subtotal) as total, SUM(df.cantidad), sum(DATEDIFF(DAY, p.fecha, f.fecha)), COUNT(f.idFactura)
	FROM LOS_BASEADOS.factura f
	JOIN LOS_BASEADOS.cliente cliente ON cliente.idCliente= f.idCliente
	JOIN LOS_BASEADOS.sucursal su ON su.numeroSucursal = f.numeroSucursal
	JOIN LOS_BASEADOS.localidad localidad ON localidad.idLocalidad=su.idLocalidad
	JOIN LOS_BASEADOS.detalle_factura df ON df.idFactura = f.idFactura
	JOIN LOS_BASEADOS.detalle_pedido dp ON df.idDetallePedido = dp.idDetallePedido
	JOIN LOS_BASEADOS.pedido p ON dp.numeroPedido = p.numeroPedido
	JOIN LOS_BASEADOS.sillon s ON s.codigoSillon = dp.codigoSillon
	JOIN LOS_BASEADOS.modelo_sillon ms ON s.codigoModelo = ms.codigoModelo
	JOIN LOS_BASEADOS.BI_dimension_tiempo tiempo ON LOS_BASEADOS.comparar_fecha(tiempo.anio,tiempo.mes,tiempo.cuatrimestre,f.fecha)=1
	JOIN LOS_BASEADOS.BI_dimension_ubicacion ubi ON su.idLocalidad=ubi.idLocalidad AND localidad.idProvincia=ubi.idProvincia
	JOIN LOS_BASEADOS.BI_dimension_sucursal ds ON ds.numeroSucursal = f.numeroSucursal
	JOIN LOS_BASEADOS.BI_dimension_rango_etario dre ON LOS_BASEADOS.comparar_rango_etario(dre.rango,cliente.fechaNacimiento) = 1
	JOIN LOS_BASEADOS.BI_dimension_modelo_sillon dms ON dms.codigoModelo = ms.codigoModelo
	GROUP BY tiempo.idTiempo,ubi.idUbicacion, ds.idSucursal, dre.idRangoEtario, dms.idBiModeloSillon
END
GO

-- MIGRA DESDE FACTURA (JOINEA CON OTRAS TABLAS PARA LOS DATOS RESTANTES)
-- CANTIDAD Y MONTO TOTAL DE VENTAS POR TIEMPO, UBICACION Y SUCURSAL (CONSIDERA EL COSTO DE ENVIO PORQUE VIENE DE FACTURA)
-- 171 Rows = 19 (Tiempo) * 9 (Sucursales) && SUM(cantidad_ventas) = 17408 = ROWS DE LA TABLA FACTURA
CREATE PROCEDURE LOS_BASEADOS.BI_migrar_hecho_venta_por_ubi_y_cuatri
AS
BEGIN
	INSERT LOS_BASEADOS.BI_hecho_venta_por_ubi_y_cuatri(idTiempo,idUbicacion,idSucursal,total_ventas,cant_ventas)
	SELECT tiempo.idTiempo,ubi.idUbicacion, ds.idSucursal, sum(factura.total), count(factura.idFactura)
	FROM LOS_BASEADOS.factura factura 
	JOIN LOS_BASEADOS.sucursal sucursal ON sucursal.numeroSucursal= factura.numeroSucursal
	JOIN LOS_BASEADOS.localidad localidad ON localidad.idLocalidad=sucursal.idLocalidad
	JOIN LOS_BASEADOS.BI_dimension_tiempo tiempo ON LOS_BASEADOS.comparar_fecha(tiempo.anio,tiempo.mes,tiempo.cuatrimestre,factura.fecha)=1
	JOIN LOS_BASEADOS.BI_dimension_ubicacion ubi ON sucursal.idLocalidad=ubi.idLocalidad AND localidad.idProvincia=ubi.idProvincia
	JOIN LOS_BASEADOS.BI_dimension_sucursal ds ON sucursal.numeroSucursal = ds.numeroSucursal
	GROUP BY tiempo.idTiempo, ubi.idUbicacion, ds.idSucursal
END
GO

-- CREACION DE VISTAS --------------------------------------------------------------------

-- 1) 171 Rows = 19 (meses) * 9 (Sucursal)
-- Total  de ingresos  (facturación)  -  total  de  egresos (compras), por cada mes, por cada sucursal
-- OK -- SUM(Ganancia) = 13346491535.63 COINCIDE CON LOS DATOS DEL MODELO ANTERIOR
CREATE VIEW LOS_BASEADOS.gananciasView AS
	SELECT dt.mes,dt.anio,ds.numeroSucursal,ds.direccion,
    SUM(hv.total_ventas) + 
		(SELECT SUM(total_costo_envio) FROM LOS_BASEADOS.BI_hecho_envio he WHERE he.idTiempo = hv.idTiempo AND he.idSucursal = hv.idSucursal)
		- (SELECT SUM(total_compras) FROM LOS_BASEADOS.BI_hecho_compra hc WHERE hc.idTiempo = hv.idTiempo AND hc.idSucursal = hv.idSucursal) AS Ganancia
	FROM LOS_BASEADOS.BI_hecho_venta hv
	JOIN LOS_BASEADOS.BI_dimension_tiempo dt ON hv.idTiempo = dt.idTiempo
	JOIN LOS_BASEADOS.BI_dimension_sucursal ds ON hv.idSucursal = ds.idSucursal
	GROUP BY dt.mes, dt.anio, ds.numeroSucursal, ds.direccion, hv.idTiempo, hv.idSucursal
GO

-- 2) 35 Rows = 5 (Cuatrimestres) * 7 (Provincias)
-- Factura promedio mensual por provincia (de la sucursal) y cuatrimestre
-- OK -- COINCIDE CON LA QUERY DE PRUEBA (CASO BUENOS AIRES FECHA 1/2026)
CREATE VIEW LOS_BASEADOS.facturaPromedioMensualView AS
	SELECT 
		dt.anio,
		dt.cuatrimestre,
		du.provincia,
		SUM(hvuc.total_ventas)/ SUM(hvuc.cant_ventas) AS factura_promedio
	FROM LOS_BASEADOS.BI_hecho_venta_por_ubi_y_cuatri hvuc
	JOIN LOS_BASEADOS.BI_dimension_tiempo dt ON hvuc.idTiempo = dt.idTiempo
	JOIN LOS_BASEADOS.BI_dimension_ubicacion du ON hvuc.idUbicacion = du.idUbicacion
	GROUP BY dt.anio, dt.cuatrimestre, du.provincia
GO

-- 3) 405 Rows = 5 (Cuatrimestres) * 3 (Rango Etario) * 9 (Localidad de Sucursal) * 3 (TOP 3)
-- Top 3 modelos más vendidos por cuatrimestre, localidad y rango etario
-- OK COINCIDE CON EL MODELO ANTERIOR
CREATE VIEW LOS_BASEADOS.rendimientoModelosView AS
	SELECT *
	FROM (
		SELECT dt.anio,dt.cuatrimestre,du.localidad,dre.rango AS rango_etario,dms.modelo,dms.descripcion,SUM(hv.cant_ventas_totales) AS cantidad_ventas, SUM(hv.total_ventas) AS monto_total,
			ROW_NUMBER() OVER (
				PARTITION BY dt.anio, dt.cuatrimestre, du.localidad, dre.rango
				ORDER BY SUM(hv.cant_ventas_totales) DESC
			) AS Ranking
		FROM LOS_BASEADOS.BI_hecho_venta hv
		JOIN LOS_BASEADOS.BI_dimension_tiempo dt ON hv.idTiempo = dt.idTiempo
		JOIN LOS_BASEADOS.BI_dimension_ubicacion du ON hv.idUbicacion = du.idUbicacion
		JOIN LOS_BASEADOS.BI_dimension_rango_etario dre ON hv.idRangoEtario = dre.idRangoEtario
		JOIN LOS_BASEADOS.BI_dimension_modelo_sillon dms ON hv.idBiModeloSillon = dms.idBiModeloSillon
		GROUP BY dt.anio, dt.cuatrimestre, du.localidad, dre.rango, dms.modelo, dms.descripcion
	) t
	WHERE Ranking <= 3
GO

-- 4) 342 Rows = 19 (meses) * 9 (Sucursal) * 2 (Turno)
-- Cantidad de pedidos por turno, sucursal y mes
-- OK COINCIDE CON LA QUERY DE PRUEBA (CASO SUCURSAL 37 MES 1/2026 TURNO TARDE 78 ROWS)
CREATE VIEW LOS_BASEADOS.volumenPedidosView AS
    SELECT 
        dt.anio,
        dt.mes,
        ds.numeroSucursal,
        dtv.turno,
        SUM(hp.cant_pedidos) AS cant_pedidos
    FROM LOS_BASEADOS.BI_hecho_pedido hp
    JOIN LOS_BASEADOS.BI_dimension_tiempo dt ON hp.idTiempo = dt.idTiempo
    JOIN LOS_BASEADOS.BI_dimension_sucursal ds ON hp.idSucursal = ds.idSucursal
    JOIN LOS_BASEADOS.BI_dimension_turno_venta dtv ON hp.idTurnoVenta = dtv.idTurnoVenta
    GROUP BY dt.anio, dt.mes, ds.numeroSucursal, dtv.turno
GO

-- 5) 135 Rows = 3 (Estados) * 5 (Cuatrimestres) * 9 (Sucursal)
-- Porcentaje de pedidos según estado, por cuatrimestre y sucursal
-- OK -- COINCIDEN LAS CANTIDADES CON LAS QUERY DE PRUEBA
CREATE VIEW LOS_BASEADOS.conversionPedidosView AS
	SELECT 
		dt.anio,
		dt.cuatrimestre,
		ds.numeroSucursal,
		dep.estado,
		SUM(hp.cant_pedidos) AS Cantidad_Pedidos_En_Estado,
		SUM(SUM(hp.cant_pedidos)) OVER (PARTITION BY dt.anio, dt.cuatrimestre, ds.numeroSucursal) AS Cantidad_Total_Pedidos,
		CAST(SUM(hp.cant_pedidos) * 100.0 / NULLIF( SUM(SUM(hp.cant_pedidos)) OVER (PARTITION BY dt.anio, dt.cuatrimestre, ds.numeroSucursal), 0) AS DECIMAL(5,2)) AS Porcentaje
	FROM LOS_BASEADOS.BI_hecho_pedido hp
	JOIN LOS_BASEADOS.BI_dimension_tiempo dt ON hp.idTiempo = dt.idTiempo
	JOIN LOS_BASEADOS.BI_dimension_sucursal ds ON hp.idSucursal = ds.idSucursal
	JOIN LOS_BASEADOS.BI_dimension_estado_pedido dep ON hp.idBiEstadoPedido = dep.idBiEstadoPedido
	GROUP BY dt.anio, dt.cuatrimestre, ds.numeroSucursal, dep.estado
GO

-- 6) 45 Rows = 5 (Cuatrimestres) * 9 (Sucursal)
-- Promedio de días que pasan entre pedido y factura por sucursal y cuatrimestre
-- OK
CREATE VIEW LOS_BASEADOS.tiempoPromedioFabricacionView AS
	SELECT dt.anio, dt.cuatrimestre, ds.numeroSucursal, SUM(hv.tiempo_total_fabricacion)/SUM(hv.cant_ventas) TiempoPromedio
	FROM LOS_BASEADOS.BI_hecho_venta hv
	JOIN LOS_BASEADOS.BI_dimension_sucursal ds ON hv.idSucursal = ds.idSucursal
	JOIN LOS_BASEADOS.BI_dimension_tiempo dt ON hv.idTiempo = dt.idTiempo
	GROUP BY dt.cuatrimestre, dt.anio, ds.numeroSucursal
GO

-- 7) 19 Rows = 19 (meses)
-- Promedio de compras por mes
-- OK -- COINCIDEN CON LAS QUERY DE PRUEBA
CREATE VIEW LOS_BASEADOS.promedioComprasView AS
	WITH compras_unicas AS (
	SELECT dt.anio, dt.mes, compra.idCompra, SUM(detalle_compra.subtotal) AS total
	FROM LOS_BASEADOS.compra compra
	JOIN LOS_BASEADOS.detalle_compra detalle_compra ON detalle_compra.idCompra = compra.idCompra
	JOIN LOS_BASEADOS.BI_dimension_tiempo dt ON LOS_BASEADOS.comparar_fecha(dt.anio, dt.mes, dt.cuatrimestre, compra.fecha) = 1
	GROUP BY dt.anio, dt.mes, compra.idCompra)
	SELECT anio, mes, SUM(total) / COUNT(*) AS promedio_compras
	FROM compras_unicas
	GROUP BY anio, mes
GO

-- 8) 135 Rows = 3 (Tipo Material) * 5 (Cuatrimestres) * 9 (Sucursal)
-- Importe total de compras por Tipo de Material, sucursal y cuatrimestre
-- OK
CREATE VIEW LOS_BASEADOS.comprasPorTipoMaterialView AS
	SELECT dt.anio, dt.cuatrimestre, ds.numeroSucursal, dtm.tipo, SUM(hc.total_compras) AS total_gastado
	FROM LOS_BASEADOS.BI_hecho_compra hc 
	JOIN LOS_BASEADOS.BI_dimension_tiempo dt ON hc.idTiempo = dt.idTiempo
	JOIN LOS_BASEADOS.BI_dimension_sucursal ds ON hc.idSucursal = ds.idSucursal
	JOIN LOS_BASEADOS.BI_dimension_tipo_material dtm ON hc.idBiTipoMaterial = dtm.idBiTipoMaterial
	GROUP BY dt.anio, dt.cuatrimestre, ds.numeroSucursal, dtm.tipo
GO

-- 9) 19 Rows = 19 (meses) -- OK
-- Porcentaje de cumplimiento de envíos en tiempo por mes
-- OK
CREATE VIEW LOS_BASEADOS.porcentajeCumplimientoEnviosView AS
	SELECT 
		dt.anio,
		dt.mes,
		SUM(he.cant_envios_cumplidos) AS envios_cumplidos,
		SUM(he.cant_envios_total) AS envios_totales,
		CAST(SUM(he.cant_envios_cumplidos) * 100.0 / NULLIF(SUM(he.cant_envios_total),0) AS DECIMAL(5,2)) AS porcentaje_cumplimiento
	FROM LOS_BASEADOS.BI_hecho_envio he
	JOIN LOS_BASEADOS.BI_dimension_tiempo dt ON he.idTiempo = dt.idTiempo
	JOIN LOS_BASEADOS.BI_dimension_sucursal ds ON he.idSucursal = ds.idSucursal
	GROUP BY dt.anio, dt.mes
GO

-- 10) 3 Rows = 3 (top 3) -- OK
-- TOP 3 localidades con mayor costo de envío promedio
-- OK
CREATE VIEW LOS_BASEADOS.localidadesConMayorCostoEnvioView AS
	SELECT TOP 3
		du.localidad,
		du.provincia,
		SUM(he.total_costo_envio) / NULLIF(SUM(he.cant_envios_total),0) AS promedio_costo_envio
	FROM LOS_BASEADOS.BI_hecho_envio he
	JOIN LOS_BASEADOS.BI_dimension_ubicacion du ON he.idUbicacionCliente = du.idUbicacion
	GROUP BY du.localidad, du.provincia
	ORDER BY promedio_costo_envio DESC
GO

-- EJECUCION DE PROCEDURES --------------------------------------------------------------------

EXEC LOS_BASEADOS.BI_migrar_dimension_estado_pedido
EXEC LOS_BASEADOS.BI_migrar_dimension_modelo_sillon
EXEC LOS_BASEADOS.BI_migrar_dimension_rango_etario
EXEC LOS_BASEADOS.BI_migrar_dimension_tiempo
EXEC LOS_BASEADOS.BI_migrar_dimension_tipo_material
EXEC LOS_BASEADOS.BI_migrar_dimension_turno_venta
EXEC LOS_BASEADOS.BI_migrar_dimension_sucursal
EXEC LOS_BASEADOS.BI_migrar_dimension_ubicaciones

EXEC LOS_BASEADOS.BI_migrar_hecho_compra
EXEC LOS_BASEADOS.BI_migrar_hecho_envio
EXEC LOS_BASEADOS.BI_migrar_hecho_pedido
EXEC LOS_BASEADOS.BI_migrar_hecho_venta
EXEC LOS_BASEADOS.BI_migrar_hecho_venta_por_ubi_y_cuatri

/*

-------------------- SELECTS DE LAS VISTAS --------------------

SELECT * FROM LOS_BASEADOS.gananciasView
SELECT * FROM LOS_BASEADOS.facturaPromedioMensualView
SELECT * FROM LOS_BASEADOS.rendimientoModelosView
SELECT * FROM LOS_BASEADOS.volumenPedidosView
SELECT * FROM LOS_BASEADOS.conversionPedidosView
SELECT * FROM LOS_BASEADOS.tiempoPromedioFabricacionView
SELECT * FROM LOS_BASEADOS.promedioComprasView
SELECT * FROM LOS_BASEADOS.comprasPorTipoMaterialView
SELECT * FROM LOS_BASEADOS.porcentajeCumplimientoEnviosView
SELECT * FROM LOS_BASEADOS.localidadesConMayorCostoEnvioView

*/