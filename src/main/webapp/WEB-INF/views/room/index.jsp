<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ include file="/WEB-INF/views/common/header.jsp" %>


<link rel="stylesheet" href="${ctx}/index.css">

<div class="index-wrap">

    <!-- ================= Search ================= -->

    <section class="top-menu">

        <div class="search-box">

            <input type="text" id="keyword" placeholder="채팅방 이름 또는 설명 검색">
            <button id="search-btn">검색</button>
        </div>

        <button id="create-btn">+ 채팅방 만들기</button>

    </section>


    <div id="create-modal">

        <div class="create-modal-content">

            <h2>채팅방 만들기</h2>

            <label>방 이름 *</label>
            <input type="text" id="roomName">

            <label>방 설명</label>
            <textarea id="roomDescription"></textarea>

            <label>방 이미지 (선택)</label>
            <input type="file" id="roomImage" accept="image/*">

            <img id="previewImage" src="">

            <label>방 분류</label>

            <select id="roomType">

                <option value="artist">🎤 아티스트별</option>
                <option value="song">🎵 노래별</option>

            </select>

            <label id="artistInputArea">아티스트
                <input type="text" id="artistName" placeholder="아티스트를 입력하세요">
            </label>

            <label id="songInputArea" style="display:none;">노래
                <input type="text" id="songTitle" placeholder="노래 제목">
            </label>

            <label>장르</label>

            <select id="themeId">

                <option value="">선택 안 함</option>

            </select>

            <div class="modal-btn">

                <button id="save-btn">생성</button>
                <button id="close-btn">취소</button>

            </div>

        </div>

    </div>

    <div id="join-modal">

        <div class="join-modal-content">

            <h2>채팅방 정보</h2>

            <img id="join-room-image"
                 src=""
                 alt="채팅방 이미지">

            <h3 id="join-room-name"></h3>

            <p>

                <strong>방장</strong><br>

                <span id="join-room-owner"></span>

            </p>

            <p>

                <strong>방 설명</strong><br>

                <span id="join-room-description"></span>

            </p>

            <p>

                <strong>참여 인원</strong><br>

                <span id="join-room-count"></span>명

            </p>

            <p>

                <strong>생성일</strong><br>

                <span id="join-room-created-at"></span>

            </p>

            <div class="join-modal-btn-area">

                <button id="join-ok-btn">가입하기</button>
                <button id="join-cancel-btn">취소</button>

            </div>

        </div>

    </div>

    <!-- ================= Artist ================= -->

    <section class="room-section">
        <div class="section-header">
            <h3>🎤 아티스트별 채팅방</h3>
            <span class="section-sub">좋아하는 아티스트 팬들과 대화해보세요.</span>

        </div>

        <div id="artistList" class="room-grid"></div>
        <div id="artistPaging" class="pagination"></div>

    </section>

    <!-- ================= Song ================= -->

    <section class="room-section">

        <div class="section-header">
            <h3>🎵 노래별 채팅방</h3>
            <span class="section-sub">노래를 좋아하는 사람들과 이야기해보세요.</span>

        </div>

        <div id="songList" class="room-grid"></div>
        <div id="songPaging" class="pagination"></div>

    </section>

</div>

