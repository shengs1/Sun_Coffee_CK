package com.cafe.controller;

import com.cafe.dao.CategoryDAO;
import com.cafe.model.Category;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class CategoryServlet extends HttpServlet {
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
            req.setAttribute("categories", categoryDAO.getAllCategories());
            req.getRequestDispatcher("/admin/category-management.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Không tải được danh mục: " + e.getMessage());
            req.getRequestDispatcher("/admin/category-management.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) {
                Category c = new Category();
                c.setCategoryName(trim(req.getParameter("categoryName")));
                c.setDescription(trim(req.getParameter("description")));
                categoryDAO.addCategory(c);
            } else if ("update".equals(action)) {
                Category c = new Category();
                c.setCategoryId(parseInt(req.getParameter("categoryId"), 0));
                c.setCategoryName(trim(req.getParameter("categoryName")));
                c.setDescription(trim(req.getParameter("description")));
                categoryDAO.updateCategory(c);
            } else if ("delete".equals(action)) {
                categoryDAO.deleteCategory(parseInt(req.getParameter("categoryId"), 0));
            }
            resp.sendRedirect(req.getContextPath() + "/categories");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi xử lý danh mục: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private int parseInt(String value, int fallback) {
        try { return Integer.parseInt(value); } catch (Exception e) { return fallback; }
    }
    private String trim(String value) { return value == null ? "" : value.trim(); }
}
