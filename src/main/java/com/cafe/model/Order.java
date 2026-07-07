package com.cafe.model;

import java.time.LocalDateTime;
import java.util.List;
import com.cafe.util.FormatUtil;

public class Order {
    private int orderId;
    private int userId;
    private int tableId;
    private double totalAmount;
    private double discount;
    private String note;
    private String status;
    private LocalDateTime createdAt;
    private List<OrderDetail> orderDetails;
    private String staffName;
    private String orderCode;

    public Order() {}

    public Order(int userId, int tableId, double totalAmount, double discount, String note) {
        this.userId = userId;
        this.tableId = tableId;
        this.totalAmount = totalAmount;
        this.discount = discount;
        this.note = note;
        this.status = "pending";
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getTableId() { return tableId; }
    public void setTableId(int tableId) { this.tableId = tableId; }
    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }
    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }
    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    public List<OrderDetail> getOrderDetails() { return orderDetails; }
    public void setOrderDetails(List<OrderDetail> orderDetails) { this.orderDetails = orderDetails; }
    public String getStaffName() { return staffName; }
    public void setStaffName(String staffName) { this.staffName = staffName; }
    public String getOrderCode() { return orderCode; }
    public void setOrderCode(String orderCode) { this.orderCode = orderCode; }

    public String getFormattedCreatedAt() {
        return FormatUtil.formatDateTime(this.createdAt);
    }
}
