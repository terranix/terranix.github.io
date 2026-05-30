/* terranix — theme toggle (light/dark)
   Click handler that flips data-theme on <html> and persists to localStorage. */
(function () {
  function applyTheme(theme) {
    var root = document.documentElement;
    if (theme === "dark") root.setAttribute("data-theme", "dark");
    else root.removeAttribute("data-theme");
    try {
      localStorage.setItem("terranix-theme", theme);
    } catch (e) {}
  }

  function currentTheme() {
    return document.documentElement.getAttribute("data-theme") === "dark"
      ? "dark"
      : "light";
  }

  function wire() {
    var btns = document.querySelectorAll("[data-tx-theme-toggle]");
    btns.forEach(function (btn) {
      if (btn.__txWired) return;
      btn.__txWired = true;
      btn.addEventListener("click", function () {
        var next = currentTheme() === "dark" ? "light" : "dark";
        applyTheme(next);
        btn.setAttribute(
          "aria-label",
          next === "dark" ? "Switch to light mode" : "Switch to dark mode",
        );
      });
    });
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", wire);
  } else {
    wire();
  }
})();
