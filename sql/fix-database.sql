-- ============================================================================
-- TSW x STAYWOKE — FULL DATABASE FIX
-- Go to: https://supabase.com/dashboard → your project → SQL Editor → New Query
-- Paste EVERYTHING below and click "Run"
-- ============================================================================

-- 1. Drop old tables and policies (safe — recreates below)
DROP POLICY IF EXISTS "products_select_active" ON products;
DROP POLICY IF EXISTS "products_admin_write" ON products;
DROP POLICY IF EXISTS "products_admin_update" ON products;
DROP POLICY IF EXISTS "products_admin_delete" ON products;
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS coupons CASCADE;
DROP TABLE IF EXISTS products CASCADE;

-- 2. PRODUCTS (full schema)
CREATE TABLE products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name text NOT NULL,
  category text,
  price numeric NOT NULL,
  sale_price numeric,
  image_url text,
  colors text[] DEFAULT '{}',
  sizes text[] DEFAULT '{}',
  description text,
  stock int NOT NULL DEFAULT 0,
  is_active boolean NOT NULL DEFAULT true,
  is_featured boolean NOT NULL DEFAULT false,
  is_new boolean NOT NULL DEFAULT false,
  created_at timestamptz NOT NULL DEFAULT now()
);

-- 3. COUPONS
CREATE TABLE coupons (
  code text PRIMARY KEY,
  type text NOT NULL CHECK (type IN ('percent', 'flat')),
  value numeric NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  expires_at timestamptz
);

-- 4. ORDERS
CREATE TABLE orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number text UNIQUE NOT NULL,
  user_id uuid REFERENCES auth.users(id) ON DELETE SET NULL,
  customer_name text NOT NULL,
  customer_phone text NOT NULL,
  customer_address text NOT NULL,
  subtotal numeric NOT NULL,
  discount numeric NOT NULL DEFAULT 0,
  delivery_fee numeric NOT NULL DEFAULT 0,
  total numeric NOT NULL,
  coupon_code text REFERENCES coupons(code),
  status text NOT NULL DEFAULT 'Pending'
    CHECK (status IN ('Pending','Confirmed','Processing','Shipped','Delivered','Cancelled')),
  created_at timestamptz NOT NULL DEFAULT now()
);

-- 5. ORDER ITEMS
CREATE TABLE order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id uuid REFERENCES products(id) ON DELETE SET NULL,
  product_name text NOT NULL,
  price numeric NOT NULL,
  qty int NOT NULL,
  size text,
  color text
);

-- 6. ROW LEVEL SECURITY
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

CREATE POLICY "products_select_active" ON products
  FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "products_admin_write" ON products
  FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "products_admin_update" ON products
  FOR UPDATE USING (is_admin());
CREATE POLICY "products_admin_delete" ON products
  FOR DELETE USING (is_admin());

CREATE POLICY "coupons_select_active" ON coupons
  FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "coupons_admin_write" ON coupons
  FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "coupons_admin_update" ON coupons
  FOR UPDATE USING (is_admin());
CREATE POLICY "coupons_admin_delete" ON coupons
  FOR DELETE USING (is_admin());

CREATE POLICY "orders_select_own_or_admin" ON orders
  FOR SELECT USING (auth.uid() = user_id OR is_admin());
CREATE POLICY "orders_insert_own" ON orders
  FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);
CREATE POLICY "orders_admin_update" ON orders
  FOR UPDATE USING (is_admin());

CREATE POLICY "order_items_select" ON order_items
  FOR SELECT USING (
    EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id
            AND (orders.user_id = auth.uid() OR is_admin()))
  );
CREATE POLICY "order_items_insert" ON order_items
  FOR INSERT WITH CHECK (
    EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id
            AND (orders.user_id = auth.uid() OR orders.user_id IS NULL))
  );

-- 7. SEED PRODUCTS (16 items)
INSERT INTO products (name, category, price, image_url, description, stock, is_active, is_featured, is_new) VALUES
('Shadow Hoodie', 'hoodies', 25000, 'img/1.jpg', 'Oversized black hoodie with embossed TSW logo. Premium heavyweight cotton.', 15, true, true, true),
('Midnight Graphic Tee', 'tees', 8500, 'img/2.jpg', 'Relaxed-fit tee with midnight graphic print. 100% cotton.', 30, true, false, true),
('Stealth Cargo Pants', 'pants', 18000, 'img/3.jpg', 'Tactical cargo pants with multiple pockets. Water-resistant finish.', 20, true, true, false),
('Urban Windbreaker', 'jackets', 22000, 'img/4.jpg', 'Lightweight windbreaker with reflective details. Perfect for layering.', 12, true, false, true),
('Classic TSW Cap', 'accessories', 5500, 'img/5.jpg', 'Structured baseball cap with embroidered logo. Adjustable strap.', 40, true, false, false),
('Premium Joggers', 'pants', 15000, 'img/6.jpg', 'Tapered joggers with side pockets. French terry cotton.', 25, true, true, false),
('Oversized Denim Jacket', 'jackets', 28000, 'img/7.jpg', 'Raw denim jacket with distressed details. Limited edition.', 8, true, true, true),
('Streetwear Bucket Hat', 'accessories', 4500, 'img/8.jpg', 'Reversible bucket hat with tonal branding.', 35, true, false, true),
('Logo Puffer Vest', 'jackets', 32000, 'img/9.jpg', 'Insulated puffer vest with detachable hood. Water-repellent.', 10, true, true, false),
('Textured Knit Sweater', 'tees', 12000, 'img/10.jpg', 'Ribbed knit sweater with subtle logo. Relaxed fit.', 18, true, false, false),
('Relaxed Fit Jeans', 'pants', 16000, 'img/11.jpg', 'Wide-leg jeans with vintage wash. 12oz denim.', 22, true, false, true),
('Tech Fleece Hoodie', 'hoodies', 22000, 'img/12.jpg', 'Slim-fit tech fleece with zip pockets. Lightweight warmth.', 14, true, true, true),
('Canvas High-Tops', 'accessories', 19000, 'img/13.jpg', 'Premium canvas sneakers with vulcanized sole. TSW branding.', 20, true, false, false),
('Layered Chain Necklace', 'accessories', 7500, 'img/14.jpg', 'Stainless steel layered chain set. Hypoallergenic.', 30, true, false, true),
('Graphic Pullover', 'hoodies', 17000, 'img/15.jpg', 'Heavyweight pullover with all-over print. Brushed interior.', 16, true, false, true),
('Utility Backpack', 'accessories', 14000, 'img/16.jpg', 'Water-resistant backpack with padded laptop sleeve.', 25, true, true, false);

-- 8. MAKE YOURSELF ADMIN
-- Replace YOUR_EMAIL with the email you used to register:
--
-- UPDATE profiles SET is_admin = true
-- WHERE id = (SELECT id FROM auth.users WHERE email = 'YOUR_EMAIL');
