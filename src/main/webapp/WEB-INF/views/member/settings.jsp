<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>프로필 설정 | Youwin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/mypage.css">
  <style>
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

    /* 기본 가이드 상태일 때 (회색) */
    .error-msg {
      font-size: 12px;
      color: #888888;
      min-height: 18px;
      line-height: 18px;
      display: block;
      margin-top: 4px;
      transition: color 0.2s ease;
    }
    /* 에러 상태일 때 (빨간색) */
    .error-msg.has-error {
      color: #e53e3e;
    }
    /* 성공/중복확인 통과 상태일 때 (초록색) */
    .error-msg.success-msg {
      color: #21a675;
    }

    /* ==========================================
   프로필 이미지 규격 통일 스타일
   ========================================== */

    /* 1. 프로필 아바타 기본 레이아웃 (원형 & 120px 규격) */
    .profile-avatar {
      width: 120px;
      height: 120px;
      border-radius: 50%;
      overflow: hidden;
      display: flex;
      align-items: center;
      justify-content: center;
      background-color: #f0f0f0;
      border: 4px solid #6366f1; /* 맘에 들어 하신 원형 테두리 라인 */
      box-shadow: 0 4px 12px rgba(99, 102, 241, 0.2);
      flex-shrink: 0;
    }

    /* 2. 내부 이미지 규격 및 비율 유지 */
    .profile-avatar .profile-img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    /* 3. 메인 설정 카드 내 프로필 정렬 및 간격 */
    .profile-avatar-edit {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 1.25rem;
      padding: 1rem 0;
    }

    /* 4. 모달 내부 프로필 미리보기 중앙 정렬 */
    .modal-avatar-wrapper {
      margin: 0 auto 1.5rem auto;
    }
  </style>
</head>
<body>

<%-- Security Context의 memberDto 객체를 member 변수로 안전하게 바인딩 --%>
<sec:authorize access="isAuthenticated()">
  <sec:authentication property="principal" var="principal"/>
  <c:set var="member" value="${not empty principal.memberDto ? principal.memberDto : memberDto}"/>
</sec:authorize>

<div class="site-shell">
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
      <section class="surface mypage-card">
        <h2 class="section-title">프로필 사진</h2>
        <div class="profile-avatar-edit">
          <!-- 인라인 style 없이 class만 사용 -->
          <div class="profile-avatar" id="avatarPreviewContainer">
            <img id="mainAvatarImg"
                 src="${not empty member.profileImage ? pageContext.request.contextPath.concat(member.profileImage) : pageContext.request.contextPath.concat('/upload/profile/default-profile.svg')}"
                 class="profile-img" alt="프로필 사진">
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
        <a href="javascript:void(0);" style="color: #e53e3e; font-size: 0.9rem;" onclick="openModal('modalDelete')">계정 삭제 (회원 탈퇴)</a>
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
    <form action="${pageContext.request.contextPath}/member/updateNickname" method="post" id="formNickname" onsubmit="return false;">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

      <div class="form-group" style="margin-bottom: 1rem;">
        <label for="nickname">새 닉네임</label>
        <div class="input-with-btn" style="display: flex; gap: 8px; margin-top: 4px;">
          <input type="text" id="nickname" name="nickname" value="${member.nickname}" class="input-control" style="flex: 1;">
          <button type="button" class="button button--secondary" id="btn-check-nickname" onclick="checkDuplicateNickname()">중복확인</button>
        </div>
        <span class="error-msg" id="err-nickname" data-default="공백 없이 2자 이상 10자 이하로 입력해 주세요.">공백 없이 2자 이상 10자 이하로 입력해 주세요.</span>
      </div>
      <button type="button" class="button button--full" onclick="submitNicknameForm()">수정 완료</button>
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
    <form action="${pageContext.request.contextPath}/member/updatePhone" method="post" id="formPhone" onsubmit="return false;">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

      <div class="form-group" style="margin-bottom: 1rem;">
        <label for="memberPhone">새 전화번호</label>
        <input type="tel" id="memberPhone" name="memberPhone" value="${member.memberPhone}" maxlength="11" class="input-control">
        <span class="error-msg" id="err-phone" data-default="숫자만 입력해 주세요. (예: 01012345678)">숫자만 입력해 주세요. (예: 01012345678)</span>
      </div>
      <button type="button" id="btnPhone" class="button button--full" onclick="submitPhoneForm()">수정 완료</button>
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
    <form action="${pageContext.request.contextPath}/member/updateEmail" method="post" id="formEmail" onsubmit="return false;">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

      <div class="form-group" style="margin-bottom: 1rem;">
        <label for="memberEmail">새 이메일</label>
        <input type="email" id="memberEmail" name="memberEmail" value="${member.memberEmail}" class="input-control">
        <span class="error-msg" id="err-email" data-default="올바른 이메일 형식을 입력해 주세요. (예: example@domain.com)">올바른 이메일 형식을 입력해 주세요. (예: example@domain.com)</span>
      </div>
      <button type="button" id="btnEmail" class="button button--full" onclick="submitEmailForm()">수정 완료</button>
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
    <form action="${pageContext.request.contextPath}/member/updatePasswordInSettings" method="post" id="formPassword" onsubmit="return false;">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

      <div class="form-group" style="margin-bottom: 0.5rem;">
        <label for="currentPassword">현재 비밀번호</label>
        <input type="password" id="currentPassword" name="currentPassword" class="input-control">
        <span class="error-msg" id="err-currentPw" data-default="현재 사용 중인 비밀번호를 입력해 주세요.">현재 사용 중인 비밀번호를 입력해 주세요.</span>
      </div>
      <div class="form-group" style="margin-bottom: 0.5rem;">
        <label for="newPassword">새 비밀번호</label>
        <input type="password" id="newPassword" name="newPassword" class="input-control">
        <span class="error-msg" id="err-newPw" data-default="영문, 숫자, 특수문자 포함 8자~20자">영문, 숫자, 특수문자 포함 8자~20자</span>
      </div>
      <div class="form-group" style="margin-bottom: 1rem;">
        <label for="confirmPassword">새 비밀번호 확인</label>
        <input type="password" id="confirmPassword" name="confirmPassword" class="input-control">
        <span class="error-msg" id="err-confirmPw" data-default="새 비밀번호를 한번 더 입력해 주세요.">새 비밀번호를 한번 더 입력해 주세요.</span>
      </div>
      <button type="button" id="btnPassword" class="button button--full" onclick="submitPasswordForm()">비밀번호 변경</button>
    </form>
  </div>
</div>

<!-- 5. 프로필 사진 변경 팝업 -->
<div class="modal-overlay" id="modalProfile">
  <div class="modal-content modal-content--center">
    <div class="modal-header">
      <h3>프로필 사진 변경</h3>
      <button type="button" class="modal-close" onclick="closeModal('modalProfile')">&times;</button>
    </div>

    <form action="${pageContext.request.contextPath}/member/updateProfileImage" method="post" enctype="multipart/form-data" id="formProfile">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
      <input type="hidden" name="deleteProfile" id="deleteProfile" value="false">

      <div class="profile-avatar modal-avatar-wrapper" id="modalAvatarPreview">
        <img id="modalAvatarImg"
             src="${not empty member.profileImage ? pageContext.request.contextPath.concat(member.profileImage) : pageContext.request.contextPath.concat('/upload/profile/default-profile.svg')}"
             class="profile-img" alt="프로필 미리보기">
      </div>

      <div class="modal-actions-row">
        <input type="file" id="profile" name="profile" accept="image/*" hidden>
        <label for="profile" class="button button--secondary">새 사진 선택</label>
        <button type="button" id="modalResetAvatarBtn" class="button button--secondary">기본 이미지로 변경</button>
      </div>

      <button type="submit" class="button button--full">저장하기</button>
    </form>
  </div>
</div>

<!-- 회원 삭제(Delete) 모달 팝업 -->
<div class="modal-overlay" id="modalDelete">
  <div class="modal-content">
    <div class="modal-header">
      <h3 style="color: #e53e3e;">계정 삭제</h3>
      <button type="button" class="modal-close" onclick="closeModal('modalDelete')">&times;</button>
    </div>

    <form action="${pageContext.request.contextPath}/member/delete" method="post" id="formDelete" onsubmit="return false;">
      <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

      <!-- 안내문 박스 -->
      <div style="background: #fff5f5; border: 1px solid #fed7d7; border-radius: 8px; padding: 1rem; margin-bottom: 1rem; text-align: left;">
        <p style="font-size: 0.85rem; color: #c53030; font-weight: 600; margin-bottom: 0.5rem;">⚠️ 삭제 전 반드시 확인해 주세요</p>
        <ul style="font-size: 0.8rem; color: #4a5568; padding-left: 1.2rem; margin: 0; line-height: 1.5;">
          <li>계정 삭제 신청 후 30일간 보관되며, 이후 영구 삭제됩니다.</li>
          <li><b>작성하신 게시글 및 댓글은 계정을 삭제해도 자동으로 삭제되지 않습니다.</b></li>
          <li>삭제를 원하시는 게시물은 미리 직접 삭제해 주세요.</li>
        </ul>
      </div>

      <!-- 동의 체크박스 -->
      <div style="margin-bottom: 1rem; text-align: left;">
        <label style="font-size: 0.85rem; cursor: pointer; display: flex; align-items: center; gap: 6px;">
          <input type="checkbox" id="agreeDelete" style="width: 16px; height: 16px;">
          <span>안내문을 확인했으며, 계정 삭제에 동의합니다.</span>
        </label>
        <span class="error-msg" id="err-agreeDelete"></span>
      </div>

      <!-- 비밀번호 재확인 입력 -->
      <div class="form-group" style="margin-bottom: 1.5rem; text-align: left;">
        <label for="deletePassword">현재 비밀번호 확인</label>
        <input type="password" id="deletePassword" name="password" class="input-control" placeholder="비밀번호를 입력하세요">
        <span class="error-msg" id="err-deletePw"></span>
      </div>

      <button type="button" class="button button--full" style="background: #e53e3e; color: #fff;" onclick="submitDeleteForm()">삭제 확정</button>
    </form>
  </div>
</div>

