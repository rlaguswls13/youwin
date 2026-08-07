<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" scope="request" />

<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Youwin 비밀번호 찾기">
    <title>Youwin | 비밀번호 찾기</title>
    <link rel="stylesheet" href="${ctx}/app.css">
    <link rel="stylesheet" href="${ctx}/home.css">
    <link rel="stylesheet" href="${ctx}/account.css">
</head>
<body class="account-support">
<div class="site-shell">
    <header class="site-header">
        <div class="site-container site-header__inner">
            <a class="brand" href="${ctx}/" aria-label="Youwin 홈">
                <span class="brand__mark">YW</span>
                <span>Youwin</span>
            </a>
            <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
                <a href="${ctx}/">홈</a>
                <a href="${ctx}/board">게시판</a>
                <a href="${ctx}/index">채팅방</a>
                <a href="${ctx}/member/mypage">마이페이지</a>
                <div class="user-menu">
                    <c:if test="${not empty sessionScope.loginUser}">
                        <span><strong>${sessionScope.loginUser.memberId}</strong>님 환영합니다!</span>
                        <a href="${ctx}/member/logout">로그아웃</a>
                    </c:if>
                    <c:if test="${empty sessionScope.loginUser}">
                        <a href="${ctx}/auth/login">로그인</a>
                        <a href="${ctx}/member/joinStep1">회원가입</a>
                    </c:if>
                </div>
            </nav>
            <div class="site-header__actions">
                <a class="avatar-link" href="${ctx}/member/mypage" aria-label="마이페이지">YU</a>
            </div>
            <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
        </div>
    </header>

    <main class="page-main">
        <div class="site-container account-container">
            <div class="surface account-card">
                <div class="section-head mb-24">
                    <div>
                        <h1 class="section-title" id="pageTitle">비밀번호 찾기</h1>
                        <p class="section-copy" id="pageSubTitle">가입하신 아이디와 이메일 정보를 입력해 주세요.</p>
                    </div>
                </div>

                <!-- Step 1: 아이디 & 이메일 인증 -->
                <form id="findPwForm" class="account-form" onsubmit="return false;">
                    <div class="form-group">
                        <label for="memberId">아이디</label>
                        <input type="text" id="memberId" name="memberId" class="input-control" placeholder="아이디를 입력하세요">
                        <span class="msg-text msg-error" id="err-id"></span>
                    </div>

                    <div class="form-group">
                        <label for="memberEmail">이메일</label>
                        <div class="input-group-btn">
                            <input type="email" id="memberEmail" name="memberEmail" class="input-control" placeholder="example@youwin.com">
                            <button type="button" class="btn-sub" onclick="sendAuthCode()">인증 요청</button>
                        </div>
                        <span class="msg-text" id="err-email"></span>
                    </div>

                    <div id="authCodeGroup" class="form-group hidden">
                        <label for="authCode">인증번호</label>
                        <div class="input-group-btn pos-relative">
                            <input type="text" id="authCode" class="input-control" maxlength="6" placeholder="인증번호 6자리">
                            <span class="timer-badge" id="timer">05:00</span>
                            <button type="button" class="btn-sub" onclick="verifyAuthCode()">확인</button>
                        </div>
                        <span class="msg-text" id="err-auth-code"></span>
                    </div>
                </form>

                <!-- Step 2: 새 비밀번호 설정 -->
                <form id="resetPwForm" class="hidden account-form" onsubmit="return false;">
                    <div class="form-group">
                        <label for="newPassword">새 비밀번호</label>
                        <input type="password" id="newPassword" class="input-control" placeholder="8~20자, 특수문자 포함">
                        <span class="msg-text msg-error" id="err-pw"></span>
                    </div>

                    <div class="form-group">
                        <label for="newPasswordConfirm">새 비밀번호 확인</label>
                        <input type="password" id="newPasswordConfirm" class="input-control" placeholder="비밀번호 재입력">
                        <span class="msg-text msg-error" id="err-pw-confirm"></span>
                    </div>

                    <button type="button" class="button btn-full mt-8" onclick="resetPasswordSubmit()">비밀번호 변경 완료</button>
                </form>

                <div class="account-links">
                    <a class="text-link" href="${ctx}/member/findId">아이디 찾기</a>
                    <a class="text-link" href="${ctx}/auth/login">로그인으로 돌아가기</a>
                </div>
            </div>
        </div>
    </main>

    <footer class="site-footer">
        <div class="site-container site-footer__inner">
            <span>© 2026 Youwin. 음악으로 연결되는 커뮤니티.</span>
            <div class="site-footer__links">
                <a href="${ctx}/board">공지사항</a>
                <a href="#">이용약관</a>
                <a href="#">개인정보처리방침</a>
            </div>
        </div>
    </footer>
</div>

<script>
    const CTX = "${ctx}";
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

    function sendAuthCode() {
        const memberId = document.getElementById('memberId').value.trim();
        const email = document.getElementById('memberEmail').value.trim();

        clearMsg('err-id');
        clearMsg('err-email');

        if (!memberId) { showMsg('err-id', '아이디를 입력해 주세요.', false); return; }
        if (!email) { showMsg('err-email', '이메일을 입력해 주세요.', false); return; }

        showMsg('err-email', '정보 확인 및 인증번호 발송 중...', true);

        fetch(`${CTX}/api/member/find-pw/send-code`, {
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

    function verifyAuthCode() {
        const email = document.getElementById('memberEmail').value.trim();
        const code = document.getElementById('authCode').value.trim();

        if (!code || code.length !== 6) {
            showMsg('err-auth-code', '6자리 인증번호를 입력해 주세요.', false);
            return;
        }

        fetch(`${CTX}/api/member/verify-code`, {
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

        const pwPattern = /^(?=.*[a-zA-Z])(?=.*\d)(?=.*[!@#$%^&*]).{8,20}$/;
        if (!pwPattern.test(newPassword)) {
            showMsg('err-pw', '8~20자, 영문/숫자/특수문자(!@#$%^&*)를 모두 포함해야 합니다.', false);
            return;
        }

        if (newPassword !== newPasswordConfirm) {
            showMsg('err-pw-confirm', '비밀번호가 일치하지 않습니다.', false);
            return;
        }

        fetch(`${CTX}/api/member/reset-pw`, {
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
                    location.href = `${CTX}/auth/login`;
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
<script src="${ctx}/app.js"></script>
</body>
</html>