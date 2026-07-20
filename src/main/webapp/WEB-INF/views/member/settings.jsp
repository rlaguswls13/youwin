<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>회원 설정</title>
  <style>
    /* 전체 배경 및 폰트 설정 */
    body {
      background-color: #ededed;
      font-family: 'Malgun Gothic', sans-serif;
      display: flex;
      justify-content: center;
      align-items: center;
      height: 100vh;
      margin: 0;
    }

    /* 중앙 정렬 컨테이너 */
    .container {
      width: 100%;
      max-width: 500px;
      text-align: center;
      padding: 20px;
    }

    /* 타이틀 */
    h2 {
      font-size: 28px;
      font-weight: bold;
      margin-bottom: 40px;
      color: #000;
    }

    /* 폼 그룹 레이아웃 */
    .form-group {
      text-align: left;
      margin-bottom: 25px;
    }

    .form-group label {
      display: block;
      font-size: 14px;
      font-weight: bold;
      margin-bottom: 10px;
      color: #333;
    }

    /* 프로필 섹션 전용 폼 그룹 스타일 */
    .form-group.profile-group {
      text-align: center; /* 내부 글자들을 모두 가운데로 */
    }

    /* 프로필 그룹 안의 상단 label만 선택해서 가운데 정렬 */
    .form-group.profile-group > label {
      display: block;
      text-align: center;
      font-size: 18px;
    }

    /* 프로필 이미지 영역 */
    .profile-section {
      display: flex;
      flex-direction: column;  /* 가로 정렬을 '세로 정렬'로 변경 */
      align-items: center;     /* 자식 요소들을 가로축 기준 '가운데 정렬' */
      gap: 15px;               /* 이미지와 파일 올리기 텍스트 사이의 간격 */
    }

    .profile-img-preview {
      width: 80px;
      height: 80px;
      border-radius: 50%;
      background-color: #d1d1d1;
      display: flex;
      justify-content: center;
      align-items: center;
      overflow: hidden;
      margin: 0 auto;          /* 혹시 모를 외부 여백을 위한 중앙 정렬 보장 */
    }

    /* 기본 아바타 모양 (SVG) */
    .profile-img-preview svg {
      width: 100%;
      height: 100%;
      fill: #ffffff;
    }

    /* 실제 업로드된 이미지 */
    .profile-img-preview img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    /* 파일 올리기 텍스트 버튼 */
    .file-upload-btn {
      font-size: 12px;
      color: #555;
      cursor: pointer;
      text-decoration: none;
    }

    .file-upload-btn:hover {
      text-decoration: underline;
    }

    /* 실제 파일 input은 숨김 */
    input[type="file"] {
      display: none;
    }

    /* 닉네임 입력창 */
    input[type="text"] {
      width: 100%;
      box-sizing: border-box;
      padding: 15px;
      border: none;
      background-color: #d8d8d8;
      font-size: 16px;
      outline: none;
    }

    /* 다음 버튼 */
    .submit-btn {
      margin-top: 40px;
      width: 100px;
      padding: 12px 0;
      border: none;
      background-color: #d8d8d8;
      font-size: 16px;
      font-weight: bold;
      color: #000;
      cursor: pointer;
      transition: background-color 0.2s;
    }

    .submit-btn:hover {
      background-color: #c5c5c5;
    }
  </style>
</head>
<body>

<div class="container">
  <h2>회원 설정</h2>

  <!-- 파일 업로드를 위해 encType 설정 추가 -->
  <form action="#" method="post" enctype="multipart/form-data">

    <!-- 프로필 이미지 섹션 -->
    <div class="form-group profile-group">
      <label>프로필 이미지</label>
      <div class="profile-section">
        <div class="profile-img-preview" id="imagePreview">
          <!-- 기본 기본 사람 아이콘 아이콘(SVG) -->
          <svg viewBox="0 0 24 24">
            <path d="M12 12c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-2.67 0-8 1.34-8 4v2h16v-2c0-2.66-5.33-4-8-4z">
            </path>>
          </svg>
        </div>
        <!-- label의 for와 input의 id를 연결하여 글씨 클릭 시 파일창이 열리도록 함 -->
        <label for="profileFile" class="file-upload-btn">파일 올리기</label>
        <input type="file" id="profileFile" name="profileImage" accept="image/*" onchange="previewImage(this)">
      </div>
    </div>

    <!-- 닉네임 섹션 -->
    <div class="form-group">
      <label for="nickname">닉네임</label>
      <input type="text" id="nickname" name="nickname" placeholder="">
    </div>

    <!-- 다음 버튼 -->
    <button type="submit" class="submit-btn">다음</button>

  </form>
</div>

<script>
  // 이미지를 선택했을 때 미리보기가 가능하게 해주는 자바스크립트 함수
  function previewImage(input) {
    const previewContainer = document.getElementById('imagePreview');

    if (input.files && input.files[0]) {
      const reader = new FileReader();

      reader.onload = function(e) {
        // 기존의 SVG 아이콘을 지우고 img 태그를 생성해서 넣음
        previewContainer.innerHTML = '<img src="' + e.target.result + '" alt="프로필 미리보기">';
      }

      reader.readAsDataURL(input.files[0]);
    }
  }
</script>

</body>
</html>