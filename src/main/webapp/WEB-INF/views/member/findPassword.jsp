<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Youwin 비밀번호 찾기">
    <title>Youwin | 비밀번호 찾기</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/home.css">
    <style>
        .hidden { display: none !important; }

        /* Input Group 배치 */
        .input-group-btn {
            display: flex;
            gap: 8px;
            margin-top: 8px;
            position: relative;
        }
        .input-group-btn input { flex: 1; }

        /* 1. 서브 버튼 (인증 요청, 확인 버튼) 스타일 보정 */
        .btn-sub {
            padding: 0 18px;
            white-space: nowrap;
            background-color: #4f46e5; /* 보라/파란계열의 확실한 포인트 컬러 */
            color: #ffffff !important;  /* 흰색 글자 고정 */
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.2s ease-in-out;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }
        .btn-sub:hover {
            background-color: #4338ca; /* 호버 시 약간 더 어둡게 */
        }
        .btn-sub:active {
            transform: scale(0.98);
        }

        /* 2. 메인 제출 버튼 (아이디 찾기 / 비밀번호 변경 완료 버튼) 스타일 보정 */
        .button {
            width: 100%;
            padding: 14px;
            background-color: #6366f1 !important; /* 밝고 명확한 브랜드 컬러 */
            color: #ffffff !important;            /* 글자 확실하게 보이도록 지정 */
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        .button:hover {
            background-color: #4f46e5 !important;
        }

        /* 메시지 및 타이머 스타일 */
        .msg-text { font-size: 12px; margin-top: 6px; display: block; }
        .msg-error { color: #f87171; }
        .msg-success { color: #4ade80; }
        .timer-badge {
            position: absolute;
            right: 110px;
            top: 50%;
            transform: translateY(-50%);
            color: #f87171;
            font-size: 13px;
            font-weight: bold;
            pointer-events: none;
        }
    </style>
</head>
<body>
<div class="site-shell">
    <!-- 헤더 영역 -->
    <header class="site-header">
        <div class="site-container site-header__inner">
            <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈">
                <span class="brand__mark">YW</span>
                <span>Youwin</span>
            </a>
            <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
                <a href="${pageContext.request.contextPath}/">홈</a>
                <a href="${pageContext.request.contextPath}/board">게시판</a>
                <a href="${pageContext.request.contextPath}/chatroom">채팅방</a>
                <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
                <div class="user-menu">
                    <c:if test="${not empty sessionScope.loginUser}">
                        <span><strong>${sessionScope.loginUser.memberId}</strong>님 환영합니다!</span>
                        <a href="${pageContext.request.contextPath}/member/logout">로그아웃</a>
                    </c:if>
                    <c:if test="${empty sessionScope.loginUser}">
                        <a href="${pageContext.request.contextPath}/member/login">로그인</a>
                        <a href="${pageContext.request.contextPath}/member/joinStep1">회원가입</a>
                    </c:if>
                </div>
            </nav>
            <div class="site-header__actions">
                <a class="avatar-link" href="${pageContext.request.contextPath}/member/mypage" aria-label="마이페이지">YU</a>
            </div>
        </div>
    </header>

    <!-- 메인 콘텐츠 영역 -->
    <main class="page-main">
        <div class="site-container" style="max-width: 480px; padding-top: 60px; padding-bottom: 80px;">
            <div class="surface" style="padding: 32px; border-radius: 16px;">
                <div class="section-head" style="margin-bottom: 24px;">
                    <div>
                        <h1 class="section-title" id="pageTitle" style="font-size: 24px;">비밀번호 찾기</h1>
                        <p class="section-copy" id="pageSubTitle">가입하신 아이디와 이메일 정보를 입력해 주세요.</p>
                    </div>
                </div>

                <!-- Step 1: 아이디 & 이메일 인증 -->
                <form id="findPwForm" onsubmit="return false;" style="display: flex; flex-direction: column; gap: 16px;">
                    <div>
                        <label for="memberId" style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #ffffff;">아이디</label>
                        <input type="text" id="memberId" name="memberId" placeholder="아이디를 입력하세요"
                               style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.2); background: #1a1a1a; color: #ffffff; font-size: 15px; box-sizing: border-box; outline: none;">
                        <span class="msg-text msg-error" id="err-id"></span>
                    </div>

                    <div>
                        <label for="memberEmail" style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #ffffff;">이메일</label>
                        <div class="input-group-btn">
                            <input type="email" id="memberEmail" name="memberEmail" placeholder="example@youwin.com"
                                   style="padding: 12px; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.2); background: #1a1a1a; color: #ffffff; font-size: 15px; box-sizing: border-box; outline: none;">
                            <button type="button" class="btn-sub" onclick="sendAuthCode()">인증 요청</button>
                        </div>
                        <span class="msg-text" id="err-email"></span>
                    </div>

                    <!-- 인증번호 입력란 (기본 숨김) -->
                    <div id="authCodeGroup" class="hidden">
                        <label for="authCode" style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #ffffff;">인증번호</label>
                        <div class="input-group-btn" style="position: relative;">
                            <input type="text" id="authCode" maxlength="6" placeholder="인증번호 6자리"
                                   style="padding: 12px; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.2); background: #1a1a1a; color: #ffffff; font-size: 15px; box-sizing: border-box; outline: none;">
                            <span class="timer-badge" id="timer">05:00</span>
                            <button type="button" class="btn-sub" onclick="verifyAuthCode()">확인</button>
                        </div>
                        <span class="msg-text" id="err-auth-code"></span>
                    </div>
                </form>

                <!-- Step 2: 새 비밀번호 설정 (인증 완료 시 표시) -->
                <form id="resetPwForm" class="hidden" onsubmit="return false;" style="display: flex; flex-direction: column; gap: 16px;">
                    <div>
                        <label for="newPassword" style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #ffffff;">새 비밀번호</label>
                        <input type="password" id="newPassword" placeholder="8~20자, 특수문자 포함"
                               style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.2); background: #1a1a1a; color: #ffffff; font-size: 15px; box-sizing: border-box; outline: none;">
                        <span class="msg-text msg-error" id="err-pw"></span>
                    </div>

                    <div>
                        <label for="newPasswordConfirm" style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #ffffff;">새 비밀번호 확인</label>
                        <input type="password" id="newPasswordConfirm" placeholder="비밀번호 재입력"
                               style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.2); background: #1a1a1a; color: #ffffff; font-size: 15px; box-sizing: border-box; outline: none;">
                        <span class="msg-text msg-error" id="err-pw-confirm"></span>
                    </div>

                    <button type="button" class="button" onclick="resetPasswordSubmit()" style="width: 100%; margin-top: 8px;">비밀번호 변경 완료</button>
                </form>

                <div style="margin-top: 24px; padding-top: 16px; border-top: 1px solid rgba(255, 255, 255, 0.1); display: flex; justify-content: space-between; font-size: 14px;">
                    <a class="text-link" href="${pageContext.request.contextPath}/member/findId">아이디 찾기</a>
                    <a class="text-link" href="${pageContext.request.contextPath}/member/login">로그인으로 돌아가기</a>
                </div>
            </div>
        </div>
    </main>

    <!-- 푸터 영역 -->
    <footer class="site-footer">
        <div class="site-container site-footer__inner">
            <span>© 2026 Youwin. 음악으로 연결되는 커뮤니티.</span>
            <div class="site-footer__links">
                <a href="${pageContext.request.contextPath}/board">공지사항</a>
                <a href="#">이용약관</a>
                <a href="#">개인정보처리방침</a>
            </div>
        </div>
    </footer>
</div>

<script>
    let isEmailVerified = false;
    let timerInterval = null;

    function showMsg(elemId, msg, isSuccess) {
        const target = document.getElementById(elemId);
        target.innerText = msg;
        target.className = 'msg-text ' + (isSuccess ? 'msg-success' : 'msg-error');
    }

    function clearMsg(elemId) {
        const target = document.getElementById(elemId);
        target.innerText = '';
    }

    // 1. 인증번호 요청 (아이디 + 이메일 검증)
    function sendAuthCode() {
        const memberId = document.getElementById('memberId').value.trim();
        const email = document.getElementById('memberEmail').value.trim();

        clearMsg('err-id');
        clearMsg('err-email');

        if (!memberId) { showMsg('err-id', '아이디를 입력해 주세요.', false); return; }
        if (!email) { showMsg('err-email', '이메일을 입력해 주세요.', false); return; }

        showMsg('err-email', '정보 확인 및 인증번호 발송 중...', true);

        fetch('${pageContext.request.contextPath}/api/member/find-pw/send-code', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ memberId: memberId, memberEmail: email })
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    showMsg('err-email', '인증번호가 발송되었습니다.', true);
                    document.getElementById('authCodeGroup').classList.remove('hidden');
                    document.getElementById('authCode').focus();
                    startTimer(300);
                } else {
                    showMsg('err-email', data.message || '일치하는 회원 정보가 없습니다.', false);
                }
            })
            .catch(() => showMsg('err-email', '서버 통신 중 오류가 발생했습니다.', false));
    }

    // 2. 인증번호 대조
    function verifyAuthCode() {
        const email = document.getElementById('memberEmail').value.trim();
        const code = document.getElementById('authCode').value.trim();

        if (!code || code.length !== 6) {
            showMsg('err-auth-code', '6자리 인증번호를 입력해 주세요.', false);
            return;
        }

        fetch('${pageContext.request.contextPath}/api/member/verify-code', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ memberEmail: email, code: code })
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert('이메일 인증이 완료되었습니다. 새 비밀번호를 설정해 주세요.');
                    isEmailVerified = true;
                    clearInterval(timerInterval);

                    // UI를 Step 2(새 비밀번호 입력창)로 교체
                    document.getElementById('findPwForm').classList.add('hidden');
                    document.getElementById('resetPwForm').classList.remove('hidden');
                    document.getElementById('pageTitle').innerText = '새 비밀번호 설정';
                    document.getElementById('pageSubTitle').innerText = '새롭게 사용할 비밀번호를 입력해 주세요.';
                } else {
                    showMsg('err-auth-code', data.message || '인증번호가 일치하지 않습니다.', false);
                    isEmailVerified = false;
                }
            });
    }

    // 3. 비밀번호 재설정 제출
    function resetPasswordSubmit() {
        if (!isEmailVerified) {
            alert('이메일 인증이 완료되지 않았습니다.');
            return;
        }

        const memberId = document.getElementById('memberId').value.trim();
        const email = document.getElementById('memberEmail').value.trim();
        const newPassword = document.getElementById('newPassword').value;
        const newPasswordConfirm = document.getElementById('newPasswordConfirm').value;

        clearMsg('err-pw');
        clearMsg('err-pw-confirm');

        // 비밀번호 유효성 검사 (8~20자, 특수문증 포함 규칙)
        const pwPattern = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,20}$/;
        if (!pwPattern.test(newPassword)) {
            showMsg('err-pw', '8~20자, 영문/숫자/특수문자(!@#$%^&*)를 모두 포함해야 합니다.', false);
            return;
        }

        if (newPassword !== newPasswordConfirm) {
            showMsg('err-pw-confirm', '비밀번호가 일치하지 않습니다.', false);
            return;
        }

        fetch('${pageContext.request.contextPath}/api/member/reset-pw', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({
                memberId: memberId,
                memberEmail: email,
                newPassword: newPassword
            })
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert('비밀번호가 성공적으로 변경되었습니다. 로그인 페이지로 이동합니다.');
                    location.href = '${pageContext.request.contextPath}/member/login';
                } else {
                    alert(data.message || '비밀번호 변경에 실패했습니다.');
                }
            })
            .catch(() => alert('서버 통신 중 오류가 발생했습니다.'));
    }

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
                showMsg('err-auth-code', '인증시간이 만료되었습니다. 다시 요청해주세요.', false);
            }
        }, 1000);
    }
</script>
<script src="${pageContext.request.contextPath}/app.js"></script>
</body>
</html>