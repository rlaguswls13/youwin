<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>
    <!-- 카카오 SDK -->
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

        .title {
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 30px;
            color: #000;
        }

        .wrapper {
            width: 100%;
            max-width: 440px;
        }

        .login-container {
            background-color: #dcdcdc;
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

        /* 비밀번호 아래 에러 메시지 스타일 */
        .error-msg {
            display: none; /* 기본 상태에서는 안 보임 */
            color: #ff4d4f;
            font-size: 13px;
            margin-top: 6px;
            margin-bottom: 12px; /* 자동 로그인 체크박스를 자연스럽게 밀어냄 */
            line-height: 1.4;
        }

        /* 메시지가 없을 때 자동 로그인과 비밀번호 입력창 사이의 기본 간격 유지 */
        .checkbox-group {
            margin-top: 10px; /* 약간 더 내려가도록 조절 */
        }

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

        .btn-kakao {
            width: 100%;
            padding: 14px;
            background-color: #FEE500;
            color: #191919;
            border: 2px solid #000;
            border-radius: 30px;
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
    </style>
</head>
<body>

<div class="title">어서오세요~!</div>

<div class="wrapper">
    <div class="login-container">
        <!-- 일반 Controller(@PostMapping("/member/login"))로 전송 -->
        <form id="loginForm" action="/member/login" method="POST">

            <div class="input-group">
                <label for="memberId">아이디</label>
                <input type="text" id="memberId" name="memberId" value="${savedMemberId}" required placeholder="아이디를 입력하세요">
            </div>

            <div class="input-group">
                <label for="memberPassword">비밀번호</label>
                <input type="password" id="memberPassword" name="memberPassword" required placeholder="비밀번호를 입력하세요">
            </div>

            <!-- 🎯 비밀번호 아래 에러 메시지 영역 -->
            <div id="loginErrorMsg" class="error-msg"></div>

            <div class="checkbox-group">
                <input type="checkbox" id="autoLogin" name="autoLogin" value="true">
                <label for="autoLogin">자동 로그인 유지</label>
            </div>

            <button type="submit" class="btn-submit">로그인</button>
        </form>

        <button type="button" id="kakaoLoginBtn" class="btn-kakao">
            <svg width="22" height="22" viewBox="0 0 24 24" fill="currentColor">
                <path d="M12 3c-5.523 0-10 3.866-10 8.634 0 3.033 1.815 5.698 4.545 7.221-.194.721-.698 2.614-.8 3.03-.128.523.197.516.416.37.172-.115 2.733-1.855 3.822-2.592.651.091 1.32.139 2.017.139 5.523 0-10-3.866 10-8.634 0-4.768-4.477-8.634-10-8.634z"/>
            </svg>
            카카오 로그인
        </button>
    </div>

    <div class="footer-links">
        <a href="/member/findId">아이디 찾기</a>
        <span class="bar">|</span>
        <a href="/member/findPw">비밀번호 찾기</a>
        <span class="bar">|</span>
        <a href="/member/joinStep1">회원가입</a>
    </div>
</div>

<!-- 🎯 실패 메시지 수신 및 출력용 스크립트 -->
<script>
    const serverError = "${errorMessage}";
    if (serverError) {
        const errorDiv = document.getElementById("loginErrorMsg");
        errorDiv.textContent = serverError;
        errorDiv.style.display = "block"; // 에러가 있을 때만 보이게 설정
    }
</script>

</body>
</html>