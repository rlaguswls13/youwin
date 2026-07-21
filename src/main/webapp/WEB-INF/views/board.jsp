<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Youwin 음악 커뮤니티 게시판">
    <title>게시판 | Youwin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/board.css">
</head>
<body>
<div class="site-shell">
    <header class="site-header">
        <div class="site-container site-header__inner">
            <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈"><span class="brand__mark">YW</span><span>Youwin</span></a>
            <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
                <a href="${pageContext.request.contextPath}/">홈</a>
                <a class="is-active" href="${pageContext.request.contextPath}/board">게시판</a>
                <a href="${pageContext.request.contextPath}/chatroom">채팅방</a>
                <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
            </nav>
            <div class="site-header__actions"><a class="button button--secondary" href="${pageContext.request.contextPath}/member/login">로그인</a><a class="avatar-link" href="${pageContext.request.contextPath}/member/mypage" aria-label="마이페이지">YU</a></div>
            <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
        </div>
    </header>

    <main class="page-main">
        <div class="site-container board-layout">
            <aside class="surface board-sidebar" aria-label="게시판 메뉴">
                <p class="board-sidebar__title">Community</p>
                <div class="board-menu">
                    <button class="is-active" type="button" data-board-target="notice"><span>공지사항</span><span class="board-menu__count">NOTICE</span></button>
                    <button type="button" data-board-target="faq"><span>자주 묻는 질문</span><span class="board-menu__count">FAQ</span></button>
                    <button type="button" data-board-target="inquiry"><span>1:1 문의</span><span class="board-menu__count">Q&A</span></button>
                </div>
                <p class="board-sidebar__note">운영 관련 문의는 평일 10:00–18:00에 순차적으로 답변합니다.</p>
            </aside>

            <div class="board-content">
                <section class="board-view is-active" data-board-view="notice" aria-labelledby="notice-title">
                    <div class="board-heading">
                        <div class="page-heading"><p class="page-eyebrow">Community board</p><h1 class="page-title" id="notice-title">공지사항</h1><p class="page-description">Youwin의 새로운 소식과 서비스 안내를 확인하세요.</p></div>
                        <button class="button" type="button" data-open-editor>새 글 작성</button>
                    </div>
                    <div class="board-notice"><div><strong>PINNED</strong>커뮤니티 이용 가이드와 기본 에티켓을 확인해 주세요.</div><time datetime="2026-07-16">2026.07.16</time></div>
                    <div class="board-tools">
                        <div class="board-filters" aria-label="분류 필터">
                            <button class="board-filter is-active" type="button" data-board-filter="all">전체</button>
                            <button class="board-filter" type="button" data-board-filter="안내">안내</button>
                            <button class="board-filter" type="button" data-board-filter="업데이트">업데이트</button>
                            <button class="board-filter" type="button" data-board-filter="이벤트">이벤트</button>
                        </div>
                        <div class="board-search" role="search"><label class="sr-only" for="board-search">게시글 검색</label><input id="board-search" type="search" data-board-search placeholder="제목 또는 작성자 검색"><button type="button">검색</button></div>
                    </div>
                    <div class="surface board-table-wrap">
                        <table class="board-table">
                            <caption class="sr-only">공지사항 목록</caption>
                            <colgroup><col class="board-col-number"><col class="board-col-category"><col><col class="board-col-author"><col class="board-col-date"><col class="board-col-count"></colgroup>
                            <thead><tr><th>번호</th><th>분류</th><th>제목</th><th>작성자</th><th>작성일</th><th>조회</th></tr></thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty list}"><tr><td class="board-empty" colspan="6">등록된 공지사항이 없습니다.</td></tr></c:when>
                                <c:otherwise>
                                    <c:forEach var="notice" items="${list}">
                                        <tr data-board-row data-category="${notice.category}">
                                            <td class="board-table__number">${notice.noticeId}</td>
                                            <td><span class="chip">${notice.category}</span></td>
                                            <td class="board-table__title"><c:if test="${notice.isPinned == 1}"><span class="chip chip--live">고정</span>&nbsp;</c:if>${notice.title}</td>
                                            <td class="board-table__meta">${empty notice.memberId ? '운영팀' : notice.memberId}</td>
                                            <td class="board-table__meta">${notice.createAt}</td>
                                            <td class="board-table__meta">${notice.count}</td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>
                    <nav class="board-pagination" aria-label="페이지 이동"><a class="is-active" href="#">1</a><a href="#">2</a><a href="#">3</a><a href="#" aria-label="다음 페이지">→</a></nav>
                </section>

                <section class="board-view" data-board-view="write" aria-labelledby="write-title">
                    <div class="page-heading"><p class="page-eyebrow">Write a post</p><h1 class="page-title" id="write-title">새 공지 작성</h1><p class="page-description">회원에게 필요한 내용을 간결하고 정확하게 작성해 주세요.</p></div>
                    <form class="surface editor-card form-grid" action="${pageContext.request.contextPath}/board/write" method="post">
                        <div class="form-field"><label for="category">분류</label><select id="category" name="category" required><option value="안내">안내</option><option value="업데이트">업데이트</option><option value="이벤트">이벤트</option></select></div>
                        <div class="form-options"><label><input type="checkbox" name="isPinned" value="1"> 상단 고정</label><label><input type="checkbox" name="allowComments" value="1"> 댓글 허용</label></div>
                        <div class="form-field"><label for="post-title">제목</label><input id="post-title" type="text" name="title" maxlength="200" placeholder="제목을 입력해 주세요" required></div>
                        <div class="form-field"><label for="post-content">내용</label><textarea id="post-content" name="content" placeholder="내용을 입력해 주세요" required></textarea></div>
                        <div class="form-actions"><button class="button button--secondary" type="button" data-cancel-editor>취소</button><button class="button" type="submit">등록하기</button></div>
                    </form>
                </section>

                <section class="board-view" data-board-view="faq" aria-labelledby="faq-title">
                    <div class="page-heading"><p class="page-eyebrow">Help center</p><h1 class="page-title" id="faq-title">자주 묻는 질문</h1><p class="page-description">서비스 이용 중 자주 묻는 내용을 모았습니다.</p></div>
                    <div class="surface faq-list">
                        <article class="faq-item"><p class="faq-question"><span class="chip">계정</span>&nbsp; 비밀번호를 잊어버렸어요.</p><p class="faq-answer">로그인 화면의 비밀번호 찾기에서 가입 이메일로 재설정 링크를 받을 수 있습니다.</p></article>
                        <article class="faq-item"><p class="faq-question"><span class="chip">채팅</span>&nbsp; 채팅방 알림을 끌 수 있나요?</p><p class="faq-answer">채팅방 상단의 설정 메뉴에서 방별 알림을 조정할 수 있습니다.</p></article>
                        <article class="faq-item"><p class="faq-question"><span class="chip">음악</span>&nbsp; 플레이리스트는 어디에 저장되나요?</p><p class="faq-answer">마이페이지의 내 플레이리스트에서 저장한 곡을 확인할 수 있습니다.</p></article>
                    </div>
                </section>

                <section class="board-view" data-board-view="inquiry" aria-labelledby="inquiry-title">
                    <div class="page-heading"><p class="page-eyebrow">Contact us</p><h1 class="page-title" id="inquiry-title">1:1 문의</h1><p class="page-description">문의 내용과 답변 받을 이메일을 남겨 주세요.</p></div>
                    <form class="surface editor-card form-grid" action="#" method="post">
                        <div class="form-field"><label for="inquiry-category">문의 유형</label><select id="inquiry-category"><option>계정</option><option>서비스 이용</option><option>신고</option><option>기타</option></select></div>
                        <div class="form-field"><label for="inquiry-title-field">제목</label><input id="inquiry-title-field" type="text" placeholder="문의 제목을 입력해 주세요"></div>
                        <div class="form-field"><label for="inquiry-content">내용</label><textarea id="inquiry-content" placeholder="문의 내용을 입력해 주세요"></textarea></div>
                        <div class="form-actions"><button class="button" type="submit">문의 접수</button></div>
                    </form>
                </section>
            </div>
        </div>
    </main>
</div>
<script src="${pageContext.request.contextPath}/app.js"></script>
<script src="${pageContext.request.contextPath}/board.js"></script>
</body>
</html>
