package com.cafe.dao;

import com.cafe.connection.DBConnection;
import com.cafe.model.InventoryItem;
import java.sql.*;
import java.util.*;

public class InventoryDAO {
    public List<InventoryItem> getAllItems() throws SQLException {
        String sql = "SELECT * FROM inventory_items ORDER BY id DESC";
        List<InventoryItem> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public void addItem(InventoryItem item) throws SQLException {
        String sql = "INSERT INTO inventory_items(item_name,unit,quantity,min_quantity,supplier,status) VALUES(?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            fillStatement(ps, item);
            ps.executeUpdate();
        }
    }

    public void updateItem(InventoryItem item) throws SQLException {
        String sql = "UPDATE inventory_items SET item_name=?,unit=?,quantity=?,min_quantity=?,supplier=?,status=?,updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            fillStatement(ps, item);
            ps.setInt(7, item.getId());
            ps.executeUpdate();
        }
    }

    public void adjustStock(int id, double quantity) throws SQLException {
        String sql = "UPDATE inventory_items SET quantity=?, updated_at=CURRENT_TIMESTAMP WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDouble(1, quantity);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public void deleteItem(int id) throws SQLException {
        String sql = "DELETE FROM inventory_items WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public int countLowStock() throws SQLException {
        String sql = "SELECT COUNT(*) FROM inventory_items WHERE quantity <= min_quantity";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    private void fillStatement(PreparedStatement ps, InventoryItem item) throws SQLException {
        ps.setString(1, item.getItemName());
        ps.setString(2, item.getUnit());
        ps.setDouble(3, item.getQuantity());
        ps.setDouble(4, item.getMinQuantity());
        ps.setString(5, item.getSupplier());
        ps.setString(6, item.getStatus());
    }

    private InventoryItem mapRow(ResultSet rs) throws SQLException {
        InventoryItem item = new InventoryItem();
        item.setId(rs.getInt("id"));
        item.setItemName(rs.getString("item_name"));
        item.setUnit(rs.getString("unit"));
        item.setQuantity(rs.getDouble("quantity"));
        item.setMinQuantity(rs.getDouble("min_quantity"));
        item.setSupplier(rs.getString("supplier"));
        item.setStatus(rs.getString("status"));
        Timestamp ts = rs.getTimestamp("updated_at");
        if (ts != null) item.setUpdatedAt(ts.toLocalDateTime());
        return item;
    }
}
