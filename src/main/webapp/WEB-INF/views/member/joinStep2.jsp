<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!-- 프로필 이미지 섹션 -->
<div class="form-group profile-group">
  <label>프로필 이미지</label>
  <div class="profile-section">
    <div class="profile-img-preview" id="image-preview">
      <svg viewBox="0 0 24 24">
        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"></path>
      </svg>
    </div>
    <label for="profile-file" class="file-upload-btn">파일 올리기</label>
    <input type="file" id="profile-file" name="profile" accept="image/*" onchange="previewImage(this)">
  </div>
</div>

<!-- 닉네임 섹션 -->
<div class="form-group">
  <label for="nickname">닉네임</label>
  <input type="text" id="nickname" name="nickname" placeholder="닉네임을 입력해주세요 (2~10자)">
  <span class="error-msg" id="err-nickname"></span>
</div>

<!-- 제출 버튼 -->
<div class="btn-container">
  <button type="button" class="btn" onclick="submitForm()">가입완료</button>
</div>

<script>
  // 이미지 파일 선택 시 미리보기 처리
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

  // 닉네임 유효성 검사 함수
  function validateNickname(nicknameValue) {
    if (!nicknameValue || nicknameValue.trim() === '') return '닉네임을 입력해 주세요.';
    if (/\s/.test(nicknameValue)) return '닉네임에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    if (nicknameValue.length < 2 || nicknameValue.length > 10) return '닉네임은 2자 이상 10자 이하로 입력해 주세요.';
    return '';
  }

  // 최종 회원가입 폼 제출 처리 함수
  function submitForm() {
    const nicknameInput = document.getElementById('nickname');
    const errNickname = document.getElementById('err-nickname');
    const nicknameMsg = validateNickname(nicknameInput.value);

    if (nicknameMsg) {
      showError(nicknameInput, errNickname, nicknameMsg);
      nicknameInput.focus();
    } else {
      clearError(nicknameInput, errNickname);
      // 최종 유효성 검사 통과 시 서브밋 실행
      document.getElementById('joinForm').submit();
    }
  }
</script>