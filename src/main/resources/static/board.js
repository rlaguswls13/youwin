(function () {
    const viewButtons = document.querySelectorAll('[data-board-target]');
    const views = document.querySelectorAll('[data-board-view]');
    const filterButtons = document.querySelectorAll('[data-board-filter]');
    const searchInput = document.querySelector('[data-board-search]');
    const rows = document.querySelectorAll('[data-board-row]');

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
})();