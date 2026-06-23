CREATE DATABASE IF NOT EXISTS innovatech_db;
USE innovatech_db;

DROP TABLE IF EXISTS despacho;
DROP TABLE IF EXISTS venta;

CREATE TABLE venta (
    id_venta BIGINT AUTO_INCREMENT PRIMARY KEY,
    direccion_compra VARCHAR(255) NOT NULL,
    valor_compra DOUBLE,
    fecha_compra DATE NOT NULL,
    despacho_generado BOOLEAN NOT NULL DEFAULT FALSE
);

CREATE TABLE despacho (
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
('Camino El Alba 9210, Las Condes', 159990, '2026-06-22', 1),
('Av. Vicuña Mackenna 3400, Macul', 74990, '2026-06-22', 0),
('Av. Las Condes 11200, Las Condes', 219990, '2026-06-23', 0),
('Gran Avenida 7850, La Cisterna', 55990, '2026-06-23', 0),
('Av. Independencia 1800, Independencia', 99990, '2026-06-24', 1),
('Av. Pajaritos 4500, Maipú', 134990, '2026-06-24', 0),
('Av. Irarrázaval 3200, Ñuñoa', 45990, '2026-06-25', 0),
('Av. Recoleta 2100, Recoleta', 189990, '2026-06-25', 1);

INSERT INTO despacho 
(fecha_despacho, patente_camion, intento, id_compra, direccion_compra, valor_compra, despachado) 
VALUES
('2026-06-23', 'ABCD12', 1, 3, 'Camino El Alba 9210, Las Condes', 159990, 0),
('2026-06-24', 'KJTR45', 1, 7, 'Av. Independencia 1800, Independencia', 99990, 0),
('2026-06-25', 'PLMN89', 2, 10, 'Av. Recoleta 2100, Recoleta', 189990, 0);