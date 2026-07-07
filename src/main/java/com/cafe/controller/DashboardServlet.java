package com.cafe.controller;

import com.cafe.connection.DBConnection;
import com.cafe.dao.EmployeeDAO;
import com.cafe.dao.OrderDAO;
import com.cafe.dao.ProductDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;

public class DashboardServlet extends HttpServlet {
    private void setUtf8(HttpServletRequest request, HttpServletResponse response) throws java.io.UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setUtf8(req, resp);
        try (Connection conn = DBConnection.getConnection()) {
            req.setAttribute("totalRevenue", queryDouble(conn, "SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE status <> 'cancelled'"));
            req.setAttribute("totalOrders", queryInt(conn, "SELECT COUNT(*) FROM orders"));
            req.setAttribute("totalProducts", new ProductDAO().countProducts());
            req.setAttribute("totalEmployees", new EmployeeDAO().countActiveEmployees());
            req.setAttribute("recentOrders", new OrderDAO().getRecentOrders(6));
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không tải được tổng quan: " + e.getMessage());
            req.getRequestDispatcher("/admin/dashboard.jsp").forward(req, resp);
        }
    }

    private double queryDouble(Connection conn, String sql) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0;
        }
    }
    private int queryInt(Connection conn, String sql) throws SQLException {
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
