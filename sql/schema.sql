-- ============================================================================
-- TSW x STAYWOKE — SUPABASE SCHEMA
-- Run this once in: Supabase Dashboard → SQL Editor → New Query → Run
-- ============================================================================

-- ---------- PROFILES (extends Supabase's built-in auth.users) ----------
create table if not exists profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  email text,
  full_name text,
  phone text,
  address text,
  is_admin boolean not null default false,
  created_at timestamptz not null default now()
);

-- Auto-create a profile row whenever someone signs up
create or replace function handle_new_user()
returns trigger as $$
begin
  insert into profiles (id, email, full_name)
  values (new.id, new.email, new.raw_user_meta_data ->> 'full_name');
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure handle_new_user();

-- Helper: is the currently logged-in user an admin?
create or replace function is_admin()
returns boolean as $$
  select coalesce((select is_admin from profiles where id = auth.uid()), false);
$$ language sql stable security definer;

-- ---------- PRODUCTS ----------
create table if not exists products (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  category text,
  price numeric not null,
  sale_price numeric,
  image_url text,
  colors text[] default '{}',
  sizes text[] default '{}',
  description text,
  stock int not null default 0,
  is_active boolean not null default true,
  is_featured boolean not null default false,
  is_new boolean not null default false,
  created_at timestamptz not null default now()
);

-- ---------- COUPONS ----------
create table if not exists coupons (
  code text primary key,
  type text not null check (type in ('percent', 'flat')),
  value numeric not null,
  is_active boolean not null default true,
  expires_at timestamptz
);

-- ---------- ORDERS ----------
create table if not exists orders (
  id uuid primary key default gen_random_uuid(),
  order_number text unique not null,
  user_id uuid references auth.users(id) on delete set null,
  customer_name text not null,
  customer_phone text not null,
  customer_address text not null,
  subtotal numeric not null,
  discount numeric not null default 0,
  delivery_fee numeric not null default 0,
  total numeric not null,
  coupon_code text references coupons(code),
  status text not null default 'Pending'
    check (status in ('Pending','Confirmed','Processing','Shipped','Delivered','Cancelled')),
  created_at timestamptz not null default now()
);

-- ---------- ORDER ITEMS ----------
create table if not exists order_items (
  id uuid primary key default gen_random_uuid(),
  order_id uuid not null references orders(id) on delete cascade,
  product_id uuid references products(id) on delete set null,
  product_name text not null,
  price numeric not null,
  qty int not null,
  size text,
  color text
);

-- ============================================================================
-- ROW LEVEL SECURITY
-- ============================================================================
alter table profiles enable row level security;
alter table products enable row level security;
alter table coupons enable row level security;
alter table orders enable row level security;
alter table order_items enable row level security;

-- Profiles: users see/edit their own row; admins see everyone
create policy "profiles_select_own_or_admin" on profiles
  for select using (auth.uid() = id or is_admin());
create policy "profiles_update_own" on profiles
  for update using (auth.uid() = id);

-- Products: anyone (including logged-out visitors) can view active products;
-- only admins can create/edit/delete
create policy "products_select_active" on products
  for select using (is_active = true or is_admin());
create policy "products_admin_write" on products
  for insert with check (is_admin());
create policy "products_admin_update" on products
  for update using (is_admin());
create policy "products_admin_delete" on products
  for delete using (is_admin());

-- Coupons: anyone can check an active coupon code at checkout; only admins manage
create policy "coupons_select_active" on coupons
  for select using (is_active = true or is_admin());
create policy "coupons_admin_write" on coupons
  for insert with check (is_admin());
create policy "coupons_admin_update" on coupons
  for update using (is_admin());
create policy "coupons_admin_delete" on coupons
  for delete using (is_admin());

-- Orders: customers see only their own orders; admins see & manage all;
-- anyone signed in can create an order for themselves
create policy "orders_select_own_or_admin" on orders
  for select using (auth.uid() = user_id or is_admin());
create policy "orders_insert_own" on orders
  for insert with check (auth.uid() = user_id or user_id is null);
create policy "orders_admin_update" on orders
  for update using (is_admin());

-- Order items: visible if you can see the parent order
create policy "order_items_select" on order_items
  for select using (
    exists (select 1 from orders where orders.id = order_items.order_id
            and (orders.user_id = auth.uid() or is_admin()))
  );
create policy "order_items_insert" on order_items
  for insert with check (
    exists (select 1 from orders where orders.id = order_items.order_id
            and (orders.user_id = auth.uid() or orders.user_id is null))
  );

-- ============================================================================
-- MAKE YOURSELF AN ADMIN
-- After you sign up once through register.html, run this (with your email):
--
--   update profiles set is_admin = true
--   where id = (select id from auth.users where email = 'you@example.com');
--
-- ============================================================================
