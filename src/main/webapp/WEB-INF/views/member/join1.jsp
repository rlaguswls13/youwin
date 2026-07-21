<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입</title>
  <style>
    /* 기존 스타일 톤앤매너 100% 유지 */
    * {
      margin: 0;
      padding: 0;
      box-sizing: border-box;
      font-family: 'Malgun Gothic', sans-serif;
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
      margin-bottom: 40px;
      letter-spacing: -0.5px;
    }

    .join-form {
      display: flex;
      flex-direction: column;
      gap: 20px;
      text-align: left;
    }

    .form-row {
      display: flex;
      flex-direction: column;
      gap: 6px;
    }

    .form-row label {
      font-size: 14px;
      font-weight: bold;
      color: #333;
    }

    .form-row input {
      width: 100%;
      height: 45px;
      padding: 0 15px;
      background-color: #dbdbdb;
      border: none;
      outline: none;
      font-size: 15px;
      color: #333;
      transition: background-color 0.2s ease;
    }

    .form-row input:focus {
      background-color: #cfcfcf;
      border: 1px solid #999;
    }

    /* 중복확인 레이아웃 */
    .input-with-button {
      display: flex;
      gap: 10px;
    }

    .btn-outline {
      width: 100px;
      height: 45px;
      background-color: #dbdbdb;
      border: none;
      font-size: 14px;
      font-weight: bold;
      color: #333;
      cursor: pointer;
      transition: all 0.2s ease;
    }

    .btn-outline:hover {
      background-color: #c5c5c5;
    }

    /* 하단 가이드 팁 및 경고문 스타일 */
    .form-tip {
      font-size: 12px;
      margin-top: 2px;
      min-height: 16px; /* 경고문 노출 시 레이아웃 덜컹거림 방지 */
    }
    .text-danger { color: #ff3b30; }
    .text-success { color: #0076ff; }

    .btn-container {
      margin-top: 35px;
      display: flex;
      justify-content: center;
    }

    .next-btn {
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

    .next-btn:hover {
      background-color: #c5c5c5;
      color: #000;
    }

    /* STEP 2 프로필 영역 */
    .form-row.profile-group {
      text-align: center;
    }

    .form-row.profile-group > label {
      display: block;
      text-align: center;
      font-size: 18px;
    }

    .profile-section {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 15px;
    }

    .profile-img-preview {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      background-color: #d1d1d1;
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: hidden;
      margin: 0 auto;
    }

    .profile-img-preview svg {
      width: 100%;
      height: 100%;
      fill: #ffffff;
    }

    .profile-img-preview img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .file-upload-btn {
      font-size: 12px;
      color: #555;
      cursor: pointer;
      text-decoration: none;
    }

    .file-upload-btn:hover {
      text-decoration: underline;
    }

    input[type="file"] {
      display: none;
    }
  </style>
</head>
<body>

<div class="join-container">
  <form id="join-form" class="join-form">

    <!-- ────────────────────────────────────────── -->
    <!-- [STEP 1] 회원 정보 섹션 -->
    <!-- ────────────────────────────────────────── -->
    <div id="step-1">
      <h1 class="join-title">회원 정보</h1>

      <!-- 아이디 및 중복확인 -->
      <div class="form-row">
        <label for="member-id">아이디</label>
        <div class="input-with-button">
          <input type="text" id="member-id" autocomplete="off">
          <button type="button" id="check-id-btn" class="btn btn-outline">중복확인</button>
        </div>
        <p id="check-id-result" class="form-tip"></p>
      </div>

      <!-- 비밀번호 -->
      <div class="form-row">
        <label for="member-password">비밀번호</label>
        <input type="password" id="member-password" placeholder="비밀번호">
        <p id="error-password" class="form-tip text-danger"></p>
      </div>

      <!-- 이름 -->
      <div class="form-row">
        <label for="member-name">이름</label>
        <input type="text" id="member-name" placeholder="이름">
        <p id="error-name" class="form-tip text-danger"></p>
      </div>

      <!-- 이메일 -->
      <div class="form-row">
        <label for="member-email">이메일</label>
        <input type="email" id="member-email" placeholder="이메일">
        <p id="error-email" class="form-tip text-danger"></p>
      </div>

      <!-- 전화번호 -->
      <div class="form-row">
        <label for="member-phone">휴대전화번호</label>
        <input type="tel" id="member-phone" placeholder="휴대전화번호">
        <p id="error-phone" class="form-tip text-danger"></p>
      </div>

      <!-- 다음 버튼 (수동 검증 트리거) -->
      <div class="btn-container">
        <button type="button" class="next-btn" onclick="nextStep()">다음</button>
      </div>
    </div>

    <!-- ────────────────────────────────────────── -->
    <!-- [STEP 2] 회원 설정 섹션 -->
    <!-- ────────────────────────────────────────── -->
    <div id="step-2" style="display: none;">
      <h1 class="join-title" style="font-size: 28px;">회원 설정</h1>

      <!-- 프로필 이미지 (선택 항목) -->
      <div class="form-row profile-group">
        <label>프로필 이미지</label>
        <div class="profile-section">
          <div class="profile-img-preview" id="image-preview">
            <svg viewBox="0 0 24 24">
              <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"></path>
            </svg>
          </div>
          <label for="profile-image" class="file-upload-btn">파일 올리기</label>
          <input type="file" id="profile-image" accept="image/*" onchange="previewImage(this)">
        </div>
      </div>

      <!-- 닉네임 -->
      <div class="form-row">
        <label for="nickname">닉네임</label>
        <input type="text" id="nickname" placeholder="닉네임을 입력해 주세요">
        <p id="error-nickname" class="form-tip text-danger"></p>
      </div>

      <!-- 가입완료 버튼 -->
      <div class="btn-container">
        <button type="button" class="next-btn" onclick="submitForm()">가입완료</button>
      </div>
    </div>

  </form>
</div>

<script>
  // 상태 제어용 프론트엔드 변수
  let isIdChecked = false;
  // 임시 중복 아이디 모의 테스트용 배열 (실제 연동 시 사용 불가)
  const dummyExistingIds = ["admin", "user01", "test"];

  // 아이디 값이 변경되면 중복확인 인증 상태를 취소
  document.getElementById('member-id').addEventListener('input', function() {
    isIdChecked = false;
    document.getElementById('check-id-result').textContent = "";
  });

  // [중복확인] 버튼 클릭 처리
  document.getElementById('check-id-btn').addEventListener('click', function() {
    const idInput = document.getElementById('member-id');
    const idValue = idInput.value.trim();
    const resultTip = document.getElementById('check-id-result');

    if (!idValue) {
      resultTip.className = "form-tip text-danger";
      resultTip.textContent = "아이디를 먼저 입력해 주세요.";
      return;
    }

    // 프론트엔드 모의 중복 검증
    if (dummyExistingIds.includes(idValue)) {
      resultTip.className = "form-tip text-danger";
      resultTip.textContent = "이미 사용중인 아이디 입니다.";
      isIdChecked = false;
    } else {
      resultTip.className = "form-tip text-success";
      resultTip.textContent = "사용 가능한 아이디입니다.";
      isIdChecked = true;
    }
  });

  // [다음] 버튼 클릭 - STEP 1 완벽 검증
  function nextStep() {
    // 기존 에러 메시지 텍스트 일괄 청소
    document.getElementById('error-password').textContent = "";
    document.getElementById('error-name').textContent = "";
    document.getElementById('error-email').textContent = "";
    document.getElementById('error-phone').textContent = "";

    let isValid = true;

    // 1. 아이디 중복확인 선행 체크
    const idResult = document.getElementById('check-id-result');
    if (!isIdChecked) {
      idResult.className = "form-tip text-danger";
      idResult.textContent = "아이디 중복확인을 진행해 주세요.";
      isValid = false;
    }

    // 2. 나머지 요소 텍스트 추출 및 유효성 판단
    const pwd = document.getElementById('member-password').value.trim();
    const name = document.getElementById('member-name').value.trim();
    const email = document.getElementById('member-email').value.trim();
    const phone = document.getElementById('member-phone').value.trim();

    if (!pwd) { document.getElementById('error-password').textContent = "비밀번호를 입력해 주세요."; isValid = false; }
    if (!name) { document.getElementById('error-name').textContent = "이름을 입력해 주세요."; isValid = false; }
    if (!email) { document.getElementById('error-email').textContent = "이메일을 입력해 주세요."; isValid = false; }
    if (!phone) { document.getElementById('error-phone').textContent = "휴대전화번호를 입력해 주세요."; isValid = false; }

    // 검증에 하나라도 걸리면 절대 다음 단계로 진입 불가
    if (!isValid) return;

    // 통과 시 STEP 2 전환 (이전 기능 차단 상태이므로 되돌아갈 수 없음)
    document.getElementById('step-1').style.display = 'none';
    document.getElementById('step-2').style.display = 'block';
  }

  // 프로필 이미지 미리보기 연출
  function previewImage(input) {
    const previewContainer = document.getElementById('image-preview');
    if (input.files && input.files[0]) {
      const reader = new FileReader();
      reader.onload = function(e) {
        previewContainer.innerHTML = '<img src="' + e.target.result + '" alt="프로필 미리보기">';
      }
      reader.readAsDataURL(input.files[0]);
    }
  }

  // [가입완료] 최종 클릭 - STEP 2 검증 및 마무리
  function submitForm() {
    document.getElementById('error-nickname').textContent = "";
    const nicknameInput = document.getElementById('nickname');
    const nicknameValue = nicknameInput.value.trim();

    if (!nicknameValue) {
      document.getElementById('error-nickname').textContent = "닉네임을 입력해 주세요.";
      nicknameInput.focus();
      return;
    }

    // 모든 조건 클리어 시 최종 마감 피드백
    alert("회원가입이 성공적으로 완료되었습니다!");
    // 향후 메인이나 로그인 화면으로 이동 흐름 유도 가능
    // window.location.href = '/login';
  }
</script>

</body>
</html>