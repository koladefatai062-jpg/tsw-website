-- ============================================================================
-- SEED PRODUCTS — run this AFTER schema.sql, once, in the SQL Editor.
-- Populates the `products` table with everything currently hardcoded into
-- the site's HTML, so switching the storefront over to the database doesn't
-- lose your existing catalog. Edit/delete any of these from admin.html
-- afterward — this is just a starting point.
-- ============================================================================

insert into products (name, category, price, sale_price, image_url, colors, sizes, description, stock, is_active, is_featured, is_new) values
('Customized Bernie Cap', 'caps', 7999, null, 'img/1.jpg', array['Black','Pink','Brown'], array['One Size'], 'Customized Bernie cap.', 20, true, false, false),
('BIKER Shorts', 'bottoms', 5999, null, 'img/5.jpg', array['Black','Pink','Brown'], array['S','M','L'], 'Biker shorts.', 20, true, false, false),
('Zipper Hoodie', 'hoodies', 39999, null, 'img/8.jpg', array['Black','White','Blue'], array['S','M','L','XL'], 'Zipper hoodie.', 15, true, true, false),
('Hoodie', 'hoodies', 19000, null, 'img/9.jpg', array['Black'], array['S','M','L','XL'], 'Everyday hoodie, available in any colour on request.', 25, true, false, false),
('Stoned Kiddies Wear', 'kids', 19999, null, 'img/10.jpg', array['White'], array['Age 1-5'], 'Stoned kiddies wear.', 15, true, false, true),
('Hoodie & JOGGERS', 'sets', 29999, null, 'img/13.jpg', array['Black','White','Blue','Brown','Pink'], array['S','M','L','XL'], 'Hoodie and joggers set.', 12, true, true, false),
('Denim Trucker Jacket', 'outerwear', 29999, null, 'img/24.jpg', array['Black','Blue'], array['S','M','L','XL'], 'Denim trucker jacket.', 10, true, false, false),
('Track Cargo Set', 'sets', 34999, null, 'img/17.jpg', array['Black'], array['S','M','L','XL'], 'Track cargo set.', 10, true, false, false),
('Ribbed Crewneck Sweater', 'sweaters', 22500, null, 'img/11.jpg', array['Black','Grey'], array['S','M','L','XL'], 'Ribbed crewneck sweater.', 15, true, false, false),
('Graphic Print Tee', 'tshirts', 16000, null, 'img/12.jpg', array['White','Black'], array['S','M','L','XL'], 'Graphic print tee.', 25, true, false, false),
('Utility Cargo Pants', 'bottoms', 27000, null, 'img/16.jpg', array['Sand','Black'], array['S','M','L','XL'], 'Utility cargo pants.', 15, true, false, false),
('Bomber Jacket', 'outerwear', 32000, null, 'img/18.jpg', array['Black'], array['S','M','L','XL'], 'Bomber jacket.', 10, true, false, false),
('Kiddies Hoodie and pant troser', 'kids', 20000, null, 'img/new 1 (1).jpg', array['Black'], array['Age 1-5'], 'Kiddies hoodie and pant trouser set.', 15, true, true, true),
('Customized tube top and knicker', 'kids', 15000, null, 'img/new 1 (2).jpg', array['Black'], array['Age 1-5'], 'Customized tube top and knicker set.', 15, true, true, true),
('4 pocket troser and top (Age 1-5)', 'kids', 18000, null, 'img/new 1 (3).jpg', array['Black'], array['Age 1-5'], '4 pocket trouser and top set.', 15, true, true, true),
('Kids Denim Overall Set', 'kids', 24999, null, 'img/24.jpg', array['Black','Blue'], array['Age 1-5'], 'Kids denim overall set.', 12, true, true, true);
