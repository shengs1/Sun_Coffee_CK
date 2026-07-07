package com.cafe.dao;

import com.cafe.connection.DBConnection;
import com.cafe.model.Category;
import java.sql.*;
import java.util.*;

public class CategoryDAO {

    public List<Category> getAllCategories() throws SQLException {
        String sql = "SELECT c.*, COUNT(p.product_id) AS product_count " +
                     "FROM categories c LEFT JOIN products p ON c.category_id = p.category_id " +
                     "GROUP BY c.category_id, c.category_name, c.description " +
                     "ORDER BY c.category_id DESC";
        List<Category> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public void addCategory(Category category) throws SQLException {
        String sql = "INSERT INTO categories(category_name, description) VALUES(?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.executeUpdate();
        }
    }

    public void updateCategory(Category category) throws SQLException {
        String sql = "UPDATE categories SET category_name=?, description=? WHERE category_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, category.getCategoryName());
            ps.setString(2, category.getDescription());
            ps.setInt(3, category.getCategoryId());
            ps.executeUpdate();
        }
    }

    public void deleteCategory(int categoryId) throws SQLException {
        String sql = "DELETE FROM categories WHERE category_id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, categoryId);
            ps.executeUpdate();
        }
    }

    private Category mapRow(ResultSet rs) throws SQLException {
        Category c = new Category();
        c.setCategoryId(rs.getInt("category_id"));
        c.setCategoryName(rs.getString("category_name"));
        c.setDescription(rs.getString("description"));
        try { c.setProductCount(rs.getInt("product_count")); } catch (Exception ignored) {}
        return c;
    }
}
