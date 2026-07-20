<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>사이트 레이아웃</title>
  <!-- 돋보기 아이콘을 위한 FontAwesome 불러오기 -->
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

  <style>
    /* 기본 스타일 초기화 */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Malgun Gothic', sans-serif;
    }

    body {
      background-color: #f5f5f5;
      display: flex;
      flex-direction: column;
      min-height: 100vh; /* 화면 꽉 차게 설정 */
    }

    a {
      text-decoration: none;
      color: #333;
    }

    /* ==================== HEADER ==================== */
    header {
      background-color: #f5f5f5; /* 스케치와 동일한 밝은 회색 바탕 */
      border-bottom: 1px solid #ccc;
      width: 100%;
    }

    /* 헤더 상단 (로고, 검색창, 로그인/회원가입) */
    .header-top {
      width: 100%;
      /* 좌우 여백을 화면 폭의 4%로 유연하게 설정 (너무 달라붙지 않게) */
      padding: 20px 4% 10px 4%;

      display: grid;
      grid-template-columns: 1fr auto 1fr;
      align-items: center;
    }

    /* 로고를 왼쪽으로 붙이기 */
    .logo {
      justify-self: start;
    }

    /* 2. 검색창 영역 */
    .search-container {
      justify-self: center; /* 이게 핵심! 무조건 중앙에 고정됩니다 */
      width: 300px;
      position: relative;
    }

    /* 3. 유저 메뉴 (로그인/회원가입 -> 마이페이지 분기) */
    .user-menu {
      justify-self: end; /* 오른쪽 정렬 */
      font-size: 13px;
      display: flex;
      gap: 15px;
    }

    .search-container input {
      width: 100%;
      padding: 8px 35px 8px 12px;
      border: 1px solid #333;
      background-color: transparent;
      font-size: 14px;
      outline: none;
    }

    .search-container .fa-search {
      position: absolute;
      right: 12px;
      top: 50%;
      transform: translateY(-50%);
      color: #333;
      cursor: pointer;
    }

    .user-menu a {
      color: #555;
    }

    .user-menu a:hover {
      color: #000;
    }

    /* 상태 변환 테스트용 버튼 (로그인 전/후 전환용) */
    .auth-toggle-btn {
      position: absolute;
      top: 10px;
      right: 10px;
      padding: 4px 8px;
      font-size: 11px;
      cursor: pointer;
      background-color: #e0e0e0;
      border: 1px solid #ccc;
      border-radius: 4px;
    }


    /* 헤더 하단 (네비게이션 바) */
    .header-bottom {
      width: 100%;
      padding: 10px 4%;
    }

    .nav-menu {
      display: flex;
      justify-content: space-around; /* 스케치 메뉴 배치에 맞춰 넓게 정렬 */
      list-style: none;
      position: relative;
    }

    .nav-item {
      font-size: 16px;
      font-weight: bold;
      padding: 10px 0;
      position: relative;
    }

    /* 4. 고객센터 드롭다운 (마우스 대면 열림) */
    .dropdown {
      position: relative;
    }

    .dropdown-menu {
      display: none; /* 기본 상태는 숨김 */
      position: absolute;
      top: 100%;
      left: 50%;
      transform: translateX(-50%);
      background-color: #fff;
      border: 1px solid #ccc;
      min-width: 120px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
      list-style: none;
      z-index: 10;
    }

    .dropdown-menu li a {
      display: block;
      padding: 10px 15px;
      font-size: 14px;
      font-weight: normal;
      text-align: center;
    }

    .dropdown-menu li a:hover {
      background-color: #f5f5f5;
    }

    /* 🔥 마우스 오버 시 열리게 만드는 핵심 CSS */
    .dropdown:hover .dropdown-menu {
      display: block;
    }


    main {
      flex: 1;
      width: 100%;
      margin: 0; /* 중앙 정렬용 auto 제거 */
      padding: 40px 4%; /* 양옆 여백을 화면 폭의 4%로 대응 */
      display: flex;
      flex-direction: column;
      gap: 50px; /* 섹션 간격 조정 */
    }

    .section-title {
      text-align: left;
      font-size: 22px;
      font-weight: bold;
      margin-bottom: 20px;
      display: flex;
      align-items: center;
      gap: 8px;
    }

    /* 1. 상단: DJ 라이브 방송 그리드 (4열 추천) */
    .live-grid {
      display: flex;       /* grid 대신 flex를 사용하여 한 줄로 나열 */
      gap: 20px;
      overflow-x: auto;    /* 화면을 넘어가면 가로 스크롤 생성 */
      padding: 10px 5px 15px 5px;
      scrollbar-width: thin; /* 스크롤바를 얇고 깔끔하게 */
    }

    .live-card {
      flex: 0 0 280px;     /* 🔥 핵심: 화면이 줄어들어도 카드가 찌그러지지 않고 280px 고정 크기 유지 */
      background: #fff;
      border: 1px solid #e0e0e0;
      border-radius: 8px;
      overflow: hidden;
      box-shadow: 0 4px 10px rgba(0,0,0,0.05);
      transition: transform 0.2s;
      cursor: pointer;
    }

    .live-card:hover {
      transform: translateY(-5px);
    }

    .card-thumbnail {
      background-color: #333;
      height: 160px;
      position: relative;
      display: flex;
      align-items: center;
      justify-content: center;
      color: #fff;
    }

    .badge-live {
      position: absolute;
      top: 10px;
      left: 10px;
      background-color: #ff3b30;
      color: white;
      padding: 3px 6px;
      font-size: 11px;
      font-weight: bold;
      border-radius: 4px;
    }

    .viewer-count {
      position: absolute;
      bottom: 10px;
      right: 10px;
      background-color: rgba(0,0,0,0.6);
      color: white;
      padding: 3px 6px;
      font-size: 11px;
      border-radius: 4px;
    }

    .card-info {
      padding: 15px;
      text-align: left;
    }

    .card-info h4 {
      font-size: 15px;
      margin-bottom: 5px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .card-info .dj-name {
      font-size: 13px;
      color: #888;
    }

    /* 2. 중간: 토픽별 오픈 채팅방 섹션 */
    .topic-chat-section {
      width: 100%;
    }

    .topic-scroll-container {
      display: flex;
      gap: 16px;
      overflow-x: auto; /* 내용이 많아지면 가로 스크롤 생성 */
      padding: 10px 5px 15px 5px; /* 가로 스크롤바 커스텀 (깔끔하게) */
      scrollbar-width: thin;
    }

    .topic-card {
      flex: 0 0 280px; /* 카드가 찌그러지지 않게 고정 크기 할당 */
      background: #fff;
      border: 1px solid #e2e8f0;
      border-radius: 12px;
      padding: 16px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.04);
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      height: 150px;
      transition: all 0.2s ease;
      cursor: pointer;
    }

    .topic-card:hover {
      transform: translateY(-3px);
      border-color: #a0aec0;
      box-shadow: 0 4px 12px rgba(0,0,0,0.08);
    }

    .topic-header {
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
    }

    /* 음악/아티스트 주제를 나타내는 태그 */
    .topic-tag {
      background-color: #edf2f7;
      color: #4a5568;
      font-size: 11px;
      font-weight: bold;
      padding: 4px 8px;
      border-radius: 20px;
    }

    .topic-user-count {
      font-size: 12px;
      color: #718096;
    }

    .topic-title {
      font-size: 15px;
      font-weight: bold;
      color: #2d3748;
      margin: 12px 0 6px 0;
      word-break: keep-all;
      display: -webkit-box;
      -webkit-line-clamp: 2; /* 두 줄 넘어가면 말줄임 */
      -webkit-box-orient: vertical;
      overflow: hidden;
    }

    .topic-footer {
      font-size: 12px;
      color: #a0aec0;
      border-top: 1px dashed #edf2f7;
      padding-top: 8px;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    /* 3. 하단: 채팅 및 커뮤니티 2분할 뷰 */
    .community-split {
      display: grid;
      grid-template-columns: 8fr 4fr; /* 넓은 화면에서는 게시판이 큼직한 게 좋습니다 */
      gap: 32px;
    }

    .sub-box {
      background: #fff;
      border: 1px solid #ddd;
      border-radius: 8px;
      padding: 24px;
      text-align: left;
      box-shadow: 0 2px 5px rgba(0,0,0,0.05);
    }

    .sub-box h3 {
      font-size: 18px;
      padding-bottom: 12px;
      border-bottom: 2px solid #333;
      margin-bottom: 10px;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    /* 더보기 버튼 */
    .more-btn {
      font-size: 12px;
      color: #888;
      font-weight: normal;
    }
    .more-btn:hover {
      color: #000;
    }

    /* 게시판 테이블 스타일 리스트 */
    .board-list {
      display: flex;
      flex-direction: column;
    }

    .board-item {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 12px 4px;
      border-bottom: 1px solid #f0f0f0;
      font-size: 14px;
    }

    .board-item:hover {
      background-color: #fafafa;
    }

    .board-item .post-title {
      color: #333;
      font-weight: 500;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
      padding-right: 15px;
      flex: 1;
    }

    /* 댓글 수 배지 */
    .reply-count {
      color: #ff3b30;
      font-size: 12px;
      font-weight: bold;
      margin-left: 5px;
    }

    .board-item .post-meta {
      display: flex;
      gap: 15px;
      color: #999;
      font-size: 12px;
      white-space: nowrap;
    }

    .board-item .writer {
      color: #666;
      width: 80px;
      text-align: left;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    /* 공지사항 전용 심플 스타일 */
    .notice-item {
      padding: 12px 4px;
      border-bottom: 1px solid #f0f0f0;
      font-size: 14px;
      display: flex;
      justify-content: space-between;
      gap: 10px;
    }

    .notice-item a {
      color: #444;
      white-space: nowrap;
      overflow: hidden;
      text-overflow: ellipsis;
    }

    .notice-item .notice-date {
      color: #aaa;
      font-size: 12px;
      white-space: nowrap;
    }

    /* 반응형 모바일 대책 */
    @media (max-width: 1024px) {
      .community-split {
        grid-template-columns: 1fr;
      }
      main, .header-top, .header-bottom {
        padding-left: 20px;
        padding-right: 20px;
      }
    }

    /* ==================== FOOTER ==================== */
    footer {
      background-color: #dbdbdb;
      color: #333;
      text-align: center;
      padding: 25px 0;
      font-size: 14px;
      border-top: 1px solid #ccc;
      width: 100%;
    }
  </style>
</head>
<body>

<!-- 💡 로그인 상태 테스트를 위한 임시 버튼 (실제 연동 시 지우시면 됩니다) -->
<button class="auth-toggle-btn" onclick="toggleLoginState()">🔓 현재: 로그아웃 상태 (클릭해서 로그인하기)</button>

<!-- HEADER START -->
<header>
  <!-- 상단 라인: 로고, 검색창, 로그인정보 -->
  <div class="header-top">
    <!-- 누르면 홈으로 이동 -->
    <a href="/" class="logo">사이트 이름</a>

    <!-- 검색창 -->
    <div class="search-container">
      <input type="text" placeholder="검색창">
      <i class="fa-solid fa-magnifying-glass fa-search"></i>
    </div>

    <!-- 우측 로그인 메뉴 (JS 제어를 위해 ID 부여) -->
    <div class="user-menu" id="userMenu">
      <a href="/member/login">로그인</a>
      <a href="/member/join">회원가입</a>
    </div>
  </div>

  <!-- 하단 라인: 네비게이션 바 -->
  <div class="header-bottom">
    <ul class="nav-menu">
      <li class="nav-item"><a href="/music">음악</a></li>
      <li class="nav-item"><a href="/community">커뮤니티</a></li>
      <li class="nav-item"><a href="/chat">채팅방</a></li>

      <!-- 마우스 대면 열리는 고객센터 -->
      <li class="nav-item dropdown">
        <a href="/support" style="cursor: default;">고객센터 ▾</a>
        <ul class="dropdown-menu">
          <li><a href="/support/faq">자주 묻는 질문</a></li>
          <li><a href="/support/qna">1:1 문의하기</a></li>
          <li><a href="/support/notice">공지사항</a></li>
        </ul>
      </li>
    </ul>
  </div>
</header>
<!-- HEADER END -->

<!-- 메인 컨텐츠 영역 -->
<main>
  <!-- 세션 1: 현재 라이브 중인 방송 (풍성한 카드 뷰) -->
  <section>
    <h2 class="section-title">🔴 지금 온에어 중인 DJ 라이브</h2>
    <div class="live-grid">

      <!-- 방송 카드 1 -->
      <div class="live-card">
        <div class="card-thumbnail">
          <i class="fa-solid fa-radio fa-2xl"></i> <!-- 임시 아이콘 (실제 구현시 썸네일 이미지) -->
          <span class="badge-live">LIVE</span>
          <span class="viewer-count"><i class="fa-solid fa-user"></i> 142명</span>
        </div>
        <div class="card-info">
          <h4>금요 야간 감성 시티팝 스페셜 믹싱 📻</h4>
          <p class="dj-name">DJ_Midnight</p>
        </div>
      </div>

      <!-- 방송 카드 2 -->
      <div class="live-card">
        <div class="card-thumbnail" style="background-color: #445566;">
          <i class="fa-solid fa-headphones fa-2xl"></i>
          <span class="badge-live">LIVE</span>
          <span class="viewer-count"><i class="fa-solid fa-user"></i> 89명</span>
        </div>
        <div class="card-info">
          <h4>[작업용/공부용] 잔잔한 로파이(Lo-Fi) 비트 24H</h4>
          <p class="dj-name">LoFi_Lovers</p>
        </div>
      </div>

      <!-- 방송 카드 3 -->
      <div class="live-card">
        <div class="card-thumbnail" style="background-color: #664455;">
          <i class="fa-solid fa-compact-disc fa-2xl"></i>
          <span class="badge-live">LIVE</span>
          <span class="viewer-count"><i class="fa-solid fa-user"></i> 55명</span>
        </div>
        <div class="card-info">
          <h4>신나는 하우스/EDM 클럽 사운드 한판 🔥</h4>
          <p class="dj-name">DJ_BeatDrop</p>
        </div>
      </div>

      <!-- 방송 카드 4 (공간 채우기용) -->
      <div class="live-card">
        <div class="card-thumbnail" style="background-color: #556644;">
          <i class="fa-solid fa-music fa-2xl"></i>
          <span class="badge-live">LIVE</span>
          <span class="viewer-count"><i class="fa-solid fa-user"></i> 23명</span>
        </div>
        <div class="card-info">
          <h4>신곡 탐방 - 2026년 7월 멜론 차트 정주행</h4>
          <p class="dj-name">MusicFinder</p>
        </div>
      </div>

    </div>
  </section>

  <!-- 세션 2: 노래/아티스트별 오픈 토픽 채팅방 (새로 추가된 영역) -->
  <section class="topic-chat-section">
    <h2 class="section-title">💬 아티스트 & 음악 오픈 톡방</h2>
    <div class="topic-scroll-container">

      <!-- 토픽 방 1 -->
      <div class="topic-card">
        <div class="topic-header">
          <span class="topic-tag">🎵 뉴진스 (NewJeans)</span>
          <span class="topic-user-count"><i class="fa-solid fa-users"></i> 42명</span>
        </div>
        <div class="topic-title">뉴진스 이번 컴백 타이틀곡 교차편집 영상 같이 볼 분 구함!</div>
        <div class="topic-footer">최근 대화: 하입보이는 진짜 전설이다...</div>
      </div>

      <!-- 토픽 방 2 -->
      <div class="topic-card">
        <div class="topic-header">
          <span class="topic-tag" style="background-color: #fff5f5; color: #e53e3e;">🎧 시티팝 / J-Pop</span>
          <span class="topic-user-count"><i class="fa-solid fa-users"></i> 18명</span>
        </div>
        <div class="topic-title">8090 레트로 감성 시티팝 플레이리스트 공유 및 추천방 🌆</div>
        <div class="topic-footer">최근 대화: 마츠바라 미키 노래 틀어주세요</div>
      </div>

      <!-- 토픽 방 3 -->
      <div class="topic-card">
        <div class="topic-header">
          <span class="topic-tag" style="background-color: #f0fff4; color: #38a169;">🎸 데이식스 (DAY6)</span>
          <span class="topic-user-count"><i class="fa-solid fa-users"></i> 31명</span>
        </div>
        <div class="topic-title">데이식스 콘서트 취켓팅 팁 공유하고 위로하는 방 😭</div>
        <div class="topic-footer">최근 대화: 제발 내 자리 하나만 있어라</div>
      </div>

      <!-- 토픽 방 4 -->
      <div class="topic-card">
        <div class="topic-header">
          <span class="topic-tag" style="background-color: #fefcbf; color: #b7791f;">🎹 힙합 / 국힙</span>
          <span class="topic-user-count"><i class="fa-solid fa-users"></i> 12명</span>
        </div>
        <div class="topic-title">요즘 국힙 씬 트렌드나 신인 래퍼 앨범 리뷰합시다</div>
        <div class="topic-footer">최근 대화: 이번 비트 프로듀싱 누구임?</div>
      </div>

      <!-- 토픽 방 5 (스크롤 확인용) -->
      <div class="topic-card">
        <div class="topic-header">
          <span class="topic-tag" style="background-color: #ebf8ff; color: #3182ce;">🎻 클래식/재즈</span>
          <span class="topic-user-count"><i class="fa-solid fa-users"></i> 7명</span>
        </div>
        <div class="topic-title">비 오는 날 듣기 좋은 잔잔한 재즈 피아노 수다방</div>
        <div class="topic-footer">최근 대화: Bill Evans 앨범 듣는 중요</div>
      </div>

    </div>
  </section>

  <!-- 세션 3: 메인 커뮤니티 영역 (좌: 자유게시판 / 우: 공지사항) -->
  <section class="community-split">

    <!-- 7 비율: 광장 자유 게시판 -->
    <div class="sub-box">
      <h3>
        <span>📋 광장 자유 게시판</span>
        <a href="/community" class="more-btn">더보기 <i class="fa-solid fa-chevron-right"></i></a>
      </h3>

      <div class="board-list">
        <!-- 글 1 -->
        <div class="board-item">
          <a href="#" class="post-title">오늘 퇴근길 라디오 방송 DJ분 선곡 리스트 공유합니다!<span class="reply-count">[12]</span></a>
          <div class="post-meta">
            <span class="writer">음악대장</span>
            <span class="date">11:42</span>
          </div>
        </div>
        <!-- 글 2 -->
        <div class="board-item">
          <a href="#" class="post-title">뉴진스 신곡 베이스 라인 카피해보신 분 계신가요?🐋<span class="reply-count">[4]</span></a>
          <div class="post-meta">
            <span class="writer">BassLover</span>
            <span class="date">10:15</span>
          </div>
        </div>
        <!-- 글 3 -->
        <div class="board-item">
          <a href="#" class="post-title">방구석 힙합 프로듀서인데 비트 피드백 좀 부탁드립니다.</a>
          <div class="post-meta">
            <span class="writer">MC대리</span>
            <span class="date">09:55</span>
          </div>
        </div>
        <!-- 글 4 -->
        <div class="board-item">
          <a href="#" class="post-title">재즈 입문자인데 빌 에반스 앨범 순서 추천해주세요~~<span class="reply-count">[7]</span></a>
          <div class="post-meta">
            <span class="writer">라라랜드</span>
            <span class="date">08:20</span>
          </div>
        </div>
        <!-- 글 5 -->
        <div class="board-item">
          <a href="#" class="post-title">오픈 톡방에 데이식스 방 만드신 분 적게 일하고 많이 버세요 소리질러!!</a>
          <div class="post-meta">
            <span class="writer">마이데이</span>
            <span class="date">07-19</span>
          </div>
        </div>
      </div>
    </div>

    <!-- 5 비율: 공지사항 및 안내 -->
    <div class="sub-box">
      <h3>
        <span>📢 공지사항</span>
        <a href="/support/notice" class="more-btn">더보기 <i class="fa-solid fa-chevron-right"></i></a>
      </h3>

      <div class="board-list">
        <div class="notice-item">
          <a href="#"><strong>[안내]</strong> 2026년 하반기 우수 크리에이터(DJ) 지원 사업 공모</a>
          <span class="notice-date">07-20</span>
        </div>
        <div class="notice-item">
          <a href="#"><strong>[점검]</strong> 시스템 안정화를 위한 정기 서버 점검 안내 (02:00~04:00)</a>
          <span class="notice-date">07-18</span>
        </div>
        <div class="notice-item">
          <a href="#"><strong>[규정]</strong> 오픈 토픽 채팅방 개설 및 저작권 관련 커뮤니티 이용 가이드</a>
          <span class="notice-date">07-12</span>
        </div>
        <div class="notice-item">
          <a href="#"><strong>[오픈]</strong> 음악 스트리밍 및 실시간 소통 플랫폼 베타 서비스 론칭!</a>
          <span class="notice-date">07-01</span>
        </div>
      </div>
    </div>

  </section>
</main>

<!-- FOOTER START -->
<footer>
  <p>copyright ~~~</p>
</footer>
<!-- FOOTER END -->

<!-- ==================== JAVASCRIPT ==================== -->
<script>
  // 1. 로그인 상태에 따라 헤더 우측 메뉴를 교체하는 로직
  let isLoggedIn = false; // 기본값: 로그아웃 상태

  function updateHeaderUI() {
    const userMenu = document.getElementById('userMenu');
    const toggleBtn = document.querySelector('.auth-toggle-btn');

    if (isLoggedIn) {
      // 로그인 완료 시 -> 마이페이지로 변경
      userMenu.innerHTML = `
                    <a href="/member/mypage" style="font-weight: bold; color: #007bff;">마이페이지</a>
                    <a href="#" onclick="logout(event)">로그아웃</a>
                `;
      toggleBtn.innerText = "🔒 현재: 로그인 상태 (클릭해서 로그아웃하기)";
    } else {
      // 로그아웃 상태 -> 로그인 / 회원가입 노출
      userMenu.innerHTML = `
                    <a href="/member/login">로그인</a>
                    <a href="/member/join">회원가입</a>
                `;
      toggleBtn.innerText = "🔓 현재: 로그아웃 상태 (클릭해서 로그인하기)";
    }
  }

  // 로그인/로그아웃 토글 테스트용 함수
  function toggleLoginState() {
    isLoggedIn = !isLoggedIn;
    updateHeaderUI();
  }

  function logout(e) {
    e.preventDefault();
    alert("로그아웃 되었습니다.");
    isLoggedIn = false;
    updateHeaderUI();
  }
</script>
</body>
</html>