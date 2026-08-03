<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />

<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입 | Youwin</title>

  <style>
    * { margin: 0; padding: 0; box-sizing: border-box; }
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
    .hidden { display: none !important; }
    .form-group { display: flex; flex-direction: column; gap: 6px; }
    .form-group label { font-size: 14px; font-weight: bold; color: #333; }
    .input-with-btn { display: flex; gap: 8px; position: relative; }
    .input-with-btn input[type="text"],
    .input-with-btn input[type="email"] { flex: 1; }

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
    .form-group input.input-error { border-color: #e74c3c; background-color: #fdeded; }
    .form-group input.input-success { border-color: #2ecc71; background-color: #eafaf1; }
    .form-group input:focus { background-color: #cfcfcf; }

    .error-msg {
      font-size: 12px;
      color: #e74c3c;
      min-height: 18px;
      line-height: 18px;
      opacity: 0;
      transition: opacity 0.2s ease;
    }
    .error-msg.show { opacity: 1; }
    .error-msg.success-msg { color: #27ae60; }

    /* 타이머 스타일 */
    .timer-text {
      position: absolute;
      right: 105px;
      top: 13px;
      font-size: 13px;
      color: #e74c3c;
      font-weight: bold;
    }

    .btn-container { margin-top: 10px; display: flex; justify-content: center; }
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
    .btn-check {
      width: 90px;
      height: 45px;
      background-color: #dbdbdb;
      border: none;
      outline: none;
      font-size: 13px;
      font-weight: bold;
      color: #333;
      cursor: pointer;
      white-space: nowrap;
      transition: all 0.2s ease;
    }
    .btn:hover, .btn-check:hover { background-color: #c5c5c5; color: #000; }

    /* 프로필 이미지 스타일 */
    .profile-group { text-align: center; margin-bottom: 10px; }
    .profile-section { display: flex; flex-direction: column; align-items: center; gap: 12px; }
    .profile-img-preview {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      overflow: hidden;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #f0f0f0;
      border: 4px solid #6366f1;
      box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
      flex-shrink: 0;
    }
    .profile-img-preview img { width: 100%; height: 100%; object-fit: cover; }
    .file-upload-btn {
      font-size: 13px;
      color: #6366f1;
      font-weight: bold;
      cursor: pointer;
      transition: color 0.2s ease;
    }
    .file-upload-btn:hover { text-decoration: underline; color: #4f46e5; }
    input[type="file"] { display: none; }
  </style>
</head>
<body>

<div class="join-container">
  <h1 class="join-title" id="pageTitle">회원 정보</h1>

  <form id="joinForm" action="${ctx}/member/join" method="post" enctype="multipart/form-data" class="join-form" onsubmit="return false;">

    <!-- ==================== Step 1: 기본 회원 정보 ==================== -->
    <div id="step1" class="form-step">

      <!-- 아이디 -->
      <div class="form-group">
        <label for="member-id">아이디</label>
        <div class="input-with-btn">
          <input type="text" id="member-id" name="memberId" placeholder="영문 시작, 영문+숫자 4~16자">
          <button type="button" class="btn-check" id="btn-check-id" onclick="checkDuplicateId()">중복확인</button>
        </div>
        <span class="error-msg" id="err-id"></span>
      </div>

      <!-- 비밀번호 -->
      <div class="form-group">
        <label for="member-password">비밀번호</label>
        <input type="password" id="member-password" name="memberPassword" placeholder="8~20자, 특수문자 포함 3가지 이상 조합">
        <span class="error-msg" id="err-password"></span>
      </div>

      <!-- 이름 -->
      <div class="form-group">
        <label for="member-name">이름</label>
        <input type="text" id="member-name" name="memberName" placeholder="이름">
        <span class="error-msg" id="err-name"></span>
      </div>

      <!-- 이메일 및 인증 요청 -->
      <div class="form-group">
        <label for="member-email">이메일</label>
        <div class="input-with-btn">
          <input type="email" id="member-email" name="memberEmail" placeholder="이메일">
          <button type="button" class="btn-check" id="btn-send-code" onclick="sendAuthCode()">인증 요청</button>
        </div>
        <span class="error-msg" id="err-email"></span>
      </div>

      <!-- 이메일 인증번호 입력 (기본 hidden) -->
      <div class="form-group hidden" id="auth-code-group">
        <label for="auth-code">인증번호</label>
        <div class="input-with-btn">
          <input type="text" id="auth-code" maxlength="6" placeholder="인증번호 6자리">
          <span class="timer-text" id="timer">05:00</span>
          <button type="button" class="btn-check" id="btn-verify-code" onclick="verifyAuthCode()">확인</button>
        </div>
        <span class="error-msg" id="err-auth-code"></span>
      </div>

      <!-- 휴대전화번호 -->
      <div class="form-group">
        <label for="member-phone">휴대전화번호</label>
        <input type="tel" id="member-phone" name="memberPhone" maxlength="11" placeholder="숫자만 입력 (예: 01012345678)">
        <span class="error-msg" id="err-phone"></span>
      </div>

      <div class="btn-container">
        <button type="button" class="btn" onclick="goToNextStep()">다음</button>
      </div>
    </div>

    <!-- ==================== Step 2: 프로필 & 닉네임 설정 (Include) ==================== -->
    <div id="step2" class="form-step hidden">
      <jsp:include page="joinStep2.jsp" />
    </div>

  </form>
</div>

<script>
  let isIdChecked = false;
  let isEmailVerified = false;
  let timerInterval = null;

  /* ----------------------------------------------------
   * 공통 에러/성공 메시지 바인딩 헬퍼
   * ---------------------------------------------------- */
  function showError(inputElem, errElem, message) {
    inputElem.classList.remove('input-success');
    inputElem.classList.add('input-error');
    errElem.classList.remove('success-msg');
    errElem.innerText = message;
    errElem.classList.add('show');
  }

  function showSuccess(inputElem, errElem, message) {
    inputElem.classList.remove('input-error');
    inputElem.classList.add('input-success');
    errElem.classList.add('success-msg');
    errElem.innerText = message;
    errElem.classList.add('show');
  }

  function clearError(inputElem, errElem) {
    inputElem.classList.remove('input-error', 'input-success');
    errElem.innerText = '';
    errElem.classList.remove('show', 'success-msg');
  }

  function checkField(inputElem, errElem, validateFn) {
    const msg = validateFn(inputElem.value);
    if (msg) {
      showError(inputElem, errElem, msg);
      return false;
    } else {
      clearError(inputElem, errElem);
      return true;
    }
  }

  /* ----------------------------------------------------
   * 유효성 검증 정규식 규칙
   * ---------------------------------------------------- */
  function validateId(idValue) {
    if (!idValue || idValue.trim() === '') return '아이디를 입력해 주세요.';
    if (/\s/.test(idValue)) return '아이디에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    if (!/^[a-zA-Z]/.test(idValue)) return '첫 글자는 영문이어야 합니다.';
    if (!/^[a-zA-Z0-9]{4,16}$/.test(idValue)) return '영문과 숫자로만 4~16자로 입력해 주세요.';
    if (!/[a-zA-Z]/.test(idValue) || !/[0-9]/.test(idValue)) return '영문과 숫자를 모두 포함해야 합니다.';
    return '';
  }

  function validatePassword(pwValue) {
    if (!pwValue || pwValue.trim() === '') return '비밀번호를 입력해 주세요.';
    if (/\s/.test(pwValue)) return '비밀번호에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    if (pwValue.length < 8 || pwValue.length > 20) return '비밀번호는 8자 이상 20자 이하로 입력해 주세요.';

    const hasLetter = /[a-zA-Z]/.test(pwValue);
    const hasNumber = /[0-9]/.test(pwValue);
    const hasSpecial = /[!@#$%^&*]/.test(pwValue);

    if (!hasLetter || !hasNumber || !hasSpecial) {
      return '영문, 숫자, 특수문자(!@#$%^&*)를 모두 포함해야 합니다.';
    }
    return '';
  }

  function validateName(nameValue) {
    if (!nameValue || nameValue.trim() === '') return '이름을 입력해 주세요.';
    if (/\s/.test(nameValue)) return '이름에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    if (nameValue.length < 2 || nameValue.length > 20) return '이름은 2자 이상 20자 이하로 입력해 주세요.';
    return '';
  }

  function validateEmail(emailValue) {
    if (!emailValue || emailValue.trim() === '') return '이메일을 입력해 주세요.';
    if (/\s/.test(emailValue)) return '이메일에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailPattern.test(emailValue)) return '올바른 이메일 형식이 아닙니다.';
    return '';
  }

  function validatePhone(phoneValue) {
    if (!phoneValue || phoneValue.trim() === '') return '휴대전화번호를 입력해 주세요.';
    if (/\s/.test(phoneValue)) return '휴대전화번호에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    const phonePattern = /^010-?\d{4}-?\d{4}$/;
    if (!phonePattern.test(phoneValue)) {
      return '올바른 휴대전화번호 형식이 아닙니다. (예: 01012345678)';
    }
    return '';
  }

  /* ----------------------------------------------------
   * Ajax 연동 로직
   * ---------------------------------------------------- */
  // 아이디 중복 확인
  function checkDuplicateId() {
    const idInput = document.getElementById('member-id');
    const errId = document.getElementById('err-id');
    const idValue = idInput.value;

    const msg = validateId(idValue);
    if (msg) {
      showError(idInput, errId, msg);
      isIdChecked = false;
      return;
    }

    fetch('${ctx}/api/member/check-id?memberId=' + encodeURIComponent(idValue))
            .then(response => {
              if (!response.ok) throw new Error('서버 응답 오류');
              return response.json();
            })
            .then(isDuplicate => {
              if (isDuplicate) {
                showError(idInput, errId, '이미 사용 중인 아이디입니다.');
                isIdChecked = false;
              } else {
                showSuccess(idInput, errId, '사용 가능한 아이디입니다.');
                isIdChecked = true;
              }
            })
            .catch(error => {
              console.error('Error:', error);
              showError(idInput, errId, '중복 확인 중 오류가 발생했습니다.');
              isIdChecked = false;
            });
  }

  // 이메일 인증번호 발송
  function sendAuthCode() {
    const emailInput = document.getElementById('member-email');
    const errEmail = document.getElementById('err-email');
    const emailVal = emailInput.value;

    const msg = validateEmail(emailVal);
    if (msg) {
      showError(emailInput, errEmail, msg);
      return;
    }

    fetch('${ctx}/api/member/check-email?memberEmail=' + encodeURIComponent(emailVal))
            .then(res => res.json())
            .then(isDuplicate => {
              if (isDuplicate) {
                showError(emailInput, errEmail, '이미 가입된 이메일입니다.');
              } else {
                showSuccess(emailInput, errEmail, '인증번호 발송 중...');

                fetch('${ctx}/api/member/send-code', {
                  method: 'POST',
                  headers: { 'Content-Type': 'application/json' },
                  body: JSON.stringify({ memberEmail: emailVal })
                })
                        .then(res => res.json())
                        .then(data => {
                          if (data.success) {
                            showSuccess(emailInput, errEmail, '인증번호가 발송되었습니다.');
                            document.getElementById('auth-code-group').classList.remove('hidden');
                            document.getElementById('auth-code').focus();
                            startTimer(300); // 5분
                          } else {
                            showError(emailInput, errEmail, data.message);
                          }
                        });
              }
            });
  }

  // 인증번호 검증
  function verifyAuthCode() {
    const emailVal = document.getElementById('member-email').value;
    const codeInput = document.getElementById('auth-code');
    const errCode = document.getElementById('err-auth-code');

    if (!codeInput.value || codeInput.value.length !== 6) {
      showError(codeInput, errCode, '6자리 인증번호를 입력해 주세요.');
      return;
    }

    fetch('${ctx}/api/member/verify-code', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ memberEmail: emailVal, code: codeInput.value })
    })
            .then(res => res.json())
            .then(data => {
              if (data.success) {
                showSuccess(codeInput, errCode, '이메일 인증이 완료되었습니다.');
                isEmailVerified = true;
                clearInterval(timerInterval);
                document.getElementById('timer').innerText = '';
                document.getElementById('member-email').readOnly = true;
                codeInput.readOnly = true;
                document.getElementById('member-phone').focus();
              } else {
                showError(codeInput, errCode, data.message);
                isEmailVerified = false;
              }
            });
  }

  /* ----------------------------------------------------
   * 타이머 & 이벤트 핸들러
   * ---------------------------------------------------- */
  function startTimer(duration) {
    let timer = duration, minutes, seconds;
    clearInterval(timerInterval);
    timerInterval = setInterval(function () {
      minutes = parseInt(timer / 60, 10);
      seconds = parseInt(timer % 60, 10);
      minutes = minutes < 10 ? "0" + minutes : minutes;
      seconds = seconds < 10 ? "0" + seconds : seconds;

      document.getElementById('timer').innerText = minutes + ":" + seconds;

      if (--timer < 0) {
        clearInterval(timerInterval);
        document.getElementById('timer').innerText = "만료";
        showError(document.getElementById('auth-code'), document.getElementById('err-auth-code'), '인증시간이 만료되었습니다. 재발송 해주세요.');
      }
    }, 1000);
  }

  document.getElementById('member-id').addEventListener('input', function() {
    isIdChecked = false;
    clearError(this, document.getElementById('err-id'));
  });

  document.getElementById('member-email').addEventListener('input', function() {
    isEmailVerified = false;
    clearError(this, document.getElementById('err-email'));
  });

  // 다음 단계 이동 처리
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

    let isIdValid = checkField(idInput, errId, validateId);
    if (isIdValid && !isIdChecked) {
      showError(idInput, errId, '아이디 중복확인을 진행해 주세요.');
      isIdValid = false;
    }

    const isPwValid = checkField(pwInput, errPw, validatePassword);
    const isNameValid = checkField(nameInput, errName, validateName);

    let isEmailValid = checkField(emailInput, errEmail, validateEmail);
    if (isEmailValid && !isEmailVerified) {
      showError(emailInput, errEmail, '이메일 인증을 완료해 주세요.');
      isEmailValid = false;
    }
    const isPhoneValid = checkField(phoneInput, errPhone, validatePhone);

    if (!isIdValid) idInput.focus();
    else if (!isPwValid) pwInput.focus();
    else if (!isNameValid) nameInput.focus();
    else if (!isEmailValid) emailInput.focus();
    else if (!isPhoneValid) phoneInput.focus();

    if (isIdValid && isPwValid && isNameValid && isEmailValid && isPhoneValid) {
      document.getElementById('step1').classList.add('hidden');
      document.getElementById('step2').classList.remove('hidden');
      document.getElementById('pageTitle').innerText = '회원 설정';
    }
  }

  // 엔터키 연속 입력 처리
  document.getElementById('joinForm').addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
      event.preventDefault();

      const target = event.target;
      const step1 = document.getElementById('step1');

      if (!step1.classList.contains('hidden')) {
        const pwInput = document.getElementById('member-password');
        const nameInput = document.getElementById('member-name');
        const emailInput = document.getElementById('member-email');
        const phoneInput = document.getElementById('member-phone');

        if (target.id === 'member-id') {
          if (isIdChecked) pwInput.focus();
          else checkDuplicateId();
        } else if (target.id === 'member-password') {
          if (checkField(pwInput, document.getElementById('err-password'), validatePassword)) nameInput.focus();
        } else if (target.id === 'member-name') {
          if (checkField(nameInput, document.getElementById('err-name'), validateName)) emailInput.focus();
        } else if (target.id === 'member-email') {
          sendAuthCode();
        } else if (target.id === 'auth-code') {
          verifyAuthCode();
        } else if (target.id === 'member-phone') {
          if (checkField(phoneInput, document.getElementById('err-phone'), validatePhone)) goToNextStep();
        }
      } else {
        if (target.id === 'nickname') {
          if (typeof isNicknameChecked !== 'undefined' && isNicknameChecked) {
            submitForm();
          } else {
            checkDuplicateNickname();
          }
        } else {
          submitForm();
        }
      }
    }
  });
</script>

</body>
</html>