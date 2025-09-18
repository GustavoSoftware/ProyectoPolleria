
-- Crear los tipos ENUM primero
CREATE TYPE rol_usuario AS ENUM ('cliente', 'operario');
CREATE TYPE tipo_producto AS ENUM ('Pollo', 'Bebida', 'Acompañamiento', 'Postre');
CREATE TYPE estado_pedido AS ENUM ('pendiente', 'en_preparacion', 'en_camino', 'entregado', 'cancelado');
CREATE TYPE metodo_pago AS ENUM ('tarjeta', 'efectivo', 'app_pago');
 
-- Crear las tablas con la sintaxis de PostgreSQL
CREATE TABLE Usuario (
    id_usuario SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    telefono VARCHAR(20),
    direccion VARCHAR(255),
    rol rol_usuario NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE Producto (
    id_producto SERIAL PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL,
    tipo tipo_producto NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
 
CREATE TABLE Pedido (
    id_pedido SERIAL PRIMARY KEY,
    id_usuario INT NOT NULL,
    fecha_hora_pedido TIMESTAMP NOT NULL,
    estado estado_pedido NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_usuario) REFERENCES Usuario(id_usuario)
);
 
CREATE TABLE DetallePedido (
    id_detalle_pedido SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10, 2) NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES Producto(id_producto)
);
 
CREATE TABLE ComprobantePago (
    id_comprobante SERIAL PRIMARY KEY,
    id_pedido INT NOT NULL,
    metodo_pago metodo_pago NOT NULL,
    monto DECIMAL(10, 2) NOT NULL,
    fecha_hora_pago TIMESTAMP NOT NULL,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (id_pedido) REFERENCES Pedido(id_pedido)
);
 
-- Inserta los productos
INSERT INTO Producto (nombre_producto, descripcion, precio, tipo) VALUES
('1/4 de Pollo', 'Incluye papas fritas y ensalada', 25.00, 'Pollo'),
('1/2 Pollo', 'Incluye papas fritas, ensalada y cremas', 45.00, 'Pollo'),
('Pollo Entero', 'Incluye papas fritas familiares, ensalada y cremas', 85.00, 'Pollo'),
('Inca Kola personal', 'Botella de 500ml', 5.00, 'Bebida'),
('Coca Cola personal', 'Botella de 500ml', 5.00, 'Bebida'),
('Gaseosa 1.5L', 'Gaseosa a elegir de 1.5L', 10.00, 'Bebida'),
('Porción de papas fritas', 'Porción adicional de papas fritas', 8.00, 'Acompañamiento'),
('Ensalada', 'Ensalada fresca de lechuga, tomate y pepino', 7.00, 'Acompañamiento'),
('Crema Huancaína', 'Porción de crema de ají', 3.00, 'Acompañamiento');
 
-- Y ahora, crea los triggers para la actualización automática de fechas
CREATE OR REPLACE FUNCTION actualizar_fecha_modificacion()
RETURNS TRIGGER AS $$
BEGIN
    NEW.fecha_modificacion = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
 
CREATE TRIGGER actualizar_usuario_fecha_modificacion
BEFORE UPDATE ON Usuario
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_modificacion();
 
CREATE TRIGGER actualizar_producto_fecha_modificacion
BEFORE UPDATE ON Producto
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_modificacion();
 
CREATE TRIGGER actualizar_pedido_fecha_modificacion
BEFORE UPDATE ON Pedido
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_modificacion();
 
CREATE TRIGGER actualizar_detalle_pedido_fecha_modificacion
BEFORE UPDATE ON DetallePedido
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_modificacion();
 
CREATE TRIGGER actualizar_comprobante_pago_fecha_modificacion
BEFORE UPDATE ON ComprobantePago
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_modificacion();

ALTER TABLE Usuario ALTER COLUMN rol TYPE VARCHAR(50);
ALTER TABLE Producto ALTER COLUMN tipo TYPE VARCHAR(50);
ALTER TABLE Pedido ALTER COLUMN estado TYPE VARCHAR(50);
ALTER TABLE pedido ALTER COLUMN fecha_hora_pedido SET DEFAULT NOW();


select * from producto;
select * from usuario;
select * from pedido;
select * from detallepedido;

INSERT INTO pedido (
    id_usuario,
    fecha_hora_pedido,
    estado,
    total,
    fecha_creacion,
    fecha_modificacion
) VALUES (
    1,  -- id de usuario existente en tu tabla usuario
    NOW(), -- fecha y hora actual del pedido
    'pendiente', -- estado inicial
    45.50,  -- total del pedido
    NOW(),  -- fecha de creación
    NOW()   -- fecha de modificación
);
