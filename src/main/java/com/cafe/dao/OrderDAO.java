package com.cafe.dao;

import com.cafe.connection.DBConnection;
import com.cafe.model.Order;
import com.cafe.model.OrderDetail;
import com.cafe.util.FormatUtil;
import java.sql.*;
import java.time.LocalDate;
import java.util.*;

public class OrderDAO {
    public int createOrder(Order order, List<OrderDetail> details) throws SQLException {
        String orderSql = "INSERT INTO orders(user_id,table_id,total_amount,discount,note,status) VALUES(?,?,?,?,?,'completed')";
        String detailSql = "INSERT INTO order_details(order_id,product_id,quantity,unit_price,subtotal) VALUES(?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getUserId());
                ps.setInt(2, order.getTableId());
                ps.setDouble(3, order.getTotalAmount());
                ps.setDouble(4, order.getDiscount());
                ps.setString(5, order.getNote());
                ps.executeUpdate();
                ResultSet keys = ps.getGeneratedKeys();
                if (!keys.next()) {
                    conn.rollback();
                    return -1;
                }
                int orderId = keys.getInt(1);
                try (PreparedStatement dps = conn.prepareStatement(detailSql)) {
                    for (OrderDetail detail : details) {
                        dps.setInt(1, orderId);
                        dps.setInt(2, detail.getProductId());
                        dps.setInt(3, detail.getQuantity());
                        dps.setDouble(4, detail.getUnitPrice());
                        dps.setDouble(5, detail.getSubtotal());
                        dps.addBatch();
                    }
                    dps.executeBatch();
                }
                conn.commit();
                return orderId;
            } catch (SQLException e) {
                conn.rollback();
                throw e;
            } finally {
                conn.setAutoCommit(true);
            }
        }
    }

    public int createOrder(Order order) throws SQLException {
        return createOrder(order, Collections.emptyList());
    }

    public void addOrderDetail(OrderDetail detail) throws SQLException {
        String sql = "INSERT INTO order_details(order_id,product_id,quantity,unit_price,subtotal) VALUES(?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, detail.getOrderId());
            ps.setInt(2, detail.getProductId());
            ps.setInt(3, detail.getQuantity());
            ps.setDouble(4, detail.getUnitPrice());
            ps.setDouble(5, detail.getSubtotal());
            ps.executeUpdate();
        }
    }

    public List<Order> getAllOrders() throws SQLException {
        String sql = "SELECT o.*, u.full_name AS staff_name FROM orders o JOIN users u ON o.user_id=u.user_id ORDER BY o.created_at DESC, o.order_id DESC";
        return queryOrders(sql);
    }

    public List<Order> getRecentOrders(int limit) throws SQLException {
        String sql = "SELECT o.*, u.full_name AS staff_name FROM orders o JOIN users u ON o.user_id=u.user_id ORDER BY o.created_at DESC, o.order_id DESC LIMIT ?";
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, limit);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT o.*, u.full_name AS staff_name FROM orders o JOIN users u ON o.user_id=u.user_id WHERE o.order_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = mapRow(rs);
                    order.setOrderDetails(getOrderDetails(orderId));
                    return order;
                }
            }
        }
        return null;
    }

    public List<OrderDetail> getOrderDetails(int orderId) throws SQLException {
        String sql = "SELECT od.*, p.product_name FROM order_details od JOIN products p ON od.product_id=p.product_id WHERE od.order_id=? ORDER BY od.detail_id";
        List<OrderDetail> details = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderDetail d = new OrderDetail();
                    d.setDetailId(rs.getInt("detail_id"));
                    d.setOrderId(rs.getInt("order_id"));
                    d.setProductId(rs.getInt("product_id"));
                    d.setQuantity(rs.getInt("quantity"));
                    d.setUnitPrice(rs.getDouble("unit_price"));
                    d.setSubtotal(rs.getDouble("subtotal"));
                    d.setProductName(rs.getString("product_name"));
                    details.add(d);
                }
            }
        }
        return details;
    }

    public List<Order> searchInvoices(String orderCodeOrId, String tableId, String date, String status) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT o.*, u.full_name AS staff_name FROM orders o JOIN users u ON o.user_id=u.user_id WHERE 1=1");
        List<Object> params = new ArrayList<>();
        if (orderCodeOrId != null && !orderCodeOrId.trim().isEmpty()) {
            sql.append(" AND (CONCAT('SC-', DATE_FORMAT(o.created_at, '%d%m%Y'), '-', LPAD(o.order_id, 4, '0')) LIKE ?");
            params.add("%" + orderCodeOrId.trim() + "%");
            
            String digits = orderCodeOrId.replaceAll("\\D", "");
            if (!digits.isEmpty()) {
                sql.append(" OR o.order_id = ?");
                params.add(parseInt(digits, -1));
            }
            sql.append(")");
        }
        if (tableId != null && !tableId.trim().isEmpty()) {
            sql.append(" AND o.table_id=?");
            params.add(parseInt(tableId, -1));
        }
        if (date != null && !date.trim().isEmpty()) {
            sql.append(" AND DATE(o.created_at)=?");
            params.add(java.sql.Date.valueOf(LocalDate.parse(date)));
        }
        if (status != null && !status.trim().isEmpty()) {
            sql.append(" AND o.status=?");
            params.add(status);
        }
        sql.append(" ORDER BY o.created_at DESC, o.order_id DESC");
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) ps.setObject(i + 1, params.get(i));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        }
        return list;
    }

    public void updateStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET status=? WHERE order_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, orderId);
            ps.executeUpdate();
        }
    }

    public void deleteOrder(int orderId) throws SQLException {
        String sql = "DELETE FROM orders WHERE order_id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        }
    }

    private List<Order> queryOrders(String sql) throws SQLException {
        List<Order> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    private Order mapRow(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setTableId(rs.getInt("table_id"));
        o.setTotalAmount(rs.getDouble("total_amount"));
        o.setDiscount(rs.getDouble("discount"));
        o.setNote(rs.getString("note"));
        o.setStatus(rs.getString("status"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) o.setCreatedAt(ts.toLocalDateTime());
        try { o.setStaffName(rs.getString("staff_name")); } catch (Exception ignored) {}
        o.setOrderCode(FormatUtil.formatOrderCode(o.getOrderId(), o.getCreatedAt()));
        return o;
    }

    private int parseInt(String value, int fallback) {
        try { return Integer.parseInt(value); } catch (Exception e) { return fallback; }
    }
}
