<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${message.title}</title>
    <style>
        body {
            margin: 0;
            font-family: "Malgun Gothic", sans-serif;
            background: #f5f7fb;
            color: #172033;
        }

        main {
            min-height: 100vh;
            display: grid;
            place-items: center;
            padding: 40px 20px;
        }

        section {
            width: min(720px, 100%);
            padding: 32px;
            border: 1px solid #d8e0ef;
            border-radius: 8px;
            background: #ffffff;
        }

        h1 {
            margin: 0 0 12px;
            font-size: 32px;
        }

        p {
            margin: 0;
            font-size: 18px;
            line-height: 1.6;
        }
    </style>
</head>
<body>
<main>
    <header class="site-header">
        <div class="site-header-inner">
            <nav class="nav">
                <a href="/member/index">메인화면</a>
                <a href="/member/settings">회원 설정</a>
            </nav>
        </div>
    </header>
    <section>
        <h1>${message.title}</h1>
        <p>${message.content}</p>
    </section>
</main>
<script>console.log("현재 주소 : ${pageContext.request.contextPath}/");</script>
</body>
</html>