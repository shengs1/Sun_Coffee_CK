package com.cafe.controller;

import com.cafe.connection.DBConnection;
import com.cafe.dao.OrderDAO;
import com.cafe.model.Order;
import com.cafe.model.Product;
import com.google.gson.Gson;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.*;
import java.util.*;

public class StatisticServlet extends HttpServlet {
    private final Gson gson = new Gson();

    private void setUtf8(HttpServletRequest request, HttpServletResponse response) throws java.io.UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);
        try (Connection conn = DBConnection.getConnection()) {
            req.setAttribute("totalRevenue", queryDouble(conn, "SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE status <> 'cancelled'"));
            req.setAttribute("totalOrders", queryInt(conn, "SELECT COUNT(*) FROM orders"));
            req.setAttribute("todayRevenue", queryDouble(conn, "SELECT COALESCE(SUM(total_amount),0) FROM orders WHERE DATE(created_at)=CURDATE() AND status <> 'cancelled'"));
            req.setAttribute("todayOrders", queryInt(conn, "SELECT COUNT(*) FROM orders WHERE DATE(created_at)=CURDATE()"));

            Product topProduct = getTopProduct(conn);
            req.setAttribute("topProduct", topProduct);

            ChartData revenue = getRevenueLast7Days(conn);
            req.setAttribute("revenueLabels", gson.toJson(revenue.labels));
            req.setAttribute("revenueValues", gson.toJson(revenue.values));

            ChartData byCategory = getRevenueByCategory(conn);
            req.setAttribute("categoryLabels", gson.toJson(byCategory.labels));
            req.setAttribute("categoryValues", gson.toJson(byCategory.values));

            ChartData topProducts = getTopProducts(conn);
            req.setAttribute("topProductLabels", gson.toJson(topProducts.labels));
            req.setAttribute("topProductValues", gson.toJson(topProducts.values));

            List<Order> orders = new OrderDAO().getAllOrders();
            req.setAttribute("recentOrders", orders.size() > 5 ? orders.subList(0, 5) : orders);

            req.getRequestDispatcher("/admin/statistics.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không tải được thống kê: " + e.getMessage());
            req.getRequestDispatcher("/admin/statistics.jsp").forward(req, resp);
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

    private Product getTopProduct(Connection conn) throws SQLException {
        String sql = "SELECT p.product_name, COALESCE(SUM(od.quantity),0) total_sold " +
                "FROM products p LEFT JOIN order_details od ON p.product_id=od.product_id " +
                "GROUP BY p.product_id, p.product_name ORDER BY total_sold DESC LIMIT 1";
        Product p = new Product();
        p.setProductName("Chưa có");
        p.setTotalSold(0);
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                p.setProductName(rs.getString("product_name"));
                p.setTotalSold(rs.getInt("total_sold"));
            }
        }
        return p;
    }

    private ChartData getRevenueLast7Days(Connection conn) throws SQLException {
        String sql = "SELECT DATE(created_at) d, COALESCE(SUM(total_amount),0) revenue " +
                "FROM orders WHERE created_at >= DATE_SUB(CURDATE(), INTERVAL 6 DAY) AND status <> 'cancelled' " +
                "GROUP BY DATE(created_at) ORDER BY d";
        ChartData data = new ChartData();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.labels.add(rs.getString("d"));
                data.values.add(rs.getDouble("revenue"));
            }
        }
        return data;
    }

    private ChartData getRevenueByCategory(Connection conn) throws SQLException {
        String sql = "SELECT c.category_name, COALESCE(SUM(od.subtotal),0) revenue " +
                "FROM categories c " +
                "LEFT JOIN products p ON c.category_id=p.category_id " +
                "LEFT JOIN order_details od ON p.product_id=od.product_id " +
                "GROUP BY c.category_id, c.category_name ORDER BY revenue DESC LIMIT 6";
        ChartData data = new ChartData();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.labels.add(rs.getString("category_name"));
                data.values.add(rs.getDouble("revenue"));
            }
        }
        return data;
    }

    private ChartData getTopProducts(Connection conn) throws SQLException {
        String sql = "SELECT p.product_name, COALESCE(SUM(od.quantity),0) qty " +
                "FROM products p LEFT JOIN order_details od ON p.product_id=od.product_id " +
                "GROUP BY p.product_id, p.product_name ORDER BY qty DESC LIMIT 5";
        ChartData data = new ChartData();
        try (PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                data.labels.add(rs.getString("product_name"));
                data.values.add(rs.getDouble("qty"));
            }
        }
        return data;
    }

    private static class ChartData {
        List<String> labels = new ArrayList<>();
        List<Double> values = new ArrayList<>();
    }
}
