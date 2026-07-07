<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty sessionScope.user}">
    <c:choose>
        <c:when test="${sessionScope.user.role == 'admin'}">
            <c:redirect url="/dashboard"/>
        </c:when>
        <c:otherwise>
            <c:redirect url="/order"/>
        </c:otherwise>
    </c:choose>
</c:if>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng nhập – Sun Coffee</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@400;700&family=Nunito:wght@400;600;700;800&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/staff-style.css">
</head>
<body class="login-page">

<div class="login-card">
    <div class="login-card-header">
        <div class="login-logo">☕</div>
        <div class="login-brand">Sun Coffee</div>
        <div class="login-subtitle">Hệ thống quản lý cửa hàng</div>
    </div>

    <div class="login-card-body">
        <c:if test="${not empty error}">
            <div class="login-error">
                ❌ ${error}
            </div>
        </c:if>

        <c:if test="${not empty message}">
            <div style="
                background:rgba(25,135,84,.1); color:#146c43;
                border:1px solid rgba(25,135,84,.25);
                border-radius:8px; padding:.7rem .9rem;
                font-size:.82rem; margin-bottom:1rem;
                display:flex; align-items:center; gap:.5rem;
            ">
                ✅ ${message}
            </div>
        </c:if>

        <form class="login-form" action="${pageContext.request.contextPath}/login" method="post"
              onsubmit="return validateLoginForm()">

            <div class="form-group">
                <label class="form-label" for="username">
                    Tên đăng nhập <span style="color:#dc3545">*</span>
                </label>
                <input type="text"
                       id="username"
                       name="username"
                       class="form-control"
                       placeholder="Nhập tên đăng nhập"
                       value="${param.username}"
                       autocomplete="username"
                       required>
                <span class="invalid-feedback" id="err-username"></span>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">
                    Mật khẩu <span style="color:#dc3545">*</span>
                </label>
                <div class="password-wrapper">
                    <input type="password"
                           id="password"
                           name="password"
                           class="form-control"
                           placeholder="Nhập mật khẩu"
                           autocomplete="current-password"
                           required>
                    <button type="button" class="btn-toggle-pass"
                            onclick="togglePassword()"
                            title="Hiện/Ẩn mật khẩu">👁️</button>
                </div>
                <span class="invalid-feedback" id="err-password"></span>
            </div>

            <button type="submit" class="login-btn">
                🔑 Đăng nhập
            </button>

        </form>

        <div style="
            margin-top:1.25rem; padding:.75rem;
            background:#fff8ee; border-radius:8px;
            border:1px solid #e8d5c4;
            font-size:.75rem; color:#7A5C45;
        ">
            <strong>💡 Tài khoản demo:</strong><br>
            Admin: <code>admin</code> / <code>admin123</code><br>
            Nhân viên: <code>staff</code> / <code>staff123</code>
        </div>
    </div>
</div>

<script>
    function validateLoginForm() {
        let valid = true;

        const username = document.getElementById('username');
        const password = document.getElementById('password');
        const errU = document.getElementById('err-username');
        const errP = document.getElementById('err-password');

        username.classList.remove('is-invalid');
        password.classList.remove('is-invalid');
        errU.textContent = '';
        errP.textContent = '';

        if (!username.value.trim()) {
            username.classList.add('is-invalid');
            errU.textContent = 'Vui lòng nhập tên đăng nhập';
            username.style.display = 'block';
            errU.style.display = 'block';
            valid = false;
        }

        if (!password.value) {
            password.classList.add('is-invalid');
            errP.textContent = 'Vui lòng nhập mật khẩu';
            errP.style.display = 'block';
            valid = false;
        }

        return valid;
    }

    function togglePassword() {
        const input = document.getElementById('password');
        const btn   = document.querySelector('.btn-toggle-pass');
        if (input.type === 'password') {
            input.type = 'text';
            btn.textContent = '🙈';
        } else {
            input.type = 'password';
            btn.textContent = '👁️';
        }
    }
</script>
</body>
</html>
