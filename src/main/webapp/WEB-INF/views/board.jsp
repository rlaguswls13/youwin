<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>Youwin Board System</title>
    <style>
        :root {
            --bg-color: #f4f6f9;
            --sidebar-bg: #ffffff;
            --primary-color: #1e3a8a;
            --accent-blue: #e0f2fe;
            --text-main: #1f2937;
            --text-muted: #6b7280;
            --border-color: #e5e7eb;
        }

        * { box-sizing: border-box; margin: 0; padding: 0; font-family: 'Noto Sans KR', sans-serif; }
        body { display: flex; background-color: var(--bg-color); color: var(--text-main); height: 100vh; overflow: hidden; }

        /* 사이드바 스타일 */
        .sidebar { width: 260px; background-color: var(--sidebar-bg); border-right: 1px solid var(--border-color); padding: 24px; display: flex; flex-direction: column; justify-content: space-between; }
        .logo-section { display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px; }
        .logo { font-size: 24px; font-weight: bold; color: #000; }
        .user-icon { width: 32px; height: 32px; background: #e5e7eb; border-radius: 50%; display: inline-block; }

        .menu-group { margin-bottom: 30px; }
        .menu-title { font-size: 11px; color: var(--text-muted); font-weight: bold; text-transform: uppercase; margin-bottom: 12px; letter-spacing: 0.5px; }
        .menu-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 16px; border-radius: 8px; color: var(--text-muted); text-decoration: none; font-size: 14px; margin-bottom: 4px; cursor: pointer; transition: all 0.2s; }
        .menu-item.active { background-color: var(--accent-blue); color: var(--primary-color); font-weight: bold; }
        .menu-item:hover:not(.active) { background-color: #f3f4f6; color: var(--text-main); }

        /* 접속 사용자 영역 */
        .user-status { border-top: 1px solid var(--border-color); padding-top: 20px; }
        .user-select { width: 100%; padding: 10px; border: 1px solid var(--border-color); border-radius: 6px; margin-bottom: 12px; font-size: 13px; background: #fff; }
        .user-profile { display: flex; align-items: center; gap: 12px; }
        .profile-avatar { width: 36px; height: 36px; background-color: #3b82f6; border-radius: 50%; }
        .profile-info { font-size: 13px; }
        .profile-name { font-weight: bold; }
        .profile-role { color: var(--text-muted); font-size: 11px; }

        /* 메인 콘텐츠 영역 */
        .main-content { flex: 1; padding: 40px; overflow-y: auto; position: relative; }
        .content-page { display: none; }
        .content-page.active { display: block; }

        /* 상단 타이틀 및 버튼 */
        .header-wrap { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 6px; }
        .sub-title { font-size: 12px; color: var(--text-muted); font-weight: bold; text-transform: uppercase; margin-bottom: 4px; }
        .main-title { font-size: 28px; font-weight: bold; margin-bottom: 24px; }
        .btn-write { background-color: var(--primary-color); color: white; border: none; padding: 10px 20px; border-radius: 6px; font-weight: bold; cursor: pointer; font-size: 14px; }

        /* 상단 공지 배너 */
        .notice-banner { background: #fff; border: 1px solid var(--border-color); border-radius: 8px; padding: 16px 24px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 24px; font-size: 14px; }
        .badge-red { background-color: #fee2e2; color: #ef4444; padding: 3px 8px; border-radius: 4px; font-size: 12px; font-weight: bold; margin-right: 10px; }
        .banner-date { color: var(--text-muted); }

        /* 검색 바 및 필터 버튼 */
        .search-container { background: white; border: 1px solid var(--border-color); border-radius: 8px; padding: 20px; margin-bottom: 24px; }
        .search-box { display: flex; gap: 10px; margin-bottom: 12px; }
        .search-input { flex: 1; padding: 12px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 14px; }
        .btn-search { background-color: var(--primary-color); color: white; border: none; padding: 0 24px; border-radius: 6px; font-weight: bold; cursor: pointer; }
        .filter-tags { display: flex; gap: 8px; }
        .tag { border: none; padding: 6px 14px; border-radius: 20px; font-size: 12px; background-color: #f3f4f6; color: var(--text-muted); cursor: pointer; }
        .tag.active { background-color: var(--accent-blue); color: var(--primary-color); font-weight: bold; }

        /* 테이블 스타일 (공지사항 리스트) */
        .board-table { width: 100%; border-collapse: collapse; background: white; border-radius: 8px; overflow: hidden; border: 1px solid var(--border-color); }
        .board-table th { background-color: #f9fafb; border-bottom: 1px solid var(--border-color); padding: 14px; font-size: 13px; color: var(--text-muted); text-align: left; }
        .board-table td { padding: 16px 14px; border-bottom: 1px solid var(--border-color); font-size: 14px; }
        .badge-category { background-color: #eff6ff; color: #3b82f6; padding: 3px 8px; border-radius: 12px; font-size: 11px; }

        /* FAQ 아코디언 구조 */
        .faq-list { background: white; border: 1px solid var(--border-color); border-radius: 8px; overflow: hidden; }
        .faq-item { border-bottom: 1px solid var(--border-color); padding: 24px; }
        .faq-item:last-child { border-bottom: none; }
        .faq-question { font-weight: bold; font-size: 15px; display: flex; align-items: center; gap: 12px; margin-bottom: 10px; }
        .faq-answer { padding-left: 45px; color: var(--text-muted); font-size: 14px; line-height: 1.6; }

        /* 글작성 폼 공통 스타일 */
        .form-card { background: white; border: 1px solid var(--border-color); border-radius: 12px; padding: 32px; max-width: 900px; margin: 0 auto; }
        .form-group { margin-bottom: 24px; }
        .form-label { display: block; font-weight: bold; margin-bottom: 8px; font-size: 14px; }
        .form-select, .form-input, .form-textarea { width: 100%; padding: 12px; border: 1px solid var(--border-color); border-radius: 6px; font-size: 14px; background-color: #fff; }
        .form-textarea { height: 350px; resize: none; }
        .checkbox-group { display: flex; gap: 20px; margin-bottom: 24px; font-size: 14px; font-weight: bold; }
        .checkbox-group label { display: flex; align-items: center; gap: 6px; cursor: pointer; }
        .form-footer { display: flex; justify-content: space-between; border-top: 1px solid var(--border-color); padding-top: 20px; margin-top: 20px; }
        .btn-cancel { background: white; border: 1px solid var(--border-color); padding: 10px 24px; border-radius: 6px; cursor: pointer; font-weight: bold; }
    </style>
</head>
<body>

<!-- 사이드바 내비게이션 -->
<div class="sidebar">
    <div>
        <div class="logo-section">
            <span class="logo">Youwin</span>
            <span class="user-icon"></span>
        </div>

        <div class="menu-group">
            <div class="menu-title">Board Types</div>
            <div class="menu-item active" onclick="switchPage('notice')">
                <span>공지사항</span><span style="font-size:11px;">NOTICE</span>
            </div>
            <div class="menu-item" onclick="switchPage('faq')">
                <span>자주 묻는 질문</span><span style="font-size:11px;">FAQ</span>
            </div>
            <div class="menu-item" onclick="switchPage('inquiry-form')">
                <span>1:1 문의</span><span style="font-size:11px;">INQUIRY</span>
            </div>
        </div>

        <div class="menu-group">
            <div class="menu-title">Shortcuts</div>
            <div class="menu-item">
                <span>홈</span><span style="font-size:11px;">HOME</span>
            </div>
            <div class="menu-item">
                <span>마이페이지</span><span style="font-size:11px;">MY PAGE</span>
            </div>
        </div>
    </div>

    <!-- 접속 사용자 정보 -->
    <div class="user-status">
        <div class="menu-title">접속 사용자</div>
        <select class="user-select">
            <option>일반회원1 (USER)</option>
        </select>
        <div class="user-profile">
            <div class="profile-avatar"></div>
            <div class="profile-info">
                <div class="profile-name">일반회원1</div>
                <div class="profile-role">일반 회원</div>
            </div>
        </div>
    </div>
</div>

<!-- 메인 콘텐츠 영역 -->
<div class="main-content">

    <!-- PAGE 1: 공지사항 리스트 화면 -->
    <div id="page-notice" class="content-page active">
        <div class="header-wrap">
            <div>
                <div class="sub-title">Notice</div>
                <div class="main-title">공지사항</div>
            </div>
            <!-- 작성 버튼 누르면 공지사항 작성 폼(write-form)으로 이동 -->
            <button class="btn-write" onclick="switchPage('write-form')">작성</button>
        </div>

        <div class="notice-banner">
            <div><span class="badge-red">알림</span> 7월 정기 점검 안내</div>
            <div class="banner-date">2026-07-16</div>
        </div>

        <div class="search-container">
            <div class="search-box">
                <input type="text" class="search-input" placeholder="검색어를 입력하세요">
                <button class="btn-search">검색</button>
            </div>
            <div class="filter-tags">
                <button class="tag active">전체</button>
                <button class="tag">점검</button>
                <button class="tag">업데이트</button>
                <button class="tag">이벤트</button>
            </div>
        </div>

        <table class="board-table">
            <thead>
            <tr>
                <th style="width: 8%;">번호</th>
                <th style="width: 12%;">분류</th>
                <th style="width: 50%;">제목</th>
                <th style="width: 10%;">작성자</th>
                <th style="width: 12%;">날짜</th>
                <th style="width: 8%;">조회수</th>
            </tr>
            </thead>
            <tbody>
            <!-- board.jsp의 <tbody> 내부 데이터 바인딩 영역 수정 -->
            <c:forEach var="notice" items="${list}">
                <tr>
                    <!-- 1. notice.id ➡️ notice.noticeId -->
                    <td>${notice.noticeId}</td>
                    <td>
                        <span class="badge-category">${notice.category}</span>
                    </td>
                    <td style="font-weight: bold;">
                        <!-- 2. notice.isTopFixed ➡️ notice.isPinned -->
                        <c:if test="${notice.isPinned == 1}">
                            <span class="badge-red" style="margin-right:5px;">알림</span>
                        </c:if>
                            ${notice.title}
                    </td>
                    <!-- 3. notice.writer ➡️ notice.memberId -->
                    <td>${notice.memberId}</td>
                    <!-- 4. notice.regDate ➡️ notice.createAt (또는 가공된 날짜 포맷팅) -->
                    <td>${notice.createAt}</td>
                    <!-- 5. notice.views ➡️ notice.count -->
                    <td>${notice.count}</td>
                </tr>
            </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- PAGE 2: FAQ 화면 -->
    <div id="page-faq" class="content-page">
        <div class="header-wrap">
            <div>
                <div class="sub-title">FAQ</div>
                <div class="main-title">자주 묻는 질문</div>
            </div>
            <!-- 작성 버튼 누르면 1:1 문의 작성 폼(inquiry-form)으로 이동 -->
            <button class="btn-write" onclick="switchPage('inquiry-form')">작성</button>
        </div>

        <div class="search-container">
            <div class="search-box">
                <input type="text" class="search-input" placeholder="검색어를 입력하세요">
                <button class="btn-search">검색</button>
            </div>
            <div class="filter-tags">
                <button class="tag active">전체</button>
                <button class="tag">결제</button>
                <button class="tag">게임</button>
                <button class="tag">이용방법</button>
            </div>
        </div>

        <div class="faq-list">
            <div class="faq-item">
                <div class="faq-question">
                    <span class="badge-category" style="background-color:#eff6ff; color:#3b82f6; padding:4px 10px;">결제</span>
                    결제 영수증은 어디에서 확인하나요?
                </div>
                <div class="faq-answer">
                    마이페이지의 결제 내역에서 영수증을 확인하거나 출력할 수 있습니다.
                </div>
            </div>
            <div class="faq-item">
                <div class="faq-question">
                    <span class="badge-category" style="background-color:#eff6ff; color:#3b82f6; padding:4px 10px;">게임</span>
                    비밀번호를 잊어버렸어요.
                </div>
                <div class="faq-answer">
                    로그인 화면의 비밀번호 찾기를 이용해 주세요. 가입 이메일로 재설정 링크가 발송됩니다.
                </div>
            </div>
        </div>
    </div>

    <!-- PAGE 3: 공지사항 게시글 작성 폼 영역 수정 -->
    <div id="page-write-form" class="content-page">
        <div class="form-card">
            <div class="sub-title">NOTICE</div>
            <div class="main-title" style="font-size:24px; margin-bottom:20px;">게시글 작성</div>

            <!-- 💡 action 주소를 컨트롤러와 맞추고 name 속성들을 추가합니다 -->
            <form action="/board/write" method="post">
                <div class="form-group">
                    <label class="form-label">분류</label>
                    <select class="form-select" name="category">
                        <option value="점검">점검</option>
                        <option value="업데이트">업데이트</option>
                        <option value="이벤트">이벤트</option>
                    </select>
                </div>

                <div class="checkbox-group">
                    <!-- 💡 체크 시 1, 해제 시 0이 가도록 value 설정 -->
                    <label><input type="checkbox" name="isPinned" value="1"> 상단 고정</label>
                    <label><input type="checkbox" name="allowComments" value="1"> 댓글 허용</label>
                </div>

                <div class="form-group">
                    <label class="form-label">제목</label>
                    <input type="text" class="form-input" name="title" placeholder="제목을 입력해주세요.">
                </div>

                <div class="form-group">
                    <label class="form-label">내용</label>
                    <textarea class="form-textarea" name="content" placeholder="내용을 입력해주세요."></textarea>
                </div>

                <div class="form-footer">
                    <button type="submit" class="btn-write">등록</button>
                    <button type="button" class="btn-cancel" onclick="switchPage('notice')">취소</button>
                </div>
            </form>
        </div>
    </div>

    <!-- PAGE 4: 1:1 문의 작성 폼 -->
    <div id="page-inquiry-form" class="content-page">
        <div class="form-card">
            <div class="sub-title">INQUIRY</div>
            <div class="main-title" style="font-size:24px; margin-bottom:20px;">1:1 문의 작성</div>

            <form action="#" method="post">
                <div class="form-group">
                    <label class="form-label">분류</label>
                    <select class="form-select">
                        <option>결제</option>
                        <option>계정</option>
                        <option>기타</option>
                    </select>
                </div>

                <div class="checkbox-group">
                    <label><input type="checkbox"> 공개 여부</label>
                </div>

                <div class="form-group">
                    <label class="form-label">제목</label>
                    <input type="text" class="form-input" placeholder="제목을 입력해주세요.">
                </div>

                <div class="form-group">
                    <label class="form-label">내용</label>
                    <textarea class="form-textarea" placeholder="내용을 입력해주세요."></textarea>
                </div>

                <div class="form-footer">
                    <button type="submit" class="btn-write">등록</button>
                    <button type="button" class="btn-cancel" onclick="switchPage('faq')">취소</button>
                </div>
            </form>
        </div>
    </div>

</div>

<!-- 화면 단 전환 스크립트 -->
<script>
    function switchPage(pageId) {
        // 모든 페이지 숨기기
        const pages = document.querySelectorAll('.content-page');
        pages.forEach(page => page.classList.remove('active'));

        // 모든 메뉴 스타일 초기화
        const menuItems = document.querySelectorAll('.menu-item');
        menuItems.forEach(item => item.classList.remove('active'));

        // 해당 페이지 표시
        const targetPage = document.getElementById('page-' + pageId);
        if(targetPage) {
            targetPage.classList.add('active');
        }

        // 사이드바 하이라이트 활성화 제어
        if(pageId === 'notice' || pageId === 'write-form') {
            menuItems[0].classList.add('active');
        } else if(pageId === 'faq') {
            menuItems[1].classList.add('active');
        } else if(pageId === 'inquiry-form') {
            menuItems[2].classList.add('active');
        }
    }
</script>
</body>
</html>