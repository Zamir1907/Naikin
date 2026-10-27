-- NAIKIN: PROMO BARU UNTUK PRODUK UNGGULAN
-- Jalankan setelah migrasi yang menambahkan compare_at_price (migration 006).
-- Harga jual SAAT INI menjadi harga normal; harga jual BARU diturunkan.
-- Hanya produk aktif, harga > 0, dan belum memiliki compare_at_price yang diubah.
-- Tidak mengubah 118 produk sekaligus; produk lain tetap berlabel Harga Spesial.
-- Jalankan sekali saja. Pengulangan tidak menurunkan harga lagi.
BEGIN;

WITH pilihan(id, diskon) AS (
  VALUES
    ('1', 0.20::numeric),       -- Instagram Followers
    ('2', 0.15::numeric),       -- Instagram Likes
    ('3', 0.15::numeric),       -- Instagram Views
    ('6', 0.20::numeric),       -- TikTok Followers
    ('7', 0.15::numeric),       -- TikTok Likes
    ('8', 0.15::numeric),       -- TikTok Views
    ('11', 0.15::numeric),      -- YouTube Subscribers
    ('12', 0.15::numeric),      -- YouTube Views
    ('new-001', 0.15::numeric), -- Instagram Reels Views
    ('new-002', 0.15::numeric), -- Instagram Reels Likes
    ('new-013', 0.15::numeric), -- YouTube Shorts Views
    ('threads-01', 0.15::numeric), -- Threads Followers
    ('threads-02', 0.15::numeric)  -- Threads Likes
),
perubahan AS (
  UPDATE public.naikin_products p
  SET compare_at_price = CASE
        WHEN p.qty_type = 'fixed' THEN p.price
        ELSE p.price_per_unit * 1000
      END,
      price = CASE WHEN p.qty_type = 'fixed'
        THEN round(p.price * (1 - pilihan.diskon), 0)
        ELSE p.price END,
      price_per_unit = CASE WHEN p.qty_type = 'unit'
        THEN round(p.price_per_unit * (1 - pilihan.diskon), 4)
        ELSE p.price_per_unit END
  FROM pilihan
  WHERE p.id = pilihan.id
    AND p.active = true
    AND p.compare_at_price IS NULL
    AND p.qty_type IN ('fixed','unit')
    AND CASE WHEN p.qty_type = 'fixed' THEN p.price ELSE p.price_per_unit * 1000 END > 0
    AND CASE WHEN p.qty_type = 'fixed'
      THEN round(p.price * (1 - pilihan.diskon), 0)
      ELSE round(p.price_per_unit * (1 - pilihan.diskon), 4) * 1000
    END > 0
    AND CASE WHEN p.qty_type = 'fixed'
      THEN round(p.price * (1 - pilihan.diskon), 0)
      ELSE round(p.price_per_unit * (1 - pilihan.diskon), 4) * 1000
    END < CASE WHEN p.qty_type = 'fixed' THEN p.price ELSE p.price_per_unit * 1000 END
  RETURNING p.id, p.name, p.compare_at_price AS harga_normal,
    CASE WHEN p.qty_type = 'fixed' THEN p.price ELSE p.price_per_unit * 1000 END AS harga_promo
)
SELECT id, name, harga_normal, harga_promo,
  round((1 - harga_promo / harga_normal) * 100, 1) AS diskon_persen
FROM perubahan ORDER BY id;

COMMIT;

-- Verifikasi tampilan setelah migrasi:
SELECT id, name, qty_type, compare_at_price AS harga_normal,
       CASE WHEN qty_type='fixed' THEN price ELSE price_per_unit * 1000 END AS harga_sekarang
FROM public.naikin_products
WHERE compare_at_price IS NOT NULL
ORDER BY sort_order, id;
