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
    const roomModal = document.querySelector("#room-modal");
    const openRoomModal = document.querySelector("#open-room-modal");
    const closeRoomModal = document.querySelector("#close-room-modal");
    const cancelRoom = document.querySelector("#cancel-room");
    const createRoom = document.querySelector("#create-room");
    const roomName = document.querySelector("#room-name");
    const roomDescription = document.querySelector("#room-description");
    const themeId = document.querySelector("#theme-id");
    const targetId = document.querySelector("#target-id");
    const roomCount = document.querySelector("#room-count");
    const leaveButtons = document.querySelectorAll(".leave-room-btn");

    if (roomSearch) {

        roomSearch.addEventListener("input", function () {

            const keyword = roomSearch.value.trim().toLowerCase();

            let count = 0;

            roomButtons.forEach(function (button) {

             const roomName = button.dataset.roomName.toLowerCase();

                if (roomName.includes(keyword)) {
                    button.style.display = "flex";
                    count++;
                } else {
                    button.style.display = "none";
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
                message: text
            };

            const response = await fetch("/chat/message/send", {
                method: "POST", headers: {
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

                if(openRoomModal && roomModal){
                    openRoomModal.addEventListener("click",function(){
                        roomModal.classList.add("show");
                    });
                }

                if(closeRoomModal && roomModal){closeRoomModal.addEventListener("click",function(){
                    roomModal.classList.remove("show");
                    });
                }
                if(cancelRoom && roomModal) {cancelRoom.addEventListener("click", function () {
                    roomModal.classList.remove("show");
                    });
                }
                if (createRoom) {
                    createRoom.addEventListener("click", async function () {
                        const name = roomName.value.trim();
                        if (!name) {
                            alert("채팅방 이름을 입력하세요.");
                            return;
                        }

                        const data = {
                            roomName: name,
                            roomDescription: roomDescription.value.trim(),
                            themeId: Number(themeId.value),
                            targetId: Number(targetId.value)
                        };

                        const response = await fetch("/chat/room/create", {
                            method: "POST",
                            headers: {
                                "Content-Type": "application/json"
                            },
                            body: JSON.stringify(data)
                        });

                        if (!response.ok) {
                            alert("채팅방 생성 실패");
                            return;
                        }

                        const roomId = await response.json();
                        location.href = "/chatroom?roomId=" + roomId;
                    });
                }

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
                roomCount.textContent = "참여 중인 대화 " + count;

            }
        }
    })();





