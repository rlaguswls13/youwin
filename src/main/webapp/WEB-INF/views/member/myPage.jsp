<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Youwin 마이페이지">
    <title>마이페이지 | Youwin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/mypage.css">
</head>
<body>
<div class="site-shell">
    <header class="site-header">
        <div class="site-container site-header__inner">
            <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈"><span class="brand__mark">YW</span><span>Youwin</span></a>
            <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
                <a href="${pageContext.request.contextPath}/">홈</a>
                <a href="${pageContext.request.contextPath}/board">게시판</a>
                <a href="${pageContext.request.contextPath}/chatroom">채팅방</a>
                <a class="is-active" href="${pageContext.request.contextPath}/member/myPage">마이페이지</a>
            </nav>
            <div class="site-header__actions"><a class="button button--secondary" href="${pageContext.request.contextPath}/member/settings">프로필 설정</a><span class="avatar">YU</span></div>
            <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
        </div>
    </header>

    <main class="page-main">
        <div class="site-container">
            <section class="surface profile-hero" aria-labelledby="profile-title">
                <!-- 1. 프로필 사진 (등록된 이미지가 있으면 img 출력, 없으면 기본 이니셜 출력) -->
                <div class="profile-avatar" aria-hidden="true">
                    <c:choose>
                        <c:when test="${not empty member.profileImage}">
                            <img src="${pageContext.request.contextPath}${member.profileImage}" class="profile-img" alt="프로필 사진">
                        </c:when>
                        <c:otherwise>
                            <svg viewBox="0 0 24 24" width="40" height="40" fill="currentColor">
                                <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"></path>
                            </svg>
                        </c:otherwise>
                    </c:choose>
                </div>

                <div class="profile-copy">
                    <p class="profile-copy__label">MY MUSIC PROFILE</p>
                    <h1 id="profile-title">${member.nickname}</h1>
                    <div class="profile-copy__meta">
                        <span>@${member.memberId}</span>
                        <span>가입일 ${member.formattedCreatedAt}</span>
                        <span>수정일 ${member.formattedUpdatedAt}</span>
                    </div>
                </div>

                <div class="profile-hero__actions">
                    <a class="button button--secondary" href="${pageContext.request.contextPath}/member/settings">프로필 수정</a>
                    <a class="button" href="${pageContext.request.contextPath}/chatroom">채팅방 가기</a>
                </div>
            </section>

            <section class="profile-stats" aria-label="활동 통계">
                <div class="surface stat-card"><span class="stat-card__label">저장한 곡</span><strong class="stat-card__value">48</strong></div>
                <div class="surface stat-card"><span class="stat-card__label">참여한 채팅</span><strong class="stat-card__value">12</strong></div>
                <div class="surface stat-card"><span class="stat-card__label">작성한 글</span><strong class="stat-card__value">7</strong></div>
                <div class="surface stat-card"><span class="stat-card__label">받은 공감</span><strong class="stat-card__value">126</strong></div>
            </section>

            <div class="mypage-grid">
                <section class="surface mypage-card" aria-labelledby="playlist-title">
                    <div class="section-head"><div><h2 class="section-title" id="playlist-title">내 플레이리스트</h2><p class="section-copy">최근 저장한 음악을 이어서 들어보세요.</p></div><a class="text-link" href="#">전체 보기 →</a></div>
                    <div class="player-bar"><button class="player-bar__button" type="button" aria-label="재생">▶</button><div class="player-progress" aria-label="재생 진행률 38%"><span></span></div><span class="player-bar__time">01:24 / 03:42</span></div>
                    <div class="playlist">
                        <div class="playlist-item"><span class="playlist-item__number">01</span><span class="playlist-item__cover"></span><div><strong class="playlist-item__title">Midnight Drive</strong><span class="playlist-item__artist">Neon City</span></div><span class="playlist-item__plays">32회 재생</span></div>
                        <div class="playlist-item"><span class="playlist-item__number">02</span><span class="playlist-item__cover"></span><div><strong class="playlist-item__title">Paper Moon</strong><span class="playlist-item__artist">The Waves</span></div><span class="playlist-item__plays">21회 재생</span></div>
                        <div class="playlist-item"><span class="playlist-item__number">03</span><span class="playlist-item__cover"></span><div><strong class="playlist-item__title">Slow Sunday</strong><span class="playlist-item__artist">Room 52</span></div><span class="playlist-item__plays">18회 재생</span></div>
                        <div class="playlist-item"><span class="playlist-item__number">04</span><span class="playlist-item__cover"></span><div><strong class="playlist-item__title">Blue Hour</strong><span class="playlist-item__artist">Mellow Note</span></div><span class="playlist-item__plays">11회 재생</span></div>
                    </div>
                </section>

                <aside>
                    <section class="surface mypage-card" aria-labelledby="activity-title">
                        <div class="section-head"><div><h2 class="section-title" id="activity-title">최근 활동</h2><p class="section-copy">내 커뮤니티 기록</p></div></div>
                        <div class="activity-list">
                            <article class="activity-item"><p class="activity-item__type">게시글</p><p class="activity-item__title">여름밤에 어울리는 시티팝 추천</p><time datetime="2026-07-21T10:20">오늘 10:20</time></article>
                            <article class="activity-item"><p class="activity-item__type">채팅</p><p class="activity-item__title">신보 같이 듣기 방에 참여했어요</p><time datetime="2026-07-20T22:10">어제 22:10</time></article>
                            <article class="activity-item"><p class="activity-item__type">플레이리스트</p><p class="activity-item__title">Blue Hour를 저장했어요</p><time datetime="2026-07-19T18:40">7월 19일</time></article>
                        </div>
                    </section>
                    <section class="surface preference-card" aria-labelledby="preference-title"><div class="section-head"><div><h2 class="section-title" id="preference-title">나의 취향</h2><p class="section-copy">추천에 반영되는 관심 장르</p></div></div><div class="preference-tags"><span class="chip">City Pop</span><span class="chip">Indie</span><span class="chip">Jazz</span><span class="chip">Lo-Fi</span><span class="chip">R&B</span></div></section>
                </aside>
            </div>
        </div>
    </main>

    <footer class="site-footer"><div class="site-container site-footer__inner"><span>© 2026 Youwin.</span><div class="site-footer__links"><a href="${pageContext.request.contextPath}/board">고객센터</a><a href="#">로그아웃</a></div></div></footer>
</div>
<script src="${pageContext.request.contextPath}/app.js"></script>
</body>
</html>
