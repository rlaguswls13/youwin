<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>로그인 화면 예제</title>
  <!-- 카카오 SDK 포함 -->
  <script src="https://t1.kakaocdn.net/kakao_js_sdk/2.7.2/kakao.min.js"
          integrity="sha384-TiCUE00h649CAMonG018J2mWZupSD96bUwf64W/XkR62qnXtWUqgHXRE3eGo3nFo"
          crossorigin="anonymous"></script>
  <style>
    * {
      box-sizing: border-box;
      margin: 0;
      padding: 0;
      font-family: 'Malgun Gothic', sans-serif;
    }
    body {
      background-color: #f5f5f5;
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
      height: 100vh;
    }

    /* 상단 어서오세요 타이틀 */
    .title {
      font-size: 36px;
      font-weight: bold;
      margin-bottom: 30px;
      color: #000;
    }

    /* 전체를 감싸는 영역 */
    .wrapper {
      width: 100%;
      max-width: 440px;
    }

    /* 메인 로그인 회색 박스 */
    .login-container {
      background-color: #dcdcdc; /* 이미지의 연한 회색 배경 반영 */
      padding: 40px;
      border: 1px solid #999;
      width: 100%;
    }

    .input-group {
      margin-bottom: 20px;
    }
    .input-group label {
      display: block;
      margin-bottom: 8px;
      color: #000;
      font-size: 14px;
      font-weight: bold;
    }
    .input-group input {
      width: 100%;
      padding: 14px;
      border: none;
      background-color: #fff;
      font-size: 14px;
    }

    /* 자동 로그인 체크박스 영역 */
    .checkbox-group {
      display: flex;
      align-items: center;
      margin-bottom: 24px;
    }
    .checkbox-group input {
      margin-right: 8px;
      width: 16px;
      height: 16px;
      cursor: pointer;
    }
    .checkbox-group label {
      font-size: 14px;
      color: #333;
      cursor: pointer;
    }

    /* 일반 로그인 버튼 */
    .btn-submit {
      width: 100%;
      padding: 14px;
      background-color: transparent;
      color: #000;
      border: none;
      font-size: 22px;
      font-weight: bold;
      cursor: pointer;
      margin-bottom: 10px;
      text-align: center;
    }
    .btn-submit:hover {
      opacity: 0.7;
    }

    /* 카카오 로그인 버튼 (타원형 형태 적용) */
    .btn-kakao {
      width: 100%;
      padding: 14px;
      background-color: #FEE500;
      color: #191919;
      border: 2px solid #000;
      border-radius: 30px; /* 둥근 타원형 스타일 적용 */
      font-size: 20px;
      font-weight: bold;
      cursor: pointer;
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 10px;
    }
    .btn-kakao:hover {
      background-color: #E6CF00;
    }

    /* 하단 링크 영역 (아이디/비밀번호 찾기, 회원가입) */
    .footer-links {
      display: flex;
      justify-content: center;
      align-items: center;
      margin-top: 25px;
      gap: 15px;
    }
    .footer-links a {
      color: #000;
      text-decoration: none;
      font-size: 14px;
      font-weight: bold;
    }
    .footer-links a:hover {
      text-decoration: underline;
    }
    .footer-links .bar {
      color: #aaa;
      font-size: 14px;
    }

    /* 로그인 완료 화면 */
    .welcome-screen {
      display: none;
      background-color: #fff;
      padding: 40px;
      border: 1px solid #999;
      text-align: center;
      width: 100%;
    }
    .welcome-screen h3 {
      margin-bottom: 16px;
      color: #28a745;
    }
    .welcome-screen button {
      width: 100%;
      padding: 12px;
      background-color: #dc3545;
      color: white;
      border: none;
      font-size: 16px;
      cursor: pointer;
      margin-top: 20px;
    }
  </style>
</head>
<body>

<div class="title">어서오세요~!</div>

