package com.cafe.model;

public class OrderDetail {
    private int    detailId;
    private int    orderId;
    private int    productId;
    private int    quantity;
    private double unitPrice;
    private double subtotal;
    private String productName;

    public OrderDetail() {}
    public OrderDetail(int orderId, int productId, int quantity, double unitPrice) {
        this.orderId = orderId; this.productId = productId;
        this.quantity = quantity; this.unitPrice = unitPrice;
        this.subtotal = quantity * unitPrice;
    }

    public int    getDetailId()                    { return detailId; }
    public void   setDetailId(int v)               { this.detailId = v; }
    public int    getOrderId()                     { return orderId; }
    public void   setOrderId(int v)                { this.orderId = v; }
    public int    getProductId()                   { return productId; }
    public void   setProductId(int v)              { this.productId = v; }
    public int    getQuantity()                    { return quantity; }
    public void   setQuantity(int v)               { this.quantity = v; }
    public double getUnitPrice()                   { return unitPrice; }
    public void   setUnitPrice(double v)           { this.unitPrice = v; }
    public double getSubtotal()                    { return subtotal; }
    public void   setSubtotal(double v)            { this.subtotal = v; }
    public String getProductName()                 { return productName; }
    public void   setProductName(String v)         { this.productName = v; }
}
