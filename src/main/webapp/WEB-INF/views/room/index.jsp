<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
            <!DOCTYPE html>
            <html lang="ko">
            <head>
                <meta charset="UTF-8">
                <title>you win</title>

                <link rel="stylesheet" href="/index.css">
            </head>


            <body>

            <div>

                <h2> you win</h2>

                <h4> 음악 소통 페이지 </h4>

                <button id="home-btn">🏠</button>

                <label>
                    <input type="text" id="keyword" placeholder="검색어를 입력해주세요.">
                </label>

                <button id="search-btn">검색</button>



                <button id="create-btn"> +채팅방 만들기 </button>

                <div id="create-modal" style="display: none;">
                     <div>

                        <h2>채팅방 만들기</h2>

                        <label>방 이름 *</label> <br>
                        <input type="text" id="roomName"> <br><br>

                        <label>방 설명</label>
                        <textarea id="roomDescription"></textarea> <br><br>

                         <label>방 이미지 (선택)</label><br>
                         <input type="file" id="roomImage" accept="image/*"><br><br>
                         <img id="previewImage" src="" style="display:none; width:180px; height:180px; object-fit:cover;">

                        <label><input type="radio" name="roomType" value="artist" checked>아티스트</label>
                        <select id="artistId">
                            <option value="">선택 안 함</option>
                        </select>
                        <br><br>

                        <label><input type="radio" name="roomType" value="song">노래</label> <br><br>
                        <select id="songId">
                            <option value="">선택 안 함</option>
                        </select>
                        <br><br>

                         <label>장르</label>
                         <select id="themeId">
                             <option value="">선택 안 함</option>
                         </select>
                         <br><br>

                        <button id="save-btn">생성</button>
                        <button id="close-btn">취소</button>

                       </div>
                     </div>


            <div id="join-modal" style="display:none;">
                <div class="join-modal-content">

                    <h2>채팅방 정보</h2>

                    <img id="join-room-image" src="" alt="채팅방 이미지">

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




                <h3> 🎤아티스트별 </h3>
                <div id="artistList"></div>



                <h3> 🎵노래별 </h3>
                <div id="songList"></div>



            </div>

    <script>
    //  가입하려는 채팅방 번호
    let selectedRoomId = null;

    // ------------ 상단 ------------------------------------------
    window.addEventListener("DOMContentLoaded", async () => {
        await findArtistList();
        await findSongList();
        await loadArtistOption();
        await loadSongOption();
        await loadThemeOption();
    });

    // ------------------- 아티스트, 노래 검색 -------------------------
    document.querySelector("#search-btn")
        .addEventListener("click", search);

    async function search() {

        const keyword = document.querySelector("#keyword").value.trim();

        if (keyword === "") {
            await findArtistList();
            await findSongList();
            return;
        }

        await searchArtist(keyword);
        await searchSong(keyword);

    }

    async function searchArtist(keyword) {

        const response = await fetch("/chat/artist/search?keyword=" + encodeURIComponent(keyword));
        const list = await response.json();
        const artistList = document.querySelector("#artistList");

        artistList.innerHTML = "";

        for (const artist of list) {
            const div = document.createElement("div");
            div.textContent = artist.artistName;
            artistList.appendChild(div);
        }
    }

    async function searchSong(keyword) {

        const response = await fetch("/chat/song/search?keyword=" + encodeURIComponent(keyword));
        const list = await response.json();
        const songList = document.querySelector("#songList");

        songList.innerHTML = "";

        for (const song of list) {
            const div = document.createElement("div");
            div.textContent = song.songTitle;
            songList.appendChild(div);
        }
    }

    // -----------       홈 버튼 누르면 메인 페이지 ------------------------

    document.querySelector("#home-btn").addEventListener("click", goHome);

    function goHome() {
        location.href = "/";
    }

    // ----------       채팅방 만들기 생성 모달 ---------------
    document.querySelector("#create-btn").addEventListener("click", openModal);
    document.querySelector("#close-btn").addEventListener("click", closeModal);

    function openModal() {document.querySelector("#create-modal").style.display = "block";}
    function closeModal() {document.querySelector("#create-modal").style.display = "none";}

    //              ------- 채팅방 만들기 ----------
    document.querySelector("#save-btn").addEventListener("click", createRoom);

    async function createRoom() {

        const roomName = document.querySelector("#roomName").value.trim();
        const roomDescription = document.querySelector("#roomDescription").value.trim();
        const artistId = document.querySelector("#artistId").value;
        const songId = document.querySelector("#songId").value;
        const themeId = document.querySelector("#themeId").value;
        const roomType = document.querySelector("input[name='roomType']:checked").value;

        let targetId;

        if (roomType === "artist") {
            targetId = artistId;
        } else {
            targetId = songId;
        }

        if (roomName === "") {
            alert("방 이름을 입력해주세요.");
            return;
        }
        if (targetId === "") {
            alert("아티스트 또는 노래를 선택해주세요.");
            return;
        }

        if (themeId === "") {
            alert("장르를 선택해주세요.");
            return;
        }

        const data = {
            roomName: roomName,
            roomDescription: roomDescription,
            roomType: roomType,
            targetId: targetId,
            themeId: themeId
        };

        const response = await fetch("/chat/room/create", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify(data)
        });

        const roomId = await response.json();
        alert("채팅방이 생성되었습니다.");

        await findArtistList();
        await findSongList();
        closeModal();
    }

    async function loadArtistOption() {

        const response = await fetch("/chat/artist/list");
        const list = await response.json();
        const artistSelect = document.querySelector("#artistId");

        artistSelect.innerHTML = "<option value=''>선택 안 함</option>";

        for (const artist of list) {

            const option = document.createElement("option");

            option.value = artist.artistId;
            option.textContent = artist.artistName;
            artistSelect.appendChild(option);
        }
    }

    async function loadSongOption() {

        const response = await fetch("/chat/song/list");
        const list = await response.json();
        const songSelect = document.querySelector("#songId");

        songSelect.innerHTML = "<option value=''>선택 안 함</option>";

        for (const song of list) {

            const option = document.createElement("option");
            option.value = song.songId;
            option.textContent = song.songTitle;
            songSelect.appendChild(option);
        }
    }

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

    const artistSelect = document.querySelector("#artistId");
    const songSelect = document.querySelector("#songId");

    document.querySelectorAll("input[name='roomType']").forEach(radio => {

        radio.addEventListener("change", () => {

            if (radio.value === "artist" && radio.checked) {
                artistSelect.disabled = false;
                songSelect.disabled = true;
                songSelect.value = "";
            }

            if (radio.value === "song" && radio.checked) {
                artistSelect.disabled = true;
                songSelect.disabled = false;
                artistSelect.value = "";
            }
        });
    });
    songSelect.disabled = true;

    // ----------- 아티스트 누르면 방 가입 여부와 함께 들어가지거나 안되어있으면 가입 -----
    async function findArtistList() {

        const response = await fetch("/chat/artist/list");
        const list = await response.json();

        const artistList = document.querySelector("#artistList");
        artistList.innerHTML = "";

        for (const artist of list) {

            const artistDiv = document.createElement("div");
            const title = document.createElement("h4");
            title.textContent = artist.artistName;

            artistDiv.appendChild(title);

            const roomResponse = await fetch("/chat/artist/" + artist.artistId + "/room");
            const roomList = await roomResponse.json();

            if (roomList.length === 0) {

                const empty = document.createElement("div");
                empty.textContent = "채팅방이 없습니다.";
                artistDiv.appendChild(empty);

            } else {

                for (const room of roomList) {

                    const roomDiv = document.createElement("div");
                    roomDiv.textContent = room.roomName;

                    roomDiv.addEventListener("click", async () => {

                        const response = await fetch("/chat/room/" + room.roomId + "/joined");
                        const joined = await response.json();

                        if (joined) {
                            enterRoom(room.roomId);
                        } else {
                            selectedRoomId = room.roomId;
                            await loadRoomInfo(room.roomId);
                            openJoinModal();
                        }
                    });

                    artistDiv.appendChild(roomDiv);
                }
            }
            artistList.appendChild(artistDiv);
        }
    }

    function enterRoom(roomId) {
        location.href = "/chatroom?roomId=" + roomId;
    }

    function openJoinModal() {
        document.querySelector("#join-modal").style.display = "flex";
    }

    // 모달 바깥(배경) 클릭 시 닫기
    document.querySelector("#join-modal").addEventListener("click", (event) => {

        if (event.target.id === "join-modal") {
            closeJoinModal();
        }
    });

    // ESC 키를 누르면 모달 닫기
    document.addEventListener("keydown", (event) => {

        if (event.key === "Escape") {
            closeJoinModal();
        }
    });

    document.querySelector("#join-ok-btn").addEventListener("click", async () => {

        const response = await fetch("/chat/room/join", {
            method: "POST",
            headers: {
                "Content-Type": "application/json"
            },
            body: JSON.stringify({
                roomId: selectedRoomId
            })
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

    function closeJoinModal() {
        document.querySelector("#join-modal").style.display = "none";
    }

    document.querySelector("#join-cancel-btn")
        .addEventListener("click", () => {closeJoinModal();

    });

    // ----------- 노래 누르면 방 가입 여부와 함께 들어가지거나 안되어있으면 가입 -----
    async function findSongList() {

        const response = await fetch("/chat/song/list");
        const list = await response.json();

        const songList = document.querySelector("#songList");
        songList.innerHTML = "";

        for (const song of list) {
            const SongDiv = document.createElement("div");

            const title = document.createElement("h4");
            title.textContent = song.songTitle;

            SongDiv.appendChild(title);

            const roomResponse = await fetch("/chat/song/" + song.songId + "/room");
            const roomList = await roomResponse.json();

            if (roomList.length === 0) {

                const empty = document.createElement("div");
                empty.textContent = "채팅방이 없습니다.";
                SongDiv.appendChild(empty);

            } else {

                for (const room of roomList) {
                    const roomDiv = document.createElement("div");
                    roomDiv.textContent = room.roomName;

                    roomDiv.addEventListener("click", async () => {

                        const response = await fetch("/chat/room/" + room.roomId + "/joined");
                        const joined = await response.json();

                        if (joined) {
                            enterRoom(room.roomId);
                        } else {

                            selectedRoomId = room.roomId;
                            await loadRoomInfo(room.roomId);
                            openJoinModal();
                        }

                    });
                    SongDiv.appendChild(roomDiv);
                }
            }
            songList.appendChild(SongDiv);
        }
    }

    // ------------------- 채팅방 정보를 조회하여 가입 모달 표시 ------------
    async  function loadRoomInfo(roomId) {
        const response = await fetch("/chat/room/" + roomId);
        const room = await response.json();

        document.querySelector("#join-room-name").textContent = room.roomName;
        document.querySelector("#join-room-description").textContent = room.roomDescription;
        document.querySelector("#join-room-count").textContent = room.memberCount;
        document.querySelector("#join-room-image").src = room.roomImageUrl;
        document.querySelector("#join-room-owner").textContent = room.ownerName;
        document.querySelector("#join-room-created-at").textContent = room.createdAt.substring(0, 10);
    }

</script>

</body>

</html>
