package com.cafe.connection;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// Cấu hình kết nối cơ sở dữ liệu
public class DBConnection {

    // Tên cơ sở dữ liệu
    private static final String DB_NAME  = "sun_coffee";
    // Đường dẫn kết nối (cổng kết nối 3308 hoặc 3306)
    private static final String URL      = "jdbc:mysql://localhost:3308/" + DB_NAME
                                         + "?useSSL=false&serverTimezone=Asia/Ho_Chi_Minh&characterEncoding=UTF-8";
    // Tài khoản kết nối
    private static final String USER     = "root";
    private static final String PASSWORD = "";

    private static Connection connection = null;

    private DBConnection() {}

    // Hàm kết nối (dùng mẫu đơn nhất để dùng chung kết nối)
    public static Connection getConnection() throws SQLException {
        try {
            if (connection == null || connection.isClosed()) {
                // Nạp trình điều khiển cơ sở dữ liệu
                Class.forName("com.mysql.cj.jdbc.Driver");
                // Mở kết nối
                connection = DriverManager.getConnection(URL, USER, PASSWORD);
            }
        } catch (ClassNotFoundException e) {
            throw new SQLException("Lỗi trình điều khiển kết nối: " + e.getMessage());
        }
        return connection;
    }

    // Đóng kết nối khi dùng xong
    public static void closeConnection() {
        try {
            if (connection != null && !connection.isClosed()) {
                connection.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
