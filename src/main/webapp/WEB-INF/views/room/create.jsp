<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>


</body>
</html>
    <div id="creat-chatroom-form">
            <input data-id="roomName"/>
            <input data-id="roomDescription"/>
            <input data-id="targetId"/>
            <input data-id="themeId"/>
    </div>

<script>
    //
    const roommtag = document.querySelector("#creat-chatroom-form");
    const
    roommtag.addEventListener('click') -{
        fetch("chat/room/create",data)
    .then(datas =>
        {
            if(datas.ok){
                window.location = "?chatroom"+datas.result.roomNumber;
            }else {
                alert(datas.message)
            }
        }
    )
        .catch(err => alert(datas.message))
        .finally(
        );
    }

    const data = Object.fromEntries(
        [...roommtag.querySelectorAll("[data-id]")].map(input => [
            input.dataset.id,
            input.value
        ])
    );

</script>