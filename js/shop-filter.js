/**
 * SHOP FILTER — search / category / sort for the "More From The Shop" grid.
 * Only runs on pages that have #shopFilterBar (i.e. service.html). Works on
 * both the hand-coded cards and whatever js/store-products.js injects from
 * Supabase, since both carry the same .shop-product-item / data-* markup —
 * and re-applies automatically whenever the grid content changes (see the
 * "tsw:productsLoaded" event dispatched by store-products.js).
 */
(function ($) {
  "use strict";

  function applyFilters() {
    const $bar = $("#shopFilterBar");
    if (!$bar.length) return;

    const query = ($("#shopSearchInput").val() || "").trim().toLowerCase();
    const category = $("#shopCategoryFilter").val();
    const sort = $("#shopSortSelect").val();
    const $grid = $("#moreShopGrid");
    const $items = $grid.find(".shop-product-item");

    let visibleCount = 0;
    $items.each(function () {
      const $item = $(this);
      const name = $item.data("name") || "";
      const itemCategory = $item.data("category") || "";
      const matchesQuery = !query || String(name).includes(query);
      const matchesCategory = category === "all" || itemCategory === category;
      const show = matchesQuery && matchesCategory;
      $item.toggle(show);
      if (show) visibleCount++;
    });

    // Sorting: detach, sort the array, re-append in new order (only visible
    // items matter for order; hidden ones just move along with them)
    if (sort !== "default") {
      const sorted = $items.get().sort(function (a, b) {
        const $a = $(a), $b = $(b);
        if (sort === "price-asc") return Number($a.data("price")) - Number($b.data("price"));
        if (sort === "price-desc") return Number($b.data("price")) - Number($a.data("price"));
        if (sort === "name") return String($a.data("name")).localeCompare(String($b.data("name")));
        return 0;
      });
      $.each(sorted, function (i, el) {
        $grid.append(el);
      });
    }

    $("#shopResultsCount").text(
      visibleCount === 0
        ? "No products match — try clearing a filter."
        : `${visibleCount} product${visibleCount !== 1 ? "s" : ""} found`
    );
  }

  $(document).ready(function () {
    if (!$("#shopFilterBar").length) return;

    applyFilters();
    $(document).on("tsw:productsLoaded", applyFilters);

    $("#shopSearchInput").on("input", applyFilters);
    $("#shopCategoryFilter, #shopSortSelect").on("change", applyFilters);
  });
})(jQuery);
