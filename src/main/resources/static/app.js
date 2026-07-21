(function () {
    const menuButton = document.querySelector('[data-menu-toggle]');
    const menu = document.querySelector('[data-site-nav]');

    if (!menuButton || !menu) {
        return;
    }

    menuButton.addEventListener('click', function () {
        const isOpen = menu.classList.toggle('is-open');
        menuButton.setAttribute('aria-expanded', String(isOpen));
        document.body.classList.toggle('is-menu-open', isOpen);
    });

    menu.addEventListener('click', function (event) {
        if (event.target.closest('a')) {
            menu.classList.remove('is-open');
            menuButton.setAttribute('aria-expanded', 'false');
            document.body.classList.remove('is-menu-open');
        }
    });
})();
