<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${mode == 'edit' ? '공지 수정' : '새 공지 작성'} | Youwin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/board.css">
    <style>
        .existing-image-item { position: relative; display: inline-block; margin-right: 10px; margin-bottom: 10px; }
        .existing-image-item img { width: 80px; height: 80px; object-fit: cover; border-radius: 4px; border: 1px solid #ddd; }
        .existing-image-item .btn-del-existing { position: absolute; top: -5px; right: -5px; background: #ff4d4f; color: #fff; border: none; border-radius: 50%; width: 20px; height: 20px; font-size: 11px; cursor: pointer; display: flex; align-items: center; justify-content: center; }
    </style>
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
                <a href="${pageContext.request.contextPath}/mypage/main">마이페이지</a>
            </nav>
            <div class="site-header__actions"><a class="button button--secondary" href="${pageContext.request.contextPath}/auth/login">로그인</a><a class="avatar-link" href="${pageContext.request.contextPath}/mypage/main" aria-label="마이페이지">YU</a></div>
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

            <div class="board-content" style="width: 100%;">
                <section class="board-view is-active">
                    <div class="page-heading">
                        <p class="page-eyebrow">Write a post</p>
                        <h1 class="page-title">${mode == 'edit' ? '공지 수정' : '새 공지 작성'}</h1>
                        <p class="page-description">필요한 내용을 간결하고 정확하게 작성해 주세요.</p>
                    </div>

                    <form id="editor-form" class="surface editor-card form-grid"
                          action="${pageContext.request.contextPath}${mode == 'edit' ? '/board/modify/'.concat(notice.noticeId) : '/board/write'}"
                          method="post" enctype="multipart/form-data" style="margin-top: 20px; padding: 24px;">

                        <input type="hidden" name="noticeId" value="${mode == 'edit' ? notice.noticeId : ''}">

                        <div class="form-field">
                            <label for="category">분류</label>
                            <select id="category" name="category" required>
                                <option value="안내" ${notice.category == '안내' ? 'selected' : ''}>안내</option>
                                <option value="업데이트" ${notice.category == '업데이트' ? 'selected' : ''}>업데이트</option>
                                <option value="이벤트" ${notice.category == '이벤트' ? 'selected' : ''}>이벤트</option>
                            </select>
                        </div>
                        <div class="form-options" style="display: flex; gap: 16px; margin-bottom: 10px;">
                            <label><input type="checkbox" name="isPinned" value="1" ${notice.isPinned == 1 ? 'checked' : ''}> 상단 고정</label>
                            <label><input type="checkbox" name="allowComments" value="1" ${notice.allowComments == 1 ? 'checked' : ''}> 댓글 허용</label>
                        </div>
                        <div class="form-field">
                            <label for="post-title">제목</label>
                            <input id="post-title" type="text" name="title" maxlength="200" placeholder="제목을 입력해 주세요" value="${notice.title}" required>
                        </div>
                        <div class="form-field">
                            <label for="post-content">내용</label>
                            <textarea id="post-content" name="content" placeholder="내용을 입력해 주세요" required>${notice.content}</textarea>
                        </div>

                        <!-- 기존 등록된 이미지 표시 영역 (수정 모드) -->
                        <c:if test="${mode == 'edit' and not empty imageList}">
                            <div class="form-field" style="width: 100%;">
                                <label>기존 첨부 이미지 (X를 누르면 삭제됩니다)</label>
                                <div style="display: flex; gap: 10px; flex-wrap: wrap; margin-top: 8px;">
                                    <c:forEach var="img" items="${imageList}">
                                        <div class="existing-image-item" id="img-item-${img.imageId}">
                                            <img src="${pageContext.request.contextPath}/upload/${img.savedFileName}" alt="${img.originalName}">
                                            <input type="hidden" name="existingFiles" value="${img.savedFileName}">
                                            <button type="button" class="btn-del-existing" onclick="document.getElementById('img-item-${img.imageId}').remove();">×</button>
                                        </div>
                                    </c:forEach>
                                </div>
                            </div>
                        </c:if>

                        <!-- 신규 이미지 썸네일 미리보기 영역 -->
                        <div id="previewContainer" style="display: flex; gap: 10px; flex-wrap: wrap; width: 100%;"></div>

                        <!-- 이미지 업로드 버튼 및 액션 -->
                        <div class="form-actions" style="display: flex; justify-content: space-between; align-items: center; width: 100%; margin-top: 20px;">
                            <div class="image-upload-trigger-wrap" style="display: flex; align-items: center; gap: 12px;">
                                <input type="file" id="imageInput" name="imageFiles" multiple accept="image/*" style="display: none;">
                                <div id="btnUploadTrigger" style="display: flex; align-items: center; gap: 6px; padding: 8px 14px; border: 1px dashed #ced4da; border-radius: 6px; cursor: pointer; background-color: #f8f9fa; user-select: none;">
                                    <span style="font-weight: bold; color: #495057; font-size: 14px;">+ 이미지 업로드</span>
                                    <span style="font-size: 13px; color: #6c757d;">(<span id="imageCount">0</span>/5)</span>
                                </div>
                                <span style="font-size: 13px; color: #868e96; pointer-events: none;">* 장당 최대 5MB 이하</span>
                            </div>

                            <div style="display: flex; gap: 8px;">
                                <button class="button button--secondary" type="button" onclick="location.href='${pageContext.request.contextPath}/board';">취소</button>
                                <button class="button" type="submit">${mode == 'edit' ? '수정하기' : '등록하기'}</button>
                            </div>
                        </div>
                    </form>
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