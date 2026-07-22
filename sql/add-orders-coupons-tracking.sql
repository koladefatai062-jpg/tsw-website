-- Run this in Supabase SQL Editor to create coupons, orders, and tracking

-- COUPONS TABLE
CREATE TABLE IF NOT EXISTS coupons (
  code text PRIMARY KEY,
  type text NOT NULL CHECK (type IN ('percent', 'flat')),
  value numeric NOT NULL,
  is_active boolean NOT NULL DEFAULT true,
  expires_at timestamptz
);
ALTER TABLE coupons ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "coupons_select_active" ON coupons;
DROP POLICY IF EXISTS "coupons_admin_write" ON coupons;
DROP POLICY IF EXISTS "coupons_admin_update" ON coupons;
DROP POLICY IF EXISTS "coupons_admin_delete" ON coupons;
CREATE POLICY "coupons_select_active" ON coupons FOR SELECT USING (is_active = true OR is_admin());
CREATE POLICY "coupons_admin_write" ON coupons FOR INSERT WITH CHECK (is_admin());
CREATE POLICY "coupons_admin_update" ON coupons FOR UPDATE USING (is_admin());
CREATE POLICY "coupons_admin_delete" ON coupons FOR DELETE USING (is_admin());

-- ORDERS TABLE (with tracking_id)
CREATE TABLE IF NOT EXISTS orders (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_number text UNIQUE NOT NULL,
  tracking_id text UNIQUE NOT NULL,
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
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "orders_select_own_or_admin" ON orders;
DROP POLICY IF EXISTS "orders_insert_own" ON orders;
DROP POLICY IF EXISTS "orders_admin_update" ON orders;
CREATE POLICY "orders_select_own_or_admin" ON orders FOR SELECT USING (auth.uid() = user_id OR is_admin());
CREATE POLICY "orders_insert_own" ON orders FOR INSERT WITH CHECK (auth.uid() = user_id OR user_id IS NULL);
CREATE POLICY "orders_admin_update" ON orders FOR UPDATE USING (is_admin());
-- Allow anyone to look up an order by tracking_id (for the tracking page)
DROP POLICY IF EXISTS "orders_track_by_id" ON orders;
CREATE POLICY "orders_track_by_id" ON orders FOR SELECT USING (true);

-- ORDER ITEMS TABLE
CREATE TABLE IF NOT EXISTS order_items (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  order_id uuid NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id uuid REFERENCES products(id) ON DELETE SET NULL,
  product_name text NOT NULL,
  price numeric NOT NULL,
  qty int NOT NULL,
  size text,
  color text
);
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
DROP POLICY IF EXISTS "order_items_select" ON order_items;
DROP POLICY IF EXISTS "order_items_insert" ON order_items;
CREATE POLICY "order_items_select" ON order_items FOR SELECT USING (
  EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id
          AND (orders.user_id = auth.uid() OR is_admin()))
);
CREATE POLICY "order_items_insert" ON order_items FOR INSERT WITH CHECK (
  EXISTS (SELECT 1 FROM orders WHERE orders.id = order_items.order_id
          AND (orders.user_id = auth.uid() OR orders.user_id IS NULL))
);
-- Allow tracking page to see order items
DROP POLICY IF EXISTS "order_items_track" ON order_items;
CREATE POLICY "order_items_track" ON order_items FOR SELECT USING (true);
