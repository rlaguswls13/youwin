<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Youwin 아이디 찾기">
    <title>Youwin | 아이디 찾기</title>
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
                        <h1 class="section-title" style="font-size: 24px;">아이디 찾기</h1>
                        <p class="section-copy">가입 시 등록하신 이름과 이메일로 인증 후 아이디를 확인합니다.</p>
                    </div>
                </div>

                <!-- 아이디 찾기 입력 폼 -->
                <form id="findIdForm" onsubmit="return false;" style="display: flex; flex-direction: column; gap: 16px;">
                    <!-- 1. 이름 입력 -->
                    <div>
                        <label for="memberName" style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #ffffff;">이름</label>
                        <input type="text" id="memberName" name="memberName" placeholder="이름을 입력하세요"
                               style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.2); background: #1a1a1a; color: #ffffff; font-size: 15px; box-sizing: border-box; outline: none;">
                        <span class="msg-text msg-error" id="err-name"></span>
                    </div>

                    <!-- 2. 이메일 입력 및 인증 버튼 -->
                    <div>
                        <label for="memberEmail" style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #ffffff;">이메일</label>
                        <div class="input-group-btn">
                            <input type="email" id="memberEmail" name="memberEmail" placeholder="example@youwin.com"
                                   style="padding: 12px; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.2); background: #1a1a1a; color: #ffffff; font-size: 15px; box-sizing: border-box; outline: none;">
                            <button type="button" class="btn-sub" onclick="sendAuthCode()">인증 요청</button>
                        </div>
                        <span class="msg-text" id="err-email"></span>
                    </div>

                    <!-- 3. 인증번호 입력 영역 (기본 숨김) -->
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

                    <!-- 4. 결과 출력 박스 (기본 숨김) -->
                    <div id="resultBox" class="hidden" style="background-color: rgba(99, 102, 241, 0.15); border: 1px solid #6366f1; padding: 20px; border-radius: 12px; text-align: center; margin-top: 8px;">
                        <p style="margin: 0; font-size: 14px; color: #cbd5e1;">회원님의 아이디는 다음과 같습니다.</p>
                        <p style="margin: 10px 0 0 0; font-size: 20px; font-weight: bold; color: #ffffff;" id="foundMemberId"></p>
                    </div>

                    <!-- 5. 제출 버튼 -->
                    <button type="button" id="btnSubmit" class="button" onclick="findIdSubmit()" style="width: 100%; margin-top: 8px;">아이디 찾기</button>
                </form>

                <div style="margin-top: 24px; padding-top: 16px; border-top: 1px solid rgba(255, 255, 255, 0.1); display: flex; justify-content: space-between; font-size: 14px;">
                    <a class="text-link" href="${pageContext.request.contextPath}/member/findPassword">비밀번호 찾기</a>
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

    // 메시지 출력 헬퍼
    function showMsg(elemId, msg, isSuccess) {
        const target = document.getElementById(elemId);
        target.innerText = msg;
        target.className = 'msg-text ' + (isSuccess ? 'msg-success' : 'msg-error');
    }

    function clearMsg(elemId) {
        const target = document.getElementById(elemId);
        target.innerText = '';
    }

    // 1. 인증번호 요청 (이름 + 이메일 검증 후 발송)
    function sendAuthCode() {
        const name = document.getElementById('memberName').value.trim();
        const email = document.getElementById('memberEmail').value.trim();

        clearMsg('err-name');
        clearMsg('err-email');

        if (!name) { showMsg('err-name', '이름을 입력해 주세요.', false); return; }
        if (!email) { showMsg('err-email', '이메일을 입력해 주세요.', false); return; }

        showMsg('err-email', '정보 확인 및 인증번호 발송 중...', true);

        fetch('${pageContext.request.contextPath}/api/member/find-id/send-code', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ memberName: name, memberEmail: email })
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    showMsg('err-email', '인증번호가 발송되었습니다.', true);
                    document.getElementById('authCodeGroup').classList.remove('hidden');
                    document.getElementById('authCode').focus();
                    startTimer(300); // 5분
                } else {
                    showMsg('err-email', data.message || '일치하는 회원 정보가 없습니다.', false);
                }
            })
            .catch(() => showMsg('err-email', '서버 통신 중 오류가 발생했습니다.', false));
    }

    // 2. 인증번호 확인
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
                    showMsg('err-auth-code', '이메일 인증이 완료되었습니다.', true);
                    isEmailVerified = true;
                    clearInterval(timerInterval);
                    document.getElementById('timer').innerText = '';
                    document.getElementById('memberName').readOnly = true;
                    document.getElementById('memberEmail').readOnly = true;
                    document.getElementById('authCode').readOnly = true;
                } else {
                    showMsg('err-auth-code', data.message || '인증번호가 일치하지 않습니다.', false);
                    isEmailVerified = false;
                }
            });
    }

    // 3. 최종 아이디 조회 실행
    function findIdSubmit() {
        if (!isEmailVerified) {
            alert('이메일 인증을 먼저 완료해 주세요.');
            return;
        }

        const name = document.getElementById('memberName').value.trim();
        const email = document.getElementById('memberEmail').value.trim();

        fetch('${pageContext.request.contextPath}/api/member/find-id', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ memberName: name, memberEmail: email })
        })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    document.getElementById('foundMemberId').innerText = data.memberId;
                    document.getElementById('resultBox').classList.remove('hidden');
                    document.getElementById('btnSubmit').classList.add('hidden'); // 조회 성공 시 버튼 숨김
                } else {
                    alert(data.message);
                }
            });
    }

    // 타이머 헬퍼
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