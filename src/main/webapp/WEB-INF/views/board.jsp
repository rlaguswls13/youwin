<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Youwin 음악 커뮤니티 게시판">
    <title>게시판 | Youwin</title>
    <!-- [기본/게시판 전용 CSS 스타일시트 로드] -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/board.css">
</head>
<body>
<div class="site-shell">
    <!-- 1. 상단 공통 헤더 영역 (로고, 메인 메뉴, 로그인/마이페이지 버튼) -->
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
            <!-- 2. 좌측 사이드바 메뉴 (공지사항, FAQ, 1:1문의 탭 전환 제어) -->
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
                <!-- 3. [공지사항 메인 뷰 영역] -->
                <section class="board-view is-active" data-board-view="notice" aria-labelledby="notice-title">
                    <!-- 3-1. 공지사항 타이틀 및 '새 글 작성' 버튼 -->
                    <div class="board-heading">
                        <div class="page-heading"><p class="page-eyebrow">Community board</p><h1 class="page-title" id="notice-title">공지사항</h1><p class="page-description">Youwin의 새로운 소식과 service 안내를 확인하세요.</p></div>
                        <button class="button" type="button" data-open-editor>새 글 작성</button>
                    </div>

                    <!-- 3-2. 상단 상시 고정 대표 공지 바 -->
                    <div class="board-notice"><div><strong>PINNED</strong>커뮤니티 이용 가이드와 기본 에티켓을 확인해 주세요.</div><time datetime="2026-07-16">2026.07.16</time></div>

                    <!-- 3-3. 카테고리 필터 버튼 및 검색창 영역 -->
                    <div class="board-tools">
                        <div class="board-filters" aria-label="분류 필터">
                            <button class="board-filter is-active" type="button" data-board-filter="all">전체</button>
                            <button class="board-filter" type="button" data-board-filter="안내">안내</button>
                            <button class="board-filter" type="button" data-board-filter="업데이트">업데이트</button>
                            <button class="board-filter" type="button" data-board-filter="이벤트">이벤트</button>
                        </div>
                        <div class="board-search" role="search"><label class="sr-only" for="board-search">게시글 검색</label><input id="board-search" type="search" data-board-search placeholder="제목 또는 작성자 검색"><button type="button" style="white-space: nowrap; min-width: max-content;">검색</button></div>
                    </div>

                    <!-- 3-4. 공지사항 데이터 테이블 출력 영역 -->
                    <div class="surface board-table-wrap">
                        <table class="board-table">
                            <caption class="sr-only">공지사항 목록</caption>
                            <colgroup>
                                <col class="board-col-number">
                                <col class="board-col-category">
                                <col>
                                <col class="board-col-author">
                                <col class="board-col-date">
                                <col class="board-col-count">
                                <col style="width: 14%;">
                            </colgroup>
                            <thead>
                            <tr>
                                <th>번호</th>
                                <th>분류</th>
                                <th>제목</th>
                                <th>작성자</th>
                                <!-- [수정] 헤더 타이틀 텍스트 정렬 명시 (가운데 정렬) -->
                                <th style="text-align: center;">작성일</th>
                                <th style="text-align: center;">조회</th>
                                <th style="text-align: center;">관리</th>
                            </tr>
                            </thead>
                            <tbody>
                            <!-- 컨트롤러에서 넘겨받은 list 가 비어있는지 확인 -->
                            <c:choose>
                                <c:when test="${empty list}">
                                    <tr><td class="board-empty" colspan="7">등록된 공지사항이 없습니다.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <!-- 게시글 목록 반복 출력 (자바스크립트 및 더블클릭 연동용 data-* 속성 포함) -->
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
                                            <!-- [수정] 작성일 데이터와 조회수 데이터를 상단 헤더에 맞춰 가운데 정렬 처리 -->
                                            <td class="board-table__meta" style="text-align: center;">${notice.createAt}</td>
                                            <td class="board-table__meta" style="text-align: center;">${notice.count}</td>
                                            <!-- [수정] 관리 열 내부의 단추들이 상단 헤더 '관리' 중앙에 깔끔하게 오도록 정렬 확정 -->
                                            <td onclick="event.stopPropagation();" style="text-align: center;">
                                                <div style="display: flex; gap: 4px; justify-content: center; align-items: center;">
                                                    <!-- 수정 버튼 (클릭 시 작성 폼에 데이터가 채워지는 JS 연동) -->
                                                    <button type="button" class="board-filter btn-edit" style="min-height:28px; padding:0 10px; margin:0; border-color:#2f54eb; color:#2f54eb; background:none; font-size:11px; cursor:pointer;">수정</button>

                                                    <!-- 삭제 폼 및 버튼 (서버단 /board/delete 로 게시글 ID 전송) -->
                                                    <form action="${pageContext.request.contextPath}/board/delete" method="post" class="delete-form" style="margin:0;">
                                                        <input type="hidden" name="noticeId" value="${notice.noticeId}">
                                                        <button type="submit" class="board-filter" style="min-height:28px; padding:0 10px; margin:0; border-color:#ff4d4f; color:#ff4d4f; background:none; font-size:11px; cursor:pointer;">삭제</button>
                                                    </form>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                            </tbody>
                        </table>
                    </div>

                    <!-- 3-5. [동적 페이지네이션 바 영역] (서버 pageMaker 객체 기반 10개 단위 블록 연동) -->
                    <nav class="board-pagination" aria-label="페이지 이동">
                        <!-- 이전 페이지 블록 이동 화살표 (이전 10개 블록 존재 시 노출) -->
                        <c:if test="${pageMaker.prev}">
                            <a href="${pageContext.request.contextPath}/board?page=${pageMaker.startPage - 1}" aria-label="이전 페이지">←</a>
                        </c:if>

                        <!-- 계산된 시작 페이지(startPage)부터 끝 페이지(endPage)까지 숫자 단추 반복 생성 -->
                        <c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
                            <a class="${pageMaker.cri.page == num ? 'is-active' : ''}" href="${pageContext.request.contextPath}/board?page=${num}">${num}</a>
                        </c:forEach>

                        <!-- 다음 페이지 블록 이동 화살표 (다음 10개 블록 존재 시 노출) -->
                        <c:if test="${pageMaker.next}">
                            <a href="${pageContext.request.contextPath}/board?page=${pageMaker.endPage + 1}" aria-label="다음 페이지">→</a>
                        </c:if>
                    </nav>
                </section>

                <!-- 4. [글 작성 및 수정 에디터 폼 영역] (기본 숨김, 새 글 작성/수정 시 동적 노출) -->
                <section class="board-view" data-board-view="write" aria-labelledby="write-title">
                    <div class="page-heading"><p class="page-eyebrow">Write a post</p><h1 class="page-title" id="write-title">새 공지 작성</h1><p class="page-description">회원에게 필요한 내용을 간결하고 정확하게 작성해 주세요.</p></div>
                    <form id="editor-form" class="surface editor-card form-grid" action="${pageContext.request.contextPath}/board/write" method="post">
                        <!-- 수정 모드 시 게시글 ID를 저장하여 서버로 전송하는 숨김 필드 -->
                        <input type="hidden" id="post-noticeId" name="noticeId" value="">

                        <div class="form-field"><label for="category">분류</label><select id="category" name="category" required><option value="안내">안내</option><option value="업데이트">업데이트</option><option value="이벤트">이벤트</option></select></div>
                        <div class="form-options"><label><input type="checkbox" id="post-isPinned" name="isPinned" value="1"> 상단 고정</label><label><input type="checkbox" id="post-allowComments" name="allowComments" value="1"> 댓글 허용</label></div>
                        <div class="form-field"><label for="post-title">제목</label><input id="post-title" type="text" name="title" maxlength="200" placeholder="제목을 입력해 주세요" required></div>
                        <div class="form-field"><label for="post-content">내용</label><textarea id="post-content" name="content" placeholder="내용을 입력해 주세요" required></textarea></div>
                        <div class="form-actions"><button class="button button--secondary" type="button" data-cancel-editor>취소</button><button id="submit-btn" class="button" type="submit">등록하기</button></div>
                    </form>
                </section>

                <!-- 5. [FAQ (자주 묻는 질문) 뷰 영역] -->
                <section class="board-view" data-board-view="faq" aria-labelledby="faq-title">
                    <div class="page-heading"><p class="page-eyebrow">Help center</p><h1 class="page-title" id="faq-title">자주 묻는 질문</h1><p class="page-description">서비스 이용 중 자주 묻는 내용을 모았습니다.</p></div>
                    <div class="surface faq-list">
                        <article class="faq-item"><p class="faq-question"><span class="chip">계정</span>&nbsp; 비밀번호를 잊어버렸어요.</p><p class="faq-answer">로그인 화면의 비밀번호 찾기에서 가입 이메일로 재설정 링크를 받을 수 있습니다.</p></article>
                        <article class="faq-item"><p class="faq-question"><span class="chip">채팅</span>&nbsp; 채팅방 알림을 끌 수 있나요?</p><p class="faq-answer">채팅방 상단의 설정 메뉴에서 방별 알림을 조정할 수 있습니다.</p></article>
                        <article class="faq-item"><p class="faq-question"><span class="chip">음악</span>&nbsp; 플레이리스트는 어디에 저장되나요?</p><p class="faq-answer">마이페이지의 내 플레이리스트에서 저장한 곡을 확인할 수 있습니다.</p></article>
                    </div>
                </section>

                <!-- 6. [1:1 문의 접수 폼 뷰 영역] -->
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
<!-- 게시판 인터랙션 및 프론트엔드 제어 스크립트 로드 -->
<script src="${pageContext.request.contextPath}/app.js"></script>
<script src="${pageContext.request.contextPath}/board.js"></script>
</body>
</html>