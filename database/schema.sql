-- ════════════════════════════════════════════════════════
--  CarRental System – MySQL Schema
--  Run this script in MySQL Workbench or phpMyAdmin
-- ════════════════════════════════════════════════════════

CREATE DATABASE IF NOT EXISTS carrental_db
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE carrental_db;

-- ── USERS ─────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS users (
  user_id       INT AUTO_INCREMENT PRIMARY KEY,
  first_name    VARCHAR(60)  NOT NULL,
  last_name     VARCHAR(60),
  email         VARCHAR(120) NOT NULL UNIQUE,
  phone         VARCHAR(15)  NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  password_salt VARCHAR(100) NOT NULL,
  role          ENUM('user','admin') NOT NULL DEFAULT 'user',
  address       TEXT,
  license_no    VARCHAR(30),
  department    VARCHAR(80),
  dob           DATE,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── CARS ──────────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS cars (
  car_id        INT AUTO_INCREMENT PRIMARY KEY,
  name          VARCHAR(100) NOT NULL,
  category      VARCHAR(50)  NOT NULL,       -- Sedan, SUV, Coupe, Hatchback
  year          YEAR         NOT NULL,
  fuel_type     VARCHAR(30)  NOT NULL,       -- Petrol, Diesel, Electric, Hybrid
  transmission  VARCHAR(20)  NOT NULL,       -- Automatic, Manual
  seats         TINYINT      NOT NULL DEFAULT 4,
  price_per_day DECIMAL(10,2) NOT NULL,
  available     TINYINT(1)   NOT NULL DEFAULT 1,
  image_url     TEXT,
  description   TEXT,
  color         VARCHAR(30),
  license_plate VARCHAR(20)  UNIQUE,
  created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ── BOOKINGS ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS bookings (
  booking_id      INT AUTO_INCREMENT PRIMARY KEY,
  user_id         INT           NOT NULL,
  car_id          INT           NOT NULL,
  first_name      VARCHAR(60)   NOT NULL,
  last_name       VARCHAR(60),
  phone           VARCHAR(15)   NOT NULL,
  license_no      VARCHAR(30)   NOT NULL,
  pickup_date     DATE          NOT NULL,
  return_date     DATE          NOT NULL,
  pickup_location VARCHAR(100),
  total_amount    DECIMAL(10,2) NOT NULL,
  status          ENUM('Pending','Confirmed','Completed','Cancelled')
                  NOT NULL DEFAULT 'Pending',
  special_requests TEXT,
  booked_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
  CONSTRAINT fk_booking_car  FOREIGN KEY (car_id)  REFERENCES cars(car_id)  ON DELETE CASCADE
);

-- ── FEEDBACK ──────────────────────────────────────────────
CREATE TABLE IF NOT EXISTS feedback (
  feedback_id  INT AUTO_INCREMENT PRIMARY KEY,
  user_id      INT,                           -- NULL for guest feedback
  name         VARCHAR(120) NOT NULL,
  email        VARCHAR(120) NOT NULL,
  rating       TINYINT      NOT NULL CHECK (rating BETWEEN 1 AND 5),
  category     VARCHAR(60),
  subject      VARCHAR(200),
  message      TEXT         NOT NULL,
  recommend    ENUM('yes','maybe','no'),
  submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_feedback_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE SET NULL
);

-- ════════════════════════════════════════════════════════
--  SAMPLE DATA
-- ════════════════════════════════════════════════════════

-- Default admin account
-- Password: Admin@1234  (you can change after first login)
INSERT INTO users (first_name, last_name, email, phone, password_hash, password_salt, role, department)
VALUES (
  'Super', 'Admin',
  'admin@carrental.com',
  '9876543210',
  -- This hash corresponds to "Admin@1234" with the salt below
  -- Re-generate using PasswordUtil if you change the password
  'placeholder_hash',
  'placeholder_salt',
  'admin',
  'System Administrator'
);

-- Sample cars
INSERT INTO cars (name, category, year, fuel_type, transmission, seats, price_per_day, available, image_url) VALUES
('Toyota Corolla',        'Sedan',  2021, 'Diesel',   'Automatic', 5, 1300.00, 1, 'https://images.unsplash.com/photo-1590362891991-f776e747a588?w=800&q=80'),
('BMW X5',                'SUV',    2022, 'Hybrid',   'Automatic', 5, 4500.00, 1, 'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800&q=80'),
('Jeep Wrangler',         'SUV',    2023, 'Petrol',   'Manual',    4, 3200.00, 1, 'https://images.unsplash.com/photo-1533473359331-0135ef1b58bf?w=800&q=80'),
('Mercedes-Benz S-Class', 'Sedan',  2022, 'Petrol',   'Automatic', 4, 7500.00, 1, 'https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800&q=80'),
('Tesla Model 3',         'Sedan',  2023, 'Electric', 'Automatic', 5, 2800.00, 1, 'https://images.unsplash.com/photo-1560958089-b8a1929cea89?w=800&q=80'),
('Range Rover Sport',     'SUV',    2021, 'Diesel',   'Automatic', 5, 6200.00, 0, 'https://images.unsplash.com/photo-1606664515524-ed2f786a0bd6?w=800&q=80'),
('Porsche 911',           'Coupe',  2022, 'Petrol',   'Manual',    2, 9500.00, 1, 'https://images.unsplash.com/photo-1503376780353-7e6692767b70?w=800&q=80'),
('Hyundai Creta',         'SUV',    2023, 'Petrol',   'Automatic', 5, 1800.00, 1, 'https://images.unsplash.com/photo-1546614042-7df3c24c9e5d?w=800&q=80');
