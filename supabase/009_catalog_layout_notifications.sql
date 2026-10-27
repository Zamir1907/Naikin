-- Naikin patch: pengaturan katalog HP dan hapus notifikasi milik sendiri.
-- Jalankan SATU KALI setelah migration 004 (dan migration berikutnya yang sudah digunakan).
BEGIN;
INSERT INTO public.naikin_site_settings(key,value)
VALUES ('catalog_mobile_columns','{"columns":2}'::jsonb)
ON CONFLICT (key) DO NOTHING;
-- Kebijakan update pengaturan admin sudah tersedia dari migration 001.
DROP POLICY IF EXISTS naikin_notifications_delete_own ON public.naikin_notifications;
CREATE POLICY naikin_notifications_delete_own
ON public.naikin_notifications FOR DELETE TO authenticated
USING (user_id = (SELECT auth.uid()));
COMMIT;
