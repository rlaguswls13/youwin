<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
        <!doctype html>
        <html lang="ko">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1">
            <meta name="description" content="Youwin 음악 오픈 채팅방">
            <title>채팅방 | Youwin</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/chatroom.css">
        </head>
        <body>
        <div class="site-shell">
            <header class="site-header">
                <div class="site-container site-header__inner">
                    <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈"><span class="brand__mark">YW</span><span>Youwin</span></a>
                    <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
                        <a href="${pageContext.request.contextPath}/">홈</a>
                        <a href="${pageContext.request.contextPath}/board">게시판</a>
                        <a class="is-active" href="${pageContext.request.contextPath}/chatroom">채팅방</a>
                        <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
                    </nav>
                    <div class="site-header__actions"><span class="chip chip--live">온라인</span><a class="avatar-link" href="${pageContext.request.contextPath}/member/mypage" aria-label="마이페이지">YU</a></div>
                    <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
                </div>
            </header>

            <main class="chat-page">
                <div class="chat-shell">
                    <aside class="chat-rooms" data-rooms-panel aria-label="채팅방 목록">
                        <div class="chat-panel__head"><div><h2>오픈 톡</h2><span>참여 중인 대화 ${fn:length(roomList)}</span></div><button class="icon-button" type="button" aria-label="새 채팅방 만들기">＋</button></div>
                        <div class="room-search"><label class="sr-only" for="room-search">채팅방 검색</label><input id="room-search" type="search" placeholder="채팅방 검색"></div>
                        <div class="room-list">
                            <c:forEach var="room" items="${roomList}" varStatus="status">
                                <button class="room-item${status.first ? ' is-active' : ''}" type="button" data-room-item data-room-name="<c:out value='${room.roomName}'/>">
                                    <span class="room-item__art">🎵</span>
                                    <span>
                        <strong class="room-item__name">
                                ${room.roomName}
                        </strong>

                        <span class="room-item__preview">
                            음악 채팅방
                        </span>
                    </span>
                        </button>
                            </c:forEach>
                            <c:if test="${empty roomList}">
                                <p class="room-list__empty">참여 중인 채팅방이 없습니다.</p>
                            </c:if>
                        </div>
                    </aside>

                    <section class="chat-conversation" aria-labelledby="conversation-title">
                        <header class="conversation-head">
                            <button class="icon-button mobile-panel-button" type="button" data-rooms-toggle aria-label="채팅방 목록 열기" aria-expanded="false">☰</button>
                            <div class="room-item__art">NEW</div>
                            <div class="conversation-head__info"><h1 id="conversation-title" data-room-title>신보 같이 듣기</h1><p><span class="online-dot">●</span> 128명 참여 중 · 음악과 관련된 대화를 나눠 주세요</p></div>
                            <div class="conversation-head__actions"><button class="icon-button" type="button" aria-label="채팅방 검색">⌕</button><button class="icon-button" type="button" aria-label="채팅방 설정">···</button></div>
                        </header>

                        <div class="message-list" data-message-list aria-live="polite">
                            <div class="message-date">이전 채팅</div>

                            <c:forEach var="message" items="${messageList}">

                        <div class="message">

                        <span class="message__avatar">
                                ${message.memberId}
                        </span>

                        <div class="message__content">

                        <span class="message__author">
                            회원 ${message.memberId}
                        </span>

                        <div class="message__bubble">${message.message}</div>
                        </div>
                            <time class="message__time">${message.sentAt}</time>
                        </div>

                            </c:forEach>
                        </div>

                        <form class="message-composer" data-message-form>
                            <div class="message-composer__box"><button class="icon-button" type="button" aria-label="파일 첨부">＋</button><label class="sr-only" for="message-input">메시지 입력</label><textarea id="message-input" data-message-input rows="1" maxlength="1000" placeholder="메시지를 입력하세요"></textarea><button class="send-button" type="submit">전송</button></div>
                            <p class="composer-help">Enter로 전송 · Shift + Enter로 줄바꿈</p>
                        </form>
                    </section>

                    <aside class="chat-members" aria-label="참여자 목록">
                        <div class="chat-panel__head"><div><h3>참여자</h3><span>온라인 128명</span></div></div>
                        <div class="member-group"><p class="member-group__title">Host</p><div class="member-item"><span class="avatar">윤슬</span><span><strong class="member-item__name">윤슬</strong><span class="member-item__status"><span class="online-dot">●</span> 앨범 재생 중</span></span></div></div>
                        <div class="member-group"><p class="member-group__title">Online</p><div class="member-item"><span class="avatar">민트</span><span><strong class="member-item__name">민트</strong><span class="member-item__status"><span class="online-dot">●</span> 온라인</span></span></div><div class="member-item"><span class="avatar">모노</span><span><strong class="member-item__name">모노</strong><span class="member-item__status"><span class="online-dot">●</span> 온라인</span></span></div><div class="member-item"><span class="avatar">파랑</span><span><strong class="member-item__name">파란밤</strong><span class="member-item__status"><span class="online-dot">●</span> 듣는 중</span></span></div></div>
                    </aside>
                </div>
            </main>
        </div>
        <script src="${pageContext.request.contextPath}/app.js"></script>
        <script src="${pageContext.request.contextPath}/chatroom.js"></script>
        </body>
        </html>