<script>
    let selectedRoomId = null;
    let artistPage = 1;
    let songPage = 1;
    const DEFAULT_FALLBACK_IMAGE = "data:image/svg+xml;utf8,<svg xmlns='http://www.w3.org/2000/svg' width='150' height='150' viewBox='0 0 150 150'><rect width='100%' height='100%' fill='%23cccccc'/><text x='50%' y='50%' dominant-baseline='middle' text-anchor='middle' font-family='sans-serif' font-size='14' fill='%23333333'>No Image</text></svg>";

    // 페이지 로드 시 기본 데이터 조회
    window.addEventListener("DOMContentLoaded", async () => {
        await loadThemeOption();
        await findArtistList();
        await findSongList();
    });

    // ==================== 상단 검색 섹션 =================
    document.querySelector("#search-btn").addEventListener("click", (e) => {
        e.preventDefault();
        searchRooms();
    });

    document.querySelector("#keyword").addEventListener("keydown", (e) => {
        if (e.key === "Enter") {
            e.preventDefault();
            searchRooms();
        }
    });

    // ========================= 방 이름,설명 검색 실행  =========================
    async function searchRooms() {
        const keywordInput = document.querySelector("#keyword");
        const keyword = keywordInput.value.trim();

        if (keyword === "") {
            alert("검색어를 입력해주세요.");
            return;
        }

        const response = await fetch("/chat/room/search?keyword=" + encodeURIComponent(keyword));
        const roomList = await response.json();

        const artistList = document.querySelector("#artistList");
        const songList = document.querySelector("#songList");

        artistList.innerHTML = "";
        if (songList) songList.innerHTML = "";

        if (!roomList || roomList.length === 0) {
            artistList.innerHTML = `<div class="empty-room">검색 결과가 없습니다.</div>`;
            return;
        }

        for (const room of roomList) {
            const roomDiv = document.createElement("div");

            roomDiv.className = "room-card";

            roomDiv.innerHTML = `
                <img src="\${room.roomImageUrl || DEFAULT_FALLBACK_IMAGE}"
                     alt="\${room.roomName}">

                <div class="room-card-body">

                    <h4 class="room-card-title">
                        \${room.roomName}
                    </h4>

                    <p class="room-card-description">
                        \${room.roomDescription || "채팅방 설명이 없습니다."}
                    </p>

                </div>
            `;

            roomDiv.addEventListener("click", async (e) => {
                e.stopPropagation();
                const res = await fetch("/chat/room/" + room.roomId + "/joined");
                const joined = await res.json();

                if (joined) {
                    enterRoom(room.roomId);
                } else {
                    selectedRoomId = room.roomId;
                    await loadRoomInfo(room.roomId);
                    openJoinModal();
                }
            });

            artistList.appendChild(roomDiv);
        }
    }

    //======================== 홈 버튼 ===============================
    document.querySelector("#home-btn").addEventListener("click", () => {
        location.href = "/";
    });

    //  ========================== 채팅방 생성 모달  ==================================
    document.querySelector("#create-btn").addEventListener("click", openModal);
    document.querySelector("#close-btn").addEventListener("click", closeModal);
    document.querySelector("#save-btn").addEventListener("click", createRoom);

    function openModal() { document.querySelector("#create-modal").style.display = "flex"; }

    document.querySelector("#roomType").addEventListener("change", changeRoomType);

    function changeRoomType() {

        const roomType = document.querySelector("#roomType").value;

        const artistArea = document.querySelector("#artistInputArea");
        const songArea = document.querySelector("#songInputArea");

        if (roomType === "artist") {

            artistArea.style.display = "block";
            songArea.style.display = "none";

            document.querySelector("#songTitle").value = "";

        } else {

            artistArea.style.display = "none";
            songArea.style.display = "block";

            document.querySelector("#artistName").value = "";
        }
    }
    function closeModal() { document.querySelector("#create-modal").style.display = "none"; }

    // 방 생성 데이터 전송
    async function createRoom() {

        const roomName = document.querySelector("#roomName").value.trim();
        const roomDescription = document.querySelector("#roomDescription").value.trim();
        const roomType = document.querySelector("#roomType").value;
        const artistName = document.querySelector("#artistName").value.trim();
        const songTitle = document.querySelector("#songTitle").value.trim();
        const themeId = document.querySelector("#themeId").value;


        // 방 이름 검사
        if (roomName === "") {
            alert("방 이름을 입력해주세요.");
            return;
        }

        // 아티스트방 검사
        if (roomType === "artist" && artistName === "") {
            alert("아티스트를 입력해주세요.");
            return;
        }

        // 노래방 검사
        if (roomType === "song" && songTitle === "") {
            alert("노래 제목을 입력해주세요.");
            return;
        }

        // 장르 검사
        if (themeId === "") {
            alert("장르를 선택해주세요.");
            return;
        }

        const data = {
            roomName: roomName,
            roomDescription: roomDescription,
            roomType: roomType,

            artistName: roomType === "artist" ? artistName : null,
            songTitle: roomType === "song" ? songTitle : null,
            themeId: themeId
        };


        const imageFile = document.querySelector("#roomImage").files[0];
        const formData = new FormData();


        formData.append(
            "room",
            new Blob(
                [JSON.stringify(data)],
                { type: "application/json" }
            )
        );


        if (imageFile) {
            formData.append("image", imageFile);
        }

        const response =
            await fetch("/chat/room/create", {
                method: "POST",
                body: formData
            });

        if (!response.ok) {
            const message = await response.text();
            alert(message);
            return;
        }
        alert("채팅방이 생성되었습니다.");
        closeModal();
        location.reload();
    }

    // ========================= 이미지 미리보기 처리 =========================
    document.getElementById("roomImage").addEventListener("change", function () {
        const file = this.files[0];
        const previewImage = document.getElementById("previewImage");

        if (!file) {
            previewImage.style.display = "none";
            previewImage.src = "";
            return;
        }

        const reader = new FileReader();
        reader.onload = function (e) {
            previewImage.src = e.target.result;
            previewImage.style.display = "block";
        };
        reader.readAsDataURL(file);
    });

    //  ========================= 장르 드롭다운  =========================
    async function loadThemeOption() {
        const response = await fetch("/chat/theme/list");
        const list = await response.json();
        const themeSelect = document.querySelector("#themeId");

        themeSelect.innerHTML = "<option value=''>선택 안 함</option>";
        for (const theme of list) {
            const option = document.createElement("option");
            option.value = theme.themeId;
            option.textContent = theme.themeName;
            themeSelect.appendChild(option);
        }
    }

    // ========================= 메인 화면 목록 조회 섹션 (아티스트별 / 노래별) =========================

    // ========================= 아티스트별 방 목록 =========================
    async function findArtistList() {
        const artistList = document.querySelector("#artistList");
        if (!artistList) return;
        artistList.innerHTML = "";

        try {
            const response = await fetch("/chat/room/type/artist?page=" + artistPage);
            const result = await response.json();
            const roomList = result.list;
            artistPage = result.currentPage;
            const totalPage = result.totalPage;

            if (roomList && roomList.length > 0) {
                for (const room of roomList) {
                    const roomDiv = document.createElement("div");

                    roomDiv.className = "room-card";

                    roomDiv.innerHTML = `
                        <img src="\${room.roomImageUrl || DEFAULT_FALLBACK_IMAGE}"
                             alt="\${room.roomName}">

                        <div class="room-card-body">

                            <h4 class="room-card-title">
                                \${room.roomName}
                            </h4>

                            <p class="room-card-description">
                                \${room.roomDescription || "채팅방 설명이 없습니다."}
                            </p>

                        </div>
                    `;

                    const image = roomDiv.querySelector("img");

                    image.onerror = function () {
                        this.onerror = null;
                        this.src = DEFAULT_FALLBACK_IMAGE;

                    };

                    roomDiv.addEventListener("click", async (e) => {
                        e.stopPropagation();
                        const res = await fetch("/chat/room/" + room.roomId + "/joined");
                        const joined = await res.json();

                        if (joined) {
                            enterRoom(room.roomId);
                        } else {
                            selectedRoomId = room.roomId;
                            await loadRoomInfo(room.roomId);
                            openJoinModal();
                        }
                    });

                    artistList.appendChild(roomDiv);
                }
                console.log("render", totalPage);
                renderArtistPaging(totalPage);

            } else {
                artistList.innerHTML = `
                <div class="empty-room">

                    개설된 아티스트 채팅방이 없습니다.

                </div>
                `;
            }
        } catch (error) {
            alert("목록을 불러오지 못했습니다.");
        }
    }

    // ========================= 노래별 방 목록  =========================
    async function findSongList() {
        const songList = document.querySelector("#songList");
        if (!songList) return;
        songList.innerHTML = "";

        try {
            const response = await fetch("/chat/room/type/song?page=" + songPage);
            const result = await response.json();
            const roomList = result.list;
            songPage = result.currentPage;
            const totalPage = result.totalPage;

            if (roomList && roomList.length > 0) {
                for (const room of roomList) {
                    const roomDiv = document.createElement("div");

                    roomDiv.className = "room-card";
                    roomDiv.innerHTML = `
                        <img src="\${room.roomImageUrl || DEFAULT_FALLBACK_IMAGE}"
                             alt="\${room.roomName}">

                        <div class="room-card-body">

                            <h4 class="room-card-title">
                                \${room.roomName}
                            </h4>

                            <p class="room-card-description">
                                \${room.roomDescription || "채팅방 설명이 없습니다."}
                            </p>

                        </div>
                    `;

                    const image = roomDiv.querySelector("img");
                    image.onerror = function () {
                        this.onerror = null;
                        this.src = DEFAULT_FALLBACK_IMAGE;
                    };

                    roomDiv.addEventListener("click", async (e) => {
                        e.stopPropagation();
                        const res = await fetch("/chat/room/" + room.roomId + "/joined");
                        const joined = await res.json();

                        if (joined) {
                            enterRoom(room.roomId);
                        } else {
                            selectedRoomId = room.roomId;
                            await loadRoomInfo(room.roomId);
                            openJoinModal();
                        }
                    });

                    songList.appendChild(roomDiv);
                }

                renderSongPaging(totalPage);

            } else {
                songList.innerHTML = `
                <div class="empty-room">
                    개설된 노래별 채팅방이 없습니다.
                </div>
                `;
            }
        } catch (error) {
            alert("목록을 불러오지 못했습니다.");
        }
    }
    // ========================= 채팅방 가입 및 정보 모달 섹션 =========================
    function enterRoom(roomId) {
        location.href = "/chatroom?roomId=" + roomId;
    }

    function openJoinModal() {
        document.querySelector("#join-modal").style.display = "flex";
    }

    function closeJoinModal() {
        document.querySelector("#join-modal").style.display = "none";
    }

    // ========================= 바깥 클릭 시 모달 닫기 =========================
    document.querySelector("#join-modal").addEventListener("click", (event) => {
        if (event.target.id === "join-modal") closeJoinModal();
    });

    // ========================= ESC 키 입력 시 모달 닫기 =========================
    document.addEventListener("keydown", (event) => {
        if (event.key === "Escape") closeJoinModal();
    });

    document.querySelector("#join-cancel-btn").addEventListener("click", closeJoinModal);

    // ========================= 가입 승인 처리 =========================
    document.querySelector("#join-ok-btn").addEventListener("click", async () => {
        const response = await fetch("/chat/room/join", {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({ roomId: selectedRoomId })
        });

        const success = await response.json();
        if (success) {
            closeJoinModal();
            alert("가입되었습니다.");
            enterRoom(selectedRoomId);
        } else {
            alert("이미 가입된 채팅방입니다.");
        }
    });

    // ========================= 가입 모달 정보 로드 ========================
    async function loadRoomInfo(roomId) {
        try {
            const response = await fetch("/chat/room/" + roomId);
            const room = await response.json();

            document.querySelector("#join-room-name").textContent = room.roomName || "";
            document.querySelector("#join-room-description").textContent = room.roomDescription || "";
            document.querySelector("#join-room-count").textContent = room.memberCount || 0;

            const modalImg = document.querySelector("#join-room-image");
            modalImg.onerror = function () {
                this.onerror = null;
                this.src = DEFAULT_FALLBACK_IMAGE;
            };

            modalImg.src = room.roomImageUrl || DEFAULT_FALLBACK_IMAGE;

            document.querySelector("#join-room-owner").textContent = room.ownerName || "방장 정보 없음";
            document.querySelector("#join-room-created-at").textContent = room.createdAt ? room.createdAt.substring(0, 10) : "";
        } catch (e) {
        }
    }

    function renderArtistPaging(totalPage){

        const paging = document.querySelector("#artistPaging");

        paging.innerHTML = "";

        let start = artistPage - 2;

        if(start < 1){start = 1;}

        let end = start + 4;

        if(end > totalPage){end = totalPage;start = end - 4;
            if(start < 1){start = 1;
            }
        }

        if(artistPage > 1){
            paging.innerHTML += '<button onclick="artistMove('+(artistPage-1)+')">이전</button>';
        }

        for(let i=start;i<=end;i++){

            let cls="";

            if(i==artistPage){cls="active";}
            paging.innerHTML += '<button class="'+cls+'" onclick="artistMove('+i+')">'+i+'</button>';

        }

        if(artistPage<totalPage){
            paging.innerHTML += '<button onclick="artistMove('+(artistPage+1)+')">다음</button>';

        }

    }

    function renderSongPaging(totalPage){

        const paging = document.querySelector("#songPaging");

        paging.innerHTML = "";

        let start = songPage - 2;

        if(start < 1){start = 1;}

        let end = start + 4;

        if(end > totalPage){end = totalPage;start = end - 4;

            if(start < 1){start = 1;}
        }

        if(songPage > 1){

            paging.innerHTML += '<button onclick="songMove('+(songPage-1)+')">이전</button>';           }

        for(let i=start;i<=end;i++){

            let cls="";

            if(i==songPage){cls="active";}

            paging.innerHTML += '<button class="'+cls+'" onclick="songMove('+i+')">'+i+'</button>';            }

        if(songPage<totalPage){
            paging.innerHTML += '<button onclick="songMove('+(songPage+1)+')">다음</button>';            }

    }

    async function artistMove(page){artistPage = page;await findArtistList();}
    async function songMove(page){songPage = page;await findSongList();}
</script>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>