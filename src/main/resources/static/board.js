(function () {
    const viewButtons = document.querySelectorAll('[data-board-target]');
    const views = document.querySelectorAll('[data-board-view]');
    const filterButtons = document.querySelectorAll('[data-board-filter]');
    const searchInput = document.querySelector('[data-board-search]');
    const rows = document.querySelectorAll('[data-board-row]');

    // 💡 [추가] 수정 기능 연동을 위한 입력 폼 엘리먼트 탐색
    const editorForm = document.getElementById('editor-form');
    const writeTitle = document.getElementById('write-title');
    const submitBtn = document.getElementById('submit-btn');
    const noticeIdInput = document.getElementById('post-noticeId');
    const categorySelect = document.getElementById('category');
    const titleInput = document.getElementById('post-title');
    const contentTextarea = document.getElementById('post-content');
    const isPinnedCheckbox = document.getElementById('post-isPinned');

    function showView(target) {
        views.forEach(function (view) {
            view.classList.toggle('is-active', view.dataset.boardView === target);
        });
        viewButtons.forEach(function (button) {
            button.classList.toggle('is-active', button.dataset.boardTarget === target);
        });
        window.scrollTo({ top: 0, behavior: 'smooth' });
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
            // 💡 [추가] 새 글 작성 시에는 폼을 깨끗이 비우고 '등록 모드' URL과 텍스트로 초기화합니다.
            if (editorForm) {
                editorForm.reset();
                if (noticeIdInput) noticeIdInput.value = "";
                editorForm.action = editorForm.action.replace('/board/modify', '/board/write');
                if (writeTitle) writeTitle.textContent = "새 공지 작성";
                if (submitBtn) submitBtn.textContent = "등록하기";
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

    // 💡 [추가] 삭제 버튼 클릭 시 확인 알림창(Confirm) 띄우기
    const deleteForms = document.querySelectorAll('.delete-form');
    deleteForms.forEach(function (form) {
        form.addEventListener('submit', function (event) {
            // 브라우저 기본 알림창을 띄우고 사용자가 '취소'를 누르면 실행
            if (!confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
                event.preventDefault(); // Form이 서버로 전송(submit)되는 것을 취소시킵니다.
            }
        });
    });

    // 💡 [추가] 파란색 수정 버튼 클릭 시 데이터 매핑 및 수정 모드 전환
    const editButtons = document.querySelectorAll('.btn-edit');
    editButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            const row = button.closest('[data-board-row]');
            if (!row || !editorForm) return;

            // JSP 행(tr)에 심어둔 기존 공지사항 원본 데이터 가져오기
            const id = row.dataset.id;
            const category = row.dataset.category;
            const title = row.dataset.title;
            const content = row.dataset.content;
            const pinned = row.dataset.pinned;

            // 입력 폼 필드에 기존 데이터 채워 넣기
            if (noticeIdInput) noticeIdInput.value = id;
            if (categorySelect) categorySelect.value = category;
            if (titleInput) titleInput.value = title;
            if (contentTextarea) contentTextarea.value = content;
            if (isPinnedCheckbox) isPinnedCheckbox.checked = (pinned === "1");

            // Form 전송 주소를 신규 등록(/write)에서 수정 처리(/modify) 주소로 변경
            if (!editorForm.action.includes('/board/modify')) {
                editorForm.action = editorForm.action.replace('/board/write', '/board/modify');
            }

            // 가이드 타이틀 및 서브밋 버튼 텍스트 변경
            if (writeTitle) writeTitle.textContent = "공지사항 수정";
            if (submitBtn) submitBtn.textContent = "수정하기";

            // 2, 3번째 사진 등록 양식 폼으로 화면 이동
            showView('write');
        });
    });
})();