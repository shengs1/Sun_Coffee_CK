# Cafe Management System - Sun Coffee

## 1. Thông tin nhóm
- Thành viên 1: 2305CT2048_Trần Quốc Anh Dũng
- Thành viên 2: 2305CT2084_Nguyễn Đức Thịnh
- Thành viên 3: 2305CT7714_Võ Thị Mỹ Tuyền
- Thành viên 4: 2305CT2348_Nguyễn Thị Hải Anh
- Thành viên 5: 2305CT7673_Trịnh Gia Hưng

## 2. Mô tả đề tài
Cafe Management System - Sun Coffee là website quản lý quán cà phê được xây dựng bằng Java Web. Hệ thống hỗ trợ quản trị viên và nhân viên trong các công việc chính như đăng nhập, gọi món POS, quản lý thực đơn, quản lý danh mục, quản lý đơn hàng & hóa đơn, quản lý nhân viên, quản lý kho nguyên liệu và thống kê doanh thu.

Website phục vụ hai nhóm người dùng chính:
- Quản trị viên: quản lý dữ liệu hệ thống, thực đơn, danh mục, đơn hàng, nhân viên, kho nguyên liệu và xem thống kê doanh thu.
- Nhân viên: sử dụng màn hình POS để chọn món, tạo đơn hàng và thanh toán cho khách.

## 3. Công nghệ sử dụng
- Java Servlet
- JSP
- JDBC
- HTML/CSS/JavaScript
- MySQL
- Apache Tomcat 9
- Maven
- JSTL

## 4. Các chức năng chính

Website Sun Coffee Management System có các chức năng chính sau:

### 4.1. Đăng nhập và phân quyền
- Đăng nhập bằng tài khoản quản trị viên hoặc nhân viên.
- Phân quyền người dùng theo vai trò:
  - Admin: sử dụng toàn bộ chức năng quản trị.
  - Staff: sử dụng màn hình gọi món POS.
- Đăng xuất khỏi hệ thống.

### 4.2. Tổng quan hệ thống
- Hiển thị tổng doanh thu.
- Hiển thị tổng số đơn hàng.
- Hiển thị tổng số sản phẩm.
- Hiển thị tổng số nhân viên.
- Hiển thị danh sách đơn hàng gần đây.

### 4.3. Gọi món POS
- Hiển thị danh sách món theo danh mục.
- Tìm kiếm món theo tên.
- Thêm món vào giỏ hàng.
- Tăng, giảm số lượng món.
- Xóa món khỏi giỏ hàng.
- Nhập giảm giá và ghi chú đơn hàng.
- Tính tạm tính và tổng tiền.
- Thanh toán và lưu đơn hàng vào cơ sở dữ liệu.

### 4.4. Quản lý thực đơn
- Xem danh sách sản phẩm/món nước.
- Thêm sản phẩm mới.
- Cập nhật thông tin sản phẩm.
- Xóa sản phẩm.
- Tìm kiếm sản phẩm.
- Lọc sản phẩm theo danh mục và trạng thái.
- Quản lý hình ảnh, giá bán và trạng thái sản phẩm.

### 4.5. Quản lý danh mục
- Xem danh sách danh mục.
- Thêm danh mục mới.
- Cập nhật danh mục.
- Xóa danh mục.
- Sử dụng danh mục để phân loại sản phẩm trong thực đơn.

### 4.6. Quản lý Đơn & Hóa đơn
- Gộp chức năng quản lý đơn hàng và tra cứu hóa đơn vào cùng một trang.
- Hiển thị danh sách đơn hàng/hóa đơn.
- Tìm kiếm hóa đơn theo mã đơn.
- Lọc theo số bàn, ngày tạo và trạng thái.
- Xem chi tiết hóa đơn.
- Hiển thị mã đơn theo định dạng `SC-ddMMyyyy-XXXX`.
- Cập nhật trạng thái đơn hàng.
- Hủy đơn hàng khi cần thiết.

