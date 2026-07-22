(function () {
    const viewButtons = document.querySelectorAll('[data-board-target]');
    const views = document.querySelectorAll('[data-board-view]');
    const filterButtons = document.querySelectorAll('[data-board-filter]');
    const searchInput = document.querySelector('[data-board-search]');
    const rows = document.querySelectorAll('[data-board-row]');

    // [추가] 수정 및 조회 기능 연동을 위한 입력 폼 엘리먼트 탐색
    const editorForm = document.getElementById('editor-form');
    const writeTitle = document.getElementById('write-title');
    const submitBtn = document.getElementById('submit-btn');
    const noticeIdInput = document.getElementById('post-noticeId');
    const categorySelect = document.getElementById('category');
    const titleInput = document.getElementById('post-title');
    const contentTextarea = document.getElementById('post-content');
    const isPinnedCheckbox = document.getElementById('post-isPinned');
    const allowCommentsCheckbox = document.getElementById('post-allowComments');

    function showView(target) {
        views.forEach(function (view) {
            view.classList.toggle('is-active', view.dataset.boardView === target);
        });
        viewButtons.forEach(function (button) {
            button.classList.toggle('is-active', button.dataset.boardTarget === target);
        });
        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    // [추가] 조회 모드(상세보기)와 일반 작성/수정 모드 간의 입력 필드 활성/비활성을 제어하는 함수
    function setFormReadOnly(isReadOnly) {
        if (!editorForm) return;

        const elements = [categorySelect, isPinnedCheckbox, allowCommentsCheckbox, titleInput, contentTextarea];
        elements.forEach(function (el) {
            if (!el) return;
            if (el.tagName === 'SELECT' || el.type === 'checkbox') {
                el.disabled = isReadOnly; // 셀렉트 박스와 체크박스는 disabled로 잠금
            } else {
                el.readOnly = isReadOnly; // 일반 텍스트 필드들은 readOnly로 잠금
            }
        });
    }

    // [추가] 행 데이터를 가져와서 폼 필드에 넣어주는 공통 맵핑 함수
    function fillFormData(row) {
        if (!row) return;
        if (noticeIdInput) noticeIdInput.value = row.dataset.id;
        if (categorySelect) categorySelect.value = row.dataset.category;
        if (titleInput) titleInput.value = row.dataset.title;
        if (contentTextarea) contentTextarea.value = row.dataset.content;
        if (isPinnedCheckbox) isPinnedCheckbox.checked = (row.dataset.pinned === "1");
        // JSP에 추가한 id="post-allowComments" 연동 (데이터가 담겨온다고 가정 시 추가 세팅 가능)
        if (allowCommentsCheckbox) allowCommentsCheckbox.checked = (row.dataset.allowComments === "1");
    }

    function filterRows() {
        const activeFilter = document.querySelector('[data-board-filter].is-active');
        const category = activeFilter ? activeFilter.dataset.boardFilter : 'all';
        const query = searchInput ? searchInput.value.trim().toLowerCase() : '';

        rows.forEach(function (row) {
            const matchesCategory = category === 'all' || row.dataset.category === category;
            const matchesQuery = !query || row.textContent.toLowerCase().includes(query);
            row.hidden = !(matchesCategory && matchesQuery);
        });
    }

    viewButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            showView(button.dataset.boardTarget);
        });
    });

    document.querySelectorAll('[data-open-editor]').forEach(function (button) {
        button.addEventListener('click', function () {
            // [추가] 새 글 작성 시에는 폼을 깨끗이 비우고 잠금을 해제하며 '등록 모드' URL과 텍스트로 초기화합니다.
            if (editorForm) {
                editorForm.reset();
                setFormReadOnly(false); // 잠금 해제
                if (noticeIdInput) noticeIdInput.value = "";
                editorForm.action = editorForm.action.replace('/board/modify', '/board/write');
                if (writeTitle) writeTitle.textContent = "새 공지 작성";
                if (submitBtn) {
                    submitBtn.textContent = "등록하기";
                    submitBtn.type = "submit"; // 일반 전송 타입으로 복원
                }
            }
            showView('write');
        });
    });

    document.querySelectorAll('[data-cancel-editor]').forEach(function (button) {
        button.addEventListener('click', function () {
            showView('notice');
        });
    });

    filterButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            filterButtons.forEach(function (item) {
                item.classList.remove('is-active');
            });
            button.classList.add('is-active');
            filterRows();
        });
    });

    if (searchInput) {
        searchInput.addEventListener('input', filterRows);
    }

    // [추가] 삭제 버튼 클릭 시 확인 알림창(Confirm) 띄우기
    const deleteForms = document.querySelectorAll('.delete-form');
    deleteForms.forEach(function (form) {
        form.addEventListener('submit', function (event) {
            // 브라우저 기본 알림창을 띄우고 사용자가 '취소'를 누르면 실행
            if (!confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
                event.preventDefault(); // Form이 서버로 전송(submit)되는 것을 취소시킵니다.
            }
        });
    });

    // [추가] 작성 글 더블클릭(dblclick) 시 기존 글 상세 조회 기능
    rows.forEach(function (row) {
        row.addEventListener('dblclick', function () {
            fillFormData(row);     // 데이터 세팅
            setFormReadOnly(true); // 입력 폼을 읽기 전용으로 잠금

            if (editorForm && !editorForm.action.includes('/board/modify')) {
                editorForm.action = editorForm.action.replace('/board/write', '/board/modify');
            }

            if (writeTitle) writeTitle.textContent = "공지사항 상세 조회";

            // 단순 조회 중이므로 즉시 submit 되지 않도록 버튼 커스텀
            if (submitBtn) {
                submitBtn.textContent = "수정하기로 전환";
                submitBtn.type = "button";
            }
            showView('write');
        });
    });

    // [추가] '수정하기로 전환' 버튼 클릭 시 폼 잠금을 풀고 수정 모드로 바꿔주는 기능
    if (submitBtn) {
        submitBtn.addEventListener('click', function (event) {
            if (submitBtn.type === 'button') {
                event.preventDefault();
                setFormReadOnly(false); // 잠금 해제 (수정 가능하게 변경)
                if (writeTitle) writeTitle.textContent = "공지사항 수정";
                submitBtn.textContent = "수정하기";
                submitBtn.type = "submit"; // 다시 form을 전송할 수 있는 상태로 변경
            }
        });
    }

    // [추가] 파란색 수정 버튼 클릭 시 데이터 매핑 및 수정 모드 전환
    const editButtons = document.querySelectorAll('.btn-edit');
    editButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            const row = button.closest('[data-board-row]');
            if (!row || !editorForm) return;

            fillFormData(row);
            setFormReadOnly(false); // 수정 창이므로 잠금 해제 상태 보장

            // Form 전송 주소를 신규 등록(/write)에서 수정 처리(/modify) 주소로 변경
            if (!editorForm.action.includes('/board/modify')) {
                editorForm.action = editorForm.action.replace('/board/write', '/board/modify');
            }

            // 가이드 타이틀 및 서브밋 버튼 텍스트 변경
            if (writeTitle) writeTitle.textContent = "공지사항 수정";
            if (submitBtn) {
                submitBtn.textContent = "수정하기";
                submitBtn.type = "submit";
            }

            // 2, 3번째 사진 등록 양식 폼으로 화면 이동
            showView('write');
        });
    });
})();