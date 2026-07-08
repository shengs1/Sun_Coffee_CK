<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<fmt:setLocale value="vi_VN" />
<c:if test="${empty sessionScope.user || sessionScope.user.role != 'admin'}">
    <c:redirect url="/login.jsp"/>
</c:if>
<c:set var="activePage" value="menu"/><c:set var="pageTitle" value="Quản lý thực đơn"/><c:set var="pageTitleIcon" value="☕"/><c:set var="pageDescription" value="Thêm, chỉnh sửa, xóa các sản phẩm trong thực đơn"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width,initial-scale=1.0">
    <title>Quản lý thực đơn – Sun Coffee</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/admin-style.css">
</head>
<body>
<div class="app-wrapper">
<%@ include file="../components/header.jsp" %>
<%@ include file="../components/sidebar-admin.jsp" %>

<main class="main-content">
    <c:if test="${not empty error}">
        <div class="alert-error">
            ⚠️ ${error}
        </div>
    </c:if>
    <div class="page-header d-flex justify-end align-center flex-wrap gap-1">
        <button class="btn btn-primary" onclick="openModal('modal-add-product')">
            ➕ Thêm sản phẩm
        </button>
    </div>

    <div class="filter-bar">
        <div class="search-box">
            <span class="search-icon">🔍</span>
            <input class="search-input" placeholder="Tìm theo tên sản phẩm..."
                   oninput="searchTable(this.value,'product-table',2)">
        </div>
        <select class="btn btn-ghost btn-sm"
                onchange="filterTable(this.value,'product-table',2)">
            <option value="">📂 Tất cả danh mục</option>
            <c:forEach var="cat" items="${categories}">
                <option value="${cat.categoryName}">${cat.categoryName}</option>
            </c:forEach>
        </select>
        <select class="btn btn-ghost btn-sm"
                onchange="filterTable(this.value,'product-table',5)">
            <option value="">📦 Tất cả trạng thái</option>
            <option value="Còn hàng">Còn hàng</option>
            <option value="Hết hàng">Hết hàng</option>
        </select>
    </div>

    <div class="card">
        <div class="card-header">
            <h3>Danh sách sản phẩm (${fn:length(products)} món)</h3>
        </div>
        <div class="table-wrapper">
            <table class="data-table" id="product-table">
                <thead>
                    <tr>
                        <th>#</th><th>Ảnh</th><th>Tên sản phẩm</th>
                        <th>Danh mục</th><th>Giá bán</th><th>Trạng thái</th>
                        <th>Thao tác</th>
                    </tr>
                </thead>
                <tbody>
                <c:forEach var="p" items="${products}" varStatus="st">
                    <tr>
                        <td class="text-muted">${st.count}</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty p.image}">
                                    <c:set var="adminProductImageSrc" value="${pageContext.request.contextPath}/assets/images/${p.image}" />
                                    <c:if test="${fn:startsWith(p.image, 'http://') || fn:startsWith(p.image, 'https://')}">
                                        <c:set var="adminProductImageSrc" value="${p.image}" />
                                    </c:if>
                                    <img src="${adminProductImageSrc}" class="table-img"
                                         onerror="this.src='${pageContext.request.contextPath}/assets/images/products/default-product.jpg'" alt="${p.productName}">
                                </c:when>
                                <c:otherwise>
                                    <div style="width:42px;height:42px;background:var(--cream-2);border-radius:8px;
                                                display:flex;align-items:center;justify-content:center;font-size:1.2rem">☕</div>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="fw-bold">${p.productName}
                            <div style="font-size:.72rem;color:var(--muted)">${p.description}</div>
                        </td>
                        <td>${p.categoryName}</td>
                        <td class="fw-bold text-coffee">
                            <fmt:formatNumber value="${p.price}" type="currency" currencySymbol="₫" maxFractionDigits="0"/>
                        </td>
                        <td>
                            <c:choose>
                                <c:when test="${p.status == 'active'}">
                                    <span class="badge badge-success">✅ Còn hàng</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-danger">❌ Hết hàng</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <div class="d-flex gap-1">
                                <button class="btn btn-ghost btn-sm js-edit-product" title="Chỉnh sửa"
                                    data-id="${p.productId}"
                                    data-name="${fn:escapeXml(p.productName)}"
                                    data-price="${p.price}"
                                    data-category-id="${p.categoryId}"
                                    data-description="${fn:escapeXml(p.description)}"
                                    data-image="${fn:escapeXml(p.image)}"
                                    data-status="${fn:escapeXml(p.status)}">✏️ Sửa</button>
                                <form id="del-product-${p.productId}"
                                      action="${pageContext.request.contextPath}/products" method="post" style="display:none">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="productId" value="${p.productId}">
                                </form>
                                <button class="btn btn-danger btn-sm" title="Xóa sản phẩm"
                                    onclick="confirmDelete('del-product-${p.productId}','${p.productName}')">
                                    🗑️ Xóa
                                </button>
                            </div>
                        </td>
                    </tr>
                </c:forEach>
                <c:if test="${empty products}">
                    <tr><td colspan="7" style="text-align:center;padding:2rem;color:var(--muted)">
                        Chưa có sản phẩm nào. Nhấn "Thêm sản phẩm" để bắt đầu.
                    </td></tr>
                </c:if>
                </tbody>
            </table>
        </div>
    </div>
