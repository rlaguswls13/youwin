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

                <div>
                    <input type="text" id="keyword" placeholder="검색어를 입력하세요">
                    <button type="button" id="search-btn">검색</button>
                </div>



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

                         <label>방 분류 선택 *</label><br>
                         <select id="roomType">
                             <option value="artist">🎤 아티스트별 방</option>
                             <option value="song">🎵 노래별 방</option>
                         </select>
                         <br><br>

                         <label id="targetLabel">대상 선택 (아티스트/노래)</label><br>
                         <select id="targetId">
                             <option value="">선택 안함</option>
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
        let selectedRoomId = null;
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
                artistList.innerHTML = "<div>검색 결과가 없습니다.</div>";
                return;
            }

            for (const room of roomList) {
                const roomDiv = document.createElement("div");

                const image = document.createElement("img");
                image.src = room.roomImageUrl || DEFAULT_FALLBACK_IMAGE;
                image.width = 150;
                image.height = 150;

                image.onerror = function() {
                    this.onerror = null;
                    this.src = DEFAULT_FALLBACK_IMAGE;
                };

                const name = document.createElement("div");
                name.textContent = room.roomName;

                roomDiv.appendChild(image);
                roomDiv.appendChild(name);

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

        function openModal() { document.querySelector("#create-modal").style.display = "block"; }

        document.querySelector("#roomType").addEventListener("change", loadTargetOptions);

        // 모달 열릴 때 목록 로드
        function openModal() {
            document.querySelector("#create-modal").style.display = "block";
            loadTargetOptions(); // [추가] 모달 열릴 때 옵션 불러오기
        }

        // targetId 드롭다운 옵션 채우는 함수
        async function loadTargetOptions() {
            const roomType = document.querySelector("#roomType").value;
            const targetSelect = document.querySelector("#targetId");
            if (!targetSelect) return;

            targetSelect.innerHTML = "<option value=''>선택 안함</option>";

            if (roomType === "artist") {
                try {
                    const response = await fetch("/chat/artist/list");
                    const list = await response.json();
                    for (const artist of list) {
                        const option = document.createElement("option");
                        option.value = artist.artistId; // 백엔드의 artistId
                        option.textContent = artist.artistName || artist.name;
                        targetSelect.appendChild(option);
                    }
                } catch (e) { console.error("아티스트 목록 로드 실패", e); }
            } else if (roomType === "song") {
                try {
                    const response = await fetch("/chat/song/list");
                    const list = await response.json();
                    for (const song of list) {
                        const option = document.createElement("option");
                        option.value = song.songId; // 백엔드의 songId
                        option.textContent = song.songTitle || song.title;
                        targetSelect.appendChild(option);
                    }
                } catch (e) { console.error("노래 목록 로드 실패", e); }
            }
        }

        function closeModal() { document.querySelector("#create-modal").style.display = "none"; }

        // 방 생성 데이터 전송
        async function createRoom() {
            const roomName = document.querySelector("#roomName").value.trim();
            const roomDescription = document.querySelector("#roomDescription").value.trim();
            const roomType = document.querySelector("#roomType").value;
            const targetId = document.querySelector("#targetId").value;
            const themeId = document.querySelector("#themeId").value;

            if (roomName === "") {
                alert("방 이름을 입력해주세요.");
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
                themeId: themeId,
                targetId: targetId === "" ? null : targetId
            };

            const imageFile = document.querySelector("#roomImage").files[0];
            const formData = new FormData();

            formData.append("room", new Blob([JSON.stringify(data)], { type: "application/json" }));
            if (imageFile) {
                formData.append("image", imageFile);
            }

            const response = await fetch("/chat/room/create", {
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

        //  ========================= 아티스트별 방 목록 =========================
        async function findArtistList() {
            const artistList = document.querySelector("#artistList");
            if (!artistList) return;
            artistList.innerHTML = "";

            try {
                const response = await fetch("/chat/room/search?keyword=");
                const roomList = await response.json();

                if (roomList && roomList.length > 0) {
                    for (const room of roomList) {

                        if (room.roomType !== "artist") continue;
                        const roomDiv = document.createElement("div");

                        const image = document.createElement("img");
                        image.src = room.roomImageUrl || DEFAULT_FALLBACK_IMAGE;
                        image.width = 150;
                        image.height = 150;

                        image.onerror = function() {
                            this.onerror = null;
                            this.src = DEFAULT_FALLBACK_IMAGE;
                        };

                        const name = document.createElement("div");
                        name.textContent = room.roomName;

                        roomDiv.appendChild(image);
                        roomDiv.appendChild(name);

                        roomDiv.addEventListener("click", async (e) => {
                            e.stopPropagation();
                            try {
                                const res = await fetch("/chat/room/" + room.roomId + "/joined");
                                const joined = await res.json();

                                if (joined) {
                                    enterRoom(room.roomId);
                                } else {
                                    selectedRoomId = room.roomId;
                                    await loadRoomInfo(room.roomId);
                                    openJoinModal();
                                }
                            } catch (err) {
                                console.error(err);
                            }
                        });

                        artistList.appendChild(roomDiv);
                    }
                }

                if (artistList.children.length === 0) {
                    artistList.innerHTML = "개설된 아티스트 채팅방이 없습니다.";
                }
            } catch (error) {
                console.error("아티스트 목록 조회 실패:", error);
            }
        }
        // ========================= 노래별 방 목록 =========================
        async function findSongList() {
            const songList = document.querySelector("#songList");
            if (!songList) return;
            songList.innerHTML = "";

            try {
                const response = await fetch("/chat/room/search?keyword=");
                const roomList = await response.json();

                if (roomList && roomList.length > 0) {
                    for (const room of roomList) {
                        // 💡 핵심: roomType이 song이 아닌 방은 노래 목록에서 제외!
                        if (room.roomType !== "song") continue;

                        const roomDiv = document.createElement("div");

                        const image = document.createElement("img");
                        image.src = room.roomImageUrl || DEFAULT_FALLBACK_IMAGE;
                        image.width = 150;
                        image.height = 150;

                        image.onerror = function() {
                            this.onerror = null;
                            this.src = DEFAULT_FALLBACK_IMAGE;
                        };

                        const name = document.createElement("div");
                        name.textContent = room.roomName;

                        roomDiv.appendChild(image);
                        roomDiv.appendChild(name);

                        roomDiv.addEventListener("click", async (e) => {
                            e.stopPropagation();
                            try {
                                const res = await fetch("/chat/room/" + room.roomId + "/joined");
                                const joined = await res.json();

                                if (joined) {
                                    enterRoom(room.roomId);
                                } else {
                                    selectedRoomId = room.roomId;
                                    await loadRoomInfo(room.roomId);
                                    openJoinModal();
                                }
                            } catch (error) {}
                        });

                        songList.appendChild(roomDiv);
                    }
                }

                if (songList.children.length === 0) {
                    const empty = document.createElement("div");
                    empty.textContent = "개설된 노래 채팅방이 없습니다.";
                    songList.appendChild(empty);
                }
            } catch (error) {
                console.error("노래 목록 조회 실패:", error);
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
    </script>

</body>

</html>
