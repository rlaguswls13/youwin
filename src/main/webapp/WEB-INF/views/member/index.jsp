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
    /* header-top 부분을 이렇게 수정하세요 */
    .header-top {
      max-width: 1200px;
      margin: 0 auto;
      padding: 20px 20px 10px 20px;

      /* 여기서 Grid를 사용합니다 */
      display: grid;
      grid-template-columns: 1fr auto 1fr; /* 좌측, 중앙(검색), 우측 공간을 1:중앙만큼:1로 배분 */
      align-items: center; /* 세로 중앙 정렬 */
    }

    /* 로고를 왼쪽으로 붙이기 */
    .logo {
      justify-self: start;
    }

    /* 2. 검색창 영역 */
    .search-container {
      justify-self: center; /* 이게 핵심! 무조건 중앙에 고정됩니다 */
      width: 300px;
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
      max-width: 1200px;
      margin: 0 auto;
      padding: 10px 20px;
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


    /* ==================== CONTENT ==================== */
    main {
      flex: 1; /* 푸터가 바닥에 붙어있도록 유연하게 확장 */
      max-width: 1200px;
      width: 100%;
      margin: 0 auto;
      padding: 50px 20px;
      text-align: center;
    }

    .welcome-box {
      background-color: #fff;
      border: 1px solid #ddd;
      padding: 100px 20px;
      border-radius: 8px;
    }


    /* ==================== FOOTER ==================== */
    footer {
      background-color: #dbdbdb; /* 스케치와 동일한 조금 진한 회색 */
      color: #333;
      text-align: center;
      padding: 20px 0;
      font-size: 14px;
      border-top: 1px solid #ccc;
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
  <div class="welcome-box">
    <h2>메인 화면 영역</h2>
    <p style="margin-top: 10px; color: #666;">헤더와 푸터를 깔끔하게 적용한 기본 뼈대입니다.</p>
  </div>
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
                    <a href="/mypage" style="font-weight: bold; color: #007bff;">마이페이지</a>
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