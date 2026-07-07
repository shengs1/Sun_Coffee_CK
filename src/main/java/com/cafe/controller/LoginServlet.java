package com.cafe.controller;

import com.cafe.dao.UserDAO;
import com.cafe.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

// Xử lý đăng nhập
public class LoginServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    // Cấu hình tiếng Việt để không lỗi phông chữ
    private void setUtf8(HttpServletRequest request, HttpServletResponse response) throws java.io.UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    // Hiển thị trang đăng nhập
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);
        req.getRequestDispatcher("login.jsp").forward(req, resp);
    }

    // Nhận thông tin khi bấm nút đăng nhập
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        setUtf8(req, resp);

        // Lấy tên tài khoản và mật khẩu từ biểu mẫu
        String username = req.getParameter("username");
        String password = req.getParameter("password");

        // Kiểm tra xem đã điền đủ thông tin chưa
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng nhập đầy đủ thông tin!");
            req.getRequestDispatcher("login.jsp").forward(req, resp);
            return;
        }

        try {
            // Kiểm tra tài khoản trong cơ sở dữ liệu
            User user = userDAO.login(username.trim(), password);
            if (user != null) {
                // Lưu thông tin đăng nhập thành công
                HttpSession session = req.getSession();
                session.setAttribute("user", user);
                session.setMaxInactiveInterval(3600); // Tự động đăng xuất sau 1 tiếng
                
                // Chuyển hướng: quản lý vào trang tổng quan, nhân viên vào trang bán hàng
                if (user.isAdmin()) {
                    resp.sendRedirect(req.getContextPath() + "/dashboard");
                } else {
                    resp.sendRedirect(req.getContextPath() + "/order");
                }
            } else {
                // Sai tài khoản hoặc mật khẩu
                req.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");
                req.getRequestDispatcher("login.jsp").forward(req, resp);
            }
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            req.getRequestDispatcher("login.jsp").forward(req, resp);
        }
    }
}

