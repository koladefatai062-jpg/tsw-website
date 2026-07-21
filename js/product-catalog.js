/**
 * STATIC PRODUCT CATALOG
 * ----------------------
 * Mirrors sql/seed-products.sql — gives every hand-coded product a stable ID
 * so product.html, filtering, and links work consistently whether or not
 * Supabase is configured yet. If a product with this ID also exists in the
 * Supabase `products` table, product.html prefers the live database version
 * (so admin edits win); this is just the fallback/offline source of truth.
 */
const STATIC_PRODUCTS = [
  { id: "customized-bernie-cap", name: "Customized Bernie Cap", category: "caps", price: 7999, image: "img/1.jpg", colors: ["Black", "Pink", "Brown"], sizes: ["One Size"], description: "Customized Bernie cap." },
  { id: "biker-shorts", name: "BIKER Shorts", category: "bottoms", price: 5999, image: "img/5.jpg", colors: ["Black", "Pink", "Brown"], sizes: ["S", "M", "L"], description: "Biker shorts." },
  { id: "zipper-hoodie", name: "Zipper Hoodie", category: "hoodies", price: 39999, image: "img/8.jpg", colors: ["Black", "White", "Blue"], sizes: ["S", "M", "L", "XL"], description: "Zipper hoodie." },
  { id: "hoodie", name: "Hoodie", category: "hoodies", price: 19000, image: "img/9.jpg", colors: ["Black"], sizes: ["S", "M", "L", "XL"], description: "Everyday hoodie, available in any colour on request." },
  { id: "stoned-kiddies-wear", name: "Stoned Kiddies Wear", category: "kids", price: 19999, image: "img/10.jpg", colors: ["White"], sizes: ["Age 1-5"], description: "Stoned kiddies wear." },
  { id: "hoodie-joggers", name: "Hoodie & JOGGERS", category: "sets", price: 29999, image: "img/13.jpg", colors: ["Black", "White", "Blue", "Brown", "Pink"], sizes: ["S", "M", "L", "XL"], description: "Hoodie and joggers set." },
  { id: "denim-trucker-jacket", name: "Denim Trucker Jacket", category: "outerwear", price: 29999, image: "img/24.jpg", colors: ["Black", "Blue"], sizes: ["S", "M", "L", "XL"], description: "Denim trucker jacket." },
  { id: "track-cargo-set", name: "Track Cargo Set", category: "sets", price: 34999, image: "img/17.jpg", colors: ["Black"], sizes: ["S", "M", "L", "XL"], description: "Track cargo set." },
  { id: "ribbed-crewneck-sweater", name: "Ribbed Crewneck Sweater", category: "sweaters", price: 22500, image: "img/11.jpg", colors: ["Black", "Grey"], sizes: ["S", "M", "L", "XL"], description: "Ribbed crewneck sweater." },
  { id: "graphic-print-tee", name: "Graphic Print Tee", category: "tshirts", price: 16000, image: "img/12.jpg", colors: ["White", "Black"], sizes: ["S", "M", "L", "XL"], description: "Graphic print tee." },
  { id: "utility-cargo-pants", name: "Utility Cargo Pants", category: "bottoms", price: 27000, image: "img/16.jpg", colors: ["Sand", "Black"], sizes: ["S", "M", "L", "XL"], description: "Utility cargo pants." },
  { id: "bomber-jacket", name: "Bomber Jacket", category: "outerwear", price: 32000, image: "img/18.jpg", colors: ["Black"], sizes: ["S", "M", "L", "XL"], description: "Bomber jacket." },
  { id: "kiddies-hoodie-pant-troser", name: "Kiddies Hoodie and pant troser", category: "kids", price: 20000, image: "img/new 1 (1).jpg", colors: ["Black"], sizes: ["Age 1-5"], description: "Kiddies hoodie and pant trouser set." },
  { id: "tube-top-knicker", name: "Customized tube top and knicker", category: "kids", price: 15000, image: "img/new 1 (2).jpg", colors: ["Black"], sizes: ["Age 1-5"], description: "Customized tube top and knicker set." },
  { id: "four-pocket-troser-top", name: "4 pocket troser and top (Age 1-5)", category: "kids", price: 18000, image: "img/new 1 (3).jpg", colors: ["Black"], sizes: ["Age 1-5"], description: "4 pocket trouser and top set." },
  { id: "kids-denim-overall-set", name: "Kids Denim Overall Set", category: "kids", price: 24999, image: "img/24.jpg", colors: ["Black", "Blue"], sizes: ["Age 1-5"], description: "Kids denim overall set." }
];

function getStaticProductById(id) {
  return STATIC_PRODUCTS.find((p) => p.id === id);
}
