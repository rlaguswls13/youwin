<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
                <div class="chat-panel__head"><div><h2>오픈 톡</h2><span>참여 중인 대화 6</span></div><button class="icon-button" type="button" aria-label="새 채팅방 만들기">＋</button></div>
                <div class="room-search"><label class="sr-only" for="room-search">채팅방 검색</label><input id="room-search" type="search" placeholder="채팅방 검색"></div>
                <div class="room-list">
                    <button class="room-item is-active" type="button" data-room-item data-room-name="신보 같이 듣기"><span class="room-item__art">NEW</span><span><strong class="room-item__name">신보 같이 듣기</strong><span class="room-item__preview">오늘 공개된 앨범부터 들어봐요</span></span><span><span class="room-item__time">방금</span><span class="room-item__unread">8</span></span></button>
                    <button class="room-item" type="button" data-room-item data-room-name="새벽 인디 라운지"><span class="room-item__art">IN</span><span><strong class="room-item__name">새벽 인디 라운지</strong><span class="room-item__preview">이 곡 베이스가 정말 좋아요</span></span><span><span class="room-item__time">2분</span><span class="room-item__unread">3</span></span></button>
                    <button class="room-item" type="button" data-room-item data-room-name="공연 같이 가요"><span class="room-item__art">ON</span><span><strong class="room-item__name">공연 같이 가요</strong><span class="room-item__preview">토요일 스탠딩 입장 순서 공유</span></span><span><span class="room-item__time">8분</span></span></button>
                    <button class="room-item" type="button" data-room-item data-room-name="시티팝 수집가"><span class="room-item__art">CP</span><span><strong class="room-item__name">시티팝 수집가</strong><span class="room-item__preview">오늘의 추천곡을 올려주세요</span></span><span><span class="room-item__time">21분</span></span></button>
                    <button class="room-item" type="button" data-room-item data-room-name="헤드폰 이야기"><span class="room-item__art">HP</span><span><strong class="room-item__name">헤드폰 이야기</strong><span class="room-item__preview">입문용 장비 추천 부탁해요</span></span><span><span class="room-item__time">1시간</span></span></button>
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
                    <div class="message-date">2026년 7월 21일 화요일</div>
                    <div class="message"><span class="message__avatar">윤슬</span><div class="message__content"><span class="message__author">윤슬 · HOST</span><div class="message__bubble">어서 오세요! 오늘 공개된 앨범을 첫 트랙부터 같이 들어볼게요.</div></div><time class="message__time" datetime="2026-07-21T20:01">20:01</time></div>
                    <div class="message"><span class="message__avatar">민트</span><div class="message__content"><span class="message__author">민트</span><div class="message__bubble">인트로 신스부터 분위기가 정말 좋네요. 이어폰으로 들으니 공간감도 훨씬 잘 느껴져요.</div></div><time class="message__time" datetime="2026-07-21T20:02">20:02</time></div>
                    <div class="message message--mine"><time class="message__time" datetime="2026-07-21T20:03">20:03</time><div class="message__content"><div class="message__bubble">저도 지금 같이 듣고 있어요. 두 번째 트랙 베이스 라인이 특히 좋아요!</div></div></div>
                    <div class="message"><span class="message__avatar">모노</span><div class="message__content"><span class="message__author">모노</span><div class="message__bubble">맞아요. 라이브로 들으면 더 좋을 것 같은 곡이에요.</div></div><time class="message__time" datetime="2026-07-21T20:04">20:04</time></div>
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
