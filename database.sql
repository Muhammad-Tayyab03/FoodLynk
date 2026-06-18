-- FoodLynk Database Schema + Sample Data
-- Run: mysql -u root -p < database.sql

CREATE DATABASE IF NOT EXISTS foodLynk CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE foodLynk;

-- ============================================================
-- TABLES
-- ============================================================

CREATE TABLE User (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    contact_no VARCHAR(20),
    role VARCHAR(20) NOT NULL DEFAULT 'customer',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    loyalty_point INT DEFAULT 0,
    street VARCHAR(255),
    city VARCHAR(100),
    country VARCHAR(100),
    FOREIGN KEY (customer_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE Staff (
    staff_id INT PRIMARY KEY,
    salary DECIMAL(10,2),
    shift VARCHAR(50),
    staff_type VARCHAR(20),
    FOREIGN KEY (staff_id) REFERENCES User(user_id) ON DELETE CASCADE
);

CREATE TABLE Manager (
    manager_id INT PRIMARY KEY,
    license_no VARCHAR(100),
    FOREIGN KEY (manager_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);

CREATE TABLE Chef (
    chef_id INT PRIMARY KEY,
    specialization VARCHAR(100),
    FOREIGN KEY (chef_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);

CREATE TABLE Waiter (
    waiter_id INT PRIMARY KEY,
    experience_year INT,
    FOREIGN KEY (waiter_id) REFERENCES Staff(staff_id) ON DELETE CASCADE
);

CREATE TABLE Category (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Menu_Item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    item_description TEXT,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE SET NULL
);

CREATE TABLE Resturent_Table (
    table_id INT AUTO_INCREMENT PRIMARY KEY,
    table_no VARCHAR(10) NOT NULL,
    capacity INT NOT NULL,
    status VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    order_status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    customer_id INT,
    table_id INT,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    waiter_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE SET NULL,
    FOREIGN KEY (table_id) REFERENCES Resturent_Table(table_id) ON DELETE SET NULL,
    FOREIGN KEY (waiter_id) REFERENCES Waiter(waiter_id) ON DELETE SET NULL
);

CREATE TABLE Order_Detail (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES Menu_Item(item_id) ON DELETE CASCADE
);

CREATE TABLE Kitchen (
    kitchen_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    chef_id INT,
    cook_status VARCHAR(50) DEFAULT 'Pending',
    prep_time VARCHAR(50),
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (chef_id) REFERENCES Chef(chef_id) ON DELETE SET NULL
);

CREATE TABLE Payment (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    amount DECIMAL(10,2) NOT NULL,
    pay_status VARCHAR(50) DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE
);

CREATE TABLE Cash_payment (
    payment_id INT PRIMARY KEY,
    cash_received DECIMAL(10,2),
    FOREIGN KEY (payment_id) REFERENCES Payment(payment_id) ON DELETE CASCADE
);

CREATE TABLE Online_Payment (
    payment_id INT PRIMARY KEY,
    gateway_name VARCHAR(100),
    account_no VARCHAR(100),
    FOREIGN KEY (payment_id) REFERENCES Payment(payment_id) ON DELETE CASCADE
);

CREATE TABLE Reservation (
    reservation_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    table_id INT,
    date_time DATETIME NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customer(customer_id) ON DELETE CASCADE,
    FOREIGN KEY (table_id) REFERENCES Resturent_Table(table_id) ON DELETE CASCADE
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

-- All sample passwords: password123
-- Generate your own: php -r "echo password_hash('password123', PASSWORD_DEFAULT);"

INSERT INTO User (user_id, name, email, password, contact_no, role) VALUES
(1, 'Admin',     'admin@foodlynk.com', '$2b$10$x0ZjDtV/PGT5zGy55U7dhOC3USt8Oz0CmWtqOsEojs5KYQEOUvJsG', '0300-1111111', 'admin'),
(2, 'John Doe',  'john@example.com',   '$2b$10$x0ZjDtV/PGT5zGy55U7dhOC3USt8Oz0CmWtqOsEojs5KYQEOUvJsG', '0300-2222222', 'customer'),
(3, 'Chef Jamie','chef@foodlynk.com',  '$2b$10$x0ZjDtV/PGT5zGy55U7dhOC3USt8Oz0CmWtqOsEojs5KYQEOUvJsG', '0300-3333333', 'staff'),
(4, 'Waiter Mike','waiter@foodlynk.com','$2b$10$x0ZjDtV/PGT5zGy55U7dhOC3USt8Oz0CmWtqOsEojs5KYQEOUvJsG', '0300-4444444', 'staff'),
(5, 'Sarah Khan','sarah@example.com',  '$2b$10$x0ZjDtV/PGT5zGy55U7dhOC3USt8Oz0CmWtqOsEojs5KYQEOUvJsG', '0300-5555555', 'customer');

INSERT INTO Customer (customer_id, loyalty_point, street, city, country) VALUES
(2, 50, '123 Main St', 'Lahore', 'Pakistan'),
(5, 20, '456 Garden Ave', 'Islamabad', 'Pakistan');

INSERT INTO Staff (staff_id, salary, shift, staff_type) VALUES
(3, 60000.00, 'Morning', 'Chef'),
(4, 35000.00, 'Evening', 'Waiter');

INSERT INTO Chef (chef_id, specialization) VALUES
(3, 'Italian Cuisine');

INSERT INTO Waiter (waiter_id, experience_year) VALUES
(4, 3);

INSERT INTO Category (category_name) VALUES
('Appetizers'),
('Main Course'),
('Desserts'),
('Beverages');

INSERT INTO Menu_Item (item_name, price, item_description, category_id) VALUES
('Spring Rolls',        350.00, 'Crispy vegetable spring rolls', 1),
('Chicken Wings',       450.00, 'Spicy BBQ chicken wings', 1),
('Chicken Biryani',     380.00, 'Fragrant basmati rice with chicken', 2),
('Beef Steak',          890.00, 'Grilled beef steak with mushroom sauce', 2),
('Gulab Jamun',         250.00, 'Deep-fried milk solid dumplings in sugar syrup', 3),
('Chocolate Cake',      320.00, 'Rich chocolate fudge cake', 3),
('Mango Lassi',         180.00, 'Creamy yogurt mango drink', 4),
('Lemonade',            150.00, 'Freshly squeezed lemonade', 4);

INSERT INTO Resturent_Table (table_no, capacity, status) VALUES
('T1', 2, 'Available'),
('T2', 2, 'Available'),
('T3', 4, 'Available'),
('T4', 4, 'Occupied'),
('T5', 6, 'Available'),
('T6', 8, 'Available');

INSERT INTO Orders (order_id, order_date, order_status, customer_id, table_id, total_amount, waiter_id) VALUES
(1, '2026-06-17 13:30:00', 'Completed', 2, 3, 1460.00, 4),
(2, '2026-06-17 19:00:00', 'Pending',   5, 4, 830.00,  4);

INSERT INTO Order_Detail (order_id, item_id, quantity, price) VALUES
(1, 1, 2, 350.00),
(1, 3, 2, 380.00),
(2, 4, 1, 890.00);

INSERT INTO Kitchen (order_id, chef_id, cook_status, prep_time) VALUES
(1, 3, 'Completed', '25 min'),
(2, 3, 'Pending',   NULL);

INSERT INTO Payment (order_id, amount, pay_status) VALUES
(1, 1460.00, 'Completed'),
(2, 830.00,  'Pending');

INSERT INTO Reservation (customer_id, table_id, date_time) VALUES
(2, 5, '2026-06-18 20:00:00');
