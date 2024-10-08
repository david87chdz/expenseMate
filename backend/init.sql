

-- Crea la tabla de familias
CREATE TABLE IF NOT EXISTS familia (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);

-- Crea la tabla de usuarios
CREATE TABLE IF NOT EXISTS usuario (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    familia_id INT,
    FOREIGN KEY (familia_id) REFERENCES familia(id) ON DELETE CASCADE
);

-- Crea la tabla para los gastos
CREATE TABLE IF NOT EXISTS gasto (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    cantidad DECIMAL(10, 2) NOT NULL,
    frecuencia VARCHAR(50) NOT NULL,  -- Ej: "mensual", "anual"
    fecha DATE NOT NULL,
    es_compartido BOOLEAN DEFAULT FALSE,
    familia_id INT,
    FOREIGN KEY (familia_id) REFERENCES familia(id) ON DELETE CASCADE
);

-- Inserta algunos datos de ejemplo
INSERT INTO familia (nombre) VALUES
    ('Familia Gómez'),
    ('Familia Pérez');

INSERT INTO usuario (nombre, familia_id) VALUES
    ('Juan Gómez', 1),
    ('María Gómez', 1),
    ('Ana Pérez', 2);

INSERT INTO gasto (nombre, cantidad, frecuencia, fecha, es_compartido, familia_id) VALUES
    ('Alquiler', 500.00, 'mensual', '2024-01-01', TRUE, 1),
    ('Comida', 200.00, 'mensual', '2024-01-01', TRUE, 1),
    ('Transporte', 50.00, 'mensual', '2024-01-01', FALSE, 2),
    ('Internet', 30.00, 'mensual', '2024-01-01', TRUE, 1);
