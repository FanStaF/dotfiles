-- Create additional databases for development
CREATE DATABASE IF NOT EXISTS `testing` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Grant privileges
GRANT ALL PRIVILEGES ON `development`.* TO 'dev'@'%';
GRANT ALL PRIVILEGES ON `testing`.* TO 'dev'@'%';
GRANT ALL PRIVILEGES ON `development`.* TO 'root'@'%';
GRANT ALL PRIVILEGES ON `testing`.* TO 'root'@'%';

FLUSH PRIVILEGES;
