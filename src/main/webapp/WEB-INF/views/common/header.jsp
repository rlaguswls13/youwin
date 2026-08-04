<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<header class="site-header">
    <div class="site-container site-header__inner">
        <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈">
            <span class="brand__mark">YW</span><span>Youwin</span>
        </a>
        <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
            <a href="${pageContext.request.contextPath}/">홈</a>
            <a href="${pageContext.request.contextPath}/board">게시판</a>
            <a href="${pageContext.request.contextPath}/index">채팅방</a>
            <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
        </nav>
        <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
    </div>
</header>