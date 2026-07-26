<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Youwin 아이디 찾기">
    <title>Youwin | 아이디 찾기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/home.css">
</head>
<body>
<div class="site-shell">
    <!-- 헤더 영역 -->
    <header class="site-header">
        <div class="site-container site-header__inner">
            <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈">
                <span class="brand__mark">YW</span>
                <span>Youwin</span>
            </a>
            <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
                <a href="${pageContext.request.contextPath}/">홈</a>
                <a href="${pageContext.request.contextPath}/board">게시판</a>
                <a href="${pageContext.request.contextPath}/chatroom">채팅방</a>
                <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
                <div class="user-menu">
                    <c:if test="${not empty sessionScope.loginUser}">
                        <span><strong>${sessionScope.loginUser.memberId}</strong>님 환영합니다!</span>
                        <a href="${pageContext.request.contextPath}/member/logout">로그아웃</a>
                    </c:if>
                    <c:if test="${empty sessionScope.loginUser}">
                        <a href="${pageContext.request.contextPath}/member/login">로그인</a>
                        <a href="${pageContext.request.contextPath}/member/joinStep1">회원가입</a>
                    </c:if>
                </div>
            </nav>
            <div class="site-header__actions">
                <a class="avatar-link" href="${pageContext.request.contextPath}/member/mypage" aria-label="마이페이지">YU</a>
            </div>
        </div>
    </header>

    <!-- 메인 콘텐츠 영역 -->
    <main class="page-main">
        <div class="site-container" style="max-width: 480px; padding-top: 60px; padding-bottom: 80px;">
            <div class="surface" style="padding: 32px; border-radius: 16px;">
                <div class="section-head" style="margin-bottom: 24px;">
                    <div>
                        <h1 class="section-title" style="font-size: 24px;">아이디 찾기</h1>
                        <p class="section-copy">가입 시 등록하신 정보로 아이디를 조회합니다.</p>
                    </div>
                </div>

                <!-- 에러 메시지 또는 결과 메시지가 있을 경우 표시 -->
                <c:if test="${not empty errorMessage}">
                    <div style="background-color: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px;">
                            ${errorMessage}
                    </div>
                </c:if>

                <c:if test="${not empty foundMemberId}">
                    <div style="background-color: rgba(34, 197, 94, 0.1); color: #22c55e; padding: 16px; border-radius: 8px; margin-bottom: 20px; text-align: center;">
                        <p style="margin: 0; font-size: 14px;">회원님의 아이디는 다음과 같습니다.</p>
                        <p style="margin: 8px 0 0 0; font-size: 18px; font-weight: bold; color: #ffffff;">${foundMemberId}</p>
                    </div>
                </c:if>

                <!-- 아이디 찾기 폼 -->
                <form action="${pageContext.request.contextPath}/member/findId" method="post" style="display: flex; flex-direction: column; gap: 16px;">
                    <div>
                        <label for="memberName" style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #ffffff;">이름</label>
                        <input type="text" id="memberName" name="memberName" placeholder="이름을 입력하세요" required
                               style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.2); background: #1a1a1a; color: #ffffff; font-size: 15px; box-sizing: border-box; outline: none;">
                    </div>

                    <div>
                        <label for="memberEmail" style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #ffffff;">이메일</label>
                        <input type="email" id="memberEmail" name="memberEmail" placeholder="example@youwin.com" required
                               style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.2); background: #1a1a1a; color: #ffffff; font-size: 15px; box-sizing: border-box; outline: none;">
                    </div>

                    <button type="submit" class="button" style="width: 100%; margin-top: 8px;">아이디 찾기</button>
                </form>

                <div style="margin-top: 24px; padding-top: 16px; border-top: 1px solid rgba(255, 255, 255, 0.1); display: flex; justify-content: space-between; font-size: 14px;">
                    <a class="text-link" href="${pageContext.request.contextPath}/member/findPassword">비밀번호 찾기</a>
                    <a class="text-link" href="${pageContext.request.contextPath}/member/login">로그인으로 돌아가기</a>
                </div>
            </div>
        </div>
    </main>

    <!-- 푸터 영역 -->
    <footer class="site-footer">
        <div class="site-container site-footer__inner">
            <span>© 2026 Youwin. 음악으로 연결되는 커뮤니티.</span>
            <div class="site-footer__links">
                <a href="${pageContext.request.contextPath}/board">공지사항</a>
                <a href="#">이용약관</a>
                <a href="#">개인정보처리방침</a>
            </div>
        </div>
    </footer>
</div>
<script src="${pageContext.request.contextPath}/app.js"></script>
</body>
</html>