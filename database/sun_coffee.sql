DROP DATABASE IF EXISTS sun_coffee;
CREATE DATABASE sun_coffee CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE sun_coffee;

SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS order_details;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS inventory_items;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE users (
  user_id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(50) NOT NULL UNIQUE,
  password VARCHAR(255) NOT NULL,
  full_name VARCHAR(100) NOT NULL,
  role ENUM('admin','staff') NOT NULL DEFAULT 'staff',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE categories (
  category_id INT AUTO_INCREMENT PRIMARY KEY,
  category_name VARCHAR(100) NOT NULL,
  description VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE products (
  product_id INT AUTO_INCREMENT PRIMARY KEY,
  product_name VARCHAR(150) NOT NULL,
  category_id INT NOT NULL,
  price DECIMAL(12,0) NOT NULL DEFAULT 0,
  description VARCHAR(255),
  image VARCHAR(255) DEFAULT 'products/default-product.jpg',
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_products_categories FOREIGN KEY (category_id) REFERENCES categories(category_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE orders (
  order_id INT AUTO_INCREMENT PRIMARY KEY,
  user_id INT NOT NULL,
  table_id INT NOT NULL,
  total_amount DECIMAL(12,0) NOT NULL DEFAULT 0,
  discount DECIMAL(12,0) NOT NULL DEFAULT 0,
  note VARCHAR(255),
  status ENUM('pending','completed','cancelled') NOT NULL DEFAULT 'completed',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders_users FOREIGN KEY (user_id) REFERENCES users(user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_details (
  detail_id INT AUTO_INCREMENT PRIMARY KEY,
  order_id INT NOT NULL,
  product_id INT NOT NULL,
  quantity INT NOT NULL,
  unit_price DECIMAL(12,0) NOT NULL,
  subtotal DECIMAL(12,0) NOT NULL,
  CONSTRAINT fk_order_details_orders FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
  CONSTRAINT fk_order_details_products FOREIGN KEY (product_id) REFERENCES products(product_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE employees (
  id INT AUTO_INCREMENT PRIMARY KEY,
  employee_code VARCHAR(30) NOT NULL UNIQUE,
  full_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  email VARCHAR(120),
  role VARCHAR(50),
  shift VARCHAR(50),
  salary DECIMAL(12,0) DEFAULT 0,
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE inventory_items (
  id INT AUTO_INCREMENT PRIMARY KEY,
  item_name VARCHAR(120) NOT NULL,
  unit VARCHAR(30) NOT NULL,
  quantity DECIMAL(12,2) NOT NULL DEFAULT 0,
  min_quantity DECIMAL(12,2) NOT NULL DEFAULT 0,
  supplier VARCHAR(120),
  status ENUM('active','inactive') NOT NULL DEFAULT 'active',
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO users (username, password, full_name, role) VALUES
('admin','admin123','Quản trị viên Sun Coffee','admin'),
('staff','staff123','Nhân viên bán hàng','staff');

INSERT INTO categories (category_name, description) VALUES
('Cà phê', 'Các món cà phê truyền thống và hiện đại'),
('Trà', 'Trà trái cây thanh mát'),
('Đá xay', 'Các món blended lạnh'),
('Bánh ngọt', 'Bánh dùng kèm đồ uống');

INSERT INTO products (product_name, category_id, price, description, image, status) VALUES
('Cà Phê Đen Đá', 1, 25000, 'Cà phê đen truyền thống', 'products/ca-phe-den-da.jpg', 'active'),
('Cà Phê Sữa Đá', 1, 30000, 'Cà phê sữa đá Việt Nam', 'products/ca-phe-sua-da.jpg', 'active'),
('Bạc Xỉu', 1, 35000, 'Bạc xỉu thơm béo', 'products/bac-xiu.jpg', 'active'),
('Latte Nóng', 1, 45000, 'Espresso và sữa tươi', 'products/latte-nong.jpg', 'active'),
('Cappuccino', 1, 45000, 'Cà phê Ý với foam sữa', 'products/cappuccino.jpg', 'active'),
('Trà Đào Cam Sả', 2, 39000, 'Trà đào thơm vị cam sả', 'products/tra-dao-cam-sa.jpg', 'active'),
('Trà Vải', 2, 39000, 'Trà vải thanh mát', 'products/tra-vai.jpg', 'active'),
('Matcha Đá Xay', 3, 49000, 'Matcha đá xay kem mịn', 'products/matcha-da-xay.jpg', 'active'),
('Chocolate Đá Xay', 3, 49000, 'Chocolate đá xay', 'products/chocolate-da-xay.jpg', 'active'),
('Bánh Tiramisu', 4, 42000, 'Bánh tiramisu dùng kèm cà phê', 'products/banh-tiramisu.jpg', 'active');

INSERT INTO employees (employee_code, full_name, phone, email, role, shift, salary, status, created_at) VALUES
('NV001','Nguyễn Văn An','0901234567','an@suncafe.local','Pha chế','Sáng',8000000,'active','2025-01-15 08:00:00'),
('NV002','Trần Thị Bảo','0912345678','bao@suncafe.local','Thu ngân','Chiều',7500000,'active','2025-02-10 13:30:00'),
('NV003','Lê Minh Châu','0923456789','chau@suncafe.local','Phục vụ','Sáng',7000000,'active','2025-03-01 07:30:00'),
('NV004','Phạm Thị Dung','0934567890','dung@suncafe.local','Pha chế','Tối',8500000,'active','2025-05-20 18:00:00');

INSERT INTO inventory_items (item_name, unit, quantity, min_quantity, supplier, status) VALUES
('Hạt cà phê Arabica', 'kg', 12.00, 3.00, 'Cung cấp cafe Đà Lạt', 'active'),
('Hạt cà phê Robusta', 'kg', 15.00, 4.00, 'Cung cấp cafe Tây Nguyên', 'active'),
('Sữa đặc', 'lon', 30.00, 8.00, 'Đại lý sữa Vinamilk', 'active'),
('Sữa tươi', 'lít', 25.00, 6.00, 'Đại lý sữa Vinamilk', 'active'),
('Đường', 'kg', 20.00, 5.00, 'Bách Hóa Xanh', 'active'),
('Đá viên', 'kg', 50.00, 10.00, 'Đá sạch Biên Hòa', 'active'),
('Trà đào', 'hộp', 12.00, 3.00, 'Đại lý Cozy', 'active'),
('Siro đào', 'chai', 10.00, 2.00, 'Đại lý Golden Farm', 'active'),
('Cam tươi', 'kg', 8.00, 2.00, 'Chợ đầu mối nông sản', 'active'),
('Sả cây', 'bó', 6.00, 2.00, 'Chợ đầu mối nông sản', 'active'),
('Trà vải', 'hộp', 10.00, 2.00, 'Đại lý Cozy', 'active'),
('Vải ngâm', 'hộp', 12.00, 3.00, 'Đại lý Golden Farm', 'active'),
('Bột matcha', 'kg', 5.00, 1.00, 'Nhà cung cấp Matcha Nhật', 'active'),
('Bột cacao/chocolate', 'kg', 6.00, 1.00, 'Đại lý nguyên liệu', 'active'),
('Kem whipping', 'hộp', 8.00, 2.00, 'Đại lý Anchor', 'active'),
('Bánh tiramisu', 'phần', 20.00, 5.00, 'Bếp bánh Sun Coffee', 'active'),
('Ly giấy', 'cái', 300.00, 50.00, 'Đại lý bao bì giấy', 'active'),
('Ống hút', 'cái', 500.00, 100.00, 'Đại lý bao bì giấy', 'active'),
('Nắp ly', 'cái', 300.00, 50.00, 'Đại lý bao bì giấy', 'active');

INSERT INTO orders (user_id, table_id, total_amount, discount, note, status, created_at) VALUES
(2, 1, 85000, 0, 'Ít đá', 'completed', '2026-07-01 09:30:00'),
(2, 3, 118000, 5000, 'Ít đá', 'completed', '2026-07-02 14:15:00'),
(2, 5, 74000, 0, 'Mang đi', 'pending', '2026-07-03 08:45:00');

INSERT INTO order_details (order_id, product_id, quantity, unit_price, subtotal) VALUES
(1, 1, 1, 25000, 25000),
(1, 2, 2, 30000, 60000),
(2, 6, 2, 39000, 78000),
(2, 4, 1, 45000, 45000),
(3, 3, 1, 35000, 35000),
(3, 7, 1, 39000, 39000);
