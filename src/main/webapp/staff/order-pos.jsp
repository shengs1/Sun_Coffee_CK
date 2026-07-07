<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn"  uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN" />
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login.jsp"/>
</c:if>
<c:set var="activePage" value="pos"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Gọi món POS – Sun Coffee</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-style.css">
</head>
<body>

<div class="app-wrapper" style="grid-template-rows: 1fr;">
    <%@ include file="../components/sidebar-admin.jsp" %>
    <div style="grid-column: 2; grid-row: 1/4; display: flex; flex-direction: column; height: 100vh; overflow: hidden;">

        <header class="staff-header">
            <div class="staff-header-brand">
                ☕ <span>Sun Coffee</span>
                <span style="font-size:.7rem;opacity:.6;margin-left:.25rem">| Gọi món POS</span>
            </div>
            <div class="staff-header-user">
                <span>👤 ${sessionScope.user.fullName}</span>
                <form action="${pageContext.request.contextPath}/logout" method="post" style="display:inline">
                    <button type="submit" style="
                        background:rgba(255,255,255,.15); border:1px solid rgba(255,255,255,.3);
                        color:#fff; padding:.3rem .7rem; border-radius:6px;
                        font-size:.74rem; cursor:pointer; font-family:var(--font-body);
                    ">🚪 Đăng xuất</button>
                </form>
            </div>
        </header>

        <div class="pos-layout">
            <div class="menu-panel">
                <div class="menu-search-bar">
                    <input type="text"
                           class="menu-search-input"
                           placeholder="Tìm tên món..."
                           oninput="searchMenu(this.value)">

                    <button class="category-btn active"
                            onclick="filterByCategory('all', this)">
                        Tất cả
                    </button>

                    <c:forEach var="cat" items="${categories}">
                        <button class="category-btn"
                                onclick="filterByCategory('${cat.categoryId}', this)">
                            ${cat.categoryName}
                        </button>
                    </c:forEach>
                </div>

                <div class="menu-grid" id="menu-grid">
                    <c:forEach var="product" items="${products}">
                        <div class="menu-item-wrapper"
                             data-name="${fn:escapeXml(product.productName)}"
                             data-category="${product.categoryId}">

                            <div class="menu-item-card ${product.status == 'inactive' ? 'out-of-stock' : ''}" 
                                 data-product-id="${product.productId}" 
                                 data-product-name="${fn:escapeXml(product.productName)}" 
                                 data-product-price="${product.price}" 
                                 onclick="if(!this.classList.contains('out-of-stock')) addToCart('${product.productId}', '${fn:escapeXml(product.productName)}', '${product.price}')"
                                 title="${fn:escapeXml(product.productName)}">

                                <c:choose>
                                    <c:when test="${not empty product.image}">
                                        <c:set var="productImageSrc" value="${pageContext.request.contextPath}/assets/images/${product.image}" />
                                        <c:if test="${fn:startsWith(product.image, 'http://') || fn:startsWith(product.image, 'https://')}">
                                            <c:set var="productImageSrc" value="${product.image}" />
                                        </c:if>
                                        <img src="${productImageSrc}"
                                             alt="${fn:escapeXml(product.productName)}"
                                             class="menu-item-img"
                                             onerror="this.src='${pageContext.request.contextPath}/assets/images/products/default-product.jpg'">
                                    </c:when>
                                    <c:otherwise>
                                        <img src="${pageContext.request.contextPath}/assets/images/products/default-product.jpg" class="menu-item-img" alt="${fn:escapeXml(product.productName)}">
                                    </c:otherwise>
                                </c:choose>

                                <div class="menu-item-body">
                                    <div class="menu-item-name">${product.productName}</div>
                                    <div class="menu-item-price">
                                        <fmt:formatNumber value="${product.price}" type="currency"
                                                          currencySymbol="₫" maxFractionDigits="0"/>
                                    </div>
                                </div>

                            </div>

                            <c:if test="${product.status == 'inactive'}">
                                <div class="out-of-stock-badge">Hết hàng</div>
                            </c:if>

                        </div>
                    </c:forEach>

                    <c:if test="${empty products}">
                        <div style="grid-column:1/-1; text-align:center; padding:3rem; color:var(--muted)">
                            <div style="font-size:3rem;margin-bottom:.75rem">☕</div>
                            <p>Chưa có sản phẩm nào.<br>Vui lòng thêm sản phẩm vào thực đơn.</p>
                        </div>
                    </c:if>

                </div>
            </div>

            <div class="order-panel">
                <div class="order-panel-header">
                    <h3>🛒 Đơn hàng
                        <span id="cart-item-count"
                              style="background:var(--gold);color:var(--coffee-dark);
                                     width:20px;height:20px;border-radius:50%;
                                     display:inline-flex;align-items:center;justify-content:center;
                                     font-size:.7rem;font-weight:800;margin-left:.35rem">0</span>
                    </h3>
                    <button onclick="clearCart()" style="
                        background:none; border:1px solid var(--border);
                        border-radius:6px; padding:.3rem .65rem;
                        font-size:.75rem; color:var(--muted); cursor:pointer;
                    " title="Xóa toàn bộ đơn">🗑️ Xóa đơn</button>
                </div>

                <div class="table-selector">
                    <label>🪑 Bàn số:</label>
                    <select id="table-select" class="table-select">
                        <c:forEach begin="1" end="15" var="i">
                            <option value="${i}">Bàn ${i}</option>
                        </c:forEach>
                    </select>
                </div>

                <div class="cart-items" id="cart-items"></div>

                <div class="cart-empty" id="cart-empty">
                    <div class="empty-icon">🛒</div>
                    <p>Chưa có món nào<br><small>Nhấn vào món bên trái để thêm</small></p>
                </div>

                <div class="order-panel-footer">
                    <div class="total-row">
                        <span>Tạm tính:</span>
                        <span id="subtotal">0 ₫</span>
                    </div>

                    <div class="discount-row">
                        <label>Giảm giá:</label>
                        <input type="text"
                               id="discount-amount"
                               class="discount-input"
                               placeholder="0"
                               style="width: 120px;"
                               onkeydown="if(event.key==='Enter'){ applyDiscount(); event.preventDefault(); }"
                               onblur="applyDiscount()">
                        <span style="font-size:.78rem;color:var(--muted)">₫</span>
                    </div>

                    <div style="margin-bottom:.5rem">
                        <input type="text"
                               id="order-note"
                               style="width:100%;padding:.38rem .65rem;
                                      border:2px solid var(--border);border-radius:8px;
                                      font-size:.8rem;font-family:var(--font-body)"
                               placeholder="💬 Ghi chú (ít đường, không đá,...)">
                    </div>

                    <div class="total-row" id="discount-display-row" style="display: none; color: var(--danger); font-weight: 700;">
                        <span>Giảm giá:</span>
                        <span id="discount-val">-0 ₫</span>
                    </div>

                    <hr class="total-divider">

                    <div class="grand-total">
                        <span>Tổng cộng:</span>
                        <span class="amount" id="grand-total">0 ₫</span>
                    </div>

                    <button class="pay-btn" id="pay-btn"
                            onclick="submitOrder()" disabled>
                        💳 Thanh toán
                    </button>

                    <button class="clear-btn" onclick="clearCart()">
                        Xóa toàn bộ đơn hàng
                    </button>
                </div>
            </div>
        </div>

    </div>
</div>

<script>
    window.APP_CONTEXT = '${pageContext.request.contextPath}';
    window.POS_SUCCESS_MESSAGE = '${fn:escapeXml(sessionScope.successMessage)}';
    window.POS_ERROR_MESSAGE = '${fn:escapeXml(sessionScope.errorMessage)}';
</script>
<c:remove var="successMessage" scope="session"/>
<c:remove var="errorMessage" scope="session"/>
<script src="${pageContext.request.contextPath}/assets/js/staff-script.js" charset="UTF-8"></script>
</body>
</html>
