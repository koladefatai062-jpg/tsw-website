/**
 * THEME TOGGLE — dark/light mode, persisted in localStorage.
 * The actual theme is already applied before paint by a tiny inline script
 * in each page's <head> (avoids a flash of the wrong theme). This file just
 * wires up the toggle button and keeps its icon in sync.
 */
(function ($) {
  "use strict";

  const KEY = "tsw_theme";

  function getTheme() {
    try {
      return localStorage.getItem(KEY) || "light";
    } catch (e) {
      return "light";
    }
  }

  function setTheme(theme) {
    document.documentElement.setAttribute("data-theme", theme);
    try {
      localStorage.setItem(KEY, theme);
    } catch (e) {}
    updateIcon(theme);
  }

  function updateIcon(theme) {
    $("[data-theme-toggle]").html(theme === "dark" ? '<i class="fa fa-sun"></i>' : '<i class="fa fa-moon"></i>');
  }

  $(document).ready(function () {
    updateIcon(getTheme());
    $("[data-theme-toggle]").on("click", function () {
      setTheme(getTheme() === "dark" ? "light" : "dark");
    });
  });
})(jQuery);
