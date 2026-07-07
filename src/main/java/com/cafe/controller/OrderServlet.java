package com.cafe.controller;

import com.cafe.dao.CategoryDAO;
import com.cafe.dao.OrderDAO;
import com.cafe.dao.ProductDAO;
import com.cafe.model.Order;
import com.cafe.model.OrderDetail;
import com.cafe.model.User;
import com.cafe.util.FormatUtil;
import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class OrderServlet extends HttpServlet {
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
            req.setAttribute("products", new ProductDAO().getAllProducts());
            req.setAttribute("categories", new CategoryDAO().getAllCategories());
            req.getRequestDispatcher("/staff/order-pos.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setUtf8(req, resp);
        if ("createOrder".equals(req.getParameter("action"))) {
            createOrder(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/order");
        }
    }

    private void createOrder(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        try {
            if (session == null || session.getAttribute("user") == null) {
                resp.sendRedirect(req.getContextPath() + "/login.jsp");
                return;
            }
            User user = (User) session.getAttribute("user");
            int tableId = parseInt(req.getParameter("tableId"), 1);
            double discount = Math.max(0, parseDouble(req.getParameter("discount"), 0));
            String note = req.getParameter("note");
            String itemsJson = req.getParameter("itemsJson");

            JsonArray items = JsonParser.parseString(itemsJson == null ? "[]" : itemsJson).getAsJsonArray();
            List<OrderDetail> details = new ArrayList<>();
            double subtotal = 0;
            for (JsonElement el : items) {
                JsonObject item = el.getAsJsonObject();
                int quantity = item.get("quantity").getAsInt();
                double unitPrice = item.get("unitPrice").getAsDouble();
                if (quantity <= 0 || unitPrice < 0) continue;
                OrderDetail detail = new OrderDetail(0, item.get("productId").getAsInt(), quantity, unitPrice);
                details.add(detail);
                subtotal += detail.getSubtotal();
            }

            if (details.isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng chọn món trước khi thanh toán");
                resp.sendRedirect(req.getContextPath() + "/order");
                return;
            }

            double total = Math.max(0, subtotal - discount);
            int orderId = orderDAO.createOrder(new Order(user.getUserId(), tableId, total, discount, note), details);
            if (orderId > 0) {
                session.setAttribute("successMessage", "Thanh toán thành công: " + FormatUtil.formatOrderCode(orderId, LocalDateTime.now()));
            } else {
                session.setAttribute("errorMessage", "Tạo đơn thất bại!");
            }
        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) session.setAttribute("errorMessage", "Lỗi thanh toán: " + e.getMessage());
        }
        resp.sendRedirect(req.getContextPath() + "/order");
    }

    private int parseInt(String value, int fallback) {
        try { return Integer.parseInt(value); } catch (Exception e) { return fallback; }
    }

    private double parseDouble(String value, double fallback) {
        try { return Double.parseDouble(value); } catch (Exception e) { return fallback; }
    }
}
