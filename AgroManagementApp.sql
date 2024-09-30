-- Users Table (Unified for both customers and sellers)
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    address VARCHAR(255) NULL,  -- Optional for sellers, applicable to customers
    phone_number VARCHAR(15) NOT NULL
);

-- Roles Table (Defines the various roles)
CREATE TABLE Roles (
    role_id INT PRIMARY KEY AUTO_INCREMENT,
    role_name VARCHAR(50) NOT NULL
);

-- User_Roles Table (Many-to-many relationship between users and roles)
CREATE TABLE User_Roles (
    user_id INT,
    role_id INT,
    PRIMARY KEY(user_id, role_id),
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (role_id) REFERENCES Roles(role_id)
);

-- Crops Table (Now with a user_id for the owner of the crop)
CREATE TABLE Crops (
    crop_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,  -- Owner of the crop
    location VARCHAR(100) NOT NULL,
    variation VARCHAR(50) NOT NULL,
    size FLOAT NOT NULL,
    sowing_date DATE NOT NULL,
    harvesting_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)  -- User is the crop owner
);

-- Products Table
CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(50) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL
);

-- Transactions Table (Merged Offers and Demands)
CREATE TABLE Transactions (
    transaction_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,  -- Linked to the Users table (could be seller or customer)
    product_id INT,  -- Linked to the Products table
    quantity FLOAT NOT NULL,
    transaction_date DATETIME NOT NULL,
    type ENUM('OFFER', 'DEMAND') NOT NULL,  -- To distinguish between Offers and Demands
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

-- Orders Table (Now with transaction_id as a foreign key)
CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,  -- Linked to the Users table (customer)
    transaction_id INT,  -- Linked to the Transactions table
    total_amount DECIMAL(10,2) NOT NULL,
    order_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),  -- Customers who place orders
    FOREIGN KEY (transaction_id) REFERENCES Transactions(transaction_id)  -- Link to the corresponding transaction
);

-- Payments Table (Removed user_id)
CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATETIME NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)  -- Link to the order for which the payment is made
);

-- Billing Table (Now with a foreign key for Payments table)
CREATE TABLE Billing (
    billing_id INT PRIMARY KEY AUTO_INCREMENT,
    total_amount DECIMAL(10,2) NOT NULL,
    billing_date DATETIME NOT NULL,
    status VARCHAR(20) NOT NULL,
    payment_id INT,  -- Linked to the Payments table
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)  -- Link to the payment related to this billing
);

-- Logistics Table
CREATE TABLE Logistics (
    logistics_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT,
    carrier_name VARCHAR(100) NOT NULL,
    tracking_number VARCHAR(100) NOT NULL,
    shipment_date DATETIME NOT NULL,
    delivery_date DATETIME NULL,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

-- Crops_Status Table
CREATE TABLE Crops_Status (
    status_id INT PRIMARY KEY AUTO_INCREMENT,
    crop_id INT,
    status VARCHAR(50) NOT NULL,
    description TEXT NULL,
    update_date DATETIME NOT NULL,
    FOREIGN KEY (crop_id) REFERENCES Crops(crop_id)
);

-- Forecast Table
CREATE TABLE Forecast (
    forecast_id INT PRIMARY KEY AUTO_INCREMENT,
    crop_id INT,
    forecast_date DATE NOT NULL,
    temperature_min DECIMAL(5,2) NOT NULL,
    temperature_max DECIMAL(5,2) NOT NULL,
    precipitation DECIMAL(5,2) NOT NULL,
    humidity DECIMAL(5,2) NOT NULL,
    description TEXT NULL,
    FOREIGN KEY (crop_id) REFERENCES Crops(crop_id)
);
