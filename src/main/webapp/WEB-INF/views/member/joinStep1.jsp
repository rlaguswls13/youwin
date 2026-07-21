<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입</title>
  <style>
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
    }

    body {
      background-color: #f0f0f0;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }

    .join-container {
      width: 100%;
      max-width: 450px;
      padding: 40px 20px;
      text-align: center;
    }

    .join-title {
      font-size: 32px;
      font-weight: bold;
      color: #1a1a1a;
      margin-bottom: 30px;
    }

    .join-form, .form-step {
      display: flex;
      flex-direction: column;
      gap: 12px;
      text-align: left;
    }

    .hidden {
      display: none !important;
    }

    .form-group {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }

    .form-group label {
      font-size: 14px;
      font-weight: bold;
      color: #333;
    }

    .form-group input[type="text"],
    .form-group input[type="password"],
    .form-group input[type="email"],
    .form-group input[type="tel"] {
      width: 100%;
      height: 45px;
      padding: 0 15px;
      background-color: #dbdbdb;
      border: 1px solid transparent;
      outline: none;
      font-size: 15px;
      color: #333;
      transition: background-color 0.2s, border-color 0.2s;
    }

    .form-group input.input-error {
      border-color: #e74c3c;
      background-color: #fdeded;
    }

    .form-group input:focus {
      background-color: #cfcfcf;
    }

    .error-msg {
      font-size: 12px;
      color: #e74c3c;
      min-height: 18px;
      line-height: 18px;
      opacity: 0;
      transition: opacity 0.2s ease;
    }

    .error-msg.show {
      opacity: 1;
    }

    /* Step 2 스타일 */
    .profile-group { text-align: center; }
    .profile-group > label { display: block; margin-bottom: 10px; }
    .profile-section { display: flex; flex-direction: column; align-items: center; gap: 10px; }
    .profile-img-preview {
      width: 80px; height: 80px; border-radius: 50%;
      background-color: #d1d1d1; display: flex; justify-content: center; align-items: center;
      overflow: hidden;
    }
    .profile-img-preview svg { width: 100%; height: 100%; fill: #ffffff; }
    .profile-img-preview img { width: 100%; height: 100%; object-fit: cover; }
    .file-upload-btn { font-size: 12px; color: #555; cursor: pointer; }
    .file-upload-btn:hover { text-decoration: underline; }
    input[type="file"] { display: none; }

    .btn-container {
      margin-top: 10px;
      display: flex;
      justify-content: center;
    }

    .btn {
      width: 120px;
      height: 45px;
      background-color: #dbdbdb;
      border: none;
      outline: none;
      font-size: 16px;
      font-weight: bold;
      color: #333;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .btn:hover {
      background-color: #c5c5c5;
      color: #000;
    }
  </style>
</head>
<body>

<div class="join-container">
  <h1 class="join-title" id="pageTitle">회원 정보</h1>

  <form id="joinForm" action="/member/join" method="post" enctype="multipart/form-data" class="join-form" onsubmit="return false;">

    <!-- Step 1: 회원 정보 -->
    <div id="step1" class="form-step">

      <div class="form-group">
        <label for="member-id">아이디</label>
        <input type="text" id="member-id" name="memberId" placeholder="영문 시작, 영문+숫자 4~16자">
        <span class="error-msg" id="err-id"></span>
      </div>

      <div class="form-group">
        <label for="member-password">비밀번호</label>
        <input type="password" id="member-password" name="memberPassword" placeholder="8~20자, 특수문자 포함 3가지 이상 조합">
        <span class="error-msg" id="err-password"></span>
      </div>

      <div class="form-group">
        <label for="member-name">이름</label>
        <input type="text" id="member-name" name="memberName" placeholder="이름">
        <span class="error-msg" id="err-name"></span>
      </div>

      <div class="form-group">
        <label for="member-email">이메일</label>
        <input type="email" id="member-email" name="memberEmail" placeholder="이메일">
        <span class="error-msg" id="err-email"></span>
      </div>

      <div class="form-group">
        <label for="member-phone">휴대전화번호</label>
        <input type="tel" id="member-phone" name="memberPhone" placeholder="숫자만 입력 (예: 01012345678)">
        <span class="error-msg" id="err-phone"></span>
      </div>

      <div class="btn-container">
        <button type="button" class="btn" onclick="goToNextStep()">다음</button>
      </div>
    </div>

    <!-- Step 2: 회원 설정 (joinStep2.jsp 불러오기) -->
    <div id="step2" class="form-step hidden">
      <jsp:include page="joinStep2.jsp" />
    </div>

  </form>
</div>

<script>
  function showError(inputElem, errElem, message) {
    inputElem.classList.add('input-error');
    errElem.innerText = message;
    errElem.classList.add('show');
  }

  function clearError(inputElem, errElem) {
    inputElem.classList.remove('input-error');
    errElem.innerText = '';
    errElem.classList.remove('show');
  }

  // 1. 아이디 유효성 검사
  function validateId(idValue) {
    if (!idValue || idValue.trim() === '') return '아이디를 입력해 주세요.';
    if (/\s/.test(idValue)) return '아이디에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    if (!/^[a-zA-Z]/.test(idValue)) return '첫 글자는 영문이어야 합니다.';
    if (!/^[a-zA-Z0-9]{4,16}$/.test(idValue)) return '영문과 숫자로만 4~16자로 입력해 주세요.';
    if (!/[a-zA-Z]/.test(idValue) || !/[0-9]/.test(idValue)) return '영문과 숫자를 모두 포함해야 합니다.';
    return '';
  }

  // 2. 비밀번호 유효성 검사 (영문 + 숫자 + 특수문자 조합)
  function validatePassword(pwValue) {
    if (!pwValue || pwValue.trim() === '') return '비밀번호를 입력해 주세요.';
    if (/\s/.test(pwValue)) return '비밀번호에는 공백(띄어쓰기)을 포함할 수 없습니다.';

    if (pwValue.length < 8 || pwValue.length > 20) {
      return '비밀번호는 8자 이상 20자 이하로 입력해 주세요.';
    }

    const hasLetter = /[a-zA-Z]/.test(pwValue);
    const hasNumber = /[0-9]/.test(pwValue);
    const hasSpecial = /[!@#$%^&*]/.test(pwValue);

    if (!hasLetter || !hasNumber || !hasSpecial) {
      return '영문, 숫자, 특수문자(!@#$%^&*)를 모두 포함해야 합니다.';
    }

    return '';
  }

  // 3. 이름 유효성 검사
  function validateName(nameValue) {
    if (!nameValue || nameValue.trim() === '') return '이름을 입력해 주세요.';
    if (/\s/.test(nameValue)) return '이름에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    if (nameValue.length < 2 || nameValue.length > 20) return '이름은 2자 이상 20자 이하로 입력해 주세요.';
    return '';
  }

  // 4. 이메일 유효성 검사
  function validateEmail(emailValue) {
    if (!emailValue || emailValue.trim() === '') return '이메일을 입력해 주세요.';
    if (/\s/.test(emailValue)) return '이메일에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(emailValue)) return '올바른 이메일 형식이 아닙니다.';
    return '';
  }

  // 5. 전화번호 유효성 검사 (010 고정)
  function validatePhone(phoneValue) {
    if (!phoneValue || phoneValue.trim() === '') return '휴대전화번호를 입력해 주세요.';
    if (/\s/.test(phoneValue)) return '휴대전화번호에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    const phonePattern = /^010-?\d{4}-?\d{4}$/;
    if (!phonePattern.test(phoneValue)) {
      return '올바른 휴대전화번호 형식이 아닙니다. (예: 01012345678)';
    }
    return '';
  }

  // 단계 이동 및 전체 유효성 검사
  function goToNextStep() {
    const idInput = document.getElementById('member-id');
    const pwInput = document.getElementById('member-password');
    const nameInput = document.getElementById('member-name');
    const emailInput = document.getElementById('member-email');
    const phoneInput = document.getElementById('member-phone');

    const errId = document.getElementById('err-id');
    const errPw = document.getElementById('err-password');
    const errName = document.getElementById('err-name');
    const errEmail = document.getElementById('err-email');
    const errPhone = document.getElementById('err-phone');

    let isValid = true;

    // 1. 아이디
    const idMsg = validateId(idInput.value);
    if (idMsg) {
      showError(idInput, errId, idMsg);
      if (isValid) idInput.focus();
      isValid = false;
    } else {
      clearError(idInput, errId);
    }

    // 2. 비밀번호
    const pwMsg = validatePassword(pwInput.value);
    if (pwMsg) {
      showError(pwInput, errPw, pwMsg);
      if (isValid) pwInput.focus();
      isValid = false;
    } else {
      clearError(pwInput, errPw);
    }

    // 3. 이름
    const nameMsg = validateName(nameInput.value);
    if (nameMsg) {
      showError(nameInput, errName, nameMsg);
      if (isValid) nameInput.focus();
      isValid = false;
    } else {
      clearError(nameInput, errName);
    }

    // 4. 이메일
    const emailMsg = validateEmail(emailInput.value);
    if (emailMsg) {
      showError(emailInput, errEmail, emailMsg);
      if (isValid) emailInput.focus();
      isValid = false;
    } else {
      clearError(emailInput, errEmail);
    }

    // 5. 휴대전화번호
    const phoneMsg = validatePhone(phoneInput.value);
    if (phoneMsg) {
      showError(phoneInput, errPhone, phoneMsg);
      if (isValid) phoneInput.focus();
      isValid = false;
    } else {
      clearError(phoneInput, errPhone);
    }

    // 모든 검사 통과 시 Step 2 전환
    if (isValid) {
      document.getElementById('step1').classList.add('hidden');
      document.getElementById('step2').classList.remove('hidden');
      document.getElementById('pageTitle').innerText = '회원 설정';
    }
  }

  // 엔터키 입력 순차 포커스 이동 처리
  document.getElementById('joinForm').addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
      event.preventDefault();

      const step1 = document.getElementById('step1');

      if (!step1.classList.contains('hidden')) {
        const target = event.target;

        const idInput = document.getElementById('member-id');
        const pwInput = document.getElementById('member-password');
        const nameInput = document.getElementById('member-name');
        const emailInput = document.getElementById('member-email');
        const phoneInput = document.getElementById('member-phone');

        const errId = document.getElementById('err-id');
        const errPw = document.getElementById('err-password');
        const errName = document.getElementById('err-name');
        const errEmail = document.getElementById('err-email');
        const errPhone = document.getElementById('err-phone');

        // 아이디
        if (target.id === 'member-id') {
          const idMsg = validateId(idInput.value);
          if (idMsg) {
            showError(idInput, errId, idMsg);
          } else {
            clearError(idInput, errId);
            pwInput.focus();
          }
        }
        // 비밀번호
        else if (target.id === 'member-password') {
          const pwMsg = validatePassword(pwInput.value);
          if (pwMsg) {
            showError(pwInput, errPw, pwMsg);
          } else {
            clearError(pwInput, errPw);
            nameInput.focus();
          }
        }
        // 이름
        else if (target.id === 'member-name') {
          const nameMsg = validateName(nameInput.value);
          if (nameMsg) {
            showError(nameInput, errName, nameMsg);
          } else {
            clearError(nameInput, errName);
            emailInput.focus();
          }
        }
        // 이메일
        else if (target.id === 'member-email') {
          const emailMsg = validateEmail(emailInput.value);
          if (emailMsg) {
            showError(emailInput, errEmail, emailMsg);
          } else {
            clearError(emailInput, errEmail);
            phoneInput.focus();
          }
        }
        // 휴대전화번호
        else if (target.id === 'member-phone') {
          goToNextStep();
        }
      } else {
        // Step 2 활성화 상태에서 엔터키 입력 시
        submitForm();
      }
    }
  });
</script>

</body>
</html>