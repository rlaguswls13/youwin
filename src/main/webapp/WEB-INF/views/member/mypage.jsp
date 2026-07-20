<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>마이페이지</title>
  <style>
    /* 전체 기본 설정 */
    body {
      background-color: #ededed;
      font-family: 'Malgun Gothic', sans-serif;
      margin: 0;
      padding: 20px;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
      box-sizing: border-box;
    }

    /* 메인 컨테이너 (스케치의 큰 테두리 바깥창 모양) */
    .main-window {
      width: 100%;
      max-width: 1000px;
      background-color: #ffffff;
      border: 2px solid #333;
      border-radius: 8px;
      box-shadow: 5px 5px 0px #bcbcbc;
      overflow: hidden;
    }

    /* 브라우저 상단 바 감성 (점 3개) */
    .window-header {
      background-color: #ffffff;
      padding: 10px;
      border-bottom: 2px solid #333;
      display: flex;
      gap: 6px;
    }
    .window-dot {
      width: 8px;
      height: 8px;
      background-color: #333;
      border-radius: 50%;
    }

    /* 내부 레이아웃 배치 */
    .window-content {
      padding: 20px;
      display: grid;
      grid-template-columns: 1fr 320px; /* 왼쪽 콘텐츠 영역 : 오른쪽 RECORD 영역 */
      gap: 20px;
    }

    /* 왼쪽 상단 프로필 + 메뉴 섹션 */
    .top-section {
      display: grid;
      grid-template-columns: 1fr auto;
      gap: 15px;
      margin-bottom: 20px;
    }

    /* 유저 프로필 카드 */
    .profile-card {
      border: 2px solid #333;
      border-radius: 6px;
      padding: 15px;
      display: flex;
      gap: 15px;
    }
    .profile-avatar {
      width: 80px;
      height: 80px;
      border: 2px solid #333;
      border-radius: 6px;
      background-color: #f0f0f0;
      display: flex;
      justify-content: center;
      align-items: center;
    }
    .profile-avatar svg {
      width: 80%;
      height: 80%;
      fill: #aaa;
    }
    .profile-info {
      flex: 1;
    }
    .profile-header {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 10px;
    }
    .profile-name {
      font-size: 24px;
      font-weight: bold;
    }
    .profile-badges {
      display: flex;
      flex-direction: column;
      gap: 2px;
    }
    .badge {
      font-size: 11px;
      border: 1px solid #333;
      padding: 1px 4px;
      background-color: #fff;
      font-weight: bold;
      text-align: center;
    }
    .profile-details {
      display: grid;
      grid-template-columns: 1fr 1fr;
      gap: 5px;
      font-size: 13px;
    }

    /* 중앙 메뉴 단추 및 링크 */
    .menu-section {
      display: flex;
      gap: 15px;
    }
    .square-buttons {
      display: flex;
      flex-direction: column;
      gap: 10px;
    }
    .sq-btn {
      width: 60px;
      height: 50px;
      border: 2px solid #333;
      border-radius: 6px;
      background-color: #d8d8d8;
      font-weight: bold;
      cursor: pointer;
      font-size: 14px;
    }
    .text-links {
      display: flex;
      flex-direction: column;
      justify-content: space-between;
      padding: 5px 0;
    }
    .text-links a {
      color: #000;
      text-decoration: none;
      font-weight: bold;
      font-size: 14px;
    }
    .text-links a:hover {
      text-decoration: underline;
    }

    /* 플레이리스트 섹션 */
    .playlist-section {
      border: 2px solid #333;
      border-radius: 6px;
      overflow: hidden;
    }
    .section-title {
      background-color: #d8d8d8;
      text-align: center;
      padding: 10px;
      font-size: 18px;
      font-weight: bold;
      letter-spacing: 2px;
      border-bottom: 2px solid #333;
    }
    .player-controls {
      padding: 15px;
      border-bottom: 2px solid #333;
    }
    .progress-bar-container {
      display: flex;
      align-items: center;
      justify-content: space-between;
      font-size: 12px;
      font-weight: bold;
      margin-bottom: 15px;
    }
    .progress-bar {
      flex: 1;
      height: 4px;
      background-color: #bcbcbc;
      margin: 0 10px;
      position: relative;
    }
    .progress-handle {
      width: 10px;
      height: 14px;
      background-color: #fff;
      border: 2px solid #333;
      position: absolute;
      top: -5px;
      left: 30%;
      cursor: pointer;
    }
    .control-buttons {
      display: flex;
      justify-content: center;
      gap: 20px;
      font-size: 20px;
      cursor: pointer;
    }

    /* 뮤직 리스트 테이블 구조 */
    .playlist-content {
      display: grid;
      grid-template-columns: 100px 1fr;
    }
    .sort-menu {
      border-right: 2px solid #333;
      display: flex;
      flex-direction: column;
    }
    .sort-item {
      padding: 12px 5px;
      text-align: center;
      font-size: 13px;
      font-weight: bold;
      border-bottom: 1px solid #d8d8d8;
      cursor: pointer;
    }
    .sort-item:last-child { border-bottom: none; }
    .sort-item:hover { background-color: #f0f0f0; }

    .song-list {
      display: flex;
      flex-direction: column;
    }
    .song-item {
      display: flex;
      align-items: center;
      padding: 10px 15px;
      border-bottom: 1px solid #d8d8d8;
      gap: 15px;
    }
    .song-item:last-child { border-bottom: none; }
    .song-num { font-weight: bold; width: 15px; }
    .song-cover {
      width: 45px;
      height: 45px;
      background-color: #d8d8d8;
      border: 1px solid #333;
      border-radius: 4px;
    }
    .song-meta { flex: 1; }
    .song-title { font-weight: bold; font-size: 14px; margin-bottom: 2px;}
    .song-artist { font-size: 13px; color: #555; }
    .song-details {
      font-size: 11px;
      color: #666;
      text-align: right;
      line-height: 1.3;
    }

    /* 오른쪽 RECORD 섹션 */
    .record-section {
      border: 2px solid #333;
      border-radius: 6px;
      display: flex;
      flex-direction: column;
      background-color: #fff;
    }
    .record-content {
      padding: 15px;
      display: flex;
      flex-direction: column;
      gap: 15px;
      flex: 1;
    }
    .record-box {
      display: flex;
      flex-direction: column;
      gap: 5px;
    }
    .record-label {
      font-weight: bold;
      font-size: 15px;
    }
    .record-display {
      height: 80px;
      border: 2px solid #333;
      border-radius: 6px;
      background-color: #fff;
    }
  </style>
</head>
<body>

<div class="main-window">
  <!-- 상단 브라우저 바 디자인 -->
  <div class="window-header">
    <div class="window-dot"></div>
    <div class="window-dot"></div>
    <div class="window-dot"></div>
  </div>

  <!-- 메인 레이아웃 구역 -->
  <div class="window-content">

    <!-- 왼쪽 대구역 -->
    <div>
      <!-- 상단 유저정보 + 메뉴 -->
      <div class="top-section">
        <!-- 프로필 카드 -->
        <div class="profile-card">
          <div class="profile-avatar">
            <svg viewBox="0 0 24 24"><path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z"/></svg>
          </div>
          <div class="profile-info">
            <div class="profile-header">
              <span class="profile-name">YouWin</span>
              <div class="profile-badges">
                <span class="badge">관리자</span>
                <span class="badge">나라명</span>
              </div>
            </div>
            <div class="profile-details">
              <div>사용자:</div>
              <div>가입:</div>
              <div>로그인:</div>
              <div>수정:</div>
            </div>
          </div>
        </div>

        <!-- 버튼 및 링크 메뉴 -->
        <div class="menu-section">
          <div class="square-buttons">
            <button class="sq-btn">홈</button>
            <button class="sq-btn">채팅</button>
          </div>
          <div class="text-links">
            <a href="#">회원수정</a>
            <a href="#">로그아웃</a>
            <a href="#">고객센터</a>
            <a href="#">회원탈퇴</a>
          </div>
        </div>
      </div>

      <!-- 하단 PLAY LIST -->
      <div class="playlist-section">
        <div class="section-title">PLAY LIST</div>
        <div class="player-controls">
          <!-- 프로그레스 바 -->
          <div class="progress-bar-container">
            <span>00:00</span>
            <div class="progress-bar">
              <div class="progress-handle"></div>
            </div>
            <span>00:50</span>
          </div>
          <!-- 조작 아이콘 대체 (이모지/텍스트 구성) -->
          <div class="control-buttons">
            <span>🔍</span>
            <span>⬛</span>
            <span>⏮️</span>
            <span>▶️</span>
            <span>⏭️</span>
            <span>🔄</span>
            <span>🔀</span>
          </div>
        </div>

        <!-- 플레이리스트 본문 (정렬메뉴 + 음악목록) -->
        <div class="playlist-content">
          <div class="sort-menu">
            <div class="sort-item">재생순</div>
            <div class="sort-item">등록순</div>
            <div class="sort-item">횟수순</div>
            <div class="sort-item">발매순</div>
          </div>
          <div class="song-list">
            <!-- 1번 곡 -->
            <div class="song-item">
              <span class="song-num">1</span>
              <div class="song-cover"></div>
              <div class="song-meta">
                <div class="song-title">제목</div>
                <div class="song-artist">가수</div>
              </div>
              <div class="song-details">
                앨범<br>발매일<br>장르<br>재생횟수
              </div>
            </div>
            <!-- 2번 곡 -->
            <div class="song-item">
              <span class="song-num">2</span>
              <div class="song-cover"></div>
              <div class="song-meta">
                <div class="song-title">제목</div>
                <div class="song-artist">가수</div>
              </div>
              <div class="song-details">
                앨범<br>발매일<br>장르<br>재생횟수
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- 오른쪽 RECORD 구역 -->
    <div class="record-section">
      <div class="section-title">RECORD</div>
      <div class="record-content">
        <div class="record-box">
          <span class="record-label">작성글</span>
          <div class="record-display"></div>
        </div>
        <div class="record-box">
          <span class="record-label">댓글</span>
          <div class="record-display"></div>
        </div>
        <div class="record-box">
          <span class="record-label">방문</span>
          <div class="record-display"></div>
        </div>
      </div>
    </div>

  </div>
</div>

</body>
</html>
