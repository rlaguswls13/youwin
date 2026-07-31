<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>탈퇴 신청 계정 복구</title>
  <style>
    .container { width: 400px; margin: 50px auto; text-align: center; font-family: sans-serif; }
    .info-box { background-color: #fff3cd; border: 1px solid #ffeeba; padding: 15px; margin-bottom: 20px; color: #856404; }
    .input-group { margin-bottom: 15px; }
    input[type="text"] { width: 70%; padding: 8px; }
    button { padding: 8px 15px; cursor: pointer; }
    .btn-submit { width: 100%; background: #28a745; color: white; border: none; padding: 10px; }
  </style>
</head>
<body>
<div class="container">
  <h2>⚠️ 탈퇴 신청 계정 안내</h2>
  <div class="info-box">
    <p>회원님의 계정(<strong>${memberId}</strong>)은 현재 <strong>탈퇴 유예(대기) 상태</strong>입니다.</p>
    <p>이메일 인증을 완료하시면 탈퇴 신청이 취소되어 즉시 계정이 복구됩니다.</p>
  </div>

  <form id="restoreForm">
    <div class="input-group">
      <p>등록된 이메일: <strong>${memberEmail}</strong></p>
      <button type="button" id="btnSendCode">인증번호 발송</button>
    </div>

    <div class="input-group">
      <input type="text" id="authCode" placeholder="인증번호 6자리 입력" disabled>
      <button type="button" id="btnVerify" class="btn-submit" style="margin-top: 10px;">탈퇴 취소 및 계정 복구</button>
    </div>
  </form>
</div>

<script>
  // 1. 인증번호 발송 요청
  document.getElementById('btnSendCode').addEventListener('click', function() {
    const authInput = document.getElementById('authCode');

    fetch('/api/member/send-recovery-code', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ memberEmail: '${memberEmail}' })
    })
            .then(res => res.json())
            .then(data => {
              if (data.success) {
                alert(data.message);
                authInput.disabled = false;
                authInput.focus();
              } else {
                alert(data.message);
              }
            })
            .catch(error => {
              console.error('Error:', error);
              alert('인증번호 발송 실패!');
            });
  });

  // 2. 계정 복구 요청
  document.getElementById('btnVerify').addEventListener('click', function() {
    const authInput = document.getElementById('authCode');
    const code = authInput.value.trim();

    if (!code) {
      alert('인증번호를 입력해 주세요.');
      return;
    }

    fetch('/api/member/restoreAccount', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ code: code })
    })
            .then(res => res.text())
            .then(res => {
              if (res === 'SUCCESS') {
                alert('계정이 성공적으로 복구되었습니다! 다시 로그인해 주세요.');
                location.href = '/member/login';
              } else if (res === 'FAIL') {
                alert('인증번호가 올바르지 않습니다.');
              } else {
                alert('세션이 만료되었습니다. 다시 로그인 시도해 주세요.');
                location.href = '/member/login';
              }
            })
            .catch(error => {
              console.error('Error:', error);
              alert('처리 중 오류가 발생했습니다.');
            });
  });
</script>
</body>
</html>