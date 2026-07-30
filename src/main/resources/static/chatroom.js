    (function () {
        const roomId = Number(new URLSearchParams(location.search).get("roomId") || 1);
        const myMemberId = loginMemberId;
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


        let stompClient = null;
        let isConnected = false;

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
        function addMessage(data) {

           const message = document.createElement("div");

           message.className = data.memberId === myMemberId ? "message my-message" : "message other-message";

            message.innerHTML = `
            <span class="message__avatar"></span>
    
            <div class="message__content">
            
                <span class="message__author">
                    ${data.memberId === myMemberId ? "나" : data.nickname}
                </span>
    
                <div class="message__bubble">
                    ${data.message}
                </div>
            </div>
    
            <time class="message__time">
                ${formatTime(new Date())}
            </time>
        `;

            messageList.appendChild(message);
            messageList.scrollTop = messageList.scrollHeight;
        }

        function connectSocket() {

            stompClient = new StompJs.Client({

                webSocketFactory: () => new SockJS("/chat"),

                reconnectDelay: 5000,

                debug: str => console.log(str),

                onConnect: function () {

                    isConnected = true;

                    console.log("★★★★★ CONNECT SUCCESS ★★★★★");
                    console.log("isConnected =", isConnected);

                    stompClient.subscribe("/topic/chat/" + roomId, function (message) {

                        const data = JSON.parse(message.body);

                        addMessage(data);

                    });

                    stompClient.subscribe("/topic/member/" + roomId, function (message){

                        console.log("===== MEMBER UPDATE =====");

                        console.log(message.body);

                        const members = JSON.parse(message.body);

                        console.log(members);

                        renderMembers(members);

                    });

                    stompClient.publish({

                        destination: "/app/member/join",

                        body: JSON.stringify({

                            roomId: Number(roomId),
                            memberId: myMemberId

                        })
                    });
                },

                onStompError: function(frame){

                    console.error("STOMP ERROR", frame);

                },

                onWebSocketError: function(error){

                    console.error("SOCKET ERROR", error);

                }

            });

            stompClient.activate();
        }
            if (form && input && messageList) {

                form.addEventListener("submit", function (event) {

                    event.preventDefault();
                    console.log("===== 전송 클릭 =====");
                    console.log("isConnected =", isConnected);
                    console.log("stompClient =", stompClient);

                    const text = input.value.trim();

                    if (!text) {
                        return;
                    }

                    const data = {
                        roomId: Number(roomId),
                        memberId: myMemberId,
                        message: text
                    };

                    if (!isConnected) {
                        alert("서버와 아직 연결되지 않았습니다.");
                        return;
                    }

                    stompClient.publish({
                        destination: "/app/message",
                        body: JSON.stringify(data)
                    });

                    input.value = "";
                    input.style.height = "";

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
                            roomId: roomId,
                            memberId: myMemberId

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

        if (joinRoomButton && !joinRoomButton.disabled) {

            joinRoomButton.addEventListener("click", async function () {

                roomMenu.classList.remove("show");

                if (!confirm("나의 대화방에 추가하시겠습니까?")) {
                    return;
                }

                console.log("가입 요청");
                console.log("URL roomId =", roomId);
                console.log("memberId =", myMemberId);

                const response = await fetch("/chat/room/join", {
                    method: "POST",
                    headers: {
                        "Content-Type": "application/json"
                    },
                    body: JSON.stringify({

                        roomId: roomId,
                    })
                });

                if (!response.ok) {
                    alert("가입 실패");
                    return;
                }

                const joinResult = await response.json();

                console.log("가입 결과=", joinResult)
                console.log("가입할 roomId =", roomId);
                console.log("memberId =", myMemberId);

                if (joinResult) {
                    alert("가입되었습니다.");
                    location.href = "/chatroom?roomId=" + roomId;

                } else {
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

                document.querySelectorAll(".message__time").forEach(function(time){

                    const value = time.dataset.time;

                    if(!value){
                        return;
                    }

                    time.textContent = formatTime(new Date(value));
                })

                if(roomId) {
                    connectSocket();

                    window.addEventListener("beforeunload", function () {

                        if (!stompClient || !stompClient.active) {
                            return;
                        }

                        stompClient.publish({

                            destination: "/app/member/leave",

                            body: JSON.stringify({

                                roomId: roomId,
                                memberId: myMemberId
                            })
                        });
                    });
                }

                function renderMembers(members) {

                    console.log("renderMembers 호출");
                    console.log(members);

                    const onlineList = document.querySelector("#online-member-list");
                    const offlineList = document.querySelector("#offline-member-list");

                    const memberCount = document.querySelector("#member-count");
                    const roomMemberCount = document.querySelector("#room-member-count");

                    if(!onlineList || !offlineList) {
                        return;
                    }

                    onlineList.innerHTML = "";
                    offlineList.innerHTML = "";

                    let onlineCount = 0;

                    members.forEach(function (member){

                        const html = `
                            <div class="member-item">
                            
                            <span class="avatar">
                                ${member.nickname.substring(0,1)}
                            </span>
                            
                            <span>
                            
                                <strong class="member-item__name">
                                    ${member.nickname}
                                </strong>    
                                
                                <span class="member-item__status">
                                    ${member.online ? "🟢 참여중" : "⚪ 오프라인"}
                                </span>
                                
                              </span>
                              
                           </div>         
                        
                        `;

                        if(member.online) {
                            onlineCount++;
                            onlineList.innerHTML += html;
                        }else{
                            offlineList.innerHTML += html;
                        }
                    });

                        if(memberCount){
                            memberCount.textContent = onlineCount + "명";
                        }

                        if(roomMemberCount) {
                            roomMemberCount.textContent = onlineCount + "명";
                        }
                }
        })();
