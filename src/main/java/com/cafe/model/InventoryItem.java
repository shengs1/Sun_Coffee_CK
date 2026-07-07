package com.cafe.model;

import java.time.LocalDateTime;

public class InventoryItem {
    private int id;
    private String itemName;
    private String unit;
    private double quantity;
    private double minQuantity;
    private String supplier;
    private String status;
    private LocalDateTime updatedAt;

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }
    public String getUnit() { return unit; }
    public void setUnit(String unit) { this.unit = unit; }
    public double getQuantity() { return quantity; }
    public void setQuantity(double quantity) { this.quantity = quantity; }
    public double getMinQuantity() { return minQuantity; }
    public void setMinQuantity(double minQuantity) { this.minQuantity = minQuantity; }
    public String getSupplier() { return supplier; }
    public void setSupplier(String supplier) { this.supplier = supplier; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    public boolean isLowStock() { return quantity <= minQuantity; }
}
