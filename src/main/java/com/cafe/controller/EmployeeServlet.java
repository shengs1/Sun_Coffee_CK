package com.cafe.controller;

import com.cafe.dao.EmployeeDAO;
import com.cafe.model.Employee;
import javax.servlet.*;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class EmployeeServlet extends HttpServlet {
    private final EmployeeDAO employeeDAO = new EmployeeDAO();

    private void setUtf8(HttpServletRequest request, HttpServletResponse response) throws java.io.UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setUtf8(req, resp);
        try {
            List<Employee> list = employeeDAO.getAllEmployees();
            int baristaCount = 0;
            int cashierCount = 0;
            int serverCount = 0;
            double totalSalary = 0;

            for (Employee e : list) {
                if ("active".equals(e.getStatus())) {
                    totalSalary += e.getSalary();
                }
                String role = e.getRole() != null ? e.getRole().toLowerCase().trim() : "";
                if (role.contains("pha ch\u1ebf") || role.contains("barista")) {
                    baristaCount++;
                } else if (role.contains("thu ng\u00e2n") || role.contains("cashier")) {
                    cashierCount++;
                } else if (role.contains("ph\u1ee5c v\u1ee5") || role.contains("waiter") || role.contains("server")) {
                    serverCount++;
                }
            }

            req.setAttribute("employees", list);
            req.setAttribute("baristaCount", baristaCount);
            req.setAttribute("cashierCount", cashierCount);
            req.setAttribute("serverCount", serverCount);
            req.setAttribute("totalSalary", totalSalary);
            req.getRequestDispatcher("/admin/employee-management.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Kh\u00f4ng t\u1ea3i \u0111\u01b0\u1ee3c nh\u00e2n vi\u00ean: " + e.getMessage());
            req.getRequestDispatcher("/admin/employee-management.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        setUtf8(req, resp);
        String action = req.getParameter("action");
        try {
            if ("add".equals(action)) employeeDAO.addEmployee(readEmployee(req, false));
            else if ("update".equals(action)) employeeDAO.updateEmployee(readEmployee(req, true));
            else if ("delete".equals(action)) employeeDAO.deleteEmployee(parseInt(req.getParameter("id"), 0));
            resp.sendRedirect(req.getContextPath() + "/employees");
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "L\u1ed7i x\u1eed l\u00fd nh\u00e2n vi\u00ean: " + e.getMessage());
            doGet(req, resp);
        }
    }

    private Employee readEmployee(HttpServletRequest req, boolean hasId) {
        Employee e = new Employee();
        if (hasId) e.setId(parseInt(req.getParameter("id"), 0));
        e.setEmployeeCode(trim(req.getParameter("employeeCode")));
        e.setFullName(trim(req.getParameter("fullName")));
        e.setPhone(trim(req.getParameter("phone")));
        e.setEmail(trim(req.getParameter("email")));
        e.setRole(trim(req.getParameter("role")));
        e.setShift(trim(req.getParameter("shift")));
        e.setSalary(parseDouble(req.getParameter("salary"), 0));
        e.setStatus(trim(req.getParameter("status")).isEmpty() ? "active" : trim(req.getParameter("status")));
        return e;
    }

    private int parseInt(String value, int fallback) { try { return Integer.parseInt(value); } catch (Exception e) { return fallback; } }
    private double parseDouble(String value, double fallback) { try { return Double.parseDouble(value); } catch (Exception e) { return fallback; } }
    private String trim(String value) { return value == null ? "" : value.trim(); }
}
