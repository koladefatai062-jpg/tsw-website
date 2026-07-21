-- ============================================================================
-- LOVES / HEARTS FEATURE — run this AFTER schema.sql, once, in the SQL Editor.
-- Lets anyone (logged in or not) tap a heart on a product once per device.
-- Keyed by product *slug* (text) rather than the products.id UUID, so this
-- works identically whether a product only exists in the static HTML catalog
-- or is a real row in the `products` table added via admin.
-- ============================================================================

create table if not exists product_loves (
  id uuid primary key default gen_random_uuid(),
  product_slug text not null,
  device_id text not null,
  created_at timestamptz not null default now(),
  unique (product_slug, device_id)
);

alter table product_loves enable row level security;

-- Anyone can see aggregate love activity (needed for the RPC below to read counts)
create policy "product_loves_select_all" on product_loves
  for select using (true);

-- Inserts/deletes only happen through the toggle_product_love() function
-- below (security definer), not directly — no public write policy needed.

-- ---------- Toggle function ----------
-- Called from the browser as: supabase.rpc('toggle_product_love', { p_slug, p_device })
-- Returns the new loved state + updated count in one round trip.
create or replace function toggle_product_love(p_slug text, p_device text)
returns table(loved boolean, love_count bigint)
language plpgsql
security definer
as $$
declare
  existing_id uuid;
begin
  select id into existing_id from product_loves
    where product_slug = p_slug and device_id = p_device;

  if existing_id is not null then
    delete from product_loves where id = existing_id;
  else
    insert into product_loves (product_slug, device_id) values (p_slug, p_device);
  end if;

  return query
    select
      existing_id is null as loved,
      (select count(*) from product_loves where product_slug = p_slug) as love_count;
end;
$$;

grant execute on function toggle_product_love(text, text) to anon, authenticated;

-- ---------- Read-only helper: get current love count + whether this device loved it ----------
create or replace function get_product_love(p_slug text, p_device text)
returns table(loved boolean, love_count bigint)
language sql
stable
as $$
  select
    exists(select 1 from product_loves where product_slug = p_slug and device_id = p_device) as loved,
    (select count(*) from product_loves where product_slug = p_slug) as love_count;
$$;

grant execute on function get_product_love(text, text) to anon, authenticated;