</main>
<%@ include file="../components/footer.jsp" %>
</div>

<div class="modal-overlay" id="modal-add-product"
     onclick="closeOnBackdrop(event,'modal-add-product')">
    <div class="modal-box">
        <div class="modal-header">
            <h3>➕ Thêm sản phẩm mới</h3>
            <button class="modal-close" onclick="closeModal('modal-add-product')">✕</button>
        </div>
        <div class="modal-body">
            <form id="form-add-product" action="${pageContext.request.contextPath}/products" method="post"
                  onsubmit="return validateProductForm('form-add-product')">
                <input type="hidden" name="action" value="add">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Tên sản phẩm <span class="required">*</span></label>
                        <input type="text" name="productName" class="form-control" placeholder="VD: Cà Phê Sữa Đá">
                        <div class="invalid-feedback"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giá bán (₫) <span class="required">*</span></label>
                        <input type="number" name="price" class="form-control" placeholder="35000" min="0">
                        <div class="invalid-feedback"></div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Danh mục <span class="required">*</span></label>
                    <select name="categoryId" class="form-control">
                        <option value="">-- Chọn danh mục --</option>
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}">${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                    <div class="invalid-feedback"></div>
                </div>
                <div class="form-group">
                    <label class="form-label">Mô tả</label>
                    <textarea name="description" class="form-control" rows="2"
                              placeholder="Mô tả ngắn về sản phẩm..."></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label">URL / Tên file ảnh</label>
                    <input type="text" name="image" class="form-control"
                           placeholder="VD: products/ca-phe-sua-da.jpg"
                           oninput="previewImage(this,'add-img-preview')">
                    <img id="add-img-preview" style="max-height:120px;margin-top:.5rem;
                         border-radius:8px;display:none;object-fit:cover">
                </div>
                <div class="form-group">
                    <label class="form-label">Trạng thái</label>
                    <select name="status" class="form-control">
                        <option value="active">✅ Còn hàng</option>
                        <option value="inactive">❌ Hết hàng</option>
                    </select>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-ghost"
                            onclick="closeModal('modal-add-product')">Hủy</button>
                    <button type="submit" class="btn btn-primary">💾 Lưu sản phẩm</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div class="modal-overlay" id="modal-edit-product"
     onclick="closeOnBackdrop(event,'modal-edit-product')">
    <div class="modal-box">
        <div class="modal-header">
            <h3>✏️ Chỉnh sửa sản phẩm</h3>
            <button class="modal-close" onclick="closeModal('modal-edit-product')">✕</button>
        </div>
        <div class="modal-body">
            <form id="form-edit-product" action="${pageContext.request.contextPath}/products" method="post"
                  onsubmit="return validateProductForm('form-edit-product')">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="productId">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Tên sản phẩm <span class="required">*</span></label>
                        <input type="text" name="productName" class="form-control">
                        <div class="invalid-feedback"></div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Giá bán (₫) <span class="required">*</span></label>
                        <input type="number" name="price" class="form-control" min="0">
                        <div class="invalid-feedback"></div>
                    </div>
                </div>
                <div class="form-group">
                    <label class="form-label">Danh mục <span class="required">*</span></label>
                    <select name="categoryId" class="form-control">
                        <c:forEach var="cat" items="${categories}">
                            <option value="${cat.categoryId}">${cat.categoryName}</option>
                        </c:forEach>
                    </select>
                    <div class="invalid-feedback"></div>
                </div>
                <div class="form-group">
                    <label class="form-label">Mô tả</label>
                    <textarea name="description" class="form-control" rows="2"></textarea>
                </div>
                <div class="form-group">
                    <label class="form-label">URL / Tên file ảnh</label>
                    <input type="text" name="image" class="form-control"
                           oninput="previewImage(this,'edit-img-preview')">
                    <img id="edit-img-preview" style="max-height:120px;margin-top:.5rem;
                         border-radius:8px;display:none;object-fit:cover">
                </div>
                <div class="form-group">
                    <label class="form-label">Trạng thái</label>
                    <select name="status" class="form-control">
                        <option value="active">✅ Còn hàng</option>
                        <option value="inactive">❌ Hết hàng</option>
                    </select>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-ghost"
                            onclick="closeModal('modal-edit-product')">Hủy</button>
                    <button type="submit" class="btn btn-primary">💾 Lưu thay đổi</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>window.APP_CONTEXT = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/assets/js/admin-script.js" charset="UTF-8"></script>
</body>
</html>
