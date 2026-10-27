
-- NAIKIN PATCH 009 - SQL LENGKAP REVISI
-- Jalankan setelah migration 006.
-- Tidak menghapus produk, akun, pesanan, atau deposit lama.

BEGIN;

-- =====================================================
-- 1. PEMBELIAN BIASA: DEPOSIT PERTAMA MINIMAL RP10.000
-- =====================================================

CREATE OR REPLACE FUNCTION public.naikin_place_order(
  p_product_id text,
  p_quantity integer,
  p_target text,
  p_request_key uuid
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  u uuid := auth.uid();
  p public.naikin_products%rowtype;
  v_total numeric;
  v_id uuid;
BEGIN
  IF u IS NULL THEN
    RAISE EXCEPTION 'Silakan masuk';
  END IF;

  SELECT id INTO v_id
  FROM public.naikin_orders
  WHERE user_id = u AND request_key = p_request_key;

  IF FOUND THEN
    RETURN v_id;
  END IF;

  PERFORM pg_advisory_xact_lock(hashtext(u::text));

  SELECT * INTO p
  FROM public.naikin_products
  WHERE id = p_product_id AND active = true;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Produk tidak tersedia';
  END IF;

  IF p_quantity < 1
     OR (p.qty_type = 'fixed' AND p_quantity <> 1)
     OR (p.qty_type = 'unit' AND (
       p_quantity < p.min_qty
       OR p_quantity > p.max_qty
       OR mod(p_quantity - p.min_qty, p.step_qty) <> 0
     ))
  THEN
    RAISE EXCEPTION 'Jumlah tidak valid';
  END IF;

  IF length(trim(p_target)) < 2
     OR length(p_target) > 500
  THEN
    RAISE EXCEPTION 'Tujuan pesanan tidak valid';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM public.naikin_deposits
    WHERE user_id = u
      AND status = 'paid'
      AND amount >= 10000
  ) THEN
    RAISE EXCEPTION
      'Deposit pertama minimal Rp10.000 harus terverifikasi sebelum memesan';
  END IF;

  v_total := CASE
    WHEN p.qty_type = 'fixed' THEN p.price
    ELSE round(p.price_per_unit * p_quantity, 0)
  END;

  IF v_total <= 0 THEN
    RAISE EXCEPTION 'Harga tidak valid';
  END IF;

  IF (
    SELECT coalesce(sum(amount), 0)
    FROM public.naikin_ledger
    WHERE user_id = u
  ) < v_total THEN
    RAISE EXCEPTION 'Saldo tidak mencukupi';
  END IF;

  INSERT INTO public.naikin_orders (
    user_id, product_id, quantity,
    target, total, request_key
  )
  VALUES (
    u, p.id, p_quantity,
    trim(p_target), v_total, p_request_key
  )
  RETURNING id INTO v_id;

  INSERT INTO public.naikin_ledger (
    user_id, amount, reference, description
  )
  VALUES (
    u, -v_total, 'order:' || v_id,
    'Pembelian ' || p.name
  );

  RETURN v_id;
END;
$$;

-- =====================================================
-- 2. PEMBELIAN CUSTOM COMMENTS
-- =====================================================

CREATE OR REPLACE FUNCTION public.naikin_place_order_with_comments(
  p_product_id text,
  p_quantity integer,
  p_target text,
  p_request_key uuid,
  p_comments text[]
)
RETURNS uuid
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  u uuid := auth.uid();
  p public.naikin_products%rowtype;
  v_total numeric;
  v_id uuid;
BEGIN
  IF u IS NULL THEN
    RAISE EXCEPTION 'Silakan masuk';
  END IF;

  SELECT id INTO v_id
  FROM public.naikin_orders
  WHERE user_id = u AND request_key = p_request_key;

  IF FOUND THEN
    RETURN v_id;
  END IF;

  PERFORM pg_advisory_xact_lock(hashtext(u::text));

  SELECT * INTO p
  FROM public.naikin_products
  WHERE id = p_product_id AND active = true;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'Produk tidak tersedia';
  END IF;

  IF p_quantity < 1
     OR (p.qty_type = 'fixed' AND p_quantity <> 1)
     OR (p.qty_type = 'unit' AND (
       p_quantity < p.min_qty
       OR p_quantity > p.max_qty
       OR mod(p_quantity - p.min_qty, p.step_qty) <> 0
     ))
  THEN
    RAISE EXCEPTION 'Jumlah tidak valid';
  END IF;

  IF length(trim(p_target)) < 2
     OR length(p_target) > 500
  THEN
    RAISE EXCEPTION 'Tujuan pesanan tidak valid';
  END IF;

  IF NOT p.custom_comments_enabled THEN
    RAISE EXCEPTION
      'Produk tidak menerima komentar custom';
  END IF;

  IF p_comments IS NULL
     OR cardinality(p_comments) <> p_quantity
     OR EXISTS (
       SELECT 1
       FROM unnest(p_comments) AS c
       WHERE length(trim(c)) < 1
          OR length(c) > 500
     )
  THEN
    RAISE EXCEPTION
      'Jumlah komentar harus sama dengan jumlah pesanan, maksimal 500 karakter per komentar';
  END IF;

  IF NOT EXISTS (
    SELECT 1
    FROM public.naikin_deposits
    WHERE user_id = u
      AND status = 'paid'
      AND amount >= 10000
  ) THEN
    RAISE EXCEPTION
      'Deposit pertama minimal Rp10.000 harus terverifikasi sebelum memesan';
  END IF;

  v_total := CASE
    WHEN p.qty_type = 'fixed' THEN p.price
    ELSE round(p.price_per_unit * p_quantity, 0)
  END;

  IF v_total <= 0 THEN
    RAISE EXCEPTION 'Harga tidak valid';
  END IF;

  IF (
    SELECT coalesce(sum(amount), 0)
    FROM public.naikin_ledger
    WHERE user_id = u
  ) < v_total THEN
    RAISE EXCEPTION 'Saldo tidak mencukupi';
  END IF;

  INSERT INTO public.naikin_orders (
    user_id, product_id, quantity,
    target, total, request_key, custom_comments
  )
  VALUES (
    u, p.id, p_quantity,
    trim(p_target), v_total, p_request_key, p_comments
  )
  RETURNING id INTO v_id;

  INSERT INTO public.naikin_ledger (
    user_id, amount, reference, description
  )
  VALUES (
    u, -v_total, 'order:' || v_id,
    'Pembelian ' || p.name
  );

  RETURN v_id;
END;
$$;

-- =====================================================
-- 3. TAMBAHKAN 9 PRODUK THREADS
-- Harga followers, likes, views, dll per unit.
-- Harga per 1.000 = harga per unit x 1.000.
-- =====================================================

INSERT INTO public.naikin_products (
  id, category, name, description,
  qty_type, unit_label, duration,
  min_qty, max_qty, step_qty,
  price, price_per_unit, active,
  sort_order, requirements,
  custom_comments_enabled
)
VALUES
(
  'threads-01', 'threads', 'Threads Followers',
  'Layanan followers untuk profil Threads.',
  'unit', 'Followers', '',
  100, 100000, 1,
  24, 24, true, 5000,
  'Masukkan link profil Threads. Contoh: https://www.threads.com/@username. Pastikan profil dapat dibuka.',
  false
),
(
  'threads-02', 'threads', 'Threads Likes',
  'Layanan likes untuk postingan Threads.',
  'unit', 'Likes', '',
  100, 100000, 1,
  12, 12, true, 5001,
  'Salin link postingan Threads yang ingin dipromosikan. Contoh: https://www.threads.com/@username/post/ABC123. Pastikan postingan publik.',
  false
),
(
  'threads-03', 'threads', 'Threads Views',
  'Layanan penayangan konten Threads.',
  'unit', 'Views', '',
  100, 100000, 1,
  5, 5, true, 5002,
  'Masukkan link postingan Threads. Contoh: https://www.threads.com/@username/post/ABC123. Pastikan postingan dapat diakses.',
  false
),
(
  'threads-04', 'threads', 'Threads Reposts',
  'Layanan repost untuk postingan Threads.',
  'unit', 'Reposts', '',
  100, 100000, 1,
  30, 30, true, 5003,
  'Masukkan link postingan Threads yang ingin dibagikan ulang. Pastikan postingan publik.',
  false
),
(
  'threads-05', 'threads', 'Threads Quotes',
  'Layanan quote post untuk konten Threads.',
  'unit', 'Quotes', '',
  100, 100000, 1,
  45, 45, true, 5004,
  'Masukkan link postingan Threads. Pastikan postingan publik dan dapat dibagikan.',
  false
),
(
  'threads-06', 'threads', 'Threads Custom Comments',
  'Layanan komentar custom sesuai teks yang dimasukkan.',
  'unit', 'Custom Comments', '',
  1, 1000, 1,
  1500, 1500, true, 5005,
  'Masukkan link postingan Threads, lalu isi komentar pada kolom yang tersedia. Satu baris dihitung sebagai satu komentar. Jumlah komentar harus sama dengan jumlah pesanan.',
  true
),
(
  'threads-07', 'threads', 'Threads Replies',
  'Layanan balasan pada percakapan Threads.',
  'unit', 'Replies', '',
  1, 1000, 1,
  1200, 1200, true, 5006,
  'Masukkan link postingan Threads yang ingin mendapatkan balasan. Pastikan postingan publik.',
  false
),
(
  'threads-08', 'threads', 'Threads Profile Visits',
  'Layanan kunjungan profil Threads.',
  'unit', 'Profile Visits', '',
  100, 100000, 1,
  8, 8, true, 5007,
  'Masukkan link profil Threads. Contoh: https://www.threads.com/@username. Pastikan profil dapat diakses.',
  false
),
(
  'threads-09', 'threads', 'Threads Post Shares',
  'Layanan berbagi postingan Threads.',
  'unit', 'Post Shares', '',
  100, 100000, 1,
  25, 25, true, 5008,
  'Masukkan link postingan Threads yang ingin dibagikan. Pastikan postingan publik.',
  false
)
ON CONFLICT (id) DO UPDATE SET
  category = EXCLUDED.category,
  name = EXCLUDED.name,
  description = EXCLUDED.description,
  qty_type = EXCLUDED.qty_type,
  unit_label = EXCLUDED.unit_label,
  duration = EXCLUDED.duration,
  min_qty = EXCLUDED.min_qty,
  max_qty = EXCLUDED.max_qty,
  step_qty = EXCLUDED.step_qty,
  price = EXCLUDED.price,
  price_per_unit = EXCLUDED.price_per_unit,
  active = EXCLUDED.active,
  sort_order = EXCLUDED.sort_order,
  requirements = EXCLUDED.requirements,
  custom_comments_enabled = EXCLUDED.custom_comments_enabled;

-- Jika produk Engagement Campaign pernah ada,
-- nonaktifkan tanpa menghapus riwayat terkait.
UPDATE public.naikin_products
SET active = false
WHERE id = 'threads-10';

COMMIT;

-- =====================================================
-- 4. CEK HASIL
-- =====================================================

SELECT
  id,
  name,
  price_per_unit,
  min_qty,
  max_qty,
  active
FROM public.naikin_products
WHERE category = 'threads'
ORDER BY sort_order;
