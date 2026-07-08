<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<header class="admin-header">
    <div>
        <h1>${not empty pageTitleIcon ? pageTitleIcon : ''} ${not empty pageTitle ? pageTitle : 'Sun Coffee'}</h1>
        <p>${not empty pageDescription ? pageDescription : 'Sun Coffee Management System'}</p>
    </div>
    <div class="admin-user">
        <span>👤 ${sessionScope.user.fullName}</span>
        <form action="${pageContext.request.contextPath}/logout" method="post">
            <button type="submit" class="btn btn-ghost btn-sm">🚪 Đăng xuất</button>
        </form>
    </div>
</header>
