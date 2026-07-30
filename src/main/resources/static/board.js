(function () {
    const viewButtons = document.querySelectorAll('[data-board-target]');
    const views = document.querySelectorAll('[data-board-view]');
    const filterButtons = document.querySelectorAll('[data-board-filter]');
    const searchInput = document.querySelector('[data-board-search]');
    const searchButton = document.querySelector('.board-search button');
    const rows = document.querySelectorAll('[data-board-row]');

    const writeTitle = document.getElementById('write-title');
    const submitBtn = document.getElementById('submit-btn');
    const noticeIdInput = document.getElementById('post-noticeId');
    const categorySelect = document.getElementById('category');
    const titleInput = document.getElementById('post-title');
    const contentTextarea = document.getElementById('post-content');
    const isPinnedCheckbox = document.getElementById('post-isPinned');
    const allowCommentsCheckbox = document.getElementById('post-allowComments');



    // 공용 유틸리티 함수: 폼 읽기전용 제어 및 데이터 매핑
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

    function fillFormData(row) {
        if (!row) return;
        if (noticeIdInput) noticeIdInput.value = row.dataset.id;
        if (categorySelect) categorySelect.value = row.dataset.category;
        if (titleInput) titleInput.value = row.dataset.title;
        if (contentTextarea) contentTextarea.value = row.dataset.content;
        if (isPinnedCheckbox) isPinnedCheckbox.checked = (row.dataset.pinned === "1");
        if (allowCommentsCheckbox) allowCommentsCheckbox.checked = (row.dataset.allowComments === "1");
    }


    // ====================================================================
    // 0. 레이아웃 (Layout) : 탭 화면 전환 및 초기 UI 상태 복원
    // -> 설명: 사이드바 메뉴 클릭 시 화면을 부드럽게 전환하고,
    //    페이지 로드 시 주소창 파라미터(카테고리, 검색어)를 분석해 UI 상태를 유지합니다.
    // ====================================================================

    // [함수] 화면 전환 및 스크롤 제어
    function showView(target) {
        views.forEach(function (view) {
            view.classList.toggle('is-active', view.dataset.boardView === target);
        });
        viewButtons.forEach(function (button) {
            button.classList.toggle('is-active', button.dataset.boardTarget === target);
        });
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // 페이지 최초 로드 시 검색/필터 UI 상태 복원
    (function initFilterState() {
        const params = new URLSearchParams(window.location.search);
        const currentCategory = params.get('category') || 'all';
        const currentKeyword = params.get('keyword') || '';

        filterButtons.forEach(function (button) {
            const isMatch = button.dataset.boardFilter === currentCategory;
            button.classList.toggle('is-active', isMatch);
        });

        if (searchInput && currentKeyword) {
            searchInput.value = currentKeyword;
        }
    })();

    // 사이드바 메뉴 클릭 핸들러 (공지사항 클릭 시 파라미터 초기화 후 목록 이동)
    viewButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            if (button.dataset.boardTarget === 'notice') {
                window.location.href = window.location.origin + window.location.pathname;
            } else {
                showView(button.dataset.boardTarget);
            }
        });
    });


    // ====================================================================
    // 1. 등록 (Create) : 새 글 작성 폼 활성화 및 에디터 취소 제어
    // -> 설명: '새 글 작성' 버튼 클릭 시 폼을 초기화하고 액션 주소를 /board/write로
    //    세팅합니다. 취소 버튼 클릭 시 다시 공지사항 목록으로 돌아갑니다.
    // ====================================================================

    // '새 글 작성' 단추 클릭 핸들러
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

    // 에디터 폼 내 '취소' 버튼 핸들러
    document.querySelectorAll('[data-cancel-editor]').forEach(function (button) {
        button.addEventListener('click', function () {
            showView('notice');
        });
    });


    // ====================================================================
    // 2. 목록 및 페이지네이션 (Read List & Pagination) : 서버 연동 검색/필터링
    // -> 설명: 카테고리 필터 선택, 키워드 검색, 하단 페이지네이션 클릭 시
    //    서버단 상태(페이징, 검색어, 카테고리) 유실 없이 동적으로 리다이렉트합니다.
    // ====================================================================

    // [함수] 페이징/검색/필터 상태를 결합하여 페이지 리다이렉트
    function searchAndFilterSubmit(targetPage = 1) {
        const activeFilter = document.querySelector('[data-board-filter].is-active');
        const category = activeFilter ? activeFilter.dataset.boardFilter : 'all';
        const query = searchInput ? searchInput.value.trim() : '';

        let url = window.location.origin + window.location.pathname;
        url += '?page=' + targetPage;
        url += '&category=' + encodeURIComponent(category);
        url += '&keyword=' + encodeURIComponent(query);

        window.location.href = url;
    }

    // 카테고리 필터 버튼 클릭 시 1페이지로 새로고침 검색
    filterButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            filterButtons.forEach(function (item) {
                item.classList.remove('is-active');
            });
            button.classList.add('is-active');
            searchAndFilterSubmit(1);
        });
    });

    // 검색어 입력 후 엔터키 또는 검색 버튼 클릭 연동
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

    // 하단 페이지네이션 바 클릭 시 기존 검색 상태 유지하며 이동 (가로채기)
    const paginationLinks = document.querySelectorAll('.board-pagination a');
    paginationLinks.forEach(function (link) {
        link.addEventListener('click', function (event) {
            event.preventDefault();
            const hrefAttr = link.getAttribute('href');
            if (!hrefAttr || hrefAttr === '#') return;

            const urlObj = new URL(link.href);
            const targetPage = urlObj.searchParams.get('page') || 1;

            searchAndFilterSubmit(targetPage);
        });
    });


    // ====================================================================
    // 3. 삭제 (Delete) : 게시글 삭제 컨펌 제어
    // -> 설명: 목록 우측의 '삭제' 버튼 클릭 시 폼이 서브밋되기 전에 사용자에게
    //    정말 삭제할 것인지 묻는 안전장치 팝업을 띄웁니다.
    // ====================================================================
    const deleteForms = document.querySelectorAll('.delete-form');
    deleteForms.forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
                event.preventDefault();
            }
        });
    });


    // ====================================================================
    // 4. 수정 (Update) : 수정 모드 진입 및 데이터 매핑
    // -> 설명: 테이블 행 내부의 파란색 '수정' 단독 버튼을 눌렀을 때 실행됩니다.
    //    해당 글 데이터를 폼에 채우고 액션 주소를 /board/modify로 변경하여 활성화합니다.
    // ====================================================================
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


    // ====================================================================
    // 5. 상세조회 (Detail Read) : 더블클릭 상세조회 및 상세조회 내 수정 전환
    // -> 설명: 목록 행을 '더블클릭'하면 폼 필드들을 전부 읽기 전용(ReadOnly)으로
    //    잠근 채 내용을 보여주고, 내부에서 버튼을 통해 수정 모드로 전환할 수 있게 합니다.
    // ====================================================================

    // 행 리스트 더블클릭 시 상세조회 (잠금 모드) 진입
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

    // 상세조회 내부에서 '수정하기로 전환' 버튼 클릭 시 잠금 해제 인터랙션
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
})();