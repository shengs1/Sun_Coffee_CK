package com.cafe.controller;

import com.cafe.dao.InventoryDAO;
import com.cafe.model.InventoryItem;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class InventoryServlet extends HttpServlet {
    private final InventoryDAO inventoryDAO = new InventoryDAO();

    private void setUtf8(HttpServletRequest request, HttpServletResponse response) throws java.io.UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setUtf8(req, resp);
        try {
            req.setAttribute("items", inventoryDAO.getAllItems());
            req.setAttribute("lowStockCount", inventoryDAO.countLowStock());
            req.getRequestDispatcher("/admin/inventory.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Kh\u00f4ng t\u1ea3i \u0111\u01b0\u1ee3c kho nguy\u00ean li\u1ec7u: " + e.getMessage());
            req.getRequestDispatcher("/admin/inventory.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setUtf8(req, resp);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) inventoryDAO.addItem(readItem(req, false));
            else if ("update".equals(action)) inventoryDAO.updateItem(readItem(req, true));
            else if ("adjustStock".equals(action)) {
                int id = parseInt(req.getParameter("id"), 0);
                double quantity = parseDouble(req.getParameter("quantity"), 0);
                inventoryDAO.adjustStock(id, quantity);
            }
            else if ("delete".equals(action)) inventoryDAO.deleteItem(parseInt(req.getParameter("id"), 0));
            resp.sendRedirect(req.getContextPath() + "/inventory");
        } catch (Exception e) {
            e.printStackTrace();
            String errorMsg = e.getMessage();
            if (errorMsg != null && (errorMsg.contains("foreign key constraint fails") || errorMsg.contains("Cannot delete or update a parent row"))) {
                req.setAttribute("error", "Không thể xóa nguyên liệu này do có dữ liệu liên kết. Bạn có thể cập nhật trạng thái nguyên liệu thành 'Ngừng dùng'.");
            } else {
                req.setAttribute("error", "Lỗi xử lý kho nguyên liệu: " + errorMsg);
            }
            doGet(req, resp);
        }
    }

    private InventoryItem readItem(HttpServletRequest req, boolean hasId) {
        InventoryItem item = new InventoryItem();
        if (hasId) item.setId(parseInt(req.getParameter("id"), 0));
        item.setItemName(trim(req.getParameter("itemName")));
        item.setUnit(trim(req.getParameter("unit")));
        item.setQuantity(parseDouble(req.getParameter("quantity"), 0));
        item.setMinQuantity(parseDouble(req.getParameter("minQuantity"), 0));
        item.setSupplier(trim(req.getParameter("supplier")));
        item.setStatus(trim(req.getParameter("status")).isEmpty() ? "active" : trim(req.getParameter("status")));
        return item;
    }

    private int parseInt(String value, int fallback) { try { return Integer.parseInt(value); } catch (Exception e) { return fallback; } }
    private double parseDouble(String value, double fallback) { try { return Double.parseDouble(value); } catch (Exception e) { return fallback; } }
    private String trim(String value) { return value == null ? "" : value.trim(); }
}
