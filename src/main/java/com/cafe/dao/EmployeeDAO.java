package com.cafe.dao;

import com.cafe.connection.DBConnection;
import com.cafe.model.Employee;
import java.sql.*;
import java.util.*;

public class EmployeeDAO {
    public List<Employee> getAllEmployees() throws SQLException {
        String sql = "SELECT * FROM employees ORDER BY id DESC";
        List<Employee> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(mapRow(rs));
        }
        return list;
    }

    public void addEmployee(Employee e) throws SQLException {
        String sql = "INSERT INTO employees(employee_code,full_name,phone,email,role,shift,salary,status) VALUES(?,?,?,?,?,?,?,?)";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            fillStatement(ps, e);
            ps.executeUpdate();
        }
    }

    public void updateEmployee(Employee e) throws SQLException {
        String sql = "UPDATE employees SET employee_code=?,full_name=?,phone=?,email=?,role=?,shift=?,salary=?,status=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            fillStatement(ps, e);
            ps.setInt(9, e.getId());
            ps.executeUpdate();
        }
    }

    public void deleteEmployee(int id) throws SQLException {
        String sql = "DELETE FROM employees WHERE id=?";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public int countActiveEmployees() throws SQLException {
        String sql = "SELECT COUNT(*) FROM employees WHERE status='active'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getInt(1) : 0;
        }
    }

    public double getTotalSalary() throws SQLException {
        String sql = "SELECT COALESCE(SUM(salary),0) FROM employees WHERE status='active'";
        try (Connection conn = DBConnection.getConnection(); PreparedStatement ps = conn.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            return rs.next() ? rs.getDouble(1) : 0;
        }
    }

    private void fillStatement(PreparedStatement ps, Employee e) throws SQLException {
        ps.setString(1, e.getEmployeeCode());
        ps.setString(2, e.getFullName());
        ps.setString(3, e.getPhone());
        ps.setString(4, e.getEmail());
        ps.setString(5, e.getRole());
        ps.setString(6, e.getShift());
        ps.setDouble(7, e.getSalary());
        ps.setString(8, e.getStatus());
    }

    private Employee mapRow(ResultSet rs) throws SQLException {
        Employee e = new Employee();
        e.setId(rs.getInt("id"));
        e.setEmployeeCode(rs.getString("employee_code"));
        e.setFullName(rs.getString("full_name"));
        e.setPhone(rs.getString("phone"));
        e.setEmail(rs.getString("email"));
        e.setRole(rs.getString("role"));
        e.setShift(rs.getString("shift"));
        e.setSalary(rs.getDouble("salary"));
        e.setStatus(rs.getString("status"));
        Timestamp ts = rs.getTimestamp("created_at");
        if (ts != null) e.setCreatedAt(ts.toLocalDateTime());
        return e;
    }
}
