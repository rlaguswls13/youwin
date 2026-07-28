(function () {
    const viewButtons = document.querySelectorAll('[data-board-target]');
    const views = document.querySelectorAll('[data-board-view]');
    const filterButtons = document.querySelectorAll('[data-board-filter]');
    const searchInput = document.querySelector('[data-board-search]');
    const searchButton = document.querySelector('.board-search button');
    const rows = document.querySelectorAll('[data-board-row]');

    const editorForm = document.getElementById('editor-form');
    const writeTitle = document.getElementById('write-title');
    const submitBtn = document.getElementById('submit-btn');
    const noticeIdInput = document.getElementById('post-noticeId');
    const categorySelect = document.getElementById('category');
    const titleInput = document.getElementById('post-title');
    const contentTextarea = document.getElementById('post-content');
    const isPinnedCheckbox = document.getElementById('post-isPinned');
    const allowCommentsCheckbox = document.getElementById('post-allowComments');

    // 상세조회 전용 뷰 콤포넌트 변수 정의
    const detailImagesContainer = document.getElementById('detail-images');
    const detailContentDiv = document.getElementById('detail-content');
    const detailCategoryEyebrow = document.getElementById('detail-category-eyebrow');
    const detailTitleH1 = document.getElementById('detail-title');
    const detailMetaInfoP = document.getElementById('detail-meta-info');

    // 이미지 업로드 관련 컴포넌트 변수 및 가방 정의
    const imageInput = document.getElementById('imageInput');
    const btnUploadTrigger = document.getElementById('btnUploadTrigger');
    const previewContainer = document.getElementById('previewContainer');
    const imageCountSpan = document.getElementById('imageCount');

    // 유저가 선택한 파일들을 담아둘 실제 배열 (FileList 대체재)
    let uploadedFiles = [];
    const MAX_FILE_COUNT = 5;
    const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB

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

        if (btnUploadTrigger) {
            btnUploadTrigger.style.pointerEvents = isReadOnly ? 'none' : 'auto';
            btnUploadTrigger.style.opacity = isReadOnly ? '0.6' : '1';
        }
        if (previewContainer) {
            previewContainer.classList.toggle('readonly-view', isReadOnly);
        }
    }

    function fillFormData(row) {
        if (!row) return;
        if (noticeIdInput) noticeIdInput.value = row.dataset.id || '';
        if (categorySelect) categorySelect.value = row.dataset.category || '';
        if (titleInput) titleInput.value = row.dataset.title || '';
        if (contentTextarea) contentTextarea.value = row.dataset.content || '';
        if (isPinnedCheckbox) isPinnedCheckbox.checked = (row.dataset.pinned === "1");
        if (allowCommentsCheckbox) allowCommentsCheckbox.checked = (row.dataset.allowComments === "1");
    }

    // 이미지 관리 함수군 (업로드 제어, 프리뷰 렌더링, 초기화)
    if (btnUploadTrigger && imageInput) {
        btnUploadTrigger.addEventListener('click', function () {
            imageInput.click();
        });
    }

    if (imageInput) {
        imageInput.addEventListener('change', function (e) {
            const files = Array.from(e.target.files);

            for (let file of files) {
                if (uploadedFiles.length >= MAX_FILE_COUNT) {
                    alert(`이미지는 최대 ${MAX_FILE_COUNT}장까지만 업로드할 수 있습니다.`);
                    break;
                }

                if (file.size > MAX_FILE_SIZE) {
                    alert(`[${file.name}] 파일이 제한 용량(5MB)을 초과합니다.`);
                    continue;
                }

                uploadedFiles.push(file);
                renderPreview(file, uploadedFiles.length - 1);
            }

            updateImageCount();
            imageInput.value = '';
        });
    }

    function renderPreview(fileOrUrl, index) {
        if (!previewContainer) return;

        const previewItem = document.createElement('div');
        previewItem.className = 'preview-item';
        previewItem.style.cssText = 'position: relative; width: 80px; height: 80px; border: 1px solid #dee2e6; border-radius: 6px; overflow: hidden; background: #fafafa;';
        previewItem.setAttribute('data-index', index);

        const img = document.createElement('img');
        img.style.cssText = 'width: 100%; height: 100%; object-fit: cover;';

        const deleteBtn = document.createElement('button');
        deleteBtn.type = 'button';
        deleteBtn.innerHTML = '×';
        deleteBtn.className = 'btn-del-img';
        deleteBtn.style.cssText = 'position: absolute; top: 2px; right: 2px; width: 18px; height: 18px; border-radius: 50%; background: rgba(0,0,0,0.6); color: #fff; border: none; font-size: 12px; cursor: pointer; display: flex; align-items: center; justify-content: center; line-height: 1;';

        deleteBtn.addEventListener('click', function (event) {
            event.stopPropagation();
            const currentIndex = parseInt(previewItem.getAttribute('data-index'), 10);
            uploadedFiles.splice(currentIndex, 1);
            refreshPreviews();
        });

        previewItem.appendChild(img);
        previewItem.appendChild(deleteBtn);

        if (fileOrUrl instanceof File) {
            const reader = new FileReader();
            reader.onload = function (e) {
                img.src = e.target.result;
                previewContainer.appendChild(previewItem);
            };
            reader.readAsDataURL(fileOrUrl);
        } else {
            img.src = fileOrUrl;
            previewContainer.appendChild(previewItem);
        }
    }

    function refreshPreviews() {
        if (!previewContainer) return;
        previewContainer.innerHTML = '';
        uploadedFiles.forEach(function (fileOrUrl, index) {
            renderPreview(fileOrUrl, index);
        });
        updateImageCount();
    }

    function updateImageCount() {
        if (imageCountSpan) {
            imageCountSpan.textContent = uploadedFiles.length;
        }
    }

    function clearImageContainer() {
        uploadedFiles = [];
        if (previewContainer) previewContainer.innerHTML = '';
        updateImageCount();
        if (imageInput) imageInput.value = '';
    }


    // ====================================================================
    // 0. 레이아웃 (Layout) : 탭 화면 전환 및 초기 UI 상태 복원
    // ====================================================================
    function showView(target, pushHistory = true) {
        if (!views || views.length === 0) return;

        let hasMatchedView = false;
        views.forEach(function (view) {
            const isMatch = (view.dataset.boardView === target);
            view.classList.toggle('is-active', isMatch);
            if (isMatch) hasMatchedView = true;
        });

        if (!hasMatchedView && target !== 'notice') {
            views.forEach(function (view) {
                view.classList.toggle('is-active', view.dataset.boardView === 'notice');
            });
        }

        viewButtons.forEach(function (button) {
            button.classList.toggle('is-active', button.dataset.boardTarget === target);
        });

        // 브라우저 뒤로가기 버튼과 연동하기 위한 히스토리 상태 기록
        if (pushHistory) {
            const newUrl = new URL(window.location.href);
            newUrl.searchParams.set('view', target);
            history.pushState({ view: target }, '', newUrl.toString());
        }

        window.scrollTo({ top: 0, behavior: 'smooth' });
    }

    (function initFilterState() {
        const params = new URLSearchParams(window.location.search);
        const currentCategory = params.get('category') || 'all';
        const currentKeyword = params.get('keyword') || '';
        const currentView = params.get('view');

        filterButtons.forEach(function (button) {
            const isMatch = button.dataset.boardFilter === currentCategory;
            button.classList.toggle('is-active', isMatch);
        });

        if (searchInput && currentKeyword) {
            searchInput.value = currentKeyword;
        }

        // 페이지 진입 시 URL에 view 파라미터가 있다면 해당 뷰로 초기 복원
        if (currentView) {
            showView(currentView, false);
        }
    })();

    viewButtons.forEach(function (button) {
        button.addEventListener('click', function (event) {
            event.preventDefault();
            if (button.dataset.boardTarget === 'notice') {
                showView('notice');
            } else {
                showView(button.dataset.boardTarget);
            }
        });
    });


    // ====================================================================
    // 1. 등록 (Create) : 새 글 작성 폼 활성화 및 에디터 취소 제어
    // ====================================================================
    document.querySelectorAll('[data-open-editor]').forEach(function (button) {
        button.addEventListener('click', function (event) {
            event.preventDefault();
            if (editorForm) {
                editorForm.reset();
                setFormReadOnly(false);
                clearImageContainer();
                if (noticeIdInput) noticeIdInput.value = "";
                editorForm.action = editorForm.action.replace('/board/modify', '/board/write');
                if (writeTitle) writeTitle.textContent = "새 공지 작성";
                if (submitBtn) {
                    submitBtn.textContent = "등록하기";
                    submitBtn.type = "submit";
                    submitBtn.style.display = "inline-block";
                }
            }
            showView('write');
        });
    });

    document.querySelectorAll('[data-cancel-editor]').forEach(function (button) {
        button.addEventListener('click', function (event) {
            event.preventDefault();
            event.stopPropagation();
            showView('notice');
        });
    });


    // ====================================================================
    // 2. 목록 및 페이지네이션 (Read List & Pagination)
    // ====================================================================
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

    filterButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            filterButtons.forEach(function (item) {
                item.classList.remove('is-active');
            });
            button.classList.add('is-active');
            searchAndFilterSubmit(1);
        });
    });

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
    // 3. 삭제 (Delete)
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
    // 4. 수정 (Update)
    // ====================================================================
    const editButtons = document.querySelectorAll('.btn-edit');
    editButtons.forEach(function (button) {
        button.addEventListener('click', function (event) {
            event.preventDefault();
            event.stopPropagation();
            const row = button.closest('[data-board-row]');
            if (!row || !editorForm) return;

            clearImageContainer();
            fillFormData(row);
            setFormReadOnly(false);

            if (!editorForm.action.includes('/board/modify')) {
                if (editorForm.action.includes('/board/write')) {
                    editorForm.action = editorForm.action.replace('/board/write', '/board/modify');
                } else {
                    const baseEndpoint = editorForm.action.endsWith('/') ? editorForm.action.slice(0, -1) : editorForm.action;
                    editorForm.action = baseEndpoint.endsWith('/board') ? baseEndpoint + '/modify' : baseEndpoint;
                }
            }

            if (writeTitle) writeTitle.textContent = "공지사항 수정";
            if (submitBtn) {
                submitBtn.textContent = "수정하기";
                submitBtn.type = "submit";
                submitBtn.style.display = "inline-block";
            }

            const noticeId = row.dataset.id;
            let imageFetchUrl = '';
            if (window.contextPath !== undefined) {
                imageFetchUrl = `${window.location.origin}${window.contextPath}/board/images?noticeId=${noticeId}`;
            } else {
                const formBase = editorForm.action.split('/board/')[0];
                imageFetchUrl = `${formBase}/board/images?noticeId=${noticeId}`;
            }
            imageFetchUrl = imageFetchUrl.replace(/([^:]\/)\/+/g, "$1");

            fetch(imageFetchUrl)
                .then(response => response.ok ? response.json() : [])
                .then(images => {
                    if (images && images.length > 0) {
                        images.forEach((imgData) => {
                            // 객체 형태나 문자열 형태 모두 대응할 수 있도록 수정
                            const fileName = imgData.savedFileName || imgData.saved_file_name || imgData.fileName || imgData.file_name || (typeof imgData === 'string' ? imgData : null);
                            if (!fileName || fileName === 'undefined') return;

                            const hostOrigin = window.location.origin;
                            const context = (window.contextPath !== undefined) ? window.contextPath : '';
                            let imgUrl = `${hostOrigin}${context}/upload/${fileName}`;
                            imgUrl = imgUrl.replace(/([^:]\/)\/+/g, "$1");

                            uploadedFiles.push(imgUrl);
                            renderPreview(imgUrl, uploadedFiles.length - 1);
                        });
                        updateImageCount();
                    }
                })
                .catch(err => console.error("수정 화면 이미지 로드 실패:", err));

            showView('write');
        });
    });


    // ====================================================================
    // 5. 상세조회 (Detail Read) 및 폼 전송(Submit) 최종 제어
    // ====================================================================
    rows.forEach(function (row) {
        row.addEventListener('dblclick', function () {
            const noticeId = row.dataset.id;
            const category = row.dataset.category;
            const title = row.dataset.title;
            const content = row.dataset.content;

            // JSP에 존재하는 전용 상세 영역 컴포넌트에 데이터 바인딩
            if (detailCategoryEyebrow) detailCategoryEyebrow.textContent = category;
            if (detailTitleH1) detailTitleH1.textContent = title;
            if (detailContentDiv) detailContentDiv.textContent = content;

            const cells = row.querySelectorAll('td');
            if (cells.length >= 6 && detailMetaInfoP) {
                const author = cells[3].textContent;
                const date = cells[4].textContent;
                const count = cells[5].textContent;
                detailMetaInfoP.textContent = `작성자: ${author} | 작성일: ${date} | 조회수: ${count}`;
            }

            if (detailImagesContainer) {
                detailImagesContainer.innerHTML = '';

                let imageFetchUrl = '';
                if (window.contextPath !== undefined) {
                    imageFetchUrl = `${window.location.origin}${window.contextPath}/board/images?noticeId=${noticeId}`;
                } else {
                    const formBase = editorForm ? editorForm.action.split('/board/')[0] : '';
                    imageFetchUrl = `${formBase}/board/images?noticeId=${noticeId}`;
                }
                imageFetchUrl = imageFetchUrl.replace(/([^:]\/)\/+/g, "$1");

                fetch(imageFetchUrl)
                    .then(response => response.ok ? response.json() : [])
                    .then(images => {
                        if (images && images.length > 0) {
                            images.forEach(imgData => {
                                const img = document.createElement('img');
                                const fileName = imgData.savedFileName || imgData.saved_file_name || imgData.fileName || imgData.file_name || (typeof imgData === 'string' ? imgData : null);
                                if (!fileName || fileName === 'undefined') return;

                                const hostOrigin = window.location.origin;
                                const context = (window.contextPath !== undefined) ? window.contextPath : '';
                                let imgUrl = `${hostOrigin}${context}/upload/${fileName}`;
                                img.src = imgUrl.replace(/([^:]\/)\/+/g, "$1");

                                img.style.cssText = 'width: 100%; max-width: 600px; height: auto; border-radius: 6px; border: 1px solid #e9ecef; margin: 0 auto; display: block;';
                                detailImagesContainer.appendChild(img);
                            });
                        }
                    })
                    .catch(err => console.error("상세조회 이미지 로드 오류:", err));
            }

            // JSP 내에 구현된 진짜 상세 뷰 섹션 노출
            showView('detail');
        });
    });

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

    if (editorForm) {
        editorForm.addEventListener('submit', function (event) {
            event.preventDefault();

            const formData = new FormData(editorForm);
            formData.delete('files');

            uploadedFiles.forEach(function (fileOrUrl) {
                if (fileOrUrl instanceof File) {
                    formData.append('files', fileOrUrl);
                } else {
                    formData.append('existingFiles', fileOrUrl);
                }
            });

            const xhr = new XMLHttpRequest();
            xhr.open('POST', editorForm.action, true);

            xhr.onload = function () {
                if (xhr.status === 200 || xhr.status === 302) {
                    window.location.href = window.location.origin + window.location.pathname;
                } else {
                    alert('서버 전송 중 오류가 발생했습니다.');
                }
            };

            xhr.send(formData);
        });
    }

    // ====================================================================
    // 브라우저 뒤로가기/앞으로가기 버튼 감지 및 연동
    // ====================================================================
    window.addEventListener('popstate', function (event) {
        const params = new URLSearchParams(window.location.search);
        const viewParam = params.get('view') || 'notice';
        showView(viewParam, false); // 히스토리를 다시 쌓지 않고 화면만 복원
    });

    // ====================================================================
    // 6. 초기 실행 제어 (Initial Setup & Layout Guard)
    // ====================================================================
    const initialParams = new URLSearchParams(window.location.search);
    if (!initialParams.has('view')) {
        showView('notice', false);
    }
})();