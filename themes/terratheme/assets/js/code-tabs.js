/* terranix — code tab switcher
   Wires <button data-tx-tab="X"> + <div data-tx-tab-panel="X"> pairs inside
   the same .tx-code-tabs container. */
(function () {
  function wire() {
    var containers = document.querySelectorAll("[data-tx-code-tabs]");
    containers.forEach(function (root) {
      var tabs = root.querySelectorAll("[data-tx-tab]");
      var panels = root.querySelectorAll("[data-tx-tab-panel]");
      tabs.forEach(function (tab) {
        tab.addEventListener("click", function () {
          var name = tab.getAttribute("data-tx-tab");
          tabs.forEach(function (t) {
            t.setAttribute(
              "data-active",
              t.getAttribute("data-tx-tab") === name ? "true" : "false",
            );
          });
          panels.forEach(function (p) {
            p.setAttribute(
              "data-active",
              p.getAttribute("data-tx-tab-panel") === name ? "true" : "false",
            );
          });
        });
      });
    });
  }
  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", wire);
  } else {
    wire();
  }
})();
