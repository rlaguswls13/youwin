<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인</title>

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

            <!-- 비밀번호 아래 에러 메시지 영역 -->
            <div id="loginErrorMsg" class="error-msg"></div>

            <c:if test="${param.error == 'true'}">
                <div class="error-msg" style="display:block;">
                        ${param.exception}
                </div>
            </c:if>

            <div class="checkbox-group">
                <input type="checkbox" id="remember-me" name="remember-me" value="true">
                <label for="remember-me">자동 로그인 유지</label>
            </div>

            <button type="submit" class="btn-submit">로그인</button>
        </form>
    </div>

    <div class="footer-links">
        <a href="/member/findId">아이디 찾기</a>
        <span class="bar">|</span>
        <a href="/member/findPassword">비밀번호 찾기</a>
        <span class="bar">|</span>
        <a href="/member/joinStep1">회원가입</a>
    </div>
</div>

</body>
</html>