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
    <!-- 공통 헤더 -->
    <header class="site-header">
        <div class="site-container site-header__inner">
            <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈"><span class="brand__mark">YW</span><span>Youwin</span></a>
            <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
                <a href="${pageContext.request.contextPath}/">홈</a>
                <a class="is-active" href="${pageContext.request.contextPath}/board">게시판</a>
                <a href="${pageContext.request.contextPath}/index">채팅방</a>
                <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
            </nav>
            <div class="site-header__actions"><a class="button button--secondary" href="${pageContext.request.contextPath}/member/login">로그인</a><a class="avatar-link" href="${pageContext.request.contextPath}/member/mypage" aria-label="마이페이지">YU</a></div>
            <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
        </div>
    </header>

    <main class="page-main">
        <div class="site-container board-layout">

            <!-- ==================================================================== -->
            <!-- 0. 레이아웃 (Layout) : 좌측 사이드바 메뉴 (공지사항, FAQ, 1:1문의 탭 전환) -->
            <!-- ==================================================================== -->
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

                <!-- ==================================================================== -->
                <!-- 1. 등록 및 4. 수정 공용 에디터 폼 영역 (Write / Update Form) -->
                <!-- ==================================================================== -->
                <section class="board-view" data-board-view="write" aria-labelledby="write-title">
                    <div class="page-heading"><p class="page-eyebrow">Write a post</p><h1 class="page-title" id="write-title">새 공지 작성</h1><p class="page-description">회원에게 필요한 내용을 간결하고 정확하게 작성해 주세요.</p></div>

                    <form id="editor-form" class="surface editor-card form-grid" action="${pageContext.request.contextPath}/board/write" method="post" enctype="multipart/form-data">
                        <!-- [4. 수정 전용] 기존 글 ID 식별용 히든 필드 -->
                        <input type="hidden" id="post-noticeId" name="noticeId" value="">

                        <div class="form-field"><label for="category">분류</label><select id="category" name="category" required><option value="안내">안내</option><option value="업데이트">업데이트</option><option value="이벤트">이벤트</option></select></div>
                        <div class="form-options"><label><input type="checkbox" id="post-isPinned" name="isPinned" value="1"> 상단 고정</label><label><input type="checkbox" id="post-allowComments" name="allowComments" value="1"> 댓글 허용</label></div>
                        <div class="form-field"><label for="post-title">제목</label><input id="post-title" type="text" name="title" maxlength="200" placeholder="제목을 입력해 주세요" required></div>
                        <div class="form-field"><label for="post-content">내용</label><textarea id="post-content" name="content" placeholder="내용을 입력해 주세요" required></textarea></div>

                        <!-- 선택된 파일들의 썸네일 미리보기가 가로선 윗부분에 띄워지도록 빈 박스 추가 -->
                        <div id="previewContainer" class="image-preview-list" aria-live="polite"></div>

                        <!-- 가로선 하단 이미지 업로드 및 액션 버튼 병렬 배치 라인 -->
                        <div class="form-actions form-actions--upload">

                            <!-- [좌측] 이미지 컴포넌트 -->
                            <div class="image-upload-trigger-wrap">
                                <input type="file" id="imageInput" name="files" multiple accept="image/*" style="display: none;">
                                <div id="btnUploadTrigger" class="image-upload-trigger" role="button" tabindex="0">
                                    <span class="image-upload-trigger__label">＋ 이미지 업로드</span>
                                    <span class="image-upload-trigger__count"><span id="imageCount">0</span>/5</span>
                                </div>
                                <span class="image-upload-help">장당 최대 5MB · 최대 5장</span>
                            </div>

                            <!-- [우측] 기존 액션 버튼 컴포넌트 -->
                            <!-- [해결] form 내부 button의 새로고침/튕김 버그 차단을 위해 onclick 기본이벤트 완벽 물리 격리 적용 -->
                            <div class="form-action-buttons">
                                <button class="button button--secondary" type="button" data-cancel-editor onclick="event.preventDefault(); event.stopPropagation();">취소</button>
                                <button id="submit-btn" class="button" type="submit">등록하기</button>
                            </div>
                        </div>
                    </form>
                </section>

                <!-- ==================================================================== -->
                <!-- 2. 목록 및 페이지네이션 (Read List & Pagination) -->
                <!-- ==================================================================== -->
                <section class="board-view is-active" data-board-view="notice" aria-labelledby="notice-title">

                    <!-- [1. 등록 진입 버튼] -->
                    <div class="board-heading">
                        <div class="page-heading"><p class="page-eyebrow">Community board</p><h1 class="page-title" id="notice-title">공지사항</h1><p class="page-description">Youwin의 새로운 소식과 중요한 안내를 확인하세요.</p></div>
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
                        <div class="board-search" role="search"><label class="sr-only" for="board-search">게시글 검색</label><input id="board-search" type="search" data-board-search placeholder="제목 또는 작성자 검색"><button type="button" style="white-space: nowrap; min-width: max-content;">검색</button></div>
                    </div>

                    <!-- 2-1. 데이터 테이블 목록 출력 -->
                    <div class="surface board-table-wrap">
                        <table class="board-table">
                            <caption class="sr-only">공지사항 목록</caption>
                            <colgroup>
                                <col class="board-col-number"><col class="board-col-category"><col><col class="board-col-author"><col class="board-col-date"><col class="board-col-count"><col style="width: 14%;">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th><th>분류</th><th>제목</th><th>작성자</th>
                                <th style="text-align: center;">작성일</th><th style="text-align: center;">조회</th><th style="text-align: center;">관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:choose>
                                <c:when test="${empty list}">
                                    <tr><td class="board-empty" colspan="7">등록된 공지사항이 없습니다.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="notice" items="${list}">
                                        <tr data-board-row
                                            data-category="${notice.category}"
                                            data-id="${notice.noticeId}"
                                            data-title="<c:out value='${notice.title}'/>"
                                            data-content="<c:out value='${notice.content}'/>"
                                            data-pinned="${notice.isPinned}"
                                            style="cursor: pointer;">
                                            <td class="board-table__number">${notice.noticeId}</td>
                                            <td><span class="chip">${notice.category}</span></td>
                                            <td class="board-table__title">
                                                <c:if test="${notice.isPinned == 1}"><span class="chip chip--live">고정</span>&nbsp;</c:if>${notice.title}
                                            </td>
                                            <td class="board-table__meta">${empty notice.memberId ? '운영팀' : notice.memberId}</td>
                                            <td class="board-table__meta" style="text-align: center;">${notice.createAt}</td>
                                            <td class="board-table__meta" style="text-align: center;">${notice.count}</td>
