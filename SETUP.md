# TSW x STAYWOKE — Going Live with Supabase

Everything below is already wired into the site. It switches on automatically
once you add your Supabase credentials — nothing breaks if you haven't yet.

## Setup order (run once)

1. **Add your keys** — open `js/supabase-config.js`, fill in:
   ```js
   const SUPABASE_URL = "https://xxxx.supabase.co";
   const SUPABASE_ANON_KEY = "eyJ...";
   ```
   (Supabase Dashboard → Project Settings → API)

2. **Run the schema** — Supabase Dashboard → SQL Editor → paste all of `sql/schema.sql` → Run.
   Creates `profiles`, `products`, `orders`, `order_items`, `coupons` with Row Level Security.

3. **Seed your existing catalog** — paste `sql/seed-products.sql` → Run.
   This inserts the 16 products already hardcoded into your HTML, so switching
   to the database doesn't lose anything you already had.

4. **Set up image storage** — paste `sql/storage-setup.sql` → Run.
   Creates a public `product-images` bucket so the admin dashboard can upload
   real photos instead of typing a path.

5. **Enable the loves/hearts feature** — paste `sql/loves-setup.sql` → Run.
   Creates the `product_loves` table and RPC functions so the heart button
   on product cards works across all devices.

6. **Create your admin account**:
   - Go to `register.html` on the live site, sign up normally.
   - Back in SQL Editor, run (with your real email):
     ```sql
     update profiles set is_admin = true
     where id = (select id from auth.users where email = 'you@example.com');
     ```
   - Log in, then go directly to `admin.html` (no public nav link to it, on purpose).

## What's now connected

- **Shop (`service.html`) and Our Collection (`team.html`)** pull live from the
  `products` table. Add, edit, hide, or delete a product in `admin.html` →
  Products tab, and it updates on both pages immediately (no redeploy needed).
  The "New Outfits" showcase rows on Home/Shop stay hand-coded — that's a
  curated section, separate from the full catalog.
- **Coupons** — the cart's discount code box now checks the real `coupons`
  table. Create/deactivate codes in `admin.html` → Coupons tab.
- **Orders** — every WhatsApp checkout also saves to the `orders` table
  (customer info, items, subtotal, discount, total, coupon used). Update
  status from `admin.html` → Orders tab.
- **Product photos** — in the admin Products form, either paste an image path
  (`img/1.jpg`) or upload a real photo file; uploads go to the `product-images`
  storage bucket and the public URL is saved automatically.
- **Customers** — anyone who registers shows up in `admin.html` → Customers tab.

## Still manual / not wired

- Reviews, wishlist, and an order-tracking-by-ID page for customers.
- Real payment gateways (Paystack/Flutterwave) — WhatsApp is still the final
  checkout step either way.
- The "New Outfits" hero rows on Home/Shop are intentionally static — ask if
  you want those pulled from the database too.
