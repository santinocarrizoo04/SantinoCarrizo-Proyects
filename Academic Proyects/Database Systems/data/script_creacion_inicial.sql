USE GD1C2025 -- Usa la DB GD1C2025
GO

-- Crea el schema del grupo
CREATE SCHEMA LOS_BASEADOS
GO

-- Crea un sinonimo para la tabla maestra
CREATE SYNONYM Maestra FOR gd_esquema.Maestra;
GO

-- CREACION DE TABLAS DEL MODELO RELACIONAL DESARROLLADO

CREATE TABLE LOS_BASEADOS.provincia(
    idProvincia TINYINT NOT NULL IDENTITY(1,1),
    provincia NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.localidad(
    idLocalidad SMALLINT NOT NULL IDENTITY(1,1),
    idProvincia TINYINT NOT NULL,
    localidad NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.sucursal(
    numeroSucursal BIGINT NOT NULL,
    idLocalidad SMALLINT NOT NULL,
    direccion NVARCHAR(255) NOT NULL,
    telefono NVARCHAR(255) NOT NULL,
    mail NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.proveedor(
    idProveedor INT NOT NULL IDENTITY(1,1),
    idLocalidad SMALLINT NOT NULL,
    direccion NVARCHAR(255) NOT NULL,
    telefono NVARCHAR(255) NOT NULL,
    mail NVARCHAR(255) NOT NULL,
    razonSocial NVARCHAR(255) NOT NULL,
    cuit NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.compra(
    idCompra BIGINT NOT NULL IDENTITY(1,1),
    numeroCompra DECIMAL(18,0) NOT NULL,
    numeroSucursal BIGINT NOT NULL,
    idProveedor INT NOT NULL,
    fecha DATETIME2(6) NOT NULL,
    total DECIMAL(18,2) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.tipo_material(
    idTipoMaterial INT NOT NULL IDENTITY(1,1),
    tipo NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.tela(
    idTela INT NOT NULL IDENTITY(1,1),
    idMaterial INT NOT NULL,
    color NVARCHAR(255) NOT NULL,
    textura NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.madera(
    idMadera INT NOT NULL IDENTITY(1,1),
    idMaterial INT NOT NULL,
    color NVARCHAR(255) NOT NULL,
    dureza NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.relleno(
    idRelleno INT NOT NULL IDENTITY(1,1),
    idMaterial INT NOT NULL,
    densidad NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.detalle_compra(
    idDetalleCompra BIGINT NOT NULL IDENTITY(1,1),
    idCompra BIGINT NOT NULL,
    idMaterial INT NOT NULL,
    precioUnitario DECIMAL(18,2),
    cantidad DECIMAL(18,0),
    subtotal DECIMAL(18,2)
);
GO

CREATE TABLE LOS_BASEADOS.material(
    idMaterial INT NOT NULL IDENTITY(1,1),
    idTipoMaterial INT NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    descripcion NVARCHAR(255) NOT NULL,
    precio DECIMAL(38,2) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.modelo_sillon(
    codigoModelo BIGINT NOT NULL,
    descripcion NVARCHAR(255) NOT NULL,
    precio DECIMAL(18,2) NOT NULL,
	modelo NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.medidas(
    idMedidas INT NOT NULL IDENTITY(1,1),
    alto DECIMAL(18,2) NOT NULL,
    ancho DECIMAL(18,2) NOT NULL,
    profundidad DECIMAL(18,2) NOT NULL,
    precio DECIMAL(18,2) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.sillon(
    codigoSillon BIGINT NOT NULL,
    codigoModelo BIGINT NOT NULL,
    idMedidas INT NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.material_x_sillon(
    codigoSillon BIGINT NOT NULL,
    idMaterial INT NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.cliente(
    idCliente BIGINT NOT NULL IDENTITY(1,1),
    idLocalidad SMALLINT NOT NULL,
    dni BIGINT NOT NULL,
    nombre NVARCHAR(255) NOT NULL,
    apellido NVARCHAR(255) NOT NULL,
    fechaNacimiento DATETIME2(6) NOT NULL,
    telefono NVARCHAR(255) NOT NULL,
    mail NVARCHAR(255) NOT NULL,
    direccion NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.estado(
    idEstado TINYINT NOT NULL IDENTITY(1,1),
    estado NVARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.pedido(
    numeroPedido DECIMAL(18,0) NOT NULL,
    numeroSucursal BIGINT NOT NULL,
    idCliente BIGINT NOT NULL,
    idEstado TINYINT NOT NULL,
    fecha DATETIME2(6) NOT NULL,
    total DECIMAL(18,2) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.cancelacion(
    idCancelacion INT NOT NULL IDENTITY(1,1),
    numeroPedido DECIMAL(18,0) NOT NULL,
    fecha DATETIME2(6) NOT NULL,
    motivo VARCHAR(255) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.detalle_pedido(
    idDetallePedido BIGINT NOT NULL IDENTITY(1,1),
    numeroPedido DECIMAL(18,0) NOT NULL,
    codigoSillon BIGINT NOT NULL,
    precio DECIMAL(18,2) NOT NULL,
    cantidad DECIMAL(18,0) NOT NULL,
    subtotal DECIMAL(18,2) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.factura(
	idFactura BIGINT NOT NULL IDENTITY(1,1),
    numeroFactura BIGINT NOT NULL,
    numeroSucursal BIGINT NOT NULL,
    idCliente BIGINT NOT NULL,
    fecha DATETIME2(6) NOT NULL,
    total DECIMAL(38,2) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.detalle_factura(
    idDetalleFactura BIGINT NOT NULL IDENTITY(1,1),
    idFactura BIGINT NOT NULL,
    idDetallePedido BIGINT NOT NULL,
    precioUnitario DECIMAL(18,2) NOT NULL,
    cantidad DECIMAL(18,0) NOT NULL,
    subtotal DECIMAL(18,2) NOT NULL
);
GO

CREATE TABLE LOS_BASEADOS.envio(
    idEnvio BIGINT NOT NULL IDENTITY(1,1),
	numeroEnvio DECIMAL(18,0) NOT NULL,
    idFactura BIGINT NOT NULL,
    fechaProgramada DATETIME2(6) NOT NULL,
    fechaEntrega DATETIME2(6),
    importeTraslado DECIMAL(18,2) NOT NULL,
    importeSubida DECIMAL(18,2) NOT NULL,
    total DECIMAL(18,2) NOT NULL
);
GO

-- CREACION DE CONSTRAINTS DE LAS TABLAS (PKS, FKS)

-- CREACION DE UNA PRIMARY KEY PARA UNA TABLA
ALTER TABLE LOS_BASEADOS.provincia ADD CONSTRAINT PK_idProvincia PRIMARY KEY(idProvincia);
GO

ALTER TABLE LOS_BASEADOS.localidad ADD CONSTRAINT PK_idLocalidad PRIMARY KEY(idLocalidad);
GO
--CREACION DE UNA FOREIGN KEY PARA UNA TABLA
ALTER TABLE LOS_BASEADOS.localidad ADD CONSTRAINT FK_localidad_provincia FOREIGN KEY(idProvincia) REFERENCES LOS_BASEADOS.provincia(idProvincia);
GO

ALTER TABLE LOS_BASEADOS.sucursal ADD CONSTRAINT PK_numeroSucursal PRIMARY KEY(numeroSucursal);
GO
ALTER TABLE LOS_BASEADOS.sucursal ADD CONSTRAINT FK_sucursal_localidad FOREIGN KEY(idLocalidad) REFERENCES LOS_BASEADOS.localidad(idLocalidad);
GO

ALTER TABLE LOS_BASEADOS.proveedor ADD CONSTRAINT PK_idProveedor PRIMARY KEY(idProveedor);
GO
ALTER TABLE LOS_BASEADOS.proveedor ADD CONSTRAINT FK_proveedor_localidad FOREIGN KEY(idLocalidad) REFERENCES LOS_BASEADOS.localidad(idLocalidad);
GO

ALTER TABLE LOS_BASEADOS.compra ADD CONSTRAINT PK_idCompra PRIMARY KEY(idCompra);
GO
ALTER TABLE LOS_BASEADOS.compra ADD CONSTRAINT FK_compra_proveedor FOREIGN KEY(idProveedor) REFERENCES LOS_BASEADOS.proveedor(idProveedor);
GO
ALTER TABLE LOS_BASEADOS.compra ADD CONSTRAINT FK_compra_sucursal FOREIGN KEY(numeroSucursal) REFERENCES LOS_BASEADOS.sucursal(numeroSucursal);
GO

ALTER TABLE LOS_BASEADOS.tipo_material ADD CONSTRAINT PK_idTipoMaterial PRIMARY KEY(idTipoMaterial);
GO

ALTER TABLE LOS_BASEADOS.material ADD CONSTRAINT PK_idMaterial PRIMARY KEY(idMaterial);
GO
ALTER TABLE LOS_BASEADOS.material ADD CONSTRAINT FK_material_tipoMaterial FOREIGN KEY(idTipoMaterial) REFERENCES LOS_BASEADOS.tipo_material(idTipoMaterial);
GO

ALTER TABLE LOS_BASEADOS.tela ADD CONSTRAINT PK_idTela PRIMARY KEY(idTela);
GO
ALTER TABLE LOS_BASEADOS.tela ADD CONSTRAINT FK_tela_material FOREIGN KEY(idMaterial) REFERENCES LOS_BASEADOS.material(idMaterial);
GO

ALTER TABLE LOS_BASEADOS.madera ADD CONSTRAINT PK_idMadera PRIMARY KEY(idMadera);
GO
ALTER TABLE LOS_BASEADOS.madera ADD CONSTRAINT FK_madera_material FOREIGN KEY(idMaterial) REFERENCES LOS_BASEADOS.material(idMaterial);
GO

ALTER TABLE LOS_BASEADOS.relleno ADD CONSTRAINT PK_idRelleno PRIMARY KEY(idRelleno);
GO
ALTER TABLE LOS_BASEADOS.relleno ADD CONSTRAINT FK_relleno_material FOREIGN KEY(idMaterial) REFERENCES LOS_BASEADOS.material(idMaterial);
GO

ALTER TABLE LOS_BASEADOS.detalle_compra ADD CONSTRAINT PK_idDetalleCompra PRIMARY KEY(idDetalleCompra);
GO
ALTER TABLE LOS_BASEADOS.detalle_compra ADD CONSTRAINT FK_detalleCompra_compra FOREIGN KEY(idCompra) REFERENCES LOS_BASEADOS.compra(idCompra);
GO
ALTER TABLE LOS_BASEADOS.detalle_compra ADD CONSTRAINT FK_detalleCompra_material FOREIGN KEY(idMaterial) REFERENCES LOS_BASEADOS.material(idMaterial);
GO

ALTER TABLE LOS_BASEADOS.modelo_sillon ADD CONSTRAINT PK_codigoModelo PRIMARY KEY(codigoModelo);
GO

ALTER TABLE LOS_BASEADOS.medidas ADD CONSTRAINT PK_idMedidas PRIMARY KEY(idMedidas);
GO

ALTER TABLE LOS_BASEADOS.sillon ADD CONSTRAINT PK_codigoSillon PRIMARY KEY(codigoSillon);
GO
ALTER TABLE LOS_BASEADOS.sillon ADD CONSTRAINT FK_sillon_modeloSillon FOREIGN KEY(codigoModelo) REFERENCES LOS_BASEADOS.modelo_sillon(codigoModelo);
GO
ALTER TABLE LOS_BASEADOS.sillon ADD CONSTRAINT FK_sillon_medidas FOREIGN KEY(idMedidas) REFERENCES LOS_BASEADOS.medidas(idMedidas);
GO

ALTER TABLE LOS_BASEADOS.material_x_sillon ADD CONSTRAINT FK_materialXSillon_sillon FOREIGN KEY(codigoSillon) REFERENCES LOS_BASEADOS.sillon(codigoSillon);
GO
ALTER TABLE LOS_BASEADOS.material_x_sillon ADD CONSTRAINT FK_materialXSillon_material FOREIGN KEY(idMaterial) REFERENCES LOS_BASEADOS.material(idMaterial);
GO

ALTER TABLE LOS_BASEADOS.cliente ADD CONSTRAINT PK_idCliente PRIMARY KEY(idCliente);
GO
ALTER TABLE LOS_BASEADOS.cliente ADD CONSTRAINT FK_cliente_localidad FOREIGN KEY(idLocalidad) REFERENCES LOS_BASEADOS.localidad(idLocalidad);
GO

ALTER TABLE LOS_BASEADOS.estado ADD CONSTRAINT PK_idEstado PRIMARY KEY(idEstado);
GO

ALTER TABLE LOS_BASEADOS.pedido ADD CONSTRAINT PK_numeroPedido PRIMARY KEY(numeroPedido);
GO
ALTER TABLE LOS_BASEADOS.pedido ADD CONSTRAINT FK_pedido_sucursal FOREIGN KEY(numeroSucursal) REFERENCES LOS_BASEADOS.sucursal(numeroSucursal);
GO
ALTER TABLE LOS_BASEADOS.pedido ADD CONSTRAINT FK_pedido_cliente FOREIGN KEY(idCliente) REFERENCES LOS_BASEADOS.cliente(idCliente);
GO
ALTER TABLE LOS_BASEADOS.pedido ADD CONSTRAINT FK_pedido_estado FOREIGN KEY(idEstado) REFERENCES LOS_BASEADOS.estado(idEstado);
GO

ALTER TABLE LOS_BASEADOS.cancelacion ADD CONSTRAINT PK_idCancelacion PRIMARY KEY(idCancelacion);
GO
ALTER TABLE LOS_BASEADOS.cancelacion ADD CONSTRAINT FK_cancelacion_pedido FOREIGN KEY(numeroPedido) REFERENCES LOS_BASEADOS.pedido(numeroPedido);
GO

ALTER TABLE LOS_BASEADOS.detalle_pedido ADD CONSTRAINT PK_idDetallePedido PRIMARY KEY(idDetallePedido);
GO
ALTER TABLE LOS_BASEADOS.detalle_pedido ADD CONSTRAINT FK_detallePedido_pedido FOREIGN KEY(numeroPedido) REFERENCES LOS_BASEADOS.pedido(numeroPedido);
GO
ALTER TABLE LOS_BASEADOS.detalle_pedido ADD CONSTRAINT FK_detallePedido_sillon FOREIGN KEY(codigoSillon) REFERENCES LOS_BASEADOS.sillon(codigoSillon);
GO

ALTER TABLE LOS_BASEADOS.factura ADD CONSTRAINT PK_idFactura PRIMARY KEY(idFactura);
GO
ALTER TABLE LOS_BASEADOS.factura ADD CONSTRAINT FK_factura_sucursal FOREIGN KEY(numeroSucursal) REFERENCES LOS_BASEADOS.sucursal(numeroSucursal);
GO
ALTER TABLE LOS_BASEADOS.factura ADD CONSTRAINT FK_factura_cliente FOREIGN KEY(idCliente) REFERENCES LOS_BASEADOS.cliente(idCliente);
GO

ALTER TABLE LOS_BASEADOS.detalle_factura ADD CONSTRAINT PK_idDetalleFactura PRIMARY KEY(idDetalleFactura);
GO
ALTER TABLE LOS_BASEADOS.detalle_factura ADD CONSTRAINT FK_detalleFactura_factura FOREIGN KEY(idFactura) REFERENCES LOS_BASEADOS.factura(idFactura);
GO
ALTER TABLE LOS_BASEADOS.detalle_factura ADD CONSTRAINT FK_detalleFactura_detallePedido FOREIGN KEY(idDetallePedido) REFERENCES LOS_BASEADOS.detalle_pedido(idDetallePedido);
GO

ALTER TABLE LOS_BASEADOS.envio ADD CONSTRAINT PK_idEnvio PRIMARY KEY(idEnvio);
GO
ALTER TABLE LOS_BASEADOS.envio ADD CONSTRAINT FK_envio_factura FOREIGN KEY(idFactura) REFERENCES LOS_BASEADOS.factura(idFactura);
GO

-- CREACION DE PROCEDURES DE MIGRACION DE DATOS

CREATE PROC LOS_BASEADOS.migrar_estados AS
BEGIN
    INSERT INTO LOS_BASEADOS.estado (estado)
    SELECT DISTINCT m.Pedido_Estado 
    FROM Maestra m
    WHERE m.Pedido_Estado IS NOT NULL;

    INSERT INTO LOS_BASEADOS.estado (estado) VALUES ('PENDIENTE')
END
GO

CREATE PROC LOS_BASEADOS.migrar_provincias AS
BEGIN
    INSERT INTO LOS_BASEADOS.provincia (provincia)
    SELECT DISTINCT m.Cliente_Provincia 
    FROM Maestra m
    WHERE m.Cliente_Provincia IS NOT NULL
    UNION
    SELECT DISTINCT m.Sucursal_provincia
    FROM Maestra m
    WHERE m.Sucursal_provincia IS NOT NULL
    UNION
    SELECT DISTINCT m.Proveedor_provincia 
    FROM Maestra m
    WHERE m.Proveedor_provincia IS NOT NULL;
END
GO

CREATE PROC LOS_BASEADOS.migrar_localidades AS
BEGIN
    INSERT INTO LOS_BASEADOS.localidad (localidad, idProvincia)
    SELECT DISTINCT m.Cliente_Localidad, p.idProvincia
    FROM Maestra m JOIN LOS_BASEADOS.provincia p ON m.Cliente_Provincia = p.provincia
    WHERE m.Cliente_Localidad IS NOT NULL AND p.idProvincia IS NOT NULL
    UNION
    SELECT DISTINCT m.Proveedor_Localidad localidad, p.idProvincia
    FROM Maestra m JOIN LOS_BASEADOS.provincia p ON m.Proveedor_provincia = p.provincia
    WHERE m.Proveedor_Localidad IS NOT NULL AND p.idProvincia IS NOT NULL
    UNION
    SELECT DISTINCT m.Sucursal_Localidad localidad, p.idProvincia
    FROM Maestra m JOIN LOS_BASEADOS.provincia p ON m.Sucursal_provincia = p.provincia
    WHERE m.Sucursal_Localidad IS NOT NULL AND p.idProvincia IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_sucursales AS
BEGIN
    INSERT INTO LOS_BASEADOS.sucursal (numeroSucursal, idLocalidad, direccion, telefono, mail)
    SELECT DISTINCT 
		m.Sucursal_NroSucursal, 
		l.idLocalidad, 
		m.Sucursal_Direccion, 
		m.Sucursal_telefono, 
		m.Sucursal_mail
    FROM Maestra m 
	JOIN LOS_BASEADOS.provincia p ON m.Sucursal_Provincia = p.provincia
    JOIN LOS_BASEADOS.localidad l ON m.Sucursal_Localidad = l.localidad AND l.idProvincia = p.idProvincia
    WHERE m.Sucursal_NroSucursal IS NOT NULL AND l.idLocalidad IS NOT NULL 
        AND m.Sucursal_Direccion IS NOT NULL AND m.Sucursal_telefono IS NOT NULL AND m.Sucursal_mail IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_proveedores AS
BEGIN
    INSERT INTO LOS_BASEADOS.proveedor (idLocalidad, razonSocial, direccion, telefono, mail, cuit)
    SELECT DISTINCT 
		l.idLocalidad, 
		m.Proveedor_RazonSocial, 
		m.Proveedor_Direccion, 
		m.Proveedor_Telefono, 
		m.Proveedor_Mail, 
		m.Proveedor_Cuit
    FROM Maestra m 
	JOIN LOS_BASEADOS.provincia p ON m.Proveedor_Provincia = p.provincia
    JOIN LOS_BASEADOS.localidad l ON m.Proveedor_Localidad = l.localidad AND l.idProvincia = p.idProvincia
    WHERE m.Proveedor_Cuit IS NOT NULL AND l.idLocalidad IS NOT NULL AND m.Proveedor_RazonSocial IS NOT NULL AND m.Proveedor_Direccion IS NOT NULL
         AND m.Proveedor_Telefono IS NOT NULL AND m.Proveedor_Mail IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_tipoMaterial AS
BEGIN
    INSERT INTO LOS_BASEADOS.tipo_material (tipo)
    SELECT DISTINCT Material_tipo 
    FROM Maestra 
    WHERE Material_tipo IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_materiales AS
BEGIN
    INSERT INTO LOS_BASEADOS.material (idTipoMaterial, nombre, descripcion, precio)
    SELECT DISTINCT 
		t.idTipoMaterial, 
		m.Material_Nombre, 
		m.Material_descripcion, 
		m.Material_Precio
    FROM Maestra m 
	JOIN LOS_BASEADOS.tipo_material t ON m.Material_Tipo = t.tipo
    WHERE Material_tipo IS NOT NULL AND m.Material_Descripcion IS NOT NULL AND m.Material_Nombre IS NOT NULL AND m.Material_Precio IS NOT NULL
         AND t.idTipoMaterial IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_telas AS
BEGIN
    INSERT INTO LOS_BASEADOS.tela (idMaterial, color, textura)
    SELECT DISTINCT 
		t.idMaterial, 
		m.Tela_Color, 
		m.Tela_Textura
    FROM Maestra m 
	JOIN LOS_BASEADOS.material t ON m.Material_Nombre = t.nombre AND m.Material_Descripcion = t.descripcion
    WHERE m.Tela_Color IS NOT NULL AND m.Tela_Textura IS NOT NULL AND t.idMaterial IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_maderas AS
BEGIN
    INSERT INTO LOS_BASEADOS.madera (idMaterial, color, dureza)
    SELECT DISTINCT 
		t.idMaterial, 
		m.Madera_Color, 
		m.Madera_Dureza
    FROM Maestra m 
	JOIN LOS_BASEADOS.material t ON m.Material_Nombre = t.nombre AND m.Material_Descripcion = t.descripcion
    WHERE m.Madera_Color IS NOT NULL AND m.Madera_Dureza IS NOT NULL AND t.idMaterial IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_rellenos AS
BEGIN
    INSERT INTO LOS_BASEADOS.relleno (idMaterial, densidad)
    SELECT DISTINCT 
		t.idMaterial, 
		m.Relleno_Densidad
    FROM Maestra m 
	JOIN LOS_BASEADOS.material t ON m.Material_Nombre = t.nombre AND m.Material_Descripcion = t.descripcion
    WHERE m.Relleno_Densidad IS NOT NULL AND t.idMaterial IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_compras AS
BEGIN
    INSERT INTO LOS_BASEADOS.compra (numeroCompra, numeroSucursal, idProveedor, fecha, total)
    SELECT DISTINCT
		m.Compra_Numero, 
		s.numeroSucursal, 
		p.idProveedor, 
		m.Compra_Fecha, 
		m.Compra_Total
    FROM Maestra m 
	JOIN LOS_BASEADOS.sucursal s ON m.Sucursal_NroSucursal = s.numeroSucursal
    JOIN LOS_BASEADOS.proveedor p ON m.Proveedor_Cuit = p.cuit AND m.Proveedor_RazonSocial = p.razonSocial
    WHERE m.Compra_Numero IS NOT NULL AND s.numeroSucursal IS NOT NULL AND p.idProveedor IS NOT NULL 
        AND m.Compra_Fecha IS NOT NULL AND m.Compra_Total IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_detalleCompra AS
BEGIN
    INSERT INTO LOS_BASEADOS.detalle_compra (idCompra, idMaterial, precioUnitario, cantidad, subtotal)
    SELECT 
		c.idCompra, 
		mat.idMaterial, 
		m.Detalle_Compra_Precio, 
		m.Detalle_Compra_Cantidad, 
		m.Detalle_Compra_SubTotal
    FROM Maestra m 
	JOIN LOS_BASEADOS.compra c ON m.Compra_Numero = c.numeroCompra
    JOIN LOS_BASEADOS.material mat ON m.Material_Nombre = mat.nombre AND m.Material_Descripcion = mat.descripcion
    WHERE c.numeroCompra IS NOT NULL AND mat.idMaterial IS NOT NULL AND m.Detalle_Compra_Precio IS NOT NULL 
        AND m.Detalle_Compra_Cantidad IS NOT NULL AND m.Detalle_Compra_SubTotal IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_cliente AS
BEGIN
	INSERT INTO LOS_BASEADOS.cliente (idLocalidad, dni , nombre, apellido, fechaNacimiento, telefono, mail, direccion)
	SELECT DISTINCT
		l.idLocalidad,
		m.Cliente_Dni,
		m.Cliente_Nombre,
		m.Cliente_Apellido,
		m.Cliente_FechaNacimiento,
		m.Cliente_Telefono,
		m.Cliente_Mail,
		m.Cliente_Direccion 
	FROM Maestra m 
	JOIN LOS_BASEADOS.provincia p ON m.Cliente_Provincia=p.provincia
	JOIN LOS_BASEADOS.localidad l ON m.Cliente_Localidad = l.localidad AND l.idProvincia = p.idProvincia
	WHERE m.Cliente_DNI IS NOT NULL AND l.idLocalidad IS NOT NULL AND m.Cliente_Nombre IS NOT NULL AND m.Cliente_Apellido IS NOT NULL
        AND m.Cliente_FechaNacimiento IS NOT NULL AND m.Cliente_Telefono IS NOT NULL AND m.Cliente_Mail IS NOT NULL AND m.Cliente_Direccion IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_factura AS
BEGIN
	INSERT INTO LOS_BASEADOS.factura (numeroFactura,numeroSucursal,idCliente,fecha,total)
	SELECT DISTINCT 
		m.Factura_Numero, 
		s.numeroSucursal, 
		c.idCliente, 
		m.Factura_Fecha, 
		m.Factura_Total 
	FROM Maestra m 
	JOIN LOS_BASEADOS.sucursal s ON m.Sucursal_NroSucursal = s.numeroSucursal
	JOIN LOS_BASEADOS.cliente c ON m.Cliente_Dni = c.dni
	WHERE m.Factura_Numero IS NOT NULL AND s.numeroSucursal IS NOT NULL AND c.idCliente IS NOT NULL AND m.Factura_Fecha IS NOT NULL AND m.Factura_Total IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_envio AS 
BEGIN
	INSERT INTO LOS_BASEADOS.envio (numeroEnvio, idFactura, fechaProgramada, fechaEntrega, importeTraslado, importeSubida, total)
	SELECT DISTINCT 
		m.Envio_Numero,
		f.idFactura, 
		m.Envio_Fecha_Programada, 
		m.Envio_Fecha, 
		m.Envio_ImporteTraslado, 
		m.Envio_importeSubida, 
		m.Envio_Total
	FROM Maestra m 
	JOIN LOS_BASEADOS.factura f ON f.numeroFactura = m.Factura_Numero
	WHERE m.Envio_Numero IS NOT NULL AND f.idFactura IS NOT NULL AND m.Envio_Fecha_Programada IS NOT NULL
        AND m.Envio_importeSubida IS NOT NULL AND m.Envio_ImporteTraslado IS NOT NULL AND m.Envio_Total IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_modeloSillon AS
BEGIN
    INSERT INTO LOS_BASEADOS.modelo_sillon (codigoModelo, modelo, descripcion, precio)
    SELECT DISTINCT 
        m.Sillon_Modelo_Codigo, 
        m.Sillon_Modelo, 
        m.Sillon_Modelo_Descripcion, 
        m.Sillon_Modelo_Precio
    FROM Maestra m
    WHERE m.Sillon_Modelo_Codigo IS NOT NULL AND m.Sillon_Modelo IS NOT NULL AND m.Sillon_Modelo_Descripcion IS NOT NULL AND m.Sillon_Modelo_Precio IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_medidas AS
BEGIN
    INSERT INTO LOS_BASEADOS.medidas (alto, ancho, profundidad, precio)
    SELECT DISTINCT 
        m.Sillon_Medida_Alto,
        m.Sillon_Medida_Ancho,
        m.Sillon_Medida_Profundidad,
        m.Sillon_Medida_Precio
    FROM Maestra m
    WHERE m.Sillon_Medida_Precio IS NOT NULL AND m.Sillon_Medida_Alto IS NOT NULL 
        AND m.Sillon_Medida_Ancho IS NOT NULL AND m.Sillon_Medida_Profundidad IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_sillones AS
BEGIN
    INSERT INTO LOS_BASEADOS.sillon (codigoSillon, codigoModelo, idMedidas)
    SELECT DISTINCT 
        m.Sillon_Codigo,
        mo.codigoModelo,
        me.idMedidas
    FROM Maestra m
    JOIN LOS_BASEADOS.modelo_sillon mo ON m.Sillon_Modelo_Codigo = mo.codigoModelo
    JOIN LOS_BASEADOS.medidas me ON 
        m.Sillon_Medida_Alto = me.alto AND
        m.Sillon_Medida_Ancho = me.ancho AND
        m.Sillon_Medida_Profundidad = me.profundidad AND
        m.Sillon_Medida_Precio = me.precio
    WHERE m.Sillon_Codigo IS NOT NULL AND mo.codigoModelo IS NOT NULL AND me.idMedidas IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_materialXSillon AS
BEGIN
    INSERT INTO LOS_BASEADOS.material_x_sillon (codigoSillon, idMaterial)
    SELECT DISTINCT 
        m.Sillon_Codigo,
        mat.idMaterial
    FROM Maestra m
    JOIN LOS_BASEADOS.material mat ON m.Material_Nombre = mat.nombre AND m.Material_Descripcion = mat.descripcion
    WHERE m.Sillon_Codigo IS NOT NULL AND mat.idMaterial IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_pedidos AS
BEGIN
    INSERT INTO LOS_BASEADOS.pedido (numeroPedido, numeroSucursal, idCliente, idEstado, fecha, total)
    SELECT DISTINCT 
        m.Pedido_Numero,
        s.numeroSucursal,
        c.idCliente,
        e.idEstado,
        m.Pedido_Fecha,
        m.Pedido_Total
    FROM Maestra m
    JOIN LOS_BASEADOS.sucursal s ON m.Sucursal_NroSucursal = s.numeroSucursal
    JOIN LOS_BASEADOS.cliente c ON m.Cliente_Dni = c.dni
    JOIN LOS_BASEADOS.estado e ON m.Pedido_Estado = e.estado
    WHERE m.Pedido_Numero IS NOT NULL AND s.numeroSucursal IS NOT NULL AND c.idCliente IS NOT NULL AND e.idEstado IS NOT NULL
        AND m.Pedido_Fecha IS NOT NULL AND m.Pedido_Total IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_cancelaciones AS
BEGIN
    INSERT INTO LOS_BASEADOS.cancelacion (numeroPedido, fecha, motivo)
    SELECT DISTINCT 
        p.numeroPedido,
        m.Pedido_Cancelacion_Fecha,
        m.Pedido_Cancelacion_Motivo
    FROM Maestra m JOIN LOS_BASEADOS.pedido p ON m.Pedido_Numero = p.numeroPedido
    WHERE m.Pedido_Cancelacion_Fecha IS NOT NULL AND m.Pedido_Numero IS NOT NULL AND m.Pedido_Cancelacion_Motivo IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_detallePedido AS
BEGIN
    INSERT INTO LOS_BASEADOS.detalle_pedido (numeroPedido, codigoSillon, precio, cantidad, subtotal)
    SELECT DISTINCT 
        p.numeroPedido,
        s.codigoSillon,
        m.Detalle_Pedido_Precio,
        m.Detalle_Pedido_Cantidad,
        m.Detalle_Pedido_SubTotal
    FROM Maestra m
    JOIN LOS_BASEADOS.sillon s ON m.Sillon_Codigo = s.codigoSillon
	JOIN LOS_BASEADOS.pedido p ON m.Pedido_Numero = p.numeroPedido
    WHERE m.Pedido_Numero IS NOT NULL AND s.codigoSillon IS NOT NULL AND m.Detalle_Pedido_Precio IS NOT NULL 
        AND m.Detalle_Pedido_Cantidad IS NOT NULL AND m.Detalle_Pedido_SubTotal IS NOT NULL
END
GO

CREATE PROC LOS_BASEADOS.migrar_detalleFactura AS
BEGIN
    WITH MaestraConDetalle AS (
        SELECT 
            m.*,
            (
                SELECT TOP 1 dp2.idDetallePedido
                FROM LOS_BASEADOS.detalle_pedido dp2
                WHERE dp2.numeroPedido = m.Pedido_Numero
                  AND dp2.precio = m.Detalle_Pedido_Precio
                  AND dp2.cantidad = m.Detalle_Pedido_Cantidad
                  AND dp2.subtotal = m.Detalle_Pedido_SubTotal
            ) AS idDetallePedido
        FROM Maestra m
    )
    INSERT INTO LOS_BASEADOS.detalle_factura (
        idFactura, idDetallePedido, precioUnitario, cantidad, subtotal
    )
    SELECT 
        f.idFactura,
        mcd.idDetallePedido,
        mcd.Detalle_Factura_Precio,
        mcd.Detalle_Factura_Cantidad,
        mcd.Detalle_Factura_SubTotal
    FROM MaestraConDetalle mcd
    JOIN LOS_BASEADOS.factura f 
        ON mcd.Factura_Numero = f.numeroFactura
    WHERE mcd.Factura_Numero IS NOT NULL
      AND mcd.idDetallePedido IS NOT NULL
    ORDER BY f.idFactura;
END
GO

-- CREACION DE INDICES

        -- LOCALIDAD por localidad(nombre)
CREATE INDEX IX_localidad_nombre ON LOS_BASEADOS.localidad (localidad);

-- LOCALIDAD por provincia(idProvincia)
CREATE INDEX IX_localidad_provincia_localidad ON LOS_BASEADOS.localidad (idProvincia);

        -- CLIENTE por DNI
CREATE INDEX IX_cliente_dni ON LOS_BASEADOS.cliente (dni);

        -- FACTURA por numeroFactura
CREATE INDEX IX_factura_numero ON LOS_BASEADOS.factura (numeroFactura);

        -- PEDIDO por numeroPedido
CREATE INDEX IX_pedido_numero ON LOS_BASEADOS.pedido (numeroPedido);

        -- DETALLE_FACTURA por idFactura
CREATE INDEX IX_detalleFactura_idFactura ON LOS_BASEADOS.detalle_factura (idFactura);

        -- SILLON por codigo
CREATE INDEX IX_sillon_codigoSillon ON LOS_BASEADOS.sillon (codigoSillon);

        -- MATERIAL_X_SILLON por idMaterial (consultas de materiales)
CREATE INDEX IX_materialXSillon_idMaterial ON LOS_BASEADOS.material_x_sillon (idMaterial);

        -- MATERIAL_X_SILLON por codigoSillon (consultas por sillon)
CREATE INDEX IX_materialXSillon_codigoSillon ON LOS_BASEADOS.material_x_sillon (codigoSillon);

        -- DETALLE_COMPRA por numeroCompra
CREATE INDEX IX_detalleCompra_numeroCompra ON LOS_BASEADOS.detalle_compra (idCompra);


-- EJECUCION DE PROCEDURES CREADOS

EXEC LOS_BASEADOS.migrar_estados
EXEC LOS_BASEADOS.migrar_provincias
EXEC LOS_BASEADOS.migrar_localidades
EXEC LOS_BASEADOS.migrar_sucursales
EXEC LOS_BASEADOS.migrar_proveedores
EXEC LOS_BASEADOS.migrar_tipoMaterial
EXEC LOS_BASEADOS.migrar_materiales
EXEC LOS_BASEADOS.migrar_telas
EXEC LOS_BASEADOS.migrar_maderas
EXEC LOS_BASEADOS.migrar_rellenos
EXEC LOS_BASEADOS.migrar_compras
EXEC LOS_BASEADOS.migrar_detalleCompra
EXEC LOS_BASEADOS.migrar_cliente
EXEC LOS_BASEADOS.migrar_factura
EXEC LOS_BASEADOS.migrar_envio
EXEC LOS_BASEADOS.migrar_modeloSillon
EXEC LOS_BASEADOS.migrar_medidas
EXEC LOS_BASEADOS.migrar_sillones
EXEC LOS_BASEADOS.migrar_materialXSillon
EXEC LOS_BASEADOS.migrar_pedidos
EXEC LOS_BASEADOS.migrar_cancelaciones
EXEC LOS_BASEADOS.migrar_detallePedido
EXEC LOS_BASEADOS.migrar_detalleFactura