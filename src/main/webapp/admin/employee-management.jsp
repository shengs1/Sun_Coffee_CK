<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN" />
<c:if test="${empty sessionScope.user || sessionScope.user.role != 'admin'}"><c:redirect url="/login.jsp"/></c:if>
<c:set var="activePage" value="employees"/><c:set var="pageTitle" value="Quản lý nhân viên"/><c:set var="pageTitleIcon" value="👥"/><c:set var="pageDescription" value="Danh sách nhân viên Sun Coffee"/>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Quản lý nhân viên – Sun Coffee</title><link rel="preconnect" href="https://fonts.googleapis.com"><link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet"><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css"></head>
<body><div class="app-wrapper"><%@ include file="../components/header.jsp" %><%@ include file="../components/sidebar-admin.jsp" %><main class="main-content">
    <c:if test="${not empty error}">
        <div class="alert-error">
            ⚠️ ${error}
        </div>
    </c:if>
    <div class="page-header d-flex justify-end align-center flex-wrap gap-1"><button class="btn btn-primary" onclick="openModal('modal-add-employee')">Thêm nhân viên</button></div>
<div class="stats-grid">
    <div class="stat-card">
        <div class="stat-icon">👨‍🍳</div>
        <div class="stat-value">${baristaCount}</div>
        <div class="stat-label">Pha chế (Barista)</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">💰</div>
        <div class="stat-value">${cashierCount}</div>
        <div class="stat-label">Thu ngân</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">💁</div>
        <div class="stat-value">${serverCount}</div>
        <div class="stat-label">Phục vụ</div>
    </div>
    <div class="stat-card">
        <div class="stat-icon">💵</div>
        <div class="stat-value"><fmt:formatNumber value="${totalSalary}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div>
        <div class="stat-label">Tổng lương/tháng</div>
    </div>
</div>
<div class="filter-bar"><div class="search-box"><span class="search-icon">🔍</span><input class="search-input" placeholder="Tìm theo mã NV, họ tên, SĐT, email..." oninput="searchAnyTable(this.value,'employee-table')"></div></div>
<div class="card"><div class="card-header"><h3>Danh sách nhân viên</h3></div><div class="table-wrapper"><table class="data-table" id="employee-table"><thead><tr><th>Mã NV</th><th>Họ tên</th><th>Điện thoại</th><th>Email</th><th>Vai trò</th><th>Ca</th><th>Lương</th><th>Trạng thái</th><th>Ngày vào làm</th><th>Thao tác</th></tr></thead><tbody><c:forEach var="e" items="${employees}"><tr><td class="fw-bold">${e.employeeCode}</td><td>${e.fullName}</td><td>${e.phone}</td><td>${e.email}</td><td><span class="badge badge-coffee">${e.role}</span></td><td>${e.shift}</td><td><fmt:formatNumber value="${e.salary}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td><td><span class="badge ${e.status == 'active' ? 'badge-success' : 'badge-danger'}">${e.status == 'active' ? 'Hoạt động' : 'Ngừng hoạt động'}</span></td><td>${e.formattedCreatedAt}</td><td><div class="actions"><button class="btn btn-ghost btn-sm js-edit-employee" data-id="${e.id}" data-code="${fn:escapeXml(e.employeeCode)}" data-name="${fn:escapeXml(e.fullName)}" data-phone="${fn:escapeXml(e.phone)}" data-email="${fn:escapeXml(e.email)}" data-role="${fn:escapeXml(e.role)}" data-shift="${fn:escapeXml(e.shift)}" data-salary="${e.salary}" data-status="${e.status}">Sửa</button><form id="del-emp-${e.id}" action="${pageContext.request.contextPath}/employees" method="post" style="display:none"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="${e.id}"></form><button class="btn btn-danger btn-sm" onclick="confirmDelete('del-emp-${e.id}','${fn:escapeXml(e.fullName)}')">Xóa</button></div></td></tr></c:forEach><c:if test="${empty employees}"><tr><td colspan="10" class="empty-cell">Chưa có nhân viên</td></tr></c:if></tbody></table></div></div>
</main><%@ include file="../components/footer.jsp" %></div>
<div class="modal-overlay" id="modal-add-employee" onclick="closeOnBackdrop(event,'modal-add-employee')"><div class="modal-box"><div class="modal-header"><h3>Thêm nhân viên</h3><button class="modal-close" onclick="closeModal('modal-add-employee')">✕</button></div><div class="modal-body"><form action="${pageContext.request.contextPath}/employees" method="post"><input type="hidden" name="action" value="add"><%@ include file="employee-form.jspf" %><div class="modal-footer"><button type="button" class="btn btn-ghost" onclick="closeModal('modal-add-employee')">Hủy</button><button class="btn btn-primary">Lưu</button></div></form></div></div></div>
<div class="modal-overlay" id="modal-edit-employee" onclick="closeOnBackdrop(event,'modal-edit-employee')"><div class="modal-box"><div class="modal-header"><h3>Sửa nhân viên</h3><button class="modal-close" onclick="closeModal('modal-edit-employee')">✕</button></div><div class="modal-body"><form id="form-edit-employee" action="${pageContext.request.contextPath}/employees" method="post"><input type="hidden" name="action" value="update"><input type="hidden" name="id"><%@ include file="employee-form.jspf" %><div class="modal-footer"><button type="button" class="btn btn-ghost" onclick="closeModal('modal-edit-employee')">Hủy</button><button class="btn btn-primary">Lưu thay đổi</button></div></form></div></div></div>
<script src="${pageContext.request.contextPath}/assets/js/admin-script.js" charset="UTF-8"></script></body></html>
