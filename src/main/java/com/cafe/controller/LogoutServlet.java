package com.cafe.controller;

import javax.servlet.http.*;
import java.io.IOException;
import java.net.URLEncoder;

public class LogoutServlet extends HttpServlet {
    private void setUtf8(HttpServletRequest request, HttpServletResponse response) throws java.io.UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        setUtf8(req, resp);
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        String message = URLEncoder.encode("Đã đăng xuất thành công!", "UTF-8");
        resp.sendRedirect(req.getContextPath() + "/login.jsp?message=" + message);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        doPost(req, resp);
    }
}
