(function () {
    const form = document.querySelector("[data-message-form]");
    const input = document.querySelector("[data-message-input]");
    const messageList = document.querySelector("[data-message-list]");
    const roomsPanel = document.querySelector("[data-rooms-panel]");
    const roomsToggle = document.querySelector("[data-rooms-toggle]");
    const roomButtons = document.querySelectorAll("[data-room-item]");
    const roomTitle = document.querySelector("[data-room-title]");
    const roomSearch = document.querySelector("#room-search");
    const emptyMessage = document.querySelector("#empty-room-message");
    const roomCount = document.querySelector("#room-count");
    const leaveButtons = document.querySelectorAll(".leave-room-btn");
    const roomMenuButton = document.querySelector("#room-menu-button");
    const roomMenu = document.querySelector("#room-menu");
    const joinRoomButton = document.querySelector("#join-room-btn");
    const roomInfoButton = document.querySelector("#room-info-btn");
    const favoriteRoomButton = document.querySelector("#favorite-room-btn");
    const reportRoomButton = document.querySelector("#report-room-btn");
    const editRoomButton = document.querySelector("#edit-room-btn");
    const editRoomModal = document.querySelector("#edit-room-modal");
    const editRoomCancel = document.querySelector("#edit-room-cancel");
    const editRoomSave = document.querySelector("#edit-room-save");
    const editRoomName = document.querySelector("#edit-room-name");
    const editRoomDescription = document.querySelector("#edit-room-description");
    const editRoomTheme = document.querySelector("#edit-room-theme");

    if (roomSearch) {

        roomSearch.addEventListener("input", function () {

            const keyword = roomSearch.value.trim().toLowerCase();

            let count = 0;

            roomButtons.forEach(function (button) {
             const wrapper = button.closest(".room-item-wrapper");
             const roomName = button.dataset.roomName.toLowerCase();

                if (roomName.includes(keyword)) {
                    wrapper.style.display = "flex";
                    count++;
                } else {
                    wrapper.style.display = "none";
                }
            });

            if (emptyMessage) {
                if (keyword !== "" && count === 0) {
                    emptyMessage.style.display = "block";
                } else {
                    emptyMessage.style.display = "none";

                }
            }
        });
    }
    function formatTime(date) {

        return new Intl.DateTimeFormat("ko-KR", {
            hour: "2-digit",
            minute: "2-digit",
            hour12: false
        }).format(date);

    }

    if (form && input && messageList) {

        form.addEventListener("submit", async function (event) {

            event.preventDefault();

            const text = input.value.trim();

            if (!text) {
                input.focus();
                return;
            }

            const roomId = new URLSearchParams(window.location.search).get("roomId") || 1;

            const data = {
                roomId: Number(roomId),
                memberId: 1,
            };

            console.log("보낼 데이터 =", data);
            const response = await fetch("/chat/message/send", {
                method: "POST",
                headers: {
                    "Content-Type": "application/json"

                },
                body: JSON.stringify(data)
            });

            if(!response.ok) {
                alert("메시지 저장에 실패했습니다.");
                return;
            }

            const message = document.createElement("div");
            message.className = "message message--mine";

            const avatar = document.createElement("span");
            avatar.className = "message__avatar";
            avatar.textContent = "나";

            const content = document.createElement("div");
            content.className = "message__content";

            const author = document.createElement("span");
            author.className = "message__author";

            const bubble = document.createElement("div");
            bubble.className = "message__bubble";
            bubble.textContent = text;

            content.append(author, bubble);

            const time = document.createElement("time");
            time.className = "message__time";
            time.textContent = formatTime(new Date());

            message.append(avatar, content, time);

            messageList.appendChild(message);

            console.log(message.offsetHeight);
            console.log(messageList.scrollHeight);

            input.value = "";
            input.style.height = "";

            requestAnimationFrame(() => {
                messageList.scrollTop = messageList.scrollHeight;
            });

        });

        input.addEventListener("keydown", function (event) {

            if (event.key === "Enter" && !event.shiftKey) {

                event.preventDefault();
                form.requestSubmit();

            }

        });

        input.addEventListener("input", function () {

            input.style.height = "auto";
            input.style.height = Math.min(input.scrollHeight, 110) + "px";

        });

    }

        if (roomsToggle && roomsPanel) {

            roomsToggle.addEventListener("click", function () {

                const isOpen = roomsPanel.classList.toggle("is-open");

                roomsToggle.setAttribute(
                    "aria-expanded",
                    String(isOpen)
                );

            });

        }

            roomButtons.forEach(function (button) {

            button.addEventListener("click", function () {

                roomButtons.forEach(function (item) {
                    item.classList.remove("is-active");
                });

                button.classList.add("is-active");

                if (roomTitle) {
                    roomTitle.textContent = button.dataset.roomName;
                }
                if (roomsPanel) {
                    roomsPanel.classList.remove("is-open");
                }
            });
        });

        leaveButtons.forEach(function(button){

            button.addEventListener("click", async function(event){

                event.preventDefault();

                if(!confirm("채팅방에서 나가시겠습니까?")){
                    return;
                }

                const roomId = Number(button.dataset.roomId);
                const response = await fetch("/chat/room/leave",{

                    method:"POST",
                    headers:{"Content-Type":"application/json"},

                    body:JSON.stringify({
                        roomId:roomId,
                        memberId:1
                    })
                });

                if(!response.ok){
                    alert("채팅방 나가기에 실패했습니다.");
                    return;

                }

                const roomItem = button.closest(".room-item-wrapper");

                roomItem.remove();
                updateRoomCount();

                // 현재 보고 있는 방이라면 첫 번째 방으로 이동
                const currentRoom = Number(new URLSearchParams(location.search).get("roomId"));

                if(currentRoom === roomId){

                    const firstRoom = document.querySelector(".room-item");

                    if(firstRoom){
                        location.href = firstRoom.href;
                    }else{
                        location.href="/chatroom";
                    }
                }
            });
        });

        function updateRoomCount(){

            const count = document.querySelectorAll(".room-item-wrapper").length;

            if(roomCount){
                roomCount.textContent = "가입한 대화방 " + count;

            }
        }
            if(roomMenuButton && roomMenu){
                if(roomMenu){

                roomMenu.addEventListener("click", function(event){

                      event.stopPropagation();

                    });

                }
                roomMenuButton.addEventListener("click", function (event){

                    event.stopPropagation();

                    roomMenu.classList.toggle("show");
                });
            }

            document.addEventListener("click", function (){

               if(roomMenu) {
                   roomMenu.classList.remove("show");

               }
            });

            if(joinRoomButton && !joinRoomButton.disabled){

                joinRoomButton.addEventListener("click", async function (){

                    roomMenu.classList.remove("show");

                    const result = confirm("나의 대화방에 추가하시겠습니까?");

                 if(!result){
                     return;
                 }

                 const roomId = Number(joinRoomButton.dataset.roomId);

                    console.log(roomId);

                    console.log("현재 roomId =", roomId);

                    const response = await fetch("/chat/room/join",{
                        method:"POST",
                        headers:{
                            "Content-Type":"application/json"
                        },
                        body:JSON.stringify({
                            roomId:roomId,
                            memberId:1
                        })
                    });

                    const joinResult = await response.json();

                    if(joinResult){
                        alert("가입되었습니다.");
                        location.reload();
                    }else{
                        alert("이미 가입한 채팅방입니다.");
                    }

                });
            }

            if(editRoomButton && editRoomModal) {

                editRoomButton.addEventListener("click", function (){

                    roomMenu.classList.remove("show");

                    editRoomModal.classList.add("show");
                });
            }

            if(editRoomCancel) {
                editRoomCancel.addEventListener("click", function (){

                    editRoomModal.classList.remove("show");
                });
            }

            if(editRoomModal) {

                editRoomModal.addEventListener("click", function (event){

                    if(event.target === editRoomModal) {

                        editRoomModal.classList.remove("show");
                    }
                });
            }

            if(editRoomSave) {

                editRoomSave.addEventListener("click", async function(){

                    const roomId = Number(new URLSearchParams(location.search).get("roomId"));

                    console.log("roomId =", roomId);

                    const response = await fetch("/chat/room/update",{

                        method:"POST",
                        headers:{
                            "Content-Type":"application/json"
                        },

                        body:JSON.stringify({

                            roomId:roomId,
                            roomName:editRoomName.value,
                            roomDescription:editRoomDescription.value,
                            themeId:Number(editRoomTheme.value)
                        })
                    });

                    if(!response.ok){

                        alert("채팅방 수정에 실패했습니다.");
                        return;
                    }
                        alert("수정되었습니다.");
                        location.reload();

                });
            }
    })();
