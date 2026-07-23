<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Youwin | 비밀번호 재설정</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/home.css">
</head>
<body>
<div class="site-shell">
  <header class="site-header">
    <div class="site-container site-header__inner">
      <a class="brand" href="${pageContext.request.contextPath}/">
        <span class="brand__mark">YW</span>
        <span>Youwin</span>
      </a>
    </div>
  </header>

  <main class="page-main">
    <div class="site-container" style="max-width: 480px; padding-top: 60px; padding-bottom: 80px;">
      <div class="surface" style="padding: 32px; border-radius: 16px;">
        <div class="section-head" style="margin-bottom: 24px;">
          <div>
            <h1 class="section-title" style="font-size: 24px;">새 비밀번호 설정</h1>
            <p class="section-copy">새롭게 사용할 비밀번호를 입력해 주세요.</p>
          </div>
        </div>

        <c:if test="${not empty errorMessage}">
          <div style="background-color: rgba(239, 68, 68, 0.1); color: #ef4444; padding: 12px 16px; border-radius: 8px; margin-bottom: 20px; font-size: 14px;">
              ${errorMessage}
          </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/member/resetPassword" method="post" style="display: flex; flex-direction: column; gap: 16px;">
          <div>
            <label for="newPassword" style="display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #ffffff;">새 비밀번호</label>
            <input type="password" id="newPassword" name="newPassword" placeholder="새 비밀번호를 입력하세요" required
                   style="width: 100%; padding: 12px; border-radius: 8px; border: 1px solid rgba(255, 255, 255, 0.2); background: #1a1a1a; color: #ffffff; font-size: 15px; box-sizing: border-box; outline: none;">
          </div>

          <button type="submit" class="button" style="width: 100%; margin-top: 8px;">비밀번호 변경 완료</button>
        </form>
      </div>
    </div>
  </main>

  <footer class="site-footer">
    <div class="site-container site-footer__inner">
      <span>© Youwin. 음악으로 연결되는 커뮤니티.</span>
    </div>
  </footer>
</div>
</body>
</html>