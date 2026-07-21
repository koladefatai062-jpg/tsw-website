/**
 * SITE NAV — mobile menu open/close + search bar toggle.
 * (Cart drawer open/close is handled by Bootstrap's offcanvas JS via
 * data-bs-toggle, already wired in the header markup.)
 */
(function ($) {
  "use strict";
  $(document).ready(function () {
    $("[data-nav-toggle]").on("click", function () {
      $("[data-mobile-nav]").addClass("is-open");
    });
    $("[data-nav-close]").on("click", function () {
      $("[data-mobile-nav]").removeClass("is-open");
    });
    $("[data-mobile-nav] a").on("click", function () {
      $("[data-mobile-nav]").removeClass("is-open");
    });

    // Search bar toggle
    $("[data-nav-search]").on("click", function () {
      var $wrap = $(this).closest(".nav-search");
      var $input = $wrap.find("[data-nav-search-input]");
      $wrap.toggleClass("is-open");
      if ($wrap.hasClass("is-open")) {
        $input.focus();
      }
    });

    // Close search when clicking outside
    $(document).on("click", function (e) {
      if (!$(e.target).closest(".nav-search").length) {
        $(".nav-search").removeClass("is-open");
      }
    });

    // Search input — filter product cards on the page
    $("[data-nav-search-input]").on("input", function () {
      var q = $(this).val().toLowerCase().trim();
      var $cards = $(".product-card");
      if (!$cards.length) return;
      if (!q) {
        $cards.show();
        return;
      }
      $cards.each(function () {
        var text = ($(this).find(".product-card__name").text() + " " + $(this).find(".product-card__desc").text()).toLowerCase();
        $(this).toggle(text.indexOf(q) !== -1);
      });
    });
  });
})(jQuery);