### 4.7. Quản lý nhân viên
- Xem danh sách nhân viên.
- Thêm nhân viên mới.
- Cập nhật thông tin nhân viên.
- Xóa hoặc ngừng hoạt động nhân viên.
- Quản lý thông tin như mã nhân viên, họ tên, số điện thoại, email, vai trò, ca làm, lương và trạng thái.

### 4.8. Kho nguyên liệu
- Xem danh sách nguyên liệu trong kho.
- Thêm nguyên liệu mới.
- Cập nhật số lượng nguyên liệu.
- Xóa nguyên liệu.
- Theo dõi số lượng tồn kho và mức tối thiểu.
- Hiển thị cảnh báo nguyên liệu sắp hết.

### 4.9. Thống kê doanh thu
- Thống kê tổng doanh thu.
- Thống kê số lượng đơn hàng.
- Thống kê doanh thu theo ngày.
- Hiển thị sản phẩm bán chạy.
- Hiển thị biểu đồ doanh thu và biểu đồ theo danh mục.

## 5. Hướng dẫn cài đặt
1. Clone project từ GitHub hoặc tải source code về máy.

2. Import project vào IDE.

3. Import file database vào MySQL:
   ```bash
   mysql -u root -P 3308 < database/sun_coffee.sql
   ```
   Nếu dùng phpMyAdmin, hãy tạo/import file `database/sun_coffee.sql` trực tiếp trong giao diện phpMyAdmin.

4. Cấu hình kết nối database trong file:
   ```text
   src/main/java/com/cafe/connection/DBConnection.java
   ```
   Cấu hình mặc định của project:
   ```text
   Database: sun_coffee
   Host: localhost
   Port: 3308
   Username: root
   Password: rỗng
   ```
   Nếu MySQL trên máy dùng port `3306` hoặc có mật khẩu, hãy sửa lại thông tin trong `DBConnection.java`.

5. Build project bằng Maven:
   ```bash
   mvn clean package
   ```

6. Deploy file WAR lên Apache Tomcat 9:
   ```text
   target/cafe-management-system.war
   ```
   Có thể copy file WAR vào thư mục:
   ```text
   apache-tomcat-9.x.x/webapps/
   ```

7. Khởi động Tomcat 9 và truy cập website:
   ```text
   http://localhost:8080/cafe-management-system
   ```
   hoặc:
   ```text
   http://localhost:8080/cafe-management-system/login.jsp
   ```

## 6. Tài khoản demo nếu có
- Admin:
  - Tên đăng nhập: `admin`
  - Mật khẩu: `admin123`

- User/Staff:
  - Tên đăng nhập: `staff`
  - Mật khẩu: `staff123`

## 7. Video thuyết trình và demo
Link: https://drive.google.com/file/d/1vkctlHy064lcbPOmsiizY2IljP-hH1sZ/view?usp=sharing


## 8. Phân công công việc

### 8.1 Võ Thị Mỹ Tuyền - Backend đăng nhập và POS
- User.java
- Order.java
- OrderDetail.java
- UserDAO.java
- OrderDAO.java
- LoginServlet.java
- LogoutServlet.java
- OrderServlet.java
- AuthenticationFilter.java

### 8.2 Nguyễn Thị Hải Anh - Frontend đăng nhập và POS
- login.jsp
- staff/order-pos.jsp
- staff-style.css
- staff-script.js

### 8.3 Trần Quốc Anh Dũng - Backend sản phẩm, danh mục, thống kê
- Product.java
- Category.java
- ProductDAO.java
- CategoryDAO.java
- ProductServlet.java
- CategoryServlet.java
- StatisticServlet.java

### 8.4 Trịnh Gia Hưng - Backend nhân viên, kho, đơn hàng admin
- Employee.java
- InventoryItem.java
- EmployeeDAO.java
- InventoryDAO.java
- DashboardServlet.java
- AdminOrderServlet.java
- EmployeeServlet.java
- InventoryServlet.java

### 8.5 Nguyễn Đức Thịnh - Frontend admin và file chung
- admin/*.jsp
- components/*.jsp
- admin-style.css
- admin-script.js
- DBConnection.java
- EncodingFilter.java
- FormatUtil.java
- web.xml
- pom.xml
- database/sun_coffee.sql
- README.md

