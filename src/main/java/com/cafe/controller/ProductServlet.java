package com.cafe.controller;

import com.cafe.dao.CategoryDAO;
import com.cafe.dao.ProductDAO;
import com.cafe.model.Product;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class ProductServlet extends HttpServlet {
    private final ProductDAO productDAO = new ProductDAO();
    private final CategoryDAO categoryDAO = new CategoryDAO();

    private void setUtf8(HttpServletRequest request, HttpServletResponse response) throws java.io.UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);
        try {
            req.setAttribute("products", productDAO.getAllProducts());
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.getRequestDispatcher("/admin/menu-management.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không tải được danh sách sản phẩm: " + e.getMessage());
            req.getRequestDispatcher("/admin/menu-management.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                productDAO.addProduct(readProduct(req, false));
            } else if ("update".equals(action)) {
                productDAO.updateProduct(readProduct(req, true));
            } else if ("delete".equals(action)) {
                productDAO.deleteProduct(parseInt(req.getParameter("productId"), 0));
            }
            resp.sendRedirect(req.getContextPath() + "/products");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi xử lý sản phẩm: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private Product readProduct(HttpServletRequest req, boolean hasId) {
        Product p = new Product();
        if (hasId) p.setProductId(parseInt(req.getParameter("productId"), 0));
        p.setProductName(trim(req.getParameter("productName")));
        p.setCategoryId(parseInt(req.getParameter("categoryId"), 0));
        p.setPrice(parseDouble(req.getParameter("price"), 0));
        p.setDescription(trim(req.getParameter("description")));
        p.setImage(trim(req.getParameter("image")));
        String status = trim(req.getParameter("status"));
        p.setStatus(status.isEmpty() ? "active" : status);
        return p;
    }

    private int parseInt(String value, int fallback) {
        try { return Integer.parseInt(value); } catch (Exception e) { return fallback; }
    }
    private double parseDouble(String value, double fallback) {
        try { return Double.parseDouble(value); } catch (Exception e) { return fallback; }
    }
    private String trim(String value) { return value == null ? "" : value.trim(); }
}