<!-- 스크립트 영역 -->
<script>
  // 기본 상수 및 원본 이미지 경로
  const DEFAULT_IMAGE_SRC = "${pageContext.request.contextPath}/upload/profile/default-profile.svg";
  const currentProfileImgSrc = "${not empty member.profileImage ? pageContext.request.contextPath.concat(member.profileImage) : pageContext.request.contextPath.concat('/upload/profile/default-profile.svg')}";

  // 모달 제어 함수 (전역)
  function openModal(id) {
    const modal = document.getElementById(id);
    if (modal) modal.classList.add('is-active');
  }

  function closeModal(id) {
    const modal = document.getElementById(id);
    if (!modal) return;

    modal.classList.remove('is-active');

    // 🟢 프로필 모달이 닫힐 때 선택 취소 처리
    if (id === 'modalProfile') {
      cancelProfileChange();
    }
  }

  // 🟢 프로필 이미지 변경 취소 함수
  function cancelProfileChange() {
    const modalProfileInput = document.getElementById('profile');
    const deleteProfileInput = document.getElementById('deleteProfile');
    const modalAvatarImg = document.getElementById('modalAvatarImg');
    const mainAvatarImg = document.getElementById('mainAvatarImg');

    if (modalProfileInput) modalProfileInput.value = "";
    if (deleteProfileInput) deleteProfileInput.value = "false";

    // 원래 이미지로 복구
    if (modalAvatarImg) modalAvatarImg.src = currentProfileImgSrc;
    if (mainAvatarImg) mainAvatarImg.src = currentProfileImgSrc;
  }

  // 🟢 DOM 요소 로드 완료 후 이벤트 바인딩
  document.addEventListener('DOMContentLoaded', function() {

    // 모달 배경 클릭 시 닫기
    window.addEventListener('click', function(e) {
      if (e.target.classList.contains('modal-overlay')) {
        closeModal(e.target.id);
      }
    });

    // 프로필 이미지 선택 시 즉시 미리보기
    const modalProfileInput = document.getElementById('profile');
    if (modalProfileInput) {
      modalProfileInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (!file) return;

        document.getElementById('deleteProfile').value = "false";

        const reader = new FileReader();
        reader.onload = function(event) {
          const base64Src = event.target.result;
          const modalAvatarImg = document.getElementById('modalAvatarImg');
          const mainAvatarImg = document.getElementById('mainAvatarImg');

          if (modalAvatarImg) modalAvatarImg.src = base64Src;
          if (mainAvatarImg) mainAvatarImg.src = base64Src;
        };
        reader.readAsDataURL(file);
      });
    }

    // 기본 이미지로 변경 버튼 클릭 이벤트
    const modalResetBtn = document.getElementById('modalResetAvatarBtn');
    if (modalResetBtn) {
      modalResetBtn.addEventListener('click', function() {
        const modalProfileInput = document.getElementById('profile');
        const deleteProfileInput = document.getElementById('deleteProfile');
        const modalAvatarImg = document.getElementById('modalAvatarImg');
        const mainAvatarImg = document.getElementById('mainAvatarImg');

        if (modalProfileInput) modalProfileInput.value = "";
        if (deleteProfileInput) deleteProfileInput.value = "true";

        if (modalAvatarImg) modalAvatarImg.src = DEFAULT_IMAGE_SRC;
        if (mainAvatarImg) mainAvatarImg.src = DEFAULT_IMAGE_SRC;
      });
    }
  });

  // ==================== [공통 유효성 처리 메세지 함수] ====================
  function showError(inputElem, errElem, message) {
    if (errElem) {
      errElem.innerText = message;
      errElem.classList.remove('success-msg');
      errElem.classList.add('has-error');
    }
  }

  function showSuccess(inputElem, errElem, message) {
    if (errElem) {
      errElem.innerText = message;
      errElem.classList.remove('has-error');
      errElem.classList.add('success-msg');
    }
  }

  function resetGuide(errElem) {
    if (errElem) {
      const defaultMsg = errElem.getAttribute('data-default') || '';
      errElem.innerText = defaultMsg;
      errElem.classList.remove('has-error', 'success-msg');
    }
  }

  function checkField(inputElem, errElem, validateFn) {
    const msg = validateFn(inputElem.value);
    if (msg) {
      showError(inputElem, errElem, msg);
      return false;
    } else {
      resetGuide(errElem);
      return true;
    }
  }

  // ==================== [유효성 검사 규칙들] ====================
  const currentNickname = "${member.nickname}";
  const currentPhone = "${member.memberPhone}";
  const currentEmail = "${member.memberEmail}";

  let isNicknameChecked = true;

  function validateNickname(val) {
    if (!val || val.trim() === '') return '닉네임을 입력해 주세요.';
    if (/\s/.test(val)) return '공백(띄어쓰기)을 포함할 수 없습니다.';
    if (val.length < 2 || val.length > 10) return '닉네임은 2자 이상 10자 이하로 입력해 주세요.';
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

  function validateEmail(val) {
    if (!val || val.trim() === '') return '이메일을 입력해 주세요.';
    if (/\s/.test(val)) return '공백(띄어쓰기)을 포함할 수 없습니다.';
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(val)) return '올바른 이메일 형식이 아닙니다.';
    return '';
  }

  function validatePassword(val) {
    if (!val || val.trim() === '') return '비밀번호를 입력해 주세요.';
    if (/\s/.test(val)) return '공백(띄어쓰기)을 포함할 수 없습니다.';
    if (val.length < 8 || val.length > 20) return '비밀번호는 8자 이상 20자 이하로 입력해 주세요.';
    const hasLetter = /[a-zA-Z]/.test(val);
    const hasNumber = /[0-9]/.test(val);
    const hasSpecial = /[!@#$%^&*]/.test(val);
    if (!hasLetter || !hasNumber || !hasSpecial) return '영문, 숫자, 특수문자를 모두 포함해야 합니다.';
    return '';
  }

  // ==================== [1. 닉네임 중복확인 & 실시간 이벤트] ====================
  function checkDuplicateNickname() {
    const nicknameInput = document.getElementById('nickname');
    const errNickname = document.getElementById('err-nickname');
    const nicknameValue = nicknameInput.value.trim();

    if (nicknameValue === currentNickname) {
      showSuccess(nicknameInput, errNickname, '현재 사용 중인 본인의 닉네임입니다.');
      isNicknameChecked = true;
      return;
    }

    if (!checkField(nicknameInput, errNickname, validateNickname)) {
      isNicknameChecked = false;
      return;
    }

    fetch('${pageContext.request.contextPath}/api/member/check-nickname?nickname=' + encodeURIComponent(nicknameValue))
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

  document.getElementById('nickname').addEventListener('input', function() {
    const val = this.value.trim();
    const errNickname = document.getElementById('err-nickname');
    if (val === currentNickname) {
      isNicknameChecked = true;
      showSuccess(this, errNickname, '현재 사용 중인 본인의 닉네임입니다.');
    } else {
      isNicknameChecked = false;
      checkField(this, errNickname, validateNickname);
    }
  });

  function submitNicknameForm() {
    const nicknameInput = document.getElementById('nickname');
    const errNickname = document.getElementById('err-nickname');
    const nicknameValue = nicknameInput.value.trim();

    if (nicknameValue === currentNickname) {
      showError(nicknameInput, errNickname, '현재 사용 중인 닉네임과 동일합니다.');
      nicknameInput.focus();
      return;
    }

    let isNicknameValid = checkField(nicknameInput, errNickname, validateNickname);
    if (isNicknameValid && !isNicknameChecked) {
      showError(nicknameInput, errNickname, '닉네임 중복확인을 진행해 주세요.');
      isNicknameValid = false;
    }

    if (isNicknameValid) {
      nicknameInput.value = nicknameValue;
      document.getElementById('formNickname').submit();
    } else {
      nicknameInput.focus();
    }
  }

  // ==================== [2. 전화번호 입력 제한 및 실시간 검사] ====================
  const phoneInput = document.getElementById('memberPhone');
  const errPhone = document.getElementById('err-phone');

  phoneInput.addEventListener('input', function() {
    this.value = this.value.replace(/[^0-9-]/g, '');
    const val = this.value.trim();

    if (val === currentPhone) {
      showSuccess(this, errPhone, '현재 사용 중인 전화번호입니다.');
    } else {
      checkField(this, errPhone, validatePhone);
    }
  });

  function submitPhoneForm() {
    const phoneInput = document.getElementById('memberPhone');
    const errPhone = document.getElementById('err-phone');
    const phoneValue = phoneInput.value.trim();

    if (phoneValue === currentPhone) {
      showError(phoneInput, errPhone, '현재 사용 중인 전화번호와 동일합니다.');
      phoneInput.focus();
      return;
    }

    if (checkField(phoneInput, errPhone, validatePhone)) {
      phoneInput.value = phoneValue;
      document.getElementById('formPhone').submit();
    } else {
      phoneInput.focus();
    }
  }

  // ==================== [3. 이메일 실시간 검사 및 제출] ====================
  const emailInput = document.getElementById('memberEmail');
  const errEmail = document.getElementById('err-email');

  emailInput.addEventListener('input', function() {
    const val = this.value.trim();

    if (val === currentEmail) {
      showSuccess(this, errEmail, '현재 사용 중인 이메일입니다.');
    } else {
      checkField(this, errEmail, validateEmail);
    }
  });

  function submitEmailForm() {
    const emailInput = document.getElementById('memberEmail');
    const errEmail = document.getElementById('err-email');
    const emailValue = emailInput.value.trim();

    if (emailValue === currentEmail) {
      showError(emailInput, errEmail, '현재 사용 중인 이메일과 동일합니다.');
      emailInput.focus();
      return;
    }

    if (checkField(emailInput, errEmail, validateEmail)) {
      emailInput.value = emailValue;
      document.getElementById('formEmail').submit();
    } else {
      emailInput.focus();
    }
  }

  // ==================== [4. 비밀번호 실시간 검사 및 제출] ====================
  const curPw = document.getElementById('currentPassword');
  const newPw = document.getElementById('newPassword');
  const confirmPw = document.getElementById('confirmPassword');

  const errCur = document.getElementById('err-currentPw');
  const errNew = document.getElementById('err-newPw');
  const errConfirm = document.getElementById('err-confirmPw');

  curPw.addEventListener('input', function() {
    const curVal = this.value;
    const newVal = newPw.value;

    if (!curVal || curVal.trim() === '') {
      showError(this, errCur, '현재 비밀번호를 입력해 주세요.');
    } else {
      resetGuide(errCur);
    }

    if (newVal && curVal && newVal === curVal) {
      showError(newPw, errNew, '현재 비밀번호와 동일한 비밀번호는 사용할 수 없습니다.');
    } else if (newVal) {
      checkField(newPw, errNew, validatePassword);
    }
  });

  newPw.addEventListener('input', function() {
    const newVal = this.value;
    const curVal = curPw.value;

    if (newVal && curVal && newVal === curVal) {
      showError(this, errNew, '현재 비밀번호와 동일한 비밀번호는 사용할 수 없습니다.');
    } else {
      checkField(this, errNew, validatePassword);
    }

    if (confirmPw.value) {
      if (confirmPw.value !== newVal) {
        showError(confirmPw, errConfirm, '새 비밀번호가 일치하지 않습니다.');
      } else {
        showSuccess(confirmPw, errConfirm, '비밀번호가 일치합니다.');
      }
    }
  });

  confirmPw.addEventListener('input', function() {
    if (this.value !== newPw.value) {
      showError(this, errConfirm, '새 비밀번호가 일치하지 않습니다.');
    } else {
      showSuccess(this, errConfirm, '비밀번호가 일치합니다.');
    }
  });

  function submitPasswordForm() {
    const curVal = curPw.value;
    const newVal = newPw.value;
    const confirmVal = confirmPw.value;

    let isValid = true;

    if (!curVal || curVal.trim() === '') {
      showError(curPw, errCur, '현재 비밀번호를 입력해 주세요.');
      isValid = false;
    }

    if (!checkField(newPw, errNew, validatePassword)) {
      isValid = false;
    } else if (newVal === curVal) {
      showError(newPw, errNew, '현재 비밀번호와 동일한 비밀번호는 사용할 수 없습니다.');
      isValid = false;
    }

    if (confirmVal !== newVal) {
      showError(confirmPw, errConfirm, '새 비밀번호가 일치하지 않습니다.');
      isValid = false;
    }

    if (isValid) {
      document.getElementById('formPassword').submit();
    }
  }

  // ==================== [5. 모달 내 키보드 Enter 처리] ====================
  document.addEventListener('keydown', function(event) {
    if (event.key === 'Enter') {
      const target = event.target;

      if (target.id === 'nickname') {
        event.preventDefault();
        if (isNicknameChecked) submitNicknameForm();
        else checkDuplicateNickname();
      }
      else if (target.id === 'memberPhone') {
        event.preventDefault();
        submitPhoneForm();
      }
      else if (target.id === 'memberEmail') {
        event.preventDefault();
        submitEmailForm();
      }
      else if (target.id === 'currentPassword') {
        event.preventDefault();
        newPw.focus();
      }
      else if (target.id === 'newPassword') {
        event.preventDefault();
        confirmPw.focus();
      }
      else if (target.id === 'confirmPassword') {
        event.preventDefault();
        submitPasswordForm();
      }
    }
  });

  // ==================== [계정 삭제 (Delete) 처리] ====================
  function submitDeleteForm() {
    const agreeCheck = document.getElementById('agreeDelete');
    const deletePw = document.getElementById('deletePassword');
    const errAgree = document.getElementById('err-agreeDelete');
    const errPw = document.getElementById('err-deletePw');

    let isValid = true;

    if (!agreeCheck.checked) {
      showError(null, errAgree, '안내문 확인 동의에 체크해 주세요.');
      isValid = false;
    } else {
      resetGuide(errAgree);
    }

    if (!deletePw.value || deletePw.value.trim() === '') {
      showError(deletePw, errPw, '현재 비밀번호를 입력해 주세요.');
      isValid = false;
    } else {
      resetGuide(errPw);
    }

    if (isValid) {
      if (confirm('정말로 계정을 삭제하시겠습니까? 30일간 보관 후 영구 삭제됩니다.')) {
        document.getElementById('formDelete').submit();
      }
    }
  }
</script>

<c:if test="${not empty successMessage}">
  <script>
    alert("${successMessage}");
  </script>
</c:if>

<c:if test="${not empty errorMessage}">
  <script>
    alert("${errorMessage}");
  </script>
</c:if>
</body>
</html>