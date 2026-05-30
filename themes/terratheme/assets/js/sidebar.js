/* terranix — mobile sidebar drawer
   Opens / closes the left sidebar overlay, traps focus, closes on Esc.
   Also wires the mobile header hamburger to a slim mobile-nav drawer. */
(function () {
  function getSidebarEls() {
    return {
      sidebar: document.querySelector("[data-tx-sidebar]"),
      backdrop: document.querySelector("[data-tx-sidebar-backdrop]"),
      toggles: document.querySelectorAll("[data-tx-sidebar-toggle]"),
      closers: document.querySelectorAll("[data-tx-sidebar-close]"),
    };
  }
  function getMobileNavEls() {
    return {
      nav: document.querySelector("[data-tx-mobile-nav]"),
      openers: document.querySelectorAll("[data-tx-mobile-nav-toggle]"),
      closers: document.querySelectorAll("[data-tx-mobile-nav-close]"),
    };
  }

  var lastFocus = null;

  function trapFocus(container, ev) {
    if (ev.key !== "Tab") return;
    var f = container.querySelectorAll(
      'a[href], button:not([disabled]), input:not([disabled]), [tabindex]:not([tabindex="-1"])',
    );
    if (!f.length) return;
    var first = f[0],
      last = f[f.length - 1];
    if (ev.shiftKey && document.activeElement === first) {
      ev.preventDefault();
      last.focus();
    } else if (!ev.shiftKey && document.activeElement === last) {
      ev.preventDefault();
      first.focus();
    }
  }

  function openSidebar() {
    var els = getSidebarEls();
    if (!els.sidebar) return;
    lastFocus = document.activeElement;
    els.sidebar.setAttribute("data-open", "true");
    if (els.backdrop) els.backdrop.setAttribute("data-open", "true");
    document.body.style.overflow = "hidden";
    var firstLink = els.sidebar.querySelector("a, button");
    if (firstLink) firstLink.focus();
    document.addEventListener("keydown", sidebarKeydown);
  }
  function closeSidebar() {
    var els = getSidebarEls();
    if (!els.sidebar) return;
    els.sidebar.removeAttribute("data-open");
    if (els.backdrop) els.backdrop.removeAttribute("data-open");
    document.body.style.overflow = "";
    document.removeEventListener("keydown", sidebarKeydown);
    if (lastFocus && lastFocus.focus) lastFocus.focus();
  }
  function sidebarKeydown(ev) {
    if (ev.key === "Escape") closeSidebar();
    else {
      var els = getSidebarEls();
      if (els.sidebar) trapFocus(els.sidebar, ev);
    }
  }

  function openMobileNav() {
    var els = getMobileNavEls();
    if (!els.nav) return;
    lastFocus = document.activeElement;
    els.nav.setAttribute("data-open", "true");
    document.body.style.overflow = "hidden";
    var firstLink = els.nav.querySelector("a, button");
    if (firstLink) firstLink.focus();
    document.addEventListener("keydown", mobileNavKeydown);
  }
  function closeMobileNav() {
    var els = getMobileNavEls();
    if (!els.nav) return;
    els.nav.removeAttribute("data-open");
    document.body.style.overflow = "";
    document.removeEventListener("keydown", mobileNavKeydown);
    if (lastFocus && lastFocus.focus) lastFocus.focus();
  }
  function mobileNavKeydown(ev) {
    if (ev.key === "Escape") closeMobileNav();
    else {
      var els = getMobileNavEls();
      if (els.nav) trapFocus(els.nav, ev);
    }
  }

  function wire() {
    var s = getSidebarEls();
    s.toggles.forEach(function (b) {
      b.addEventListener("click", openSidebar);
    });
    s.closers.forEach(function (b) {
      b.addEventListener("click", closeSidebar);
    });
    if (s.backdrop) s.backdrop.addEventListener("click", closeSidebar);

    var m = getMobileNavEls();
    m.openers.forEach(function (b) {
      b.addEventListener("click", openMobileNav);
    });
    m.closers.forEach(function (b) {
      b.addEventListener("click", closeMobileNav);
    });
    if (m.nav)
      m.nav.addEventListener("click", function (ev) {
        if (ev.target === m.nav) closeMobileNav();
      });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", wire);
  } else {
    wire();
  }
})();
