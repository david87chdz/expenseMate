-- Crear tabla 'home'
CREATE TABLE IF NOT EXISTS home (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Crear tabla 'category'
CREATE TABLE IF NOT EXISTS category (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE
);

-- Crear tabla 'frequency'
CREATE TABLE IF NOT EXISTS frequency (
    id SERIAL PRIMARY KEY,
    type VARCHAR(50) NOT NULL UNIQUE
);

-- Crear tabla 'user'
CREATE TABLE IF NOT EXISTS "user" (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    income DECIMAL(10, 2),
    monthly_expenses DECIMAL(10, 2),
    home_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (home_id) REFERENCES home(id)
);

-- Crear la función del trigger para actualizar 'updated_at'
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger en la tabla 'user'
CREATE TRIGGER update_user_timestamp
BEFORE UPDATE ON "user"
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Crear tabla 'expense'
CREATE TABLE IF NOT EXISTS expense (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    frequency_id INT,
    category_id INT,
    user_id INT,
    amount DECIMAL(10, 2) NOT NULL,  -- Añadir la columna 'amount' para la cantidad del gasto
    is_shared BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (frequency_id) REFERENCES frequency(id),
    FOREIGN KEY (category_id) REFERENCES category(id),
    FOREIGN KEY (user_id) REFERENCES "user"(id)
);

-- Crear un índice único para (name, user_id)
CREATE UNIQUE INDEX idx_expense_name_user ON expense(name, user_id);

-- Crear la función del trigger para actualizar 'updated_at' en 'expense'
CREATE OR REPLACE FUNCTION update_expense_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger en la tabla 'expense'
CREATE TRIGGER update_expense_timestamp
BEFORE UPDATE ON expense
FOR EACH ROW
EXECUTE FUNCTION update_expense_timestamp();

-- Insertar datos de ejemplo en la tabla 'home'
INSERT INTO home (name) VALUES ('Familia A'), ('Familia B')
ON CONFLICT (name) DO NOTHING;

-- Insertar datos de ejemplo en la tabla 'category'
INSERT INTO category (name) VALUES ('Servicios públicos'), ('Comestibles'), ('Alquiler'), ('Entretenimiento')
ON CONFLICT (name) DO NOTHING;

-- Insertar datos de ejemplo en la tabla 'frequency'
INSERT INTO frequency (type) VALUES ('Mensual'), ('Semanal'), ('Anual')
ON CONFLICT (type) DO NOTHING;

-- Insertar datos de ejemplo en la tabla 'user'
INSERT INTO "user" (name, email, password, income, monthly_expenses, home_id) 
VALUES 
    ('Juan Pérez', 'juan.perez@example.com', 'contraseñasegura123', 3500.00, 1200.00, 1),
    ('Ana García', 'ana.garcia@example.com', 'contraseñasegura456', NULL, 500.00, 2)
ON CONFLICT (email) DO NOTHING;

-- Insertar datos de ejemplo en la tabla 'expense'
INSERT INTO expense (name, description, frequency_id, category_id, user_id, amount, is_shared) 
VALUES 
    ('Factura de electricidad', 'Pago mensual de electricidad', 1, 1, 1, 75.00, TRUE),
    ('Compra de comestibles', 'Compra semanal de alimentos', 2, 2, 2, 50.00, TRUE),
    ('Alquiler', 'Pago mensual del apartamento', 1, 3, 1, 800.00, TRUE),
    ('Membresía de gimnasio personal', 'Pago mensual del gimnasio', 1, 4, 1, 30.00, FALSE)
ON CONFLICT (name, user_id) DO NOTHING;

