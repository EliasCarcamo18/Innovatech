CREATE DATABASE IF NOT EXISTS innovatech_db;
USE innovatech_db;

CREATE TABLE IF NOT EXISTS venta (
    id_venta BIGINT AUTO_INCREMENT PRIMARY KEY,
    direccion_compra VARCHAR(255) NOT NULL,
    valor_compra DOUBLE,
    fecha_compra DATE NOT NULL,
    despacho_generado BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE IF NOT EXISTS despacho (
    id_despacho BIGINT AUTO_INCREMENT PRIMARY KEY,
    fecha_despacho DATE,
    patente_camion VARCHAR(50),
    intento INT,
    id_compra BIGINT,
    direccion_compra VARCHAR(255),
    valor_compra DOUBLE,
    despachado BOOLEAN DEFAULT FALSE
);

INSERT INTO venta 
(direccion_compra, valor_compra, fecha_compra, despacho_generado) 
VALUES
('Av. Providencia 1234, Santiago', 129990, '2026-06-20', 0),
('Av. La Florida 4550, Santiago', 89990, '2026-06-21', 0),
('Camino El Alba 9210, Las Condes', 159990, '2026-06-22', 1);

INSERT INTO despacho 
(fecha_despacho, patente_camion, intento, id_compra, direccion_compra, valor_compra, despachado) 
VALUES
('2026-06-23', 'ABCD12', 1, 3, 'Camino El Alba 9210, Las Condes', 159990, 0);