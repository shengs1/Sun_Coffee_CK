<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<aside class="admin-sidebar" id="admin-sidebar">
    <div class="sidebar-brand-wrapper">
        <div class="sidebar-brand">☕ <span class="brand-text">Sun Coffee</span></div>
    </div>
    <nav class="sidebar-menu">
        <c:if test="${sessionScope.user.role == 'admin'}">
            <a class="sidebar-link ${activePage == 'dashboard' ? 'active' : ''}" href="${pageContext.request.contextPath}/dashboard" title="T\u1ed5ng quan"><span class="link-icon">📊</span> <span class="link-text">Tổng quan</span></a>
        </c:if>
        
        <a class="sidebar-link ${activePage == 'pos' ? 'active' : ''}" href="${pageContext.request.contextPath}/order" title="G\u1ecdi m\u00f3n POS"><span class="link-icon">🛒</span> <span class="link-text">Gọi món POS</span></a>
        
        <c:if test="${sessionScope.user.role == 'admin'}">
            <a class="sidebar-link ${activePage == 'orders' ? 'active' : ''}" href="${pageContext.request.contextPath}/orders" title="Qu\u1ea3n l\u00fd \u0110\u01a1n & H\u00f3a \u0111\u01a1n"><span class="link-icon">🧾</span> <span class="link-text">Quản lý Đơn & Hóa đơn</span></a>
            <a class="sidebar-link ${activePage == 'menu' ? 'active' : ''}" href="${pageContext.request.contextPath}/products" title="Qu\u1ea3n l\u00fd th\u1ef1c \u0111\u01a1n"><span class="link-icon">☕</span> <span class="link-text">Quản lý thực đơn</span></a>
            <a class="sidebar-link ${activePage == 'employees' ? 'active' : ''}" href="${pageContext.request.contextPath}/employees" title="Qu\u1ea3n l\u00fd nh\u00e2n vi\u00ean"><span class="link-icon">👥</span> <span class="link-text">Quản lý nhân viên</span></a>
            <a class="sidebar-link ${activePage == 'inventory' ? 'active' : ''}" href="${pageContext.request.contextPath}/inventory" title="Kho nguy\u00ean li\u1ec7u"><span class="link-icon">📦</span> <span class="link-text">Kho nguyên liệu</span></a>
            <a class="sidebar-link ${activePage == 'category' ? 'active' : ''}" href="${pageContext.request.contextPath}/categories" title="Qu\u1ea3n l\u00fd danh m\u1ee5c"><span class="link-icon">📂</span> <span class="link-text">Quản lý danh mục</span></a>
            <a class="sidebar-link ${activePage == 'statistics' ? 'active' : ''}" href="${pageContext.request.contextPath}/statistics" title="Th\u1ed1ng k\u00ea doanh thu"><span class="link-icon">📈</span> <span class="link-text">Thống kê doanh thu</span></a>
        </c:if>
    </nav>
</aside>