<div class="wrapper">
  <!-- 로그인 박스 영역 -->
  <div id="loginArea">
    <div class="login-container">
      <form id="loginForm">
        <div class="input-group">
          <label for="username">아이디</label>
          <input type="text" id="username" required>
        </div>
        <div class="input-group">
          <label for="password">비밀번호</label>
          <input type="password" id="password" required>
        </div>
        <div class="checkbox-group">
          <input type="checkbox" id="autoLogin">
          <label for="autoLogin">자동 로그인 유지</label>
        </div>
        <button type="submit" class="btn-submit">로그인</button>
      </form>

      <!-- 카카오 로그인 버튼 -->
      <button id="kakaoLoginBtn" class="btn-kakao">
        <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
          <path d="M12 3c-5.523 0-10 3.866-10 8.634 0 3.033 1.815 5.698 4.545 7.221-.194.721-.698 2.614-.8 3.03-.128.523.197.516.416.37.172-.115 2.733-1.855 3.822-2.592.651.091 1.32.139 2.017.139 5.523 0 10-3.866 10-8.634 0-4.768-4.477-8.634-10-8.634z"/>
        </svg>
        카카오 로그인
      </button>
    </div>

    <!-- 이미지에 있던 하단 보조 메뉴 (박스 바깥에 위치) -->
    <div class="footer-links">
      <a href="#find-id">아이디 찾기</a>
      <span class="bar">|</span>
      <a href="#find-pw">비밀번호 찾기</a>
      <span class="bar">|</span>
      <a href="#register">회원가입</a>
    </div>
  </div>

  <!-- 로그인 성공 후 화면 -->
  <div id="welcomeScreen" class="welcome-screen">
    <h3>로그인 성공!</h3>
    <p><span id="userDisplay"></span>님, 환영합니다.</p>
    <button id="logoutBtn">로그아웃</button>
  </div>
</div>

<script>
  // ⚠️ 카카오 JavaScript 키 설정 부분
  Kakao.init('YOUR_KAKAO_JAVASCRIPT_KEY');

  const loginArea = document.getElementById('loginArea');
  const loginForm = document.getElementById('loginForm');
  const welcomeScreen = document.getElementById('welcomeScreen');
  const usernameInput = document.getElementById('username');
  const autoLoginCheckbox = document.getElementById('autoLogin');
  const userDisplay = document.getElementById('userDisplay');
  const logoutBtn = document.getElementById('logoutBtn');
  const kakaoLoginBtn = document.getElementById('kakaoLoginBtn');

  // 페이지 로드 시 자동 로그인 여부 확인
  window.addEventListener('DOMContentLoaded', () => {
    const savedUser = localStorage.getItem('autoLoginUser');
    if (savedUser) {
      showWelcomeScreen(savedUser);
    }
  });

  // 일반 로그인 처리
  loginForm.addEventListener('submit', (e) => {
    e.preventDefault();
    handleLoginSuccess(usernameInput.value);
  });

  // 카카오 로그인 기능
  kakaoLoginBtn.addEventListener('click', () => {
    Kakao.Auth.login({
      success: function(authObj) {
        Kakao.API.request({
          url: '/v2/user/me',
          success: function(res) {
            const kakaoNickname = res.properties.nickname + " (카카오)";
            handleLoginSuccess(kakaoNickname);
          },
          fail: function(error) {
            alert('카카오 정보를 가져오는데 실패했습니다.');
          }
        });
      },
      fail: function(err) {
        alert('카카오 로그인 실패');
      }
    });
  });

  function handleLoginSuccess(username) {
    if (autoLoginCheckbox.checked) {
      localStorage.setItem('autoLoginUser', username);
    }
    showWelcomeScreen(username);
  }

  logoutBtn.addEventListener('click', () => {
    localStorage.removeItem('autoLoginUser');
    if (Kakao.Auth.getAccessToken()) {
      Kakao.Auth.logout();
    }
    loginForm.reset();
    welcomeScreen.style.display = 'none';
    loginArea.style.display = 'block';
  });

  function showWelcomeScreen(username) {
    userDisplay.innerText = username;
    loginArea.style.display = 'none';
    welcomeScreen.style.display = 'block';
  }
</script>

</body>
</html>