<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>프로필 설정 | Youwin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/mypage.css">
  <style>
    /* 팝업(모달) 기본 스타일 */
    .modal-overlay {
      position: fixed; top: 0; left: 0; width: 100%; height: 100%;
      background: rgba(0, 0, 0, 0.5);
      display: none; justify-content: center; align-items: center; z-index: 1000;
    }
    .modal-overlay.is-active { display: flex; }
    .modal-content {
      background: #fff; padding: 2rem; border-radius: 12px; width: 100%; max-width: 400px;
      box-shadow: 0 10px 25px rgba(0,0,0,0.2); position: relative;
    }
    .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; }
    .modal-close { background: none; border: none; font-size: 1.5rem; cursor: pointer; }
    .setting-row { display: flex; justify-content: space-between; align-items: center; padding: 1rem 0; border-bottom: 1px solid #eee; }
    .setting-info label { display: block; font-size: 0.85rem; color: #666; }
    .setting-info p { font-size: 1rem; font-weight: 600; margin: 0.2rem 0 0 0; }
  </style>
</head>
<body>
<div class="site-shell">
  <!-- 상단 헤더 -->
  <header class="site-header">
    <div class="site-container site-header__inner">
      <a class="brand" href="${pageContext.request.contextPath}/"><span class="brand__mark">YW</span><span>Youwin</span></a>
      <nav class="site-nav">
        <a href="${pageContext.request.contextPath}/member/myPage">마이페이지</a>
      </nav>
    </div>
  </header>

  <main class="page-main">
    <div class="site-container" style="max-width: 600px;">
      <section class="section-head page-head">
        <h1 class="section-title">계정 및 프로필 설정</h1>
      </section>

      <!-- 1. 프로필 사진 카드 -->
      <section class="surface mypage-card" style="margin-bottom: 1.5rem;">
        <h2 class="section-title">프로필 사진</h2>
        <div class="profile-avatar-edit">
          <div class="profile-avatar" id="avatarPreviewContainer">
            <c:choose>
              <c:when test="${not empty member.profileImage}">
                <img src="${pageContext.request.contextPath}${member.profileImage}" class="profile-img" style="width: 100%; height: 100%; object-fit: cover;" alt="">
              </c:when>
              <c:otherwise>
                <svg viewBox="0 0 24 24" width="40" height="40" fill="currentColor"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"></path></svg>
              </c:otherwise>
            </c:choose>
          </div>
          <button type="button" class="button button--secondary" onclick="openModal('modalProfile')">사진 변경</button>
        </div>
      </section>

      <!-- 2. 계정 정보 리스트 카드 -->
      <section class="surface mypage-card" style="margin-bottom: 1.5rem;">
        <h2 class="section-title">계정 정보</h2>

        <div class="setting-row">
          <div class="setting-info"><label>닉네임</label><p>${member.nickname}</p></div>
          <button type="button" class="button button--text" onclick="openModal('modalNickname')">변경</button>
        </div>

        <div class="setting-row">
          <div class="setting-info"><label>전화번호</label><p>${member.memberPhone}</p></div>
          <button type="button" class="button button--text" onclick="openModal('modalPhone')">변경</button>
        </div>

        <div class="setting-row">
          <div class="setting-info"><label>이메일</label><p>${member.memberEmail}</p></div>
          <button type="button" class="button button--text" onclick="openModal('modalEmail')">변경</button>
        </div>

        <div class="setting-row">
          <div class="setting-info"><label>비밀번호</label><p>••••••••</p></div>
          <button type="button" class="button button--text" onclick="openModal('modalPassword')">변경</button>
        </div>
      </section>

      <!-- 3. 계정 삭제(탈퇴) -->
      <div style="text-align: right;">
        <a href="${pageContext.request.contextPath}/member/withdraw" style="color: #e53e3e; font-size: 0.9rem;" onclick="return confirm('정말로 탈퇴하시겠습니까?');">계정 삭제 (회원 탈퇴)</a>
      </div>
    </div>
  </main>
</div>

<!-- ==================== 팝업(모달) 영역들 ==================== -->

<!-- 1. 닉네임 변경 팝업 -->
<div class="modal-overlay" id="modalNickname">
  <div class="modal-content">
    <div class="modal-header">
      <h3>닉네임 변경</h3>
      <button type="button" class="modal-close" onclick="closeModal('modalNickname')">&times;</button>
    </div>
    <form action="${pageContext.request.contextPath}/member/updateNickname" method="post" id="formNickname">
      <div class="form-group" style="margin-bottom: 1rem;">
        <label for="nickname">새 닉네임</label>
        <input type="text" id="nickname" name="nickname" value="${member.nickname}" required class="input-control">
        <span id="nicknameMsg" style="font-size: 0.8rem; display: block; margin-top: 4px;"></span>
      </div>
      <button type="submit" id="btnNickname" class="button button--full">수정 완료</button>
    </form>
  </div>
</div>

<!-- 2. 전화번호 변경 팝업 -->
<div class="modal-overlay" id="modalPhone">
  <div class="modal-content">
    <div class="modal-header">
      <h3>전화번호 변경</h3>
      <button type="button" class="modal-close" onclick="closeModal('modalPhone')">&times;</button>
    </div>
    <form action="${pageContext.request.contextPath}/member/updatePhone" method="post" id="formPhone">
      <div class="form-group" style="margin-bottom: 1rem;">
        <label for="memberPhone">새 전화번호</label>
        <input type="tel" id="memberPhone" name="memberPhone" value="${member.memberPhone}" required class="input-control" placeholder="010-0000-0000">
        <span id="phoneMsg" style="font-size: 0.8rem; display: block; margin-top: 4px;"></span>
      </div>
      <button type="submit" id="btnPhone" class="button button--full">수정 완료</button>
    </form>
  </div>
</div>

<!-- 3. 이메일 변경 팝업 -->
<div class="modal-overlay" id="modalEmail">
  <div class="modal-content">
    <div class="modal-header">
      <h3>이메일 변경</h3>
      <button type="button" class="modal-close" onclick="closeModal('modalEmail')">&times;</button>
    </div>
    <form action="${pageContext.request.contextPath}/member/updateEmail" method="post" id="formEmail">
      <div class="form-group" style="margin-bottom: 1rem;">
        <label for="memberEmail">새 이메일</label>
        <input type="email" id="memberEmail" name="memberEmail" value="${member.memberEmail}" required class="input-control">
        <span id="emailMsg" style="font-size: 0.8rem; display: block; margin-top: 4px;"></span>
      </div>
      <button type="submit" id="btnEmail" class="button button--full">수정 완료</button>
    </form>
  </div>
</div>

<!-- 4. 비밀번호 변경 팝업 -->
<div class="modal-overlay" id="modalPassword">
  <div class="modal-content">
    <div class="modal-header">
      <h3>비밀번호 변경</h3>
      <button type="button" class="modal-close" onclick="closeModal('modalPassword')">&times;</button>
    </div>
    <form action="${pageContext.request.contextPath}/member/updatePasswordInSettings" method="post" id="formPassword">
      <div class="form-group" style="margin-bottom: 0.5rem;">
        <label for="currentPassword">현재 비밀번호</label>
        <input type="password" id="currentPassword" name="currentPassword" required class="input-control">
      </div>
      <div class="form-group" style="margin-bottom: 0.5rem;">
        <label for="newPassword">새 비밀번호</label>
        <input type="password" id="newPassword" name="newPassword" required class="input-control">
        <span id="pwMsg" style="font-size: 0.8rem; display: block; margin-top: 4px;"></span>
      </div>
      <div class="form-group" style="margin-bottom: 1rem;">
        <label for="confirmPassword">새 비밀번호 확인</label>
        <input type="password" id="confirmPassword" name="confirmPassword" required class="input-control">
        <span id="pwConfirmMsg" style="font-size: 0.8rem; display: block; margin-top: 4px;"></span>
      </div>
      <button type="submit" id="btnPassword" class="button button--full">비밀번호 변경</button>
    </form>
  </div>
</div>

<!-- 5. 프로필 사진 변경 팝업 -->
<div class="modal-overlay" id="modalProfile">
  <div class="modal-content" style="text-align: center;">
    <div class="modal-header">
      <h3>프로필 사진 변경</h3>
      <button type="button" class="modal-close" onclick="closeModal('modalProfile')">&times;</button>
    </div>

    <form action="${pageContext.request.contextPath}/member/updateProfileImage" method="post" enctype="multipart/form-data">
      <input type="hidden" name="deleteProfile" id="deleteProfile" value="false">

      <!-- 📸 팝업 내 실시간 프로필 미리보기 영역 -->
      <div class="profile-avatar" id="modalAvatarPreview" style="margin: 0 auto 1.5rem auto; width: 100px; height: 100px; border-radius: 50%; overflow: hidden; display: flex; align-items: center; justify-content: center; background: #f0f0f0;">
        <c:choose>
          <c:when test="${not empty member.profileImage}">
            <img src="${pageContext.request.contextPath}${member.profileImage}" class="profile-img" style="width: 100%; height: 100%; object-fit: cover;" alt="">
          </c:when>
          <c:otherwise>
            <svg viewBox="0 0 24 24" width="50" height="50" fill="#999"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"></path></svg>
          </c:otherwise>
        </c:choose>
      </div>

      <!-- 액션 버튼 영역 -->
      <div style="margin-bottom: 1.5rem; display: flex; gap: 0.5rem; justify-content: center;">
        <input type="file" id="profile" name="profile" accept="image/*" hidden>
        <label for="profile" class="button button--secondary" style="cursor: pointer;">새 사진 선택</label>
        <button type="button" id="modalResetAvatarBtn" class="button button--secondary">기본 이미지로 변경</button>
      </div>

      <button type="submit" class="button button--full">저장하기</button>
    </form>
  </div>
</div>

<!-- 스크립트: 모달 열기/닫기 및 미리보기 -->
<script>
  function openModal(id) {
    document.getElementById(id).classList.add('is-active');
  }
  function closeModal(id) {
    document.getElementById(id).classList.remove('is-active');
  }

  window.addEventListener('click', function(e) {
    if (e.target.classList.contains('modal-overlay')) {
      e.target.classList.remove('is-active');
    }
  });

  const modalProfileInput = document.getElementById('profile');
  const modalPreviewContainer = document.getElementById('modalAvatarPreview');
  const mainAvatarContainer = document.getElementById('avatarPreviewContainer');
  const modalResetBtn = document.getElementById('modalResetAvatarBtn');
  const deleteProfileInput = document.getElementById('deleteProfile');

  // 사진 선택 시 안전하게 이미지 src 만 변경하는 로직
  modalProfileInput.addEventListener('change', function(e) {
    const file = e.target.files[0];
    if (!file) return;

    deleteProfileInput.value = "false";
    const reader = new FileReader();

    reader.onload = function(event) {
      const base64Src = event.target.result;

      // 1. 모달 팝업 내부 변경
      let modalImg = modalPreviewContainer.querySelector('img');
      if (modalImg) {
        modalImg.src = base64Src;
      } else {
        modalPreviewContainer.innerHTML = `<img src="${base64Src}" class="profile-img" style="width: 100%; height: 100%; object-fit: cover;" alt="">`;
      }

      // 2. 메인 화면 변경
      let mainImg = mainAvatarContainer.querySelector('img');
      if (mainImg) {
        mainImg.src = base64Src;
      } else {
        mainAvatarContainer.innerHTML = `<img src="${base64Src}" class="profile-img" style="width: 100%; height: 100%; object-fit: cover;" alt="">`;
      }
    };

    reader.readAsDataURL(file);
  });

  // 기본 이미지로 변경 시
  modalResetBtn.addEventListener('click', function() {
    modalProfileInput.value = "";
    deleteProfileInput.value = "true";

    const defaultSvg = `
      <svg viewBox="0 0 24 24" width="40" height="40" fill="#999">
        <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"></path>
      </svg>`;

    modalPreviewContainer.innerHTML = defaultSvg;
    mainAvatarContainer.innerHTML = defaultSvg;
  });

    // 정규식 규칙
    const regex = {
    nickname: /^[a-zA-Z0-9가-힣]{2,10}$/,
    phone: /^01[016789]-\d{3,4}-\d{4}$/,
    email: /^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/,
    password: /^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{8,16}$/
  };

    // 메시지 및 색상 변경 함수
    function setMsg(element, message, isValid) {
    element.textContent = message;
    element.style.color = isValid ? '#21a675' : '#e53e3e'; // 초록색 : 빨간색
  }

    // 1. 닉네임 실시간 검사
    const nicknameInput = document.getElementById('nickname');
    const nicknameMsg = document.getElementById('nicknameMsg');
    nicknameInput.addEventListener('input', function() {
    if (regex.nickname.test(this.value)) {
    setMsg(nicknameMsg, '사용 가능한 닉네임 형식입니다.', true);
  } else {
    setMsg(nicknameMsg, '특수문자 없이 2~10자로 입력해주세요.', false);
  }
  });

    // 2. 전화번호 실시간 자동 하이픈 & 검사
    const phoneInput = document.getElementById('memberPhone');
    const phoneMsg = document.getElementById('phoneMsg');
    phoneInput.addEventListener('input', function() {
    let val = this.value.replace(/[^0-9]/g, '');
    if (val.length > 3 && val.length <= 7) {
    val = val.substring(0, 3) + '-' + val.substring(3);
  } else if (val.length > 7) {
    val = val.substring(0, 3) + '-' + val.substring(3, 7) + '-' + val.substring(7, 11);
  }
    this.value = val;

    if (regex.phone.test(this.value)) {
    setMsg(phoneMsg, '올바른 전화번호 형식입니다.', true);
  } else {
    setMsg(phoneMsg, '전화번호 형식이 올바르지 않습니다. (예: 010-1234-5678)', false);
  }
  });

    // 3. 이메일 실시간 검사
    const emailInput = document.getElementById('memberEmail');
    const emailMsg = document.getElementById('emailMsg');
    emailInput.addEventListener('input', function() {
    if (regex.email.test(this.value)) {
    setMsg(emailMsg, '올바른 이메일 형식입니다.', true);
  } else {
    setMsg(emailMsg, '이메일 형식이 올바르지 않습니다.', false);
  }
  });

    // 4. 비밀번호 실시간 검사 및 일치 확인
    const newPw = document.getElementById('newPassword');
    const confirmPw = document.getElementById('confirmPassword');
    const pwMsg = document.getElementById('pwMsg');
    const pwConfirmMsg = document.getElementById('pwConfirmMsg');

    newPw.addEventListener('input', function() {
    if (regex.password.test(this.value)) {
    setMsg(pwMsg, '안전한 비밀번호입니다.', true);
  } else {
    setMsg(pwMsg, '영문, 숫자, 특수문자 포함 8~16자로 입력해주세요.', false);
  }
    checkPwMatch();
  });

    confirmPw.addEventListener('input', checkPwMatch);

    function checkPwMatch() {
    if (!confirmPw.value) {
    pwConfirmMsg.textContent = '';
    return;
  }
    if (newPw.value === confirmPw.value) {
    setMsg(pwConfirmMsg, '비밀번호가 일치합니다.', true);
  } else {
    setMsg(pwConfirmMsg, '비밀번호가 일치하지 않습니다.', false);
  }
  }
</script>
</body>
</html>