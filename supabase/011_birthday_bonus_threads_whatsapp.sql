-- Naikin Patch 014 | jalankan setelah 010_catalog_cleanup.sql
-- Bonus hanya berlaku untuk akun yang dibuat SETELAH migration ini.
-- Akun lama, saldo, ledger, dan riwayat pesanan tidak diubah.
BEGIN;
CREATE OR REPLACE FUNCTION public.naikin_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER SET search_path = '' AS $$
BEGIN
  INSERT INTO public.naikin_profiles(id,display_name)
  VALUES(new.id,coalesce(new.raw_user_meta_data->>'display_name',''));
  INSERT INTO public.naikin_ledger(user_id,amount,reference,description)
  VALUES(new.id,4500,'signup:'||new.id,'Bonus Ulang Tahun Admin - pendaftaran');
  RETURN new;
END;
$$;

-- WA Centang Biru: menggunakan nomor bisnis aktif, bukan link profil.
UPDATE public.naikin_products SET
 description='Layanan pengajuan centang biru untuk nomor WhatsApp Business. Proses verifikasi mengikuti ketentuan dan persetujuan WhatsApp; hasil tidak dijamin.',
 requirements='Masukkan nomor WhatsApp Business aktif beserta kode negara, misalnya +6281234567890. Nomor wajib dapat menerima pesan dan digunakan untuk akun bisnis. Jangan masukkan link grup atau membagikan OTP maupun kata sandi.',
 updated_at=now()
WHERE id='28';

-- WA Group Members: batasi maksimum 1.000 per pesanan.
-- Anggota luar negeri: informasi paket, bukan jaminan lokasi setiap nomor.
UPDATE public.naikin_products SET
 description='Layanan penambahan anggota ke grup WhatsApp hingga 1.000 anggota per pesanan. Anggota dapat menggunakan nomor internasional dari berbagai negara.',
 requirements='Masukkan link undangan grup WhatsApp yang aktif (https://chat.whatsapp.com/...). Pastikan link dapat dibuka dan grup masih memiliki kapasitas. Nonaktifkan fitur persetujuan anggota agar undangan dapat digunakan. Jangan bagikan kode OTP atau akses admin.',
 max_qty=1000,
 min_qty=LEAST(min_qty,1000),
 step_qty=CASE WHEN step_qty>1000 THEN 1 ELSE step_qty END,
 updated_at=now()
WHERE id='29';
COMMIT;
