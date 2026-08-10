<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>${notice.title} | Youwin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/board.css">
</head>
<body>
<div class="site-shell">
  <header class="site-header">
    <div class="site-container site-header__inner">
        <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈">
            <span class="brand__mark">YW</span>
            <span>Youwin</span>
        </a>

        <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
            <a href="${pageContext.request.contextPath}/">홈</a>
            <a href="${pageContext.request.contextPath}/board">게시판</a>
            <a href="${pageContext.request.contextPath}/index">채팅방</a>

            <!-- 🟢 로그인 상태일 때만 마이페이지 노출 -->
            <sec:authorize access="isAuthenticated()">
                <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
            </sec:authorize>

            <div class="user-menu">
                <!-- 1. 로그인 상태인 경우 -->
                <sec:authorize access="isAuthenticated()">
                    <span class="welcome-msg">
                        <strong><sec:authentication property="principal.memberDto.nickname"/></strong>님 환영합니다!
                    </span>
                    <!-- 스프링 시큐리티 로그아웃 (CSRF 설정에 따라 POST 요청 권장) -->
                    <form action="${pageContext.request.contextPath}/member/logout" method="post" style="display:inline;">
                        <!-- Spring Security CSRF 토큰 (CSRF 사용 시 필요) -->
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                        <button type="submit" class="auth-btn logout-btn">로그아웃</button>
                    </form>
                </sec:authorize>

                <!-- 2. 비로그인(익명) 상태인 경우 -->
                <sec:authorize access="isAnonymous()">
                    <a href="${pageContext.request.contextPath}/member/login" class="auth-btn">로그인</a>
                    <a href="${pageContext.request.contextPath}/member/joinStep1" class="auth-btn">회원가입</a>
                </sec:authorize>
            </div>
        </nav>

        <div class="site-header__actions">
            <form class="header-search" data-home-search role="search">
                <label class="sr-only" for="global-search">통합 검색</label>
                <input id="global-search" name="query" type="search" placeholder="아티스트, 노래, 게시글 검색">
            </form>
            <a class="avatar-link" href="${pageContext.request.contextPath}/member/mypage" aria-label="마이페이지">YU</a>
        </div>

        <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
    </div>
</header>

  <main class="page-main">
    <div class="site-container board-layout">
      <!-- 사이드바 메뉴 -->
      <aside class="surface board-sidebar" aria-label="게시판 메뉴">
        <p class="board-sidebar__title">COMMUNITY</p>
        <div class="board-menu">
          <button class="is-active" type="button" onclick="location.href='${pageContext.request.contextPath}/board';">
            <span>공지사항</span><span class="board-menu__count">NOTICE</span>
          </button>
          <button type="button" onclick="location.href='${pageContext.request.contextPath}/board?tab=faq';">
            <span>자주 묻는 질문</span><span class="board-menu__count">FAQ</span>
          </button>
          <button type="button" onclick="location.href='${pageContext.request.contextPath}/board?tab=qna';">
            <span>1:1 문의</span><span class="board-menu__count">Q&A</span>
          </button>
        </div>
        <div style="margin-top: 24px; font-size: 12px; color: #868e96; line-height: 1.5;">
          운영 관련 문의는 평일 10:00~18:00에 순차적으로 답변해드립니다.
        </div>
      </aside>

      <!-- 상세 본문 영역 -->
      <div class="board-content" style="width: 100%;">
        <section class="board-view is-active">
          <div class="page-heading">
            <p class="page-eyebrow">COMMUNITY DETAIL</p>
            <span class="chip" style="margin-bottom: 8px; display: inline-block;">${notice.category}</span>
            <h1 class="page-title">${notice.title}</h1>
            <p class="page-description">작성자: ${empty notice.memberId ? '운영팀' : notice.memberId} | 작성일: ${notice.createAt} | 조회수: ${notice.count}</p>
          </div>

          <!-- 게시글 내용 카드 -->
          <div class="surface editor-card form-grid" style="padding: 24px; margin-top: 20px;">

            <!-- 1. 첨부 이미지 영역 -->
            <c:if test="${not empty imageList}">
              <div class="form-field" style="width: 100%; margin-bottom: 24px; text-align: center; border-bottom: 1px solid #f1f3f5; padding-bottom: 20px;">
                <div style="display: flex; gap: 12px; flex-wrap: wrap; justify-content: center;">
                  <c:forEach var="img" items="${imageList}">
                    <div style="position: relative; display: inline-block; border: 1px solid #e9ecef; border-radius: 8px; overflow: hidden; background: #f8f9fa; max-width: 100%;">
                      <a href="${pageContext.request.contextPath}/upload/${img.savedFileName}" target="_blank">
                        <img src="${pageContext.request.contextPath}/upload/${img.savedFileName}" alt="${img.originalName}" style="max-width: 100%; height: auto; max-height: 400px; object-fit: contain; display: block;">
                      </a>
                    </div>
                  </c:forEach>
                </div>
              </div>
            </c:if>

            <!-- 2. 본문 내용 영역 -->
            <div class="form-field">
              <div style="min-height: 150px; white-space: pre-wrap; line-height: 1.8; color: #212529; font-size: 15px;">${notice.content}</div>
            </div>

            <!-- 하단 버튼 영역 -->
            <div class="form-actions" style="display: flex; justify-content: space-between; align-items: center; margin-top: 30px; border-top: 1px solid #f1f3f5; padding-top: 20px;">
              <button class="button button--secondary" type="button" onclick="location.href='${pageContext.request.contextPath}/board';">목록으로</button>
              <div style="display: flex; gap: 8px;">
                <button class="button button--secondary" type="button" onclick="location.href='${pageContext.request.contextPath}/board/modify?noticeId=${notice.noticeId}';">수정하기</button>
                <form action="${pageContext.request.contextPath}/board/delete" method="POST" class="delete-form" style="margin: 0;" onsubmit="return confirm('정말 삭제하시겠습니까?');">
                  <input type="hidden" name="noticeId" value="${notice.noticeId}">
                  <button class="button" type="submit" style="background-color: #ff4d4f; border-color: #ff4d4f; color: #fff;">삭제하기</button>
                </form>
              </div>
            </div>
          </div>

        </section>
      </div>
    </div>
  </main>
</div>

<script>window.contextPath = '${pageContext.request.contextPath}';</script>
<script src="${pageContext.request.contextPath}/app.js"></script>
<script src="${pageContext.request.contextPath}/board.js"></script>
</body>
</html>