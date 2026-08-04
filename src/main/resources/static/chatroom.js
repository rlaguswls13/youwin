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
    const editRoomButton = document.querySelector("#edit-room-btn");
    const editRoomModal = document.querySelector("#edit-room-modal");
    const editRoomCancel = document.querySelector("#edit-room-cancel");
    const editRoomSave = document.querySelector("#edit-room-save");
    const editRoomName = document.querySelector("#edit-room-name");
    const editRoomDescription = document.querySelector("#edit-room-description");
    const editRoomTheme = document.querySelector("#edit-room-theme");
    const editRoomType = document.querySelector("#edit-room-type");
    const editTargetLabel = document.querySelector("#edit-target-label");
    const editTargetId = document.querySelector("#edit-target-id");
    const editRoomImage = document.querySelector("#edit-room-image");

    if (roomMenuButton && roomMenu) {
        function closeRoomMenu() {
            roomMenu.classList.remove("show");
            roomMenuButton.setAttribute("aria-expanded", "false");
        }

        roomMenuButton.addEventListener("click", function (event) {
            event.stopPropagation();
            const isOpen = roomMenu.classList.toggle("show");
            roomMenuButton.setAttribute("aria-expanded", String(isOpen));
        });

        document.addEventListener("click", function (event) {
            if (!roomMenu.contains(event.target) && !roomMenuButton.contains(event.target)) {
                closeRoomMenu();
            }
        });

        document.addEventListener("keydown", function (event) {
            if (event.key === "Escape") {
                closeRoomMenu();
                if (editRoomModal) editRoomModal.classList.remove("show");
                const reportModal = document.querySelector("#report-modal");
                if (reportModal) reportModal.style.display = "none";
            }
        });
    }

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
                        roomId: Number(roomId)
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

            const currentRoom = Number(new URLSearchParams(location.search).get("roomId"));

            if(currentRoom === roomId){
                location.replace("/index");
            }
        });
    });

    function updateRoomCount(){

        const count = document.querySelectorAll(".room-item-wrapper").length;

        if(roomCount){
            roomCount.textContent = "가입한 대화방 " + count;

        }
    }

    if (joinRoomButton && !joinRoomButton.disabled) {

        joinRoomButton.addEventListener("click", async function () {

            if (!confirm("나의 대화방에 추가하시겠습니까?")) {
                return;
            }

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

            if (joinResult) {
                alert("가입되었습니다.");
                location.href = "/chatroom?roomId=" + roomId;

            } else {
                alert("이미 가입한 채팅방입니다.");
            }
        });

    }

    if (editRoomButton && editRoomModal) {
        editRoomButton.addEventListener("click", async function () {
            editRoomModal.classList.add("show");
            await loadEditTarget();
        });
    }
    async function loadEditTarget() {

        if (!editRoomType || !editTargetId) {
            return;
        }

        const roomType = editRoomType.value;

        editTargetId.innerHTML = `<option value="">선택해주세요</option>`;

        // 아티스트 방
        if (roomType === "artist") {

            editTargetLabel.textContent = "아티스트 선택";

            const response = await fetch("/chat/artist/list");
            const artists = await response.json();

            artists.forEach(function (artist) {

                const option = document.createElement("option");

                option.value = artist.artistId;
                option.textContent = artist.artistName;

                editTargetId.appendChild(option);
            });

        }

        // 노래 방
        else if (roomType === "song") {
            editTargetLabel.textContent = "노래 선택";

            const response = await fetch("/chat/song/list");
            const songs = await response.json();

            songs.forEach(function (song) {

                const option = document.createElement("option");

                option.value = song.songId;
                option.textContent = song.songTitle;
                editTargetId.appendChild(option);
            });
        }

        // 현재 방의 targetId 가져오기
        const response = await fetch("/chat/room/" + roomId);
        const room = await response.json();

        // 기존 아티스트 또는 노래 선택
        if (room.roomType === roomType) {
            editTargetId.value = room.targetId;
        }
    }

    if (editRoomType) {
        editRoomType.addEventListener("change", function () {
            loadEditTarget();
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

    if (editRoomSave) {

        editRoomSave.addEventListener("click", async function () {

            const roomName = editRoomName.value.trim();
            const roomDescription = editRoomDescription.value.trim();
            const roomType = editRoomType.value;
            const targetId = Number(editTargetId.value);
            const themeId = Number(editRoomTheme.value);


            // 입력 확인
            if (roomName === "") {
                alert("채팅방 이름을 입력해주세요.");
                return;
            }

            if (roomDescription === "") {
                alert("방 설명을 입력해주세요.");
                return;
            }

            if (!targetId) {
                alert("아티스트 또는 노래를 선택해주세요.");
                return;
            }

            if (!themeId) {
                alert("장르를 선택해주세요.");
                return;
            }


            // 서버로 보낼 채팅방 정보
            const data = {

                roomId: roomId,
                roomName: roomName,
                roomDescription: roomDescription,
                roomType: roomType,
                targetId: targetId,
                themeId: themeId
            };


            // FormData 생성
            const formData = new FormData();


            // 채팅방 정보 JSON
            formData.append("room", new Blob([JSON.stringify(data)], {type: "application/json"}
                )
            );


            // 새 이미지가 있으면 추가
            const imageFile = editRoomImage.files[0];

            if (imageFile) {

                formData.append("image", imageFile
                );
            }

            // 서버 전송
            const response =
                await fetch("/chat/room/update", {
                    method: "POST",
                    body: formData
                });

            if (!response.ok) {

                const message = await response.text();

                alert(message || "채팅방 수정에 실패했습니다.");

                return;
            }
            alert("채팅방이 수정되었습니다.");
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

                    roomId: roomId
                })
            });
        });
    }

    function renderMembers(members) {

        const onlineList = document.querySelector("#online-member-list");
        const offlineList = document.querySelector("#offline-member-list");

        const memberCount = document.querySelector("#member-count");
        const roomMemberCount = document.querySelector("#room-member-count");

        if (!onlineList || !offlineList) {
            return;
        }

        onlineList.innerHTML = "";
        offlineList.innerHTML = "";

        let onlineCount = 0;

        // 방장이 항상 먼저 오도록 정렬
        members.sort(function(a, b) {

            if (a.memberId === roomOwnerId) {
                return -1;
            }
            if (b.memberId === roomOwnerId) {
                return 1;
            }
            return 0;
        });


        members.forEach(function(member) {

            // 방장 표시
            let ownerText = "";

            if (member.memberId === roomOwnerId) {
                ownerText = `<span style="color: blue; font-weight: bold;">[방장]</span>`;
            }


            // 자기 자신에게는 신고 버튼 안 보이게
            let reportButton = "";

            if (member.memberId !== loginMemberId) {

                reportButton = `
                <button
                    type="button"
                    onclick="reportMember(${member.memberId})"
                    style="margin-left:auto; font-size:11px;">
                    신고
                </button>
            `;
            }


            const html = `
            <div class="member-item">

                <span class="avatar">
                    ${member.nickname.substring(0, 1)}
                </span>

                <span>

                    <strong class="member-item__name">
                       ${member.nickname}
                    </strong>

                    ${ownerText}

                    <span class="member-item__status">
                        ${member.online ? "🟢 참여중" : "⚪ 오프라인"}
                    </span>

                </span>
                
                ${reportButton}
                
            </div>
        `;


            if (member.online) {
                onlineCount++;
                onlineList.innerHTML += html;
            } else {
                offlineList.innerHTML += html;
            }
        });

        if (memberCount) {memberCount.textContent = onlineCount + "명";}
        if (roomMemberCount) {roomMemberCount.textContent = onlineCount + "명";}
    }
    // 신고 사유 선택
    document.querySelectorAll("input[name='reportReason']").forEach(function(radio) {

        radio.addEventListener("change", function() {

            const etcInput = document.querySelector("#report-etc");

            if (this.value === "기타") {
                etcInput.style.display = "block";
            } else {
                etcInput.style.display = "none";
                etcInput.value = "";
            }
        });

    });

        // 취소 버튼
        document.querySelector("#report-cancel").addEventListener("click", function() {
        closeReportModal();
    });


        // 신고하기 버튼
        document.querySelector("#report-submit").addEventListener("click", async function() {
        const selectedReason = document.querySelector("input[name='reportReason']:checked");
        // 신고 사유 선택 안 함
        if (!selectedReason) {
            alert("신고 사유를 선택해주세요.");
            return;
        }

        let reason = selectedReason.value;

        // 기타 선택했을 경우
        if (reason === "기타") {

            const etcReason = document.querySelector("#report-etc").value.trim();


            if (etcReason === "") {

                alert("기타 신고 사유를 입력해주세요.");
                return;
            }
            reason = "기타: " + etcReason;
        }


        // 현재 채팅방 번호
        const roomId = new URLSearchParams(location.search).get("roomId");

        // 서버로 신고 전송
        const response = await fetch("/chat/report", {

            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },

            body: JSON.stringify({
                roomId: Number(roomId),
                reportedId: selectedReportedId,
                reason: reason
            })
        });


        if (response.ok) {

            alert("신고가 접수되었습니다.");
            closeReportModal();

        } else {

            const message = await response.text();
            alert(message || "신고 처리에 실패했습니다.");
        }
    });


    // 신고 모달 닫기
    function closeReportModal() {

        const modal = document.querySelector("#report-modal");
        modal.style.display = "none";

        // 신고 대상 초기화
        selectedReportedId = null;

        // 체크했던 신고 사유 초기화
        document
            .querySelectorAll("input[name='reportReason']")
            .forEach(function(radio) {

                radio.checked = false;

            });
        // 기타 내용 초기화
        const etcInput =
            document.querySelector("#report-etc");

        etcInput.value = "";
        etcInput.style.display = "none";

    }
})();