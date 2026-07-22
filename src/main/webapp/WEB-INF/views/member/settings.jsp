<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="description" content="Youwin 프로필 설정">
  <title>프로필 설정 | Youwin</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/mypage.css">
</head>
<body>
<div class="site-shell">
  <!-- 상단 헤더 (마이페이지 활성화 유지) -->
  <header class="site-header">
    <div class="site-container site-header__inner">
      <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈"><span class="brand__mark">YW</span><span>Youwin</span></a>
      <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
        <a href="${pageContext.request.contextPath}/">홈</a>
        <a href="${pageContext.request.contextPath}/board">게시판</a>
        <a href="${pageContext.request.contextPath}/chatroom">채팅방</a>
        <a class="is-active" href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
      </nav>
      <div class="site-header__actions">
        <a class="button button--secondary" href="${pageContext.request.contextPath}/member/settings">프로필 설정</a>
        <span class="avatar">YU</span>
      </div>
      <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
    </div>
  </header>

  <!-- 메인 컨텐츠 영역 -->
  <main class="page-main">
    <div class="site-container">

      <!-- 페이지 상단 타이틀 -->
      <section class="section-head page-head">
        <div>
          <h1 class="section-title">프로필 수정</h1>
          <p class="section-copy">Youwin에서 사용되는 회원님의 기본 정보와 음악 취향을 변경할 수 있습니다.</p>
        </div>
      </section>

      <!-- 프로필 수정 폼 -->
      <form action="${pageContext.request.contextPath}/member/updateProfile" method="post" enctype="multipart/form-data">
        <div class="mypage-grid">

          <!-- 왼쪽 : 기본 정보 입력 폼 -->
          <div class="form-section-group">

            <!-- 1. 아바타 & 이미지 변경 -->
            <section class="surface mypage-card">
              <h2 class="section-title">프로필 이미지</h2>
              <div class="profile-avatar-edit">
                <div class="profile-avatar" aria-hidden="true">YU</div>
                <div class="avatar-upload-action">
                  <input type="file" id="profileImage" name="profileImage" accept="image/*" hidden>
                  <label for="profileImage" class="button button--secondary">사진 변경</label>
                  <button type="button" class="button button--text">기본 이미지로 변경</button>
                </div>
              </div>
            </section>

            <!-- 2. 기본 계정 정보 -->
            <section class="surface mypage-card">
              <h2 class="section-title">계정 정보</h2>

              <div class="form-group">
                <label for="userId">아이디 (변경 불가)</label>
                <input type="text" id="userId" name="userId" value="youwin_user" readonly class="input-control input-control--readonly">
              </div>

              <div class="form-group">
                <label for="nickname">닉네임</label>
                <input type="text" id="nickname" name="nickname" value="Youwin Listener" required class="input-control">
              </div>

              <div class="form-group">
                <label for="bio">한 줄 소개</label>
                <textarea id="bio" name="bio" rows="3" class="input-control" placeholder="나를 표현하는 한 줄 소개를 입력해주세요.">오늘도 시티팝 듣는 중 🎧</textarea>
              </div>
            </section>

            <!-- 3. 비밀번호 변경 (옵션) -->
            <section class="surface mypage-card">
              <h2 class="section-title">비밀번호 변경</h2>
              <p class="section-copy">비밀번호를 변경할 때만 입력해주세요.</p>

              <div class="form-group">
                <label for="currentPassword">현재 비밀번호</label>
                <input type="password" id="currentPassword" name="currentPassword" class="input-control" placeholder="현재 비밀번호">
              </div>

              <div class="form-group">
                <label for="newPassword">새 비밀번호</label>
                <input type="password" id="newPassword" name="newPassword" class="input-control" placeholder="새 비밀번호">
              </div>

              <div class="form-group">
                <label for="confirmPassword">새 비밀번호 확인</label>
                <input type="password" id="confirmPassword" name="confirmPassword" class="input-control" placeholder="새 비밀번호 확인">
              </div>
            </section>

          </div>

          <!-- 오른쪽 : 음악 취향 설정 및 저장 버튼 -->
          <aside>
            <!-- 음악 취향 선택 -->
            <section class="surface preference-card">
              <div class="section-head">
                <div>
                  <h2 class="section-title">선호 장르 선택</h2>
                  <p class="section-copy">추천 음악에 반영할 장르를 선택하세요.</p>
                </div>
              </div>
              <!-- 칩 형태의 체크박스 영역 -->
              <div class="preference-tags-edit">
                <label class="chip-checkbox">
                  <input type="checkbox" name="genres" value="City Pop" checked hidden>
                  <span class="chip">City Pop</span>
                </label>
                <label class="chip-checkbox">
                  <input type="checkbox" name="genres" value="Indie" checked hidden>
                  <span class="chip">Indie</span>
                </label>
                <label class="chip-checkbox">
                  <input type="checkbox" name="genres" value="Jazz" checked hidden>
                  <span class="chip">Jazz</span>
                </label>
                <label class="chip-checkbox">
                  <input type="checkbox" name="genres" value="Lo-Fi" checked hidden>
                  <span class="chip">Lo-Fi</span>
                </label>
                <label class="chip-checkbox">
                  <input type="checkbox" name="genres" value="R&B" checked hidden>
                  <span class="chip">R&B</span>
                </label>
                <label class="chip-checkbox">
                  <input type="checkbox" name="genres" value="Rock" hidden>
                  <span class="chip">Rock</span>
                </label>
                <label class="chip-checkbox">
                  <input type="checkbox" name="genres" value="Pop" hidden>
                  <span class="chip">Pop</span>
                </label>
              </div>
            </section>

            <!-- 저장/취소 액션 버튼 -->
            <section class="surface action-card">
              <button type="submit" class="button button--full">저장하기</button>
              <a href="${pageContext.request.contextPath}/member/mypage" class="button button--secondary button--full">취소</a>
            </section>
          </aside>

        </div>
      </form>

    </div>
  </main>

  <!-- 하단 푸터 -->
  <footer class="site-footer">
    <div class="site-container site-footer__inner">
      <span>© 2026 Youwin.</span>
      <div class="site-footer__links">
        <a href="${pageContext.request.contextPath}/board">고객센터</a>
        <a href="#">로그아웃</a>
      </div>
    </div>
  </footer>
</div>
<script src="${pageContext.request.contextPath}/app.js"></script>
</body>
</html>