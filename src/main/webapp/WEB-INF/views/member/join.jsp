<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입 - 회원 정보</title>
  <style>
    /* 기본 스타일 초기화 */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Malgun Gothic', sans-serif;
    }

    body {
      background-color: #f0f0f0; /* 스케치와 동일한 연한 회색 배경 */
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }

    /* 회원가입 카드 컨테이너 */
    .join-container {
      width: 100%;
      max-width: 450px;
      padding: 40px 20px;
      text-align: center;
    }

    /* 타이틀 */
    .join-title {
      font-size: 32px;
      font-weight: bold;
      color: #1a1a1a;
      margin-bottom: 40px;
      letter-spacing: -0.5px;
    }

    /* 폼 레이아웃 */
    .join-form {
      display: flex;
      flex-direction: column;
      gap: 20px; /* 각 입력 블록 사이의 간격 */
      text-align: left; /* 라벨과 입력창은 왼쪽 정렬 */
    }

    /* 입력 폼 그룹 (라벨 + 인풋) */
    .form-group {
      display: flex;
      flex-direction: column;
      gap: 6px; /* 라벨과 인풋창 사이의 간격 */
    }

    .form-group label {
      font-size: 14px;
      font-weight: bold;
      color: #333;
    }

    /* 입력창 스타일 (스케치의 회색 인풋창 구현) */
    .form-group input {
      width: 100%;
      height: 45px;
      padding: 0 15px;
      background-color: #dbdbdb; /* 스케치와 동일한 회색 배경 */
      border: none;
      outline: none;
      font-size: 15px;
      color: #333;
      transition: background-color 0.2s ease;
    }

    /* 입력창 마우스 올리거나 클릭했을 때 효과 */
    .form-group input:focus {
      background-color: #cfcfcf;
      border: 1px solid #999;
    }

    /* 다음 버튼 영역 */
    .btn-container {
      margin-top: 35px;
      display: flex;
      justify-content: center;
    }

    /* 다음 버튼 스타일 */
    .next-btn {
      width: 120px;
      height: 45px;
      background-color: #dbdbdb; /* 스케치의 기본 회색 버튼 */
      border: none;
      outline: none;
      font-size: 16px;
      font-weight: bold;
      color: #333;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    /* 다음 버튼 호버 효과 */
    .next-btn:hover {
      background-color: #c5c5c5;
      color: #000;
    }
  </style>
</head>
<body>

<div class="join-container">
  <!-- 타이틀 -->
  <h1 class="join-title">회원 정보</h1>

  <!-- 회원가입 폼 (POST 전송) -->
  <form action="/member/join" method="post" class="join-form">

    <!-- 아이디 -->
    <div class="form-group">
      <label for="username">아이디</label>
      <input type="text" id="username" name="username" required placeholder="아이디">
    </div>

    <!-- 비밀번호 -->
    <div class="form-group">
      <label for="password">비밀번호</label>
      <input type="password" id="password" name="password" required placeholder="비밀번호">
    </div>

    <!-- 이름 -->
    <div class="form-group">
      <label for="name">이름</label>
      <input type="text" id="name" name="name" required placeholder="이름">
    </div>

    <!-- 이메일 -->
    <div class="form-group">
      <label for="email">이메일</label>
      <input type="email" id="email" name="email" required placeholder="이메일">
    </div>

    <!-- 전화번호 -->
    <div class="form-group">
      <label for="phone">휴대전화번호</label>
      <input type="tel" id="phone" name="phone" required placeholder="휴대전화번호">
    </div>

    <!-- 다음 버튼 -->
    <div class="btn-container">
      <button type="submit" class="next-btn">다음</button>
    </div>

  </form>
</div>

</body>
</html>