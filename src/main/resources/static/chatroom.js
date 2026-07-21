(function () {
    const form = document.querySelector('[data-message-form]');
    const input = document.querySelector('[data-message-input]');
    const messageList = document.querySelector('[data-message-list]');
    const roomsPanel = document.querySelector('[data-rooms-panel]');
    const roomsToggle = document.querySelector('[data-rooms-toggle]');
    const roomButtons = document.querySelectorAll('[data-room-item]');
    const roomTitle = document.querySelector('[data-room-title]');

    function formatTime(date) {
        return new Intl.DateTimeFormat('ko-KR', {
            hour: '2-digit',
            minute: '2-digit',
            hour12: false
        }).format(date);
    }

    if (form && input && messageList) {
        form.addEventListener('submit', function (event) {
            event.preventDefault();
            const text = input.value.trim();

            if (!text) {
                input.focus();
                return;
            }

            const message = document.createElement('div');
            message.className = 'message message--mine';

            const time = document.createElement('time');
            time.className = 'message__time';
            time.dateTime = new Date().toISOString();
            time.textContent = formatTime(new Date());

            const content = document.createElement('div');
            content.className = 'message__content';

            const bubble = document.createElement('div');
            bubble.className = 'message__bubble';
            bubble.textContent = text;

            content.appendChild(bubble);
            message.append(time, content);
            messageList.appendChild(message);

            input.value = '';
            input.style.height = '';
            messageList.scrollTop = messageList.scrollHeight;
        });

        input.addEventListener('keydown', function (event) {
            if (event.key === 'Enter' && !event.shiftKey) {
                event.preventDefault();
                form.requestSubmit();
            }
        });

        input.addEventListener('input', function () {
            input.style.height = 'auto';
            input.style.height = Math.min(input.scrollHeight, 110) + 'px';
        });
    }

    if (roomsToggle && roomsPanel) {
        roomsToggle.addEventListener('click', function () {
            const isOpen = roomsPanel.classList.toggle('is-open');
            roomsToggle.setAttribute('aria-expanded', String(isOpen));
        });
    }

    roomButtons.forEach(function (button) {
        button.addEventListener('click', function () {
            roomButtons.forEach(function (item) {
                item.classList.remove('is-active');
            });
            button.classList.add('is-active');
            if (roomTitle) {
                roomTitle.textContent = button.dataset.roomName;
            }
            if (roomsPanel) {
                roomsPanel.classList.remove('is-open');
            }
        });
    });
})();
