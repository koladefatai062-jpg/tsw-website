-- ============================================================================
-- STORAGE SETUP — run this AFTER schema.sql, once, in the SQL Editor.
-- Creates a public "product-images" bucket so the admin dashboard can upload
-- real product photos instead of typing an image path.
-- ============================================================================

insert into storage.buckets (id, name, public)
values ('product-images', 'product-images', true)
on conflict (id) do nothing;

-- Anyone can view images (needed for the public storefront to display them)
create policy "product_images_public_read"
on storage.objects for select
using (bucket_id = 'product-images');

-- Only admins can upload / replace / delete product images
create policy "product_images_admin_insert"
on storage.objects for insert
with check (bucket_id = 'product-images' and is_admin());

create policy "product_images_admin_update"
on storage.objects for update
using (bucket_id = 'product-images' and is_admin());

create policy "product_images_admin_delete"
on storage.objects for delete
using (bucket_id = 'product-images' and is_admin());
