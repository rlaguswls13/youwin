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

<!-- 닉네임 섹션 (중복확인 버튼 포함) -->
<div class="form-group">
  <label for="nickname">닉네임</label>
  <div class="input-with-btn">
    <input type="text" id="nickname" name="nickname" placeholder="닉네임을 입력해주세요 (2~10자)">
    <button type="button" class="btn-check" id="btn-check-nickname" onclick="checkDuplicateNickname()">중복확인</button>
  </div>
  <span class="error-msg" id="err-nickname"></span>
</div>

<!-- 제출 버튼 -->
<div class="btn-container">
  <button type="button" class="btn" onclick="submitForm()">가입완료</button>
</div>

<script>
  let isNicknameChecked = false;

  // 프로필 이미지 미리보기
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

  // 닉네임 유효성 검사
  function validateNickname(nicknameValue) {
    if (!nicknameValue || nicknameValue.trim() === '') return '닉네임을 입력해 주세요.';
    if (/\s/.test(nicknameValue)) return '닉네임에는 공백(띄어쓰기)을 포함할 수 없습니다.';
    if (nicknameValue.length < 2 || nicknameValue.length > 10) return '닉네임은 2자 이상 10자 이하로 입력해 주세요.';
    return '';
  }

  // 닉네임 중복 체크 (Ajax 연동)
  function checkDuplicateNickname() {
    const nicknameInput = document.getElementById('nickname');
    const errNickname = document.getElementById('err-nickname');
    const nicknameValue = nicknameInput.value;

    const msg = validateNickname(nicknameValue);
    if (msg) {
      showError(nicknameInput, errNickname, msg);
      isNicknameChecked = false;
      return;
    }

    fetch('/api/member/check-nickname?nickname=' + encodeURIComponent(nicknameValue))
            .then(response => {
              if (!response.ok) throw new Error('서버 응답 오류');
              return response.json();
            })
            .then(isDuplicate => {
              if (isDuplicate) {
                showError(nicknameInput, errNickname, '이미 사용 중인 닉네임입니다.');
                isNicknameChecked = false;
              } else {
                showSuccess(nicknameInput, errNickname, '사용 가능한 닉네임입니다.');
                isNicknameChecked = true;
              }
            })
            .catch(error => {
              console.error('Error:', error);
              showError(nicknameInput, errNickname, '중복 확인 중 오류가 발생했습니다.');
              isNicknameChecked = false;
            });
  }

  // 닉네임 변경 시 초기화
  document.getElementById('nickname').addEventListener('input', function() {
    isNicknameChecked = false;
    clearError(this, document.getElementById('err-nickname'));
  });

  // 최종 폼 제출 처리
  function submitForm() {
    const nicknameInput = document.getElementById('nickname');
    const errNickname = document.getElementById('err-nickname');

    const isNicknameValid = checkField(nicknameInput, errNickname, validateNickname);

    if (!isNicknameValid) {
      nicknameInput.focus();
      return;
    }

    if (!isNicknameChecked) {
      showError(nicknameInput, errNickname, '닉네임 중복확인을 진행해 주세요.');
      nicknameInput.focus();
      return;
    }

    // 모든 검사 통과 시 서브밋 실행
    document.getElementById('joinForm').submit();
  }
</script>