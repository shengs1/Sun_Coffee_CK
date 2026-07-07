package com.cafe.filter;

import com.cafe.model.User;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;

public class AuthenticationFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        User user = (session != null) ? (User) session.getAttribute("user") : null;
        String path = req.getRequestURI();
        String servletPath = req.getServletPath();

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login.jsp");
            return;
        }

        boolean adminArea = path.contains("/admin/")
                || "/dashboard".equals(servletPath)
                || "/products".equals(servletPath)
                || "/employees".equals(servletPath)
                || "/inventory".equals(servletPath)
                || "/categories".equals(servletPath)
                || "/statistics".equals(servletPath)
                || "/orders".equals(servletPath);

        if (adminArea && !user.isAdmin()) {
            resp.sendRedirect(req.getContextPath() + "/order");
            return;
        }

        chain.doFilter(request, response);
    }
}
