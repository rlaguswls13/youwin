<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!doctype html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="Youwin 음악 채팅방 둘러보기">
    <title>채팅방 | Youwin</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/app.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/index.css">
</head>
<body>
<div class="site-shell room-explore">
    <header class="site-header">
        <div class="site-container site-header__inner">
            <a class="brand" href="${pageContext.request.contextPath}/" aria-label="Youwin 홈">
                <span class="brand__mark">YW</span><span>Youwin</span>
            </a>
            <nav class="site-nav" data-site-nav aria-label="주요 메뉴">
                <a href="${pageContext.request.contextPath}/">홈</a>
                <a href="${pageContext.request.contextPath}/board">게시판</a>
                <a class="is-active" href="${pageContext.request.contextPath}/index">채팅방</a>
                <a href="${pageContext.request.contextPath}/member/mypage">마이페이지</a>
            </nav>
            <div class="site-header__actions">
                <button class="button" id="create-btn" type="button">＋ 채팅방 만들기</button>
            </div>
            <button class="menu-toggle" type="button" data-menu-toggle aria-label="메뉴 열기" aria-expanded="false"></button>
        </div>
    </header>

    <main class="page-main room-explore__main">
        <div class="site-container">
            <section class="room-discovery" aria-labelledby="room-page-title">
                <div class="room-discovery__copy">
                    <p class="page-eyebrow">Live music community</p>
                    <h1 id="room-page-title">지금 듣는 음악으로<br>대화를 시작하세요</h1>
                    <p>아티스트와 노래를 중심으로 열린 채팅방을 찾고, 취향이 닿는 사람들과 바로 이야기해 보세요.</p>
                </div>
                <div class="room-search" role="search">
                    <label class="sr-only" for="keyword">채팅방 검색</label>
                    <input type="search" id="keyword" placeholder="방 이름이나 설명으로 검색">
                    <button class="button" type="button" id="search-btn">검색</button>
                </div>
                <div class="room-discovery__meta" aria-label="이용 안내">
                    <span><strong>ARTIST</strong> 아티스트 중심 대화</span>
                    <span><strong>SONG</strong> 한 곡을 깊게 듣는 대화</span>
                </div>
            </section>

            <section class="room-section" aria-labelledby="artist-room-title">
                <div class="section-head">
                    <div>
                        <p class="room-section__eyebrow">Talk about artists</p>
                        <h2 class="section-title" id="artist-room-title">아티스트별 채팅방</h2>
                        <p class="section-copy">좋아하는 아티스트의 음악과 새로운 소식을 함께 나눠요.</p>
                    </div>
                    <span class="room-section__badge">ARTIST ROOMS</span>
                </div>
                <div class="room-list-grid" id="artistList" aria-live="polite"></div>
            </section>

            <section class="room-section" aria-labelledby="song-room-title">
                <div class="section-head">
                    <div>
                        <p class="room-section__eyebrow">One song, many stories</p>
                        <h2 class="section-title" id="song-room-title">노래별 채팅방</h2>
                        <p class="section-copy">요즘 반복해서 듣는 한 곡에 관한 감상을 나눠 보세요.</p>
                    </div>
                    <span class="room-section__badge">SONG ROOMS</span>
                </div>
                <div class="room-list-grid" id="songList" aria-live="polite"></div>
            </section>
        </div>
    </main>

    <footer class="site-footer">
        <div class="site-container site-footer__inner">
            <span>© 2026 Youwin. 음악으로 연결되는 커뮤니티.</span>
            <button class="footer-home" id="home-btn" type="button">홈으로 돌아가기 ↑</button>
        </div>
    </footer>
</div>

<div class="room-modal" id="create-modal" style="display:none;" role="dialog" aria-modal="true" aria-labelledby="create-room-title">
    <div class="room-modal__card room-create-card">
        <div class="room-modal__head">
            <div><p class="page-eyebrow">New conversation</p><h2 id="create-room-title">채팅방 만들기</h2></div>
            <button class="room-modal__close" id="close-btn" type="button" aria-label="닫기">×</button>
        </div>
        <div class="room-form">
            <label class="room-field">방 이름 <em>필수</em><input type="text" id="roomName" maxlength="50" placeholder="대화 주제가 드러나는 이름을 입력하세요"></label>
            <label class="room-field">방 설명<textarea id="roomDescription" rows="3" maxlength="200" placeholder="어떤 이야기를 나누는 방인지 알려주세요"></textarea></label>
            <div class="room-field">
                <span>대표 이미지 <small>선택</small></span>
                <label class="room-file" for="roomImage">이미지 선택</label>
                <input type="file" id="roomImage" accept="image/*">
                <img id="previewImage" src="" alt="선택한 채팅방 이미지 미리보기" style="display:none;">
            </div>
            <label class="room-field">방 분류 <em>필수</em><select id="roomType"><option value="artist">아티스트별 방</option><option value="song">노래별 방</option></select></label>
            <label class="room-field" id="artistInputArea">아티스트<input type="text" id="artistName" placeholder="아티스트 이름"></label>
            <label class="room-field" id="songInputArea" style="display:none;">노래<input type="text" id="songTitle" placeholder="노래 제목"></label>
            <label class="room-field">장르 <em>필수</em><select id="themeId"><option value="">장르 선택</option></select></label>
        </div>
        <div class="room-modal__actions">
            <button class="button button--secondary" id="close-btn-secondary" type="button">취소</button>
            <button class="button" id="save-btn" type="button">채팅방 생성</button>
        </div>
    </div>
</div>

<div class="room-modal" id="join-modal" style="display:none;" role="dialog" aria-modal="true" aria-labelledby="join-room-name">
    <div class="room-modal__card join-modal-content">
        <p class="page-eyebrow">Room preview</p>
        <img id="join-room-image" src="" alt="채팅방 대표 이미지">
        <h2 id="join-room-name"></h2>
        <p class="join-room-description" id="join-room-description"></p>
        <dl class="join-room-meta">
            <div><dt>방장</dt><dd id="join-room-owner"></dd></div>
            <div><dt>참여 인원</dt><dd><span id="join-room-count"></span>명</dd></div>
            <div><dt>생성일</dt><dd id="join-room-created-at"></dd></div>
        </dl>
        <div class="room-modal__actions join-modal-btn-area">
            <button class="button button--secondary" id="join-cancel-btn" type="button">둘러보기</button>
            <button class="button" id="join-ok-btn" type="button">가입하고 입장하기</button>
        </div>
    </div>
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

        document.addEventListener("keydown", (event) => {
            const card = event.target.closest(".room-preview-card");
            if (card && (event.key === "Enter" || event.key === " ")) {
                event.preventDefault();
                card.click();
            }
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
                roomDiv.className = "room-preview-card";
                roomDiv.tabIndex = 0;

                const image = document.createElement("img");
                image.className = "room-preview-card__image";
                image.loading = "lazy";
                image.alt = "";
                image.src = room.roomImageUrl || DEFAULT_FALLBACK_IMAGE;
                image.width = 150;
                image.height = 150;

                image.onerror = function() {
                    this.onerror = null;
                    this.src = DEFAULT_FALLBACK_IMAGE;
                };

                const name = document.createElement("div");
                name.className = "room-preview-card__name";
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
        document.querySelector("#close-btn-secondary").addEventListener("click", closeModal);
        document.querySelector("#save-btn").addEventListener("click", createRoom);

        function openModal() { document.querySelector("#create-modal").style.display = "flex"; document.querySelector("#roomName").focus(); }

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
                const response = await fetch("/chat/room/type/artist");
                const roomList = await response.json();

                if (roomList && roomList.length > 0) {
                    for (const room of roomList) {
                        const roomDiv = document.createElement("div");
                roomDiv.className = "room-preview-card";
                roomDiv.tabIndex = 0;

                        const image = document.createElement("img");
                image.className = "room-preview-card__image";
                image.loading = "lazy";
                image.alt = "";
                        image.src = room.roomImageUrl || DEFAULT_FALLBACK_IMAGE;
                        image.width = 150;
                        image.height = 150;
                        image.onerror = function() { this.onerror = null; this.src = DEFAULT_FALLBACK_IMAGE; };

                        const name = document.createElement("div");
                name.className = "room-preview-card__name";
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
                } else {
                    artistList.innerHTML = "개설된 아티스트 채팅방이 없습니다.";
                }
            } catch (error) {
                console.error("아티스트 목록 조회 실패:", error);
            }
        }

        // ========================= 노래별 방 목록  =========================
        async function findSongList() {
            const songList = document.querySelector("#songList");
            if (!songList) return;
            songList.innerHTML = "";

            try {
                const response = await fetch("/chat/room/type/song");
                const roomList = await response.json();

                if (roomList && roomList.length > 0) {
                    for (const room of roomList) {
                        const roomDiv = document.createElement("div");
                roomDiv.className = "room-preview-card";
                roomDiv.tabIndex = 0;

                        const image = document.createElement("img");
                image.className = "room-preview-card__image";
                image.loading = "lazy";
                image.alt = "";
                        image.src = room.roomImageUrl || DEFAULT_FALLBACK_IMAGE;
                        image.width = 150;
                        image.height = 150;
                        image.onerror = function() { this.onerror = null; this.src = DEFAULT_FALLBACK_IMAGE; };

                        const name = document.createElement("div");
                name.className = "room-preview-card__name";
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

                        songList.appendChild(roomDiv);
                    }
                } else {
                    songList.innerHTML = "개설된 노래 채팅방이 없습니다.";
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

        document.querySelector("#create-modal").addEventListener("click", (event) => {
            if (event.target.id === "create-modal") closeModal();
        });

        // ========================= ESC 키 입력 시 모달 닫기 =========================
        document.addEventListener("keydown", (event) => {
            if (event.key === "Escape") {
                closeJoinModal();
                closeModal();
            }
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

<script src="${pageContext.request.contextPath}/app.js"></script>
</body>

</html>
