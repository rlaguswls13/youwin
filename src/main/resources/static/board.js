(function () {
    // 1. DOM 요소 탐색 (사이드바 탭 메뉴 및 검색, 필터 인터페이스)
    const viewButtons = document.querySelectorAll('[data-board-target]');
    const views = document.querySelectorAll('[data-board-view]');
    const filterButtons = document.querySelectorAll('[data-board-filter]');
    const searchInput = document.querySelector('[data-board-search]');
    const searchButton = document.querySelector('.board-search button');
    const rows = document.querySelectorAll('[data-board-row]');

    // 2. 에디터 폼 관련 내부 입력 엘리먼트 탐색
    const editorForm = document.getElementById('editor-form');
    const writeTitle = document.getElementById('write-title');
    const submitBtn = document.getElementById('submit-btn');
    const noticeIdInput = document.getElementById('post-noticeId');
    const categorySelect = document.getElementById('category');
    const titleInput = document.getElementById('post-title');
    const contentTextarea = document.getElementById('post-content');
    const isPinnedCheckbox = document.getElementById('post-isPinned');
    const allowCommentsCheckbox = document.getElementById('post-allowComments');

    // [함수] 메뉴 탭 전환 제어 함수 (CSS 클래스 토글 및 상단 스크롤)
    function showView(target) {
        views.forEach(function (view) {
            view.classList.toggle('is-active', view.dataset.boardView === target);
        });
        viewButtons.forEach(function (button) {
            button.classList.toggle('is-active', button.dataset.boardTarget === target);
        });
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // [함수] 상세보기 모드와 수정/작성 모드 간의 입력 필드 활성/잠금 제어 함수
    function setFormReadOnly(isReadOnly) {
        if (!editorForm) return;

        const elements = [categorySelect, isPinnedCheckbox, allowCommentsCheckbox, titleInput, contentTextarea];
        elements.forEach(function (el) {
            if (!el) return;
            if (el.tagName === 'SELECT' || el.type === 'checkbox') {
                el.disabled = isReadOnly;
            } else {
                el.readOnly = isReadOnly;
            }
        });
    }

    // [함수] 선택된 테이블 행(Row)의 데이터셋을 입력 폼 양식에 맵핑하는 함수
    function fillFormData(row) {
        if (!row) return;
        if (noticeIdInput) noticeIdInput.value = row.dataset.id;
        if (categorySelect) categorySelect.value = row.dataset.category;
        if (titleInput) titleInput.value = row.dataset.title;
        if (contentTextarea) contentTextarea.value = row.dataset.content;
        if (isPinnedCheckbox) isPinnedCheckbox.checked = (row.dataset.pinned === "1");
        if (allowCommentsCheckbox) allowCommentsCheckbox.checked = (row.dataset.allowComments === "1");
    }

    // [수정] 서버단 페이징/검색/필터 상태를 결합하여 페이지를 리다이렉트하는 동적 함수
    function searchAndFilterSubmit(targetPage = 1) {
        const activeFilter = document.querySelector('[data-board-filter].is-active');
        const category = activeFilter ? activeFilter.dataset.boardFilter : 'all';
        const query = searchInput ? searchInput.value.trim() : '';

        // 기본 주소창 위치 획득 및 검색 쿼리 스트링 빌더 구성
        let url = window.location.origin + window.location.pathname;
        url += '?page=' + targetPage;
        url += '&category=' + encodeURIComponent(category);
        url += '&keyword=' + encodeURIComponent(query);

        // 정렬 및 데이터 바인딩을 위해 서버로 새롭게 동적 파라미터 요청
        window.location.href = url;
    }

    // 3. 페이지가 최초 로드되었을 때 주소창의 파라미터 상태를 분석하여 필터/검색 UI 상태 복원
    (function initFilterState() {
        const params = new URLSearchParams(window.location.search);
        const currentCategory = params.get('category') || 'all';
        const currentKeyword = params.get('keyword') || '';

        // 주소창 카테고리와 일치하는 버튼 활성화
        filterButtons.forEach(function (button) {
            const isMatch = button.dataset.boardFilter === currentCategory;
            button.classList.toggle('is-active', isMatch);
        });

        // 주소창 검색 키워드가 있다면 검색창 인풋 필드에 복원 세팅
        if (searchInput && currentKeyword) {
            searchInput.value = currentKeyword;
        }
    })();

    // 4. 이벤트 리스너 등록 - 좌측 커뮤니티 사이드바 메뉴 클릭 핸들러
    viewButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            // 주소창에 검색이나 페이징 파라미터가 남아있을 수 있으므로 공지사항 메뉴 클릭 시에는 순수 목록 이동 처리
            if (button.dataset.boardTarget === 'notice') {
                window.location.href = window.location.origin + window.location.pathname;
            } else {
                showView(button.dataset.boardTarget);
            }
        });
    });

    // 5. 이벤트 리스너 등록 - 새 글 작성 단추 클릭 핸들러 (폼 빌더 리셋 및 쓰기 주소 셋업)
    document.querySelectorAll('[data-open-editor]').forEach(function (button) {
        button.addEventListener('click', function () {
            if (editorForm) {
                editorForm.reset();
                setFormReadOnly(false);
                if (noticeIdInput) noticeIdInput.value = "";
                editorForm.action = editorForm.action.replace('/board/modify', '/board/write');
                if (writeTitle) writeTitle.textContent = "새 공지 작성";
                if (submitBtn) {
                    submitBtn.textContent = "등록하기";
                    submitBtn.type = "submit";
                }
            }
            showView('write');
        });
    });

    // 6. 이벤트 리스너 등록 - 에디터 폼 내 '취소' 버튼 핸들러
    document.querySelectorAll('[data-cancel-editor]').forEach(function (button) {
        button.addEventListener('click', function () {
            showView('notice');
        });
    });

    // [수정] 7. 이벤트 리스너 등록 - 카테고리 필터 버튼 탭 클릭 시 서버 검색 동적 유도
    filterButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            filterButtons.forEach(function (item) {
                item.classList.remove('is-active');
            });
            button.classList.add('is-active');
            // 필터 클릭 시 기존 페이지 번호를 무시하고 1페이지로 새로고침 쿼리 전송
            searchAndFilterSubmit(1);
        });
    });

    // [수정] 8. 이벤트 리스너 등록 - 검색 텍스트 필드 엔터키 또는 검색 버튼 클릭 연동
    if (searchInput) {
        searchInput.addEventListener('keypress', function (event) {
            if (event.key === 'Enter') {
                searchAndFilterSubmit(1);
            }
        });
    }
    if (searchButton) {
        searchButton.addEventListener('click', function () {
            searchAndFilterSubmit(1);
        });
    }

    // [수정] 9. 이벤트 리스너 등록 - 하단 페이지네이션 바 동적 클릭 링크 가로채기 (검색 파라미터 유실 방지)
    const paginationLinks = document.querySelectorAll('.board-pagination a');
    paginationLinks.forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault(); // 기본 href 이동 동작을 가로채 차단

            // 링크 주소의 URL에서 page 번호만 쏙 추출해 옵니다.
            const hrefAttr = link.getAttribute('href');
            if (!hrefAttr || hrefAttr === '#') return;

            const urlObj = new URL(link.href);
            const targetPage = urlObj.searchParams.get('page') || 1;

            // 현재 유지 중인 카테고리와 검색어를 잃어버리지 않은 상태로 해당 페이지만 타겟하여 다시 전송합니다.
            searchAndFilterSubmit(targetPage);
        });
    });

    // 10. 이벤트 리스너 등록 - 게시글 행 내의 삭제 폼 서브밋 컨펌 확인 제어
    const deleteForms = document.querySelectorAll('.delete-form');
    deleteForms.forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
                event.preventDefault();
            }
        });
    });

    // 11. 이벤트 리스너 등록 - 공지사항 행 리스트 더블클릭 상세조회 핸들러
    rows.forEach(function (row) {
        row.addEventListener('dblclick', function () {
            fillFormData(row);
            setFormReadOnly(true);

            if (editorForm && !editorForm.action.includes('/board/modify')) {
                editorForm.action = editorForm.action.replace('/board/write', '/board/modify');
            }

            if (writeTitle) writeTitle.textContent = "공지사항 상세 조회";

            if (submitBtn) {
                submitBtn.textContent = "수정하기로 전환";
                submitBtn.type = "button";
            }
            showView('write');
        });
    });

    // 12. 이벤트 리스너 등록 - 단순 상세보기 내부에서 '수정하기로 전환' 버튼 인터랙션 처리
    if (submitBtn) {
        submitBtn.addEventListener('click', function (event) {
            if (submitBtn.type === 'button') {
                event.preventDefault();
                setFormReadOnly(false);
                if (writeTitle) writeTitle.textContent = "공지사항 수정";
                submitBtn.textContent = "수정하기";
                submitBtn.type = "submit";
            }
        });
    }

    // 13. 이벤트 리스너 등록 - 행 내부 파란색 '수정' 바로가기 버튼 단독 클릭 인터랙션 핸들러
    const editButtons = document.querySelectorAll('.btn-edit');
    editButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            const row = button.closest('[data-board-row]');
            if (!row || !editorForm) return;

            fillFormData(row);
            setFormReadOnly(false);

            if (!editorForm.action.includes('/board/modify')) {
                editorForm.action = editorForm.action.replace('/board/write', '/board/modify');
            }

            if (writeTitle) writeTitle.textContent = "공지사항 수정";
            if (submitBtn) {
                submitBtn.textContent = "수정하기";
                submitBtn.type = "submit";
            }

            showView('write');
        });
    });
})();