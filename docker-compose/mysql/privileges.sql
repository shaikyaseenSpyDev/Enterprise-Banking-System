CREATE USER 'javatodev_development'@'%' IDENTIFIED BY 'oPItyPticIAt';
GRANT CREATE, ALTER, DROP, INSERT, UPDATE, DELETE, SELECT, REFERENCES on *.* TO 'javatodev_development'@'%';
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS banking_core_service;
CREATE DATABASE IF NOT EXISTS banking_core_fund_transfer_service;
CREATE DATABASE IF NOT EXISTS banking_core_user_service;
CREATE DATABASE IF NOT EXISTS banking_core_utility_payment_service;
CREATE USER 'banking_user'@'%' IDENTIFIED BY 'secure_banking_pwd_2024';
GRANT ALL PRIVILEGES ON banking_core_db.* TO 'banking_user'@'%';
FLUSH PRIVILEGES;