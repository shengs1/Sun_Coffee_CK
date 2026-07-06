<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN" />
<c:if test="${empty sessionScope.user || (sessionScope.user.role != 'admin' && sessionScope.user.role != 'staff')}"><c:redirect url="/login.jsp"/></c:if>
<c:set var="activePage" value="orders"/><c:set var="pageTitle" value="Quản lý Đơn & Hóa đơn"/>
<!DOCTYPE html><html lang="vi"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0"><title>Quản lý Đơn & Hóa đơn – Sun Coffee</title><link rel="preconnect" href="https://fonts.googleapis.com"><link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet"><link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css"></head>
<body><div class="app-wrapper"><%@ include file="../components/header.jsp" %><%@ include file="../components/sidebar-admin.jsp" %>
<main class="main-content"><div class="page-header"><h2>🧾 Quản lý Đơn & Hóa đơn</h2><p>Tra cứu hóa đơn và cập nhật trạng thái đơn hàng</p></div>
<c:if test="${not empty error}"><div class="alert-error">${error}</div></c:if>

<form class="filter-bar" action="${pageContext.request.contextPath}/orders" method="get">
    <div class="search-box">
        <span class="search-icon">🔍</span>
        <input name="orderCode" class="search-input" value="${fn:escapeXml(param.orderCode)}" placeholder="Tìm mã đơn...">
    </div>
    <input name="tableId" class="form-control small-input" value="${fn:escapeXml(param.tableId)}" placeholder="Số bàn">
    <input type="date" name="date" class="form-control small-input" value="${fn:escapeXml(param.date)}">
    <select name="status" class="form-control small-input">
        <option value="">-- Tất cả trạng thái --</option>
        <option value="completed" ${param.status == 'completed' ? 'selected' : ''}>Hoàn thành</option>
        <option value="cancelled" ${param.status == 'cancelled' ? 'selected' : ''}>Đã hủy</option>
    </select>
    <button class="btn btn-primary" type="submit">Tra cứu</button>
</form>

<div class="card"><div class="card-header"><h3>Danh sách đơn hàng & hóa đơn</h3></div><div class="table-wrapper"><table class="data-table" id="orders-table"><thead><tr><th>Mã đơn/Hóa đơn</th><th>Bàn</th><th>Nhân viên</th><th>Tổng tiền</th><th>Giảm giá</th><th>Trạng thái</th><th>Ngày tạo</th><th>Thao tác</th></tr></thead><tbody>
<c:forEach var="order" items="${orders}"><tr>
    <td class="fw-bold">${order.orderCode}</td>
    <td>Bàn ${order.tableId}</td>
    <td>${order.staffName}</td>
    <td class="fw-bold text-coffee"><fmt:formatNumber value="${order.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
    <td><fmt:formatNumber value="${order.discount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
    <td>
        <span class="badge ${order.status == 'completed' ? 'badge-success' : 'badge-danger'}">
            ${order.status == 'completed' ? 'Hoàn thành' : 'Đã hủy'}
        </span>
    </td>
    <td>${order.formattedCreatedAt}</td>
    <td>
        <div class="actions">
            <a class="btn btn-ghost btn-sm" href="${pageContext.request.contextPath}/orders?detailId=${order.orderId}&orderCode=${fn:escapeXml(param.orderCode)}&tableId=${fn:escapeXml(param.tableId)}&date=${fn:escapeXml(param.date)}&status=${fn:escapeXml(param.status)}">Chi tiết</a>
            
            <c:if test="${order.status == 'completed'}">
                <form action="${pageContext.request.contextPath}/orders" method="post" class="inline-form" onsubmit="return confirm('B\u1ea1n c\u00f3 ch\u1eafc ch\u1eafn mu\u1ed1n h\u1ee7y \u0111\u01a1n h\u00e0ng: ${order.orderCode}?')">
                    <input type="hidden" name="action" value="cancel">
                    <input type="hidden" name="orderId" value="${order.orderId}">
                    <button type="submit" class="btn btn-danger btn-sm">Hủy đơn</button>
                </form>
            </c:if>
        </div>
    </td>
</tr></c:forEach>
<c:if test="${empty orders}"><tr><td colspan="8" class="empty-cell">Không tìm thấy đơn hàng hoặc hóa đơn nào</td></tr></c:if>
</tbody></table></div></div>

<c:if test="${not empty selectedOrder}">
    <div class="card detail-card" style="margin-top: 1.5rem;">
        <div class="card-header"><h3>Chi tiết đơn hàng: ${selectedOrder.orderCode}</h3></div>
        <div class="table-wrapper no-scroll">
            <table class="data-table compact-table">
                <thead>
                    <tr><th>Món</th><th>Số lượng</th><th>Đơn giá</th><th>Thành tiền</th></tr>
                </thead>
                <tbody>
                    <c:forEach var="d" items="${selectedOrder.orderDetails}">
                        <tr>
                            <td class="fw-bold">${d.productName}</td>
                            <td>${d.quantity}</td>
                            <td><fmt:formatNumber value="${d.unitPrice}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                            <td class="fw-bold text-coffee"><fmt:formatNumber value="${d.subtotal}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <div class="detail-total" style="padding: 1.2rem; text-align: right; font-size: 1.1rem; border-top: 1px solid var(--border);">
            Tạm tính: <span><fmt:formatNumber value="${selectedOrder.totalAmount + selectedOrder.discount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span><br>
            Giảm giá: <span style="color: var(--danger); font-weight: bold;">-<fmt:formatNumber value="${selectedOrder.discount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></span><br>
            Tổng cộng: <strong style="font-size: 1.3rem; color: var(--coffee-dark); margin-left: 0.5rem;"><fmt:formatNumber value="${selectedOrder.totalAmount}" type="currency" currencySymbol="₫" maxFractionDigits="0"/></strong>
        </div>
    </div>
</c:if>
</main><%@ include file="../components/footer.jsp" %></div><script src="${pageContext.request.contextPath}/assets/js/admin-script.js" charset="UTF-8"></script></body></html>
