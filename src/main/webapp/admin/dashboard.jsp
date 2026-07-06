<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<c:if test="${empty sessionScope.user || sessionScope.user.role != 'admin'}"><c:redirect url="/login.jsp"/></c:if>
<c:set var="activePage" value="dashboard"/><c:set var="pageTitle" value="Tổng quan"/>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Tổng quan – Sun Coffee</title><link rel="preconnect" href="https://fonts.googleapis.com"><link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet"><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css"></head>
<body><div class="app-wrapper"><%@ include file="../components/header.jsp" %><%@ include file="../components/sidebar-admin.jsp" %>
<main class="main-content"><div class="page-header"><h2>📊 Tổng quan</h2><p>Dữ liệu tổng quan hệ thống Sun Coffee</p></div>
<c:if test="${not empty error}"><div class="alert-error">${error}</div></c:if>
<div class="stats-grid">
<div class="stat-card"><div class="stat-icon">💰</div><div class="stat-value"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></div><div class="stat-label">Tổng doanh thu</div></div>
<div class="stat-card"><div class="stat-icon">🧾</div><div class="stat-value">${totalOrders}</div><div class="stat-label">Tổng đơn hàng</div></div>
<div class="stat-card"><div class="stat-icon">☕</div><div class="stat-value">${totalProducts}</div><div class="stat-label">Tổng sản phẩm</div></div>
<div class="stat-card"><div class="stat-icon">👥</div><div class="stat-value">${totalEmployees}</div><div class="stat-label">Tổng nhân viên</div></div>
</div>
<div class="card"><div class="card-header d-flex justify-between align-center"><h3>Đơn hàng gần đây</h3><a class="btn btn-ghost btn-sm" href="${pageContext.request.contextPath}/orders">Xem tất cả</a></div><div class="table-wrapper"><table class="data-table compact-table"><thead><tr><th>Mã đơn</th><th>Bàn</th><th>Nhân viên</th><th>Tổng tiền</th><th>Trạng thái</th><th>Ngày tạo</th></tr></thead><tbody>
<c:forEach var="order" items="${recentOrders}"><tr><td class="fw-bold">${order.orderCode}</td><td>Bàn ${order.tableId}</td><td>${order.staffName}</td><td class="fw-bold text-coffee"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td><td><span class="badge ${order.status == 'completed' ? 'badge-success' : order.status == 'pending' ? 'badge-warning' : 'badge-danger'}">${order.status == 'completed' ? 'Hoàn thành' : order.status == 'pending' ? 'Đang xử lý' : 'Đã hủy'}</span></td><td>${order.formattedCreatedAt}</td></tr></c:forEach>
<c:if test="${empty recentOrders}"><tr><td colspan="6" class="empty-cell">Chưa có đơn hàng nào</td></tr></c:if>
</tbody></table></div></div>
</main><%@ include file="../components/footer.jsp" %></div><script src="${pageContext.request.contextPath}/assets/js/admin-script.js" charset="UTF-8"></script></body></html>
