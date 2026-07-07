package com.cafe.controller;

import com.cafe.dao.OrderDAO;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AdminOrderServlet extends HttpServlet {
    private final OrderDAO orderDAO = new OrderDAO();

    private void setUtf8(HttpServletRequest request, HttpServletResponse response) throws java.io.UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setUtf8(req, resp);
        try {
            String orderCode = req.getParameter("orderCode");
            String tableId = req.getParameter("tableId");
            String date = req.getParameter("date");
            String status = req.getParameter("status");

            boolean hasFilter = hasValue(orderCode) || hasValue(tableId) || hasValue(date) || hasValue(status);
            if (hasFilter) {
                req.setAttribute("orders", orderDAO.searchInvoices(orderCode, tableId, date, status));
            } else {
                req.setAttribute("orders", orderDAO.getAllOrders());
            }

            String detailId = req.getParameter("detailId");
            if (hasValue(detailId)) {
                req.setAttribute("selectedOrder", orderDAO.getOrderById(parseInt(detailId, 0)));
            }
            req.getRequestDispatcher("/admin/order-management.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Kh\u00f4ng t\u1ea3i \u0111\u01b0\u1ee3c \u0111\u01a1n h\u00e0ng: " + e.getMessage());
            req.getRequestDispatcher("/admin/order-management.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setUtf8(req, resp);
        String action = req.getParameter("action");
        String orderIdStr = req.getParameter("orderId");

        // Ghi nhận hành động và mã đơn hàng để tìm và sửa lỗi
        getServletContext().log("AdminOrderServlet - action: " + action + ", orderIdStr: " + orderIdStr);

        try {
            int orderId = parseInt(orderIdStr, 0);
            if ("updateStatus".equals(action)) {
                orderDAO.updateStatus(orderId, req.getParameter("status"));
            } else if ("delete".equals(action) || "cancel".equals(action)) {
                orderDAO.updateStatus(orderId, "cancelled");
            }
            resp.sendRedirect(req.getContextPath() + "/orders");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "L\u1ed7i x\u1eed l\u00fd \u0111\u01a1n h\u00e0ng: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private boolean hasValue(String value) { return value != null && !value.trim().isEmpty(); }
    private int parseInt(String value, int fallback) { try { return Integer.parseInt(value); } catch (Exception e) { return fallback; } }
}
