-- Create banking_core_db if it doesn't exist
CREATE DATABASE IF NOT EXISTS banking_core_db;
USE banking_core_db;

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id VARCHAR(36) PRIMARY KEY,
    keycloak_id VARCHAR(36) NOT NULL,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    phone_number VARCHAR(20),
    address TEXT,
    enabled BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Accounts Table
CREATE TABLE IF NOT EXISTS accounts (
    id VARCHAR(36) PRIMARY KEY,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    account_type ENUM('SAVINGS', 'CHECKING', 'CREDIT') NOT NULL,
    balance DECIMAL(19, 4) NOT NULL DEFAULT 0,
    currency VARCHAR(3) NOT NULL DEFAULT 'USD',
    user_id VARCHAR(36) NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'BLOCKED') NOT NULL DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

-- Transactions Table
CREATE TABLE IF NOT EXISTS transactions (
    id VARCHAR(36) PRIMARY KEY,
    transaction_type ENUM('DEPOSIT', 'WITHDRAWAL', 'TRANSFER', 'PAYMENT') NOT NULL,
    amount DECIMAL(19, 4) NOT NULL,
    currency VARCHAR(3) NOT NULL,
    from_account_id VARCHAR(36),
    to_account_id VARCHAR(36),
    description TEXT,
    status ENUM('PENDING', 'COMPLETED', 'FAILED', 'CANCELLED') NOT NULL,
    reference_number VARCHAR(50),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (from_account_id) REFERENCES accounts(id),
    FOREIGN KEY (to_account_id) REFERENCES accounts(id)
);

-- Utility Payments Table
CREATE TABLE IF NOT EXISTS utility_payments (
    id VARCHAR(36) PRIMARY KEY,
    account_id VARCHAR(36) NOT NULL,
    utility_type ENUM('ELECTRICITY', 'WATER', 'GAS', 'INTERNET', 'PHONE') NOT NULL,
    bill_number VARCHAR(50) NOT NULL,
    amount DECIMAL(19, 4) NOT NULL,
    status ENUM('PENDING', 'COMPLETED', 'FAILED') NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    transaction_reference VARCHAR(50),
    FOREIGN KEY (account_id) REFERENCES accounts(id)
);

-- Insert test users
INSERT INTO users (id, keycloak_id, username, email, first_name, last_name, phone_number, address)
VALUES 
('11111111-1111-1111-1111-111111111111', 'kc-11111111', 'admin', 'admin@securebank.com', 'Admin', 'User', '123-456-7890', '123 Admin St, City, Country'),
('22222222-2222-2222-2222-222222222222', 'kc-22222222', 'john.doe', 'john.doe@example.com', 'John', 'Doe', '123-456-7891', '456 Main St, City, Country'),
('33333333-3333-3333-3333-333333333333', 'kc-33333333', 'jane.smith', 'jane.smith@example.com', 'Jane', 'Smith', '123-456-7892', '789 Oak St, City, Country');

-- Insert test accounts
INSERT INTO accounts (id, account_number, account_type, balance, currency, user_id)
VALUES
('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '1000000001', 'SAVINGS', 5000.00, 'USD', '22222222-2222-2222-2222-222222222222'),
('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '1000000002', 'CHECKING', 2500.00, 'USD', '22222222-2222-2222-2222-222222222222'),
('cccccccc-cccc-cccc-cccc-cccccccccccc', '1000000003', 'SAVINGS', 7500.00, 'USD', '33333333-3333-3333-3333-333333333333'),
('dddddddd-dddd-dddd-dddd-dddddddddddd', '1000000004', 'CHECKING', 3500.00, 'USD', '33333333-3333-3333-3333-333333333333');

-- Insert test transactions
INSERT INTO transactions (id, transaction_type, amount, currency, from_account_id, to_account_id, description, status, reference_number)
VALUES
('trx00001-0000-0000-0000-000000000001', 'DEPOSIT', 1000.00, 'USD', NULL, 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Initial deposit', 'COMPLETED', 'REF00001'),
('trx00002-0000-0000-0000-000000000002', 'TRANSFER', 500.00, 'USD', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Transfer to checking', 'COMPLETED', 'REF00002'),
('trx00003-0000-0000-0000-000000000003', 'PAYMENT', 150.00, 'USD', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', NULL, 'Utility payment', 'COMPLETED', 'REF00003'),
('trx00004-0000-0000-0000-000000000004', 'TRANSFER', 1000.00, 'USD', 'cccccccc-cccc-cccc-cccc-cccccccccccc', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Transfer to John', 'COMPLETED', 'REF00004');

-- Insert test utility payments
INSERT INTO utility_payments (id, account_id, utility_type, bill_number, amount, status, transaction_reference)
VALUES
('pmt00001-0000-0000-0000-000000000001', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'ELECTRICITY', 'ELEC123456', 150.00, 'COMPLETED', 'REF00003'),
('pmt00002-0000-0000-0000-000000000002', 'dddddddd-dddd-dddd-dddd-dddddddddddd', 'WATER', 'WATER654321', 75.50, 'COMPLETED', 'REF00005'),
('pmt00003-0000-0000-0000-000000000003', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'INTERNET', 'INT987654', 89.99, 'PENDING', NULL);
