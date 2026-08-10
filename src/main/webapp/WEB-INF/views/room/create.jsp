<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Youwin 새 채팅방 만들기">
    <title>채팅방 만들기 | Youwin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
</head>
<body>
<div class="site-shell">
    <header class="site-header">
        <div class="site-container site-header__inner">
            <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈"><span class="brand__mark">YW</span><span>Youwin</span></a>
            <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
                <a href="${pageContext.request.contextPath}/">홈</a>
                <a href="${pageContext.request.contextPath}/board">게시판</a>
                <a class="is-active" href="${pageContext.request.contextPath}/index">채팅방</a>
                <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
            </nav>
            <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
        </div>
    </header>
    <main class="page-main">
        <div class="site-container create-route">
            <section class="surface create-route__card" aria-labelledby="create-route-title">
                <div class="create-route__visual" aria-hidden="true"><span>＋</span></div>
                <div>
                    <p class="page-eyebrow">Start a conversation</p>
                    <h1 class="page-title" id="create-route-title">새로운 음악 대화를 열어보세요</h1>
                    <p class="page-description">채팅방 목록에서 아티스트 또는 노래를 선택해 새로운 대화방을 만들 수 있습니다.</p>
                    <div class="create-route__actions">
                        <a class="button" href="${pageContext.request.contextPath}/index">채팅방 둘러보고 만들기</a>
                        <a class="button button--secondary" href="${pageContext.request.contextPath}/">홈으로 돌아가기</a>
                    </div>
                </div>
            </section>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/app.js"></script>
</body>
</html>