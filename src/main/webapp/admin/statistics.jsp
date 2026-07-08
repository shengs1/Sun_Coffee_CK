<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN" />
<c:if test="${empty sessionScope.user || sessionScope.user.role != 'admin'}"><c:redirect url="/login.jsp"/></c:if>
<c:set var="activePage" value="statistics"/><c:set var="pageTitle" value="Thống kê doanh thu"/><c:set var="pageTitleIcon" value="📈"/><c:set var="pageDescription" value="Tổng hợp doanh thu và sản phẩm bán chạy"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Thống kê – Sun Coffee</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/4.4.0/chart.umd.min.js"></script>
</head>
<body>
<div class="app-wrapper">
<%@ include file="../components/header.jsp" %>
<%@ include file="../components/sidebar-admin.jsp" %>

<main class="main-content">


    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon">💰</div>
            <div class="stat-value">
                <fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
            </div>
            <div class="stat-label">Tổng doanh thu</div>
            <div class="stat-trend trend-up">↑ Tất cả thời gian</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">📋</div>
            <div class="stat-value">${totalOrders}</div>
            <div class="stat-label">Tổng số đơn hàng</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">📅</div>
            <div class="stat-value">
                <fmt:formatNumber value="${todayRevenue}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
            </div>
            <div class="stat-label">Doanh thu hôm nay</div>
            <div class="stat-trend trend-up">↑ ${todayOrders} đơn hàng</div>
        </div>
        <div class="stat-card">
            <div class="stat-icon">☕</div>
            <div class="stat-value">${topProduct.productName}</div>
            <div class="stat-label">Sản phẩm bán chạy nhất</div>
            <div class="stat-trend trend-up">${topProduct.totalSold} ly đã bán</div>
        </div>
    </div>

    <div class="chart-grid">
        <div class="chart-card">
            <h3>📊 Doanh thu 7 ngày gần nhất</h3>
            <canvas id="chart-revenue"
                    data-labels='${revenueLabels}'
                    data-values='${revenueValues}'
                    height="220"></canvas>
        </div>

        <div class="chart-card">
            <h3>🍩 Theo danh mục</h3>
            <canvas id="chart-category"
                    data-labels='${categoryLabels}'
                    data-values='${categoryValues}'
                    height="220"></canvas>
        </div>
    </div>

    <div class="chart-grid chart-grid-secondary">
        <div class="chart-card">
            <h3>🏆 Top 5 sản phẩm bán chạy</h3>
            <canvas id="chart-top-products"
                    data-labels='${topProductLabels}'
                    data-values='${topProductValues}'
                    height="220"></canvas>
        </div>

        <div class="card">
            <div class="card-header"><h3>🕐 Đơn hàng gần đây</h3></div>
            <div class="table-wrapper no-scroll">
                <table class="data-table compact-table">
                    <thead>
                        <tr><th>Mã đơn</th><th>Bàn</th><th>Tổng tiền</th><th>Trạng thái</th></tr>
                    </thead>
                    <tbody>
                    <c:forEach var="order" items="${recentOrders}">
                        <tr>
                            <td class="fw-bold">${order.orderCode}</td>
                            <td>Bàn ${order.tableId}</td>
                            <td class="fw-bold text-coffee">
                                <fmt:formatNumber value="${order.totalAmount}" type="currency"
                                                  currencySymbol="₫" maxFractionDigits="0"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${order.status == 'completed'}">
                                        <span class="badge badge-success">✅ Hoàn thành</span>
                                    </c:when>
                                    <c:when test="${order.status == 'pending'}">
                                        <span class="badge badge-warning">⏳ Đang xử lý</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge badge-danger">❌ Đã hủy</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty recentOrders}">
                        <tr><td colspan="4" style="text-align:center;padding:1.5rem;color:var(--muted)">
                            Chưa có đơn hàng nào
                        </td></tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</main>
<%@ include file="../components/footer.jsp" %>
</div>

<script>window.APP_CONTEXT = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/admin-script.js" charset="UTF-8"></script>
</body>
</html>
