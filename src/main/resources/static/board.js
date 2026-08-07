(function () {
    const currentPath = window.location.pathname;

    // ====================================================================
    // 1. 공통 기능 (삭제 폼 컨펌 등 모든 페이지 공통)
    // ====================================================================
    const deleteForms = document.querySelectorAll('.delete-form');
    deleteForms.forEach(function (form) {
        form.addEventListener('submit', function (event) {
            if (!confirm('정말로 이 공지사항을 삭제하시겠습니까?')) {
                event.preventDefault();
            }
        });
    });

    // 에디터(등록/수정) 취소 버튼 공통 처리
    document.querySelectorAll('[data-cancel-editor]').forEach(function (button) {
        button.addEventListener('click', function () {
            window.location.href = window.contextPath + '/board';
        });
    });


    // ====================================================================
    // 2. 목록 화면 전용 기능 (list.jsp) - 카테고리 필터 및 검색
    // ====================================================================
    const filterButtons = document.querySelectorAll('[data-board-filter]');
    const searchInput = document.querySelector('input[name="keyword"]');
    const searchTypeSelect = document.querySelector('select[name="searchType"]');
    const searchButton = document.querySelector('.board-search button[type="submit"]');

    if (filterButtons.length > 0 || searchInput) {
        // 페이지 최초 로드 시 URL 파라미터를 읽어 UI 상태 복원
        (function initFilterState() {
            const params = new URLSearchParams(window.location.search);
            const currentCategory = params.get('category') || 'all';
            const currentKeyword = params.get('keyword') || '';
            const currentSearchType = params.get('searchType') || 'titleContent';

            filterButtons.forEach(function (button) {
                const isMatch = button.value === currentCategory;
                button.classList.toggle('is-active', isMatch);
            });

            if (searchInput && currentKeyword) {
                searchInput.value = currentKeyword;
            }

            if (searchTypeSelect && currentSearchType) {
                searchTypeSelect.value = currentSearchType;
            }
        })();

        // 선택된 탭, 카테고리, 검색 조건 및 검색어를 포함하여 서버로 요청을 보내는 함수
        function searchAndFilterSubmit(targetPage = 1) {
            const activeFilter = document.querySelector('[data-board-filter].is-active');
            const category = activeFilter ? activeFilter.value : 'all';
            const searchType = searchTypeSelect ? searchTypeSelect.value : 'titleContent';
            const query = searchInput ? searchInput.value.trim() : '';

            const params = new URLSearchParams(window.location.search);
            const tab = params.get('tab') || '';

            let url = window.location.origin + window.location.pathname;
            let queryParams = [];

            queryParams.push('page=' + targetPage);
            if (tab) queryParams.push('tab=' + encodeURIComponent(tab));
            queryParams.push('category=' + encodeURIComponent(category));
            queryParams.push('searchType=' + encodeURIComponent(searchType));
            queryParams.push('keyword=' + encodeURIComponent(query));

            window.location.href = url + '?' + queryParams.join('&');
        }

        // 필터 버튼 클릭 이벤트
        filterButtons.forEach(function (button) {
            button.addEventListener('click', function (e) {
                e.preventDefault();
                filterButtons.forEach(function (item) {
                    item.classList.remove('is-active');
                });
                button.classList.add('is-active');
                searchAndFilterSubmit(1);
            });
        });

        // 검색 입력창 엔터키 이벤트
        if (searchInput) {
            searchInput.addEventListener('keypress', function (event) {
                if (event.key === 'Enter') {
                    event.preventDefault();
                    searchAndFilterSubmit(1);
                }
            });
        }
    }


    // ====================================================================
    // 3. 등록 및 수정 폼 화면 전용 기능 (form.jsp) - 이미지 업로드 및 미리보기
    // ====================================================================
    const imageInput = document.getElementById('imageInput');
    const btnUploadTrigger = document.getElementById('btnUploadTrigger');
    const previewContainer = document.getElementById('previewContainer');
    const imageCountSpan = document.getElementById('imageCount');

    if (imageInput && btnUploadTrigger) {
        let selectedFiles = [];

        btnUploadTrigger.addEventListener('click', function () {
            imageInput.click();
        });

        imageInput.addEventListener('change', function (e) {
            const files = Array.from(e.target.files);

            if (selectedFiles.length + files.length > 5) {
                alert('이미지는 최대 5장까지 첨부할 수 있습니다.');
                imageInput.value = '';
                return;
            }

            for (let i = 0; i < files.length; i++) {
                const file = files[i];
                if (file.size > 5 * 1024 * 1024) {
                    alert('장당 최대 5MB 이하의 이미지만 업로드할 수 있습니다.');
                    imageInput.value = '';
                    return;
                }
                selectedFiles.push(file);
            }

            updatePreview();
            syncInputFiles();
        });

        function updatePreview() {
            if (!previewContainer) return;
            previewContainer.innerHTML = '';

            if (imageCountSpan) {
                imageCountSpan.textContent = selectedFiles.length;
            }

            selectedFiles.forEach((file, index) => {
                const reader = new FileReader();
                reader.onload = function (e) {
                    const thumbDiv = document.createElement('div');
                    thumbDiv.className = 'existing-image-item';
                    thumbDiv.innerHTML = `
                        <img src="${e.target.result}" alt="미리보기 이미지">
                        <button type="button" class="btn-del-existing" data-index="${index}">×</button>
                    `;

                    thumbDiv.querySelector('button').addEventListener('click', function () {
                        selectedFiles.splice(index, 1);
                        updatePreview();
                        syncInputFiles();
                    });

                    previewContainer.appendChild(thumbDiv);
                };
                reader.readAsDataURL(file);
            });
        }

        function syncInputFiles() {
            if (!imageInput) return;
            const dataTransfer = new DataTransfer();
            selectedFiles.forEach(file => dataTransfer.items.add(file));
            imageInput.files = dataTransfer.files;
        }
    }
})();