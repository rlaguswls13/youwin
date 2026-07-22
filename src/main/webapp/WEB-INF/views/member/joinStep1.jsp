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

    /* Input + Button 가로 정렬 컨테이너 */
    .input-with-btn {
      display: flex;
      gap: 8px;
    }

    .input-with-btn input[type="text"] {
      flex: 1;
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

    .form-group input.input-success {
      border-color: #2ecc71;
      background-color: #eafaf1;
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

    .error-msg.success-msg {
      color: #27ae60;
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

    .btn:hover, .btn-check:hover {
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
        <div class="input-with-btn">
          <input type="text" id="member-id" name="memberId" placeholder="영문 시작, 영문+숫자 4~16자">
          <button type="button" class="btn-check" id="btn-check-id" onclick="checkDuplicateId()">중복확인</button>
        </div>
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
  let isIdChecked = false;

  // 공통 메시지 표시 함수
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

  // 🎯 [공통 헬퍼] 입력 요소 1개를 검사하고 화면 에러 처리를 전담하는 함수
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

  // 유효성 검사 규칙들
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

  // 아이디 중복 체크 (Ajax 연동)
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

    fetch('/api/member/check-id?memberId=' + encodeURIComponent(idValue))
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

  // 아이디 값이 바뀌면 중복검사 상태 초기화
  document.getElementById('member-id').addEventListener('input', function() {
    isIdChecked = false;
    clearError(this, document.getElementById('err-id'));
  });

  // 다음 단계 이동 및 전체 유효성 검사
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

    // 각 필드 일괄 검사
    let isIdValid = checkField(idInput, errId, validateId);
    if (isIdValid && !isIdChecked) {
      showError(idInput, errId, '아이디 중복확인을 진행해 주세요.');
      isIdValid = false;
    }

    const isPwValid = checkField(pwInput, errPw, validatePassword);
    const isNameValid = checkField(nameInput, errName, validateName);
    const isEmailValid = checkField(emailInput, errEmail, validateEmail);
    const isPhoneValid = checkField(phoneInput, errPhone, validatePhone);

    // 첫 번째로 실패한 항목으로 포커스 이동
    if (!isIdValid) idInput.focus();
    else if (!isPwValid) pwInput.focus();
    else if (!isNameValid) nameInput.focus();
    else if (!isEmailValid) emailInput.focus();
    else if (!isPhoneValid) phoneInput.focus();

    // 모두 통과 시 Step 2 전환
    if (isIdValid && isPwValid && isNameValid && isEmailValid && isPhoneValid) {
      document.getElementById('step1').classList.add('hidden');
      document.getElementById('step2').classList.remove('hidden');
      document.getElementById('pageTitle').innerText = '회원 설정';
    }
  }

  // 엔터키 순차 포커스 이동 처리
  document.getElementById('joinForm').addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
      event.preventDefault();

      // 🎯 [수정 1] target 변수를 최상단으로 이동 (Step 1, Step 2 공용)
      const target = event.target;
      const step1 = document.getElementById('step1');

      // ----------------------------------------------------
      // [Step 1] 회원정보 입력 단계
      // ----------------------------------------------------
      if (!step1.classList.contains('hidden')) {

        const pwInput = document.getElementById('member-password');
        const nameInput = document.getElementById('member-name');
        const emailInput = document.getElementById('member-email');
        const phoneInput = document.getElementById('member-phone');

        if (target.id === 'member-id') {
          if (isIdChecked) {
            pwInput.focus(); // 이미 중복확인 통과했으면 다음 칸 이동
          } else {
            checkDuplicateId(); // 안 했으면 중복확인 실행!
          }
        }
        else if (target.id === 'member-password') {
          if (checkField(pwInput, document.getElementById('err-password'), validatePassword)) {
            nameInput.focus();
          }
        }
        else if (target.id === 'member-name') {
          if (checkField(nameInput, document.getElementById('err-name'), validateName)) {
            emailInput.focus();
          }
        }
        else if (target.id === 'member-email') {
          if (checkField(emailInput, document.getElementById('err-email'), validateEmail)) {
            phoneInput.focus();
          }
        }
        else if (target.id === 'member-phone') {
          if (checkField(phoneInput, document.getElementById('err-phone'), validatePhone)) {
            goToNextStep();
          }
        }
      }
      else {
        if (target.id === 'nickname') {
          if (isNicknameChecked) {
            submitForm(); // 이미 중복확인 통과했으면 가입 제출
          } else {
            checkDuplicateNickname(); // 안 했으면 중복확인 실행!
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