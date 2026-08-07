<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>커뮤니티 | Youwin</title>
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
            <div class="site-header__actions">
                <a class="button button--secondary" href="${pageContext.request.contextPath}/member/login">로그인</a>
                <a class="avatar-link" href="${pageContext.request.contextPath}/member/mypage" aria-label="마이페이지">YU</a>
            </div>
        </div>
    </header>

    <main class="page-main">
        <div class="site-container board-layout">
            <!-- 사이드바 -->
            <aside class="surface board-sidebar" aria-label="게시판 메뉴">
                <p class="board-sidebar__title">COMMUNITY</p>
                <div class="board-menu">
                    <button class="${param.tab == 'faq' || param.tab == 'qna' ? '' : 'is-active'}" type="button" data-board-target="notice" onclick="location.href='${pageContext.request.contextPath}/board';">
                        <span>공지사항</span><span class="board-menu__count">NOTICE</span>
                    </button>
                    <button class="${param.tab == 'faq' ? 'is-active' : ''}" type="button" data-board-target="faq" onclick="location.href='${pageContext.request.contextPath}/board?tab=faq';">
                        <span>자주 묻는 질문</span><span class="board-menu__count">FAQ</span>
                    </button>
                    <button class="${param.tab == 'qna' ? 'is-active' : ''}" type="button" data-board-target="qna" onclick="location.href='${pageContext.request.contextPath}/board?tab=qna';">
                        <span>1:1 문의</span><span class="board-menu__count">Q&A</span>
                    </button>
                </div>
                <div style="margin-top: 24px; font-size: 12px; color: #868e96; line-height: 1.5;">
                    운영 관련 문의는 평일 10:00~18:00에 순차적으로 답변해드립니다.
                </div>
            </aside>

            <!-- 본문 영역 -->
            <div class="board-content" style="width: 100%;">

                <!-- 1. 공지사항 탭 영역 -->
                <section id="tab-notice" class="board-view ${param.tab == 'faq' || param.tab == 'qna' ? '' : 'is-active'}" data-board-view="notice">
                    <div class="board-heading" style="display: flex; justify-content: space-between; align-items: flex-end;">
                        <div class="page-heading">
                            <p class="page-eyebrow">COMMUNITY BOARD</p>
                            <h1 class="page-title">공지사항</h1>
                            <p class="page-description">Youwin의 새로운 소식과 서비스 안내를 확인하세요.</p>
                        </div>
                        <button class="button" type="button" onclick="location.href='${pageContext.request.contextPath}/board/write';">새 글 작성</button>
                    </div>

                    <!-- 상단 PINNED 배너 -->
                    <div style="background-color: #212529; color: #fff; padding: 14px 20px; border-radius: 8px; display: flex; justify-content: space-between; align-items: center; margin-top: 20px; font-size: 14px;">
                        <div>
                            <span style="background-color: #495057; color: #fff; padding: 2px 8px; border-radius: 4px; font-size: 11px; font-weight: bold; margin-right: 12px;">PINNED</span>
                            커뮤니티 이용 가이드와 기본 에티켓을 확인해 주세요.
                        </div>
                        <div style="color: #adb5bd; font-size: 13px;">2026.07.16</div>
                    </div>

                    <!-- 검색 및 분류 필터 바 -->
                    <form action="${pageContext.request.contextPath}/board" method="get" style="display: flex; justify-content: space-between; align-items: center; margin-top: 20px; flex-wrap: wrap; gap: 10px;">
                        <!-- 현재 탭 유지용 히든 필드 -->
                        <input type="hidden" name="tab" value="${param.tab}">

                        <div style="display: flex; gap: 6px;">
                            <button type="submit" name="category" value="all" class="board-filter ${empty param.category || param.category == 'all' ? 'is-active' : ''}" style="padding: 6px 14px; border-radius: 20px; border: 1px solid #dee2e6; cursor: pointer; font-size: 13px;">전체</button>
                            <button type="submit" name="category" value="안내" class="board-filter ${param.category == '안내' ? 'is-active' : ''}" style="padding: 6px 14px; border-radius: 20px; border: 1px solid #dee2e6; cursor: pointer; font-size: 13px;">안내</button>
                            <button type="submit" name="category" value="업데이트" class="board-filter ${param.category == '업데이트' ? 'is-active' : ''}" style="padding: 6px 14px; border-radius: 20px; border: 1px solid #dee2e6; cursor: pointer; font-size: 13px;">업데이트</button>
                            <button type="submit" name="category" value="이벤트" class="board-filter ${param.category == '이벤트' ? 'is-active' : ''}" style="padding: 6px 14px; border-radius: 20px; border: 1px solid #dee2e6; cursor: pointer; font-size: 13px;">이벤트</button>
                        </div>
                        <div class="board-search" style="display: flex; gap: 4px;">
                            <select name="searchType" style="padding: 6px 10px; border: 1px solid #ced4da; border-radius: 6px; font-size: 13px; background-color: #fff;">
                                <option value="titleContent" ${param.searchType == 'titleContent' ? 'selected' : ''}>제목+내용</option>
                                <option value="title" ${param.searchType == 'title' ? 'selected' : ''}>제목</option>
                                <option value="content" ${param.searchType == 'content' ? 'selected' : ''}>내용</option>
                                <option value="writer" ${param.searchType == 'writer' ? 'selected' : ''}>작성자</option>
                            </select>
                            <input type="text" name="keyword" value="${param.keyword}" placeholder="검색어를 입력하세요" style="padding: 6px 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 13px; width: 180px;">
                            <button type="submit" class="button button--secondary" style="padding: 6px 12px; font-size: 13px;">검색</button>
                        </div>
                    </form>

                    <div class="surface board-table-wrap" style="margin-top: 12px;">
                        <table class="board-table">
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
                                    <!-- varStatus="status"를 추가하여 순번(status.index)을 활용 -->
                                    <c:forEach var="noticeItem" items="${list}" varStatus="status">
                                        <tr onclick="location.href='${pageContext.request.contextPath}/board/detail?noticeId=${noticeItem.noticeId}';" style="cursor: pointer;">
                                            <!-- 역순 게시글 번호 계산식 적용 -->
                                            <td class="board-table__number">
                                                    ${pageInfo.totalCount - (pageInfo.page - 1) * pageInfo.size - status.index}
                                            </td>
                                            <td><span class="chip">${noticeItem.category}</span></td>
                                            <td class="board-table__title">
                                                <c:if test="${noticeItem.isPinned == 1}">
                                                    <span style="background: #ffe3e3; color: #f03e3e; padding: 2px 6px; border-radius: 4px; font-size: 11px; margin-right: 6px; font-weight: bold;">● 고정</span>
                                                </c:if>
                                                    ${noticeItem.title}
                                            </td>
                                            <td class="board-table__meta">${empty noticeItem.memberId ? '운영팀' : noticeItem.memberId}</td>
                                            <td class="board-table__meta" style="text-align: center;">${noticeItem.createAt}</td>
                                            <td class="board-table__meta" style="text-align: center;">${noticeItem.count}</td>
                                            <td onclick="event.stopPropagation();" style="text-align: center;">
                                                <div style="display: flex; gap: 4px; justify-content: center; align-items: center;">
                                                    <button type="button" class="board-filter" onclick="location.href='${pageContext.request.contextPath}/board/modify?noticeId=${noticeItem.noticeId}';" style="min-height:28px; padding:0 10px; border-color:#2f54eb; color:#2f54eb; background:none; font-size:11px; cursor:pointer;">수정</button>
                                                    <form action="${pageContext.request.contextPath}/board/delete" method="POST" class="delete-form" style="margin:0;">
                                                        <input type="hidden" name="noticeId" value="${noticeItem.noticeId}">
                                                        <button type="submit" style="min-height:28px; padding:0 10px; border:1px solid #ff4d4f; border-radius:4px; color:#ff4d4f; background:none; font-size:11px; cursor:pointer;">삭제</button>
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

                    <!-- 페이징 처리 영역 (검색 조건, 검색 타입, 카테고리, 탭 유지 파라미터 포함) -->
                    <nav class="board-pagination" aria-label="페이지 이동" style="margin-top: 20px;">
                        <c:if test="${pageInfo.prev}">
                            <a href="${pageContext.request.contextPath}/board?page=${pageInfo.startPage - 1}&tab=${param.tab}&category=${param.category}&searchType=${param.searchType}&keyword=${param.keyword}">←</a>
                        </c:if>
                        <c:forEach var="num" begin="${pageInfo.startPage}" end="${pageInfo.endPage}">
                            <a class="${pageInfo.page == num ? 'is-active' : ''}" href="${pageContext.request.contextPath}/board?page=${num}&tab=${param.tab}&category=${param.category}&searchType=${param.searchType}&keyword=${param.keyword}">${num}</a>
                        </c:forEach>
                        <c:if test="${pageInfo.next}">
                            <a href="${pageContext.request.contextPath}/board?page=${pageInfo.endPage + 1}&tab=${param.tab}&category=${param.category}&searchType=${param.searchType}&keyword=${param.keyword}">→</a>
                        </c:if>
                    </nav>
                </section>

                <!-- 2. 자주 묻는 질문 (FAQ) 탭 영역 -->
                <section id="tab-faq" class="board-view ${param.tab == 'faq' ? 'is-active' : ''}" data-board-view="faq" style="display: ${param.tab == 'faq' ? 'block' : 'none'};">
                    <div class="page-heading">
                        <p class="page-eyebrow">HELP CENTER</p>
                        <h1 class="page-title">자주 묻는 질문</h1>
                        <p class="page-description">서비스 이용 중 자주 묻는 내용을 모았습니다.</p>
                    </div>

                    <div class="surface" style="margin-top: 20px; padding: 24px; border-radius: 12px;">
                        <div style="padding: 16px 0; border-bottom: 1px solid #f1f3f5;">
                            <span style="background: #e7f5ff; color: #1c7ed6; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; margin-right: 8px;">계정</span>
                            <strong style="font-size: 15px; color: #212529;">비밀번호를 잊어버렸어요.</strong>
                            <p style="margin-top: 8px; font-size: 14px; color: #495057; line-height: 1.5;">로그인 화면의 비밀번호 찾기에서 가입 이메일로 재설정 링크를 받을 수 있습니다.</p>
                        </div>
                        <div style="padding: 16px 0; border-bottom: 1px solid #f1f3f5;">
                            <span style="background: #e7f5ff; color: #1c7ed6; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; margin-right: 8px;">채팅</span>
                            <strong style="font-size: 15px; color: #212529;">채팅방 알림을 끌 수 있나요?</strong>
                            <p style="margin-top: 8px; font-size: 14px; color: #495057; line-height: 1.5;">채팅방 상단의 설정 메뉴에서 방별 알림을 조정할 수 있습니다.</p>
                        </div>
                        <div style="padding: 16px 0;">
                            <span style="background: #e7f5ff; color: #1c7ed6; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; margin-right: 8px;">음악</span>
                            <strong style="font-size: 15px; color: #212529;">플레이리스트는 어디에 저장되나요?</strong>
                            <p style="margin-top: 8px; font-size: 14px; color: #495057; line-height: 1.5;">마이페이지의 내 플레이리스트에서 저장한 곡을 확인할 수 있습니다.</p>
                        </div>
                    </div>
                </section>

                <!-- 3. 1:1 문의 (Q&A) 탭 영역 -->
                <section id="tab-qna" class="board-view ${param.tab == 'qna' ? 'is-active' : ''}" data-board-view="qna" style="display: ${param.tab == 'qna' ? 'block' : 'none'};">
                    <div class="page-heading">
                        <p class="page-eyebrow">CONTACT US</p>
                        <h1 class="page-title">1:1 문의</h1>
                        <p class="page-description">문의 내용과 답변 받을 이메일을 남겨 주세요.</p>
                    </div>

                    <div class="surface editor-card form-grid" style="margin-top: 20px; padding: 24px;">
                        <form action="${pageContext.request.contextPath}/board/qna/submit" method="POST">
                            <div class="form-field" style="margin-bottom: 16px;">
                                <label style="display: block; font-weight: bold; margin-bottom: 6px; font-size: 14px;">문의 유형</label>
                                <select name="qnaType" style="width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 6px;">
                                    <option value="계정">계정</option>
                                    <option value="결제">결제</option>
                                    <option value="기타">기타</option>
                                </select>
                            </div>
                            <div class="form-field" style="margin-bottom: 16px;">
                                <label style="display: block; font-weight: bold; margin-bottom: 6px; font-size: 14px;">제목</label>
                                <input type="text" name="title" placeholder="문의 제목을 입력해 주세요" style="width: 100%; padding: 10px; border: 1px solid #ced4da; border-radius: 6px;" required>
                            </div>
                            <div class="form-field" style="margin-bottom: 20px;">
                                <label style="display: block; font-weight: bold; margin-bottom: 6px; font-size: 14px;">내용</label>
                                <textarea name="content" placeholder="문의 내용을 입력해 주세요" style="width: 100%; height: 150px; padding: 10px; border: 1px solid #ced4da; border-radius: 6px; resize: vertical;" required></textarea>
                            </div>
                            <div style="text-align: right;">
                                <button type="submit" class="button">문의 접수하기</button>
                            </div>
                        </form>
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