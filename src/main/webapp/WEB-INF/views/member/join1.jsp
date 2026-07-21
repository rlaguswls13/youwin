<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<form action="process.jsp" method="post">
  <!-- 1단계 영역 -->
  <div id="section1">
    <input type="text" name="userId" required>
    <button type="button" onclick="nextSection()">다음</button>
  </div>

  <!-- 2단계 영역 (초기엔 숨김) -->
  <div id="section2" style="display:none;">
    <input type="text" name="userName" required>
    <button type="submit">완료</button>
  </div>
</form>

<script>
  function nextSection() {
    // 1단계 입력 요소들의 required 유효성 직접 검사
    const step1Inputs = document.querySelectorAll('#section1 input');
    for (let input of step1Inputs) {
      if (!input.checkValidity()) {
        input.reportValidity(); // 브라우저 기본 required 경고창 띄우기
        return;
      }
    }
    // 이상 없으면 2단계 보여주기
    document.getElementById('section1').style.display = 'none';
    document.getElementById('section2').style.display = 'block';
  }
</script>