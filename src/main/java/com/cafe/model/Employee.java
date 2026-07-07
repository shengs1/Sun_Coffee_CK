package com.cafe.model;

import java.time.LocalDateTime;
import com.cafe.util.FormatUtil;

public class Employee {
    private int id;
    private String employeeCode;
    private String fullName;
    private String phone;
    private String email;
    private String role;
    private String shift;
    private double salary;
    private String status;
    private LocalDateTime createdAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getEmployeeCode() { return employeeCode; }
    public void setEmployeeCode(String employeeCode) { this.employeeCode = employeeCode; }
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getShift() { return shift; }
    public void setShift(String shift) { this.shift = shift; }
    public double getSalary() { return salary; }
    public void setSalary(double salary) { this.salary = salary; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public String getFormattedCreatedAt() {
        return FormatUtil.formatDate(this.createdAt);
    }
}
