-- NAIKIN PATCH 013 - setelah migration 009 dan semua migration sebelumnya.
-- Aman untuk riwayat pesanan: produk lama dinonaktifkan, bukan dihapus.
BEGIN;

-- Rapikan deskripsi dan persyaratan berdasarkan ID produk.
WITH descriptions(id, description, requirements) AS (VALUES
('1','Layanan penambahan followers pada akun atau kanal Instagram sesuai jumlah pesanan.','Masukkan tautan akun, profil, atau kanal Instagram yang benar. Tidak perlu memberikan kata sandi.'),
('2','Layanan likes untuk konten Instagram sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten Instagram yang ingin dituju. Pastikan dapat dibuka.'),
('3','Layanan penayangan atau jangkauan konten Instagram sesuai paket yang dipilih.','Masukkan tautan konten Instagram yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('4','Layanan komentar atau balasan pada konten Instagram sesuai ketentuan paket.','Masukkan tautan postingan Instagram. Jika paket mendukung komentar custom, tulis satu komentar per baris.'),
('5','Layanan penayangan atau jangkauan konten Instagram sesuai paket yang dipilih.','Masukkan tautan konten Instagram yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('6','Layanan penambahan followers pada akun atau kanal TikTok sesuai jumlah pesanan.','Masukkan tautan akun, profil, atau kanal TikTok yang benar. Tidak perlu memberikan kata sandi.'),
('7','Layanan likes untuk konten TikTok sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten TikTok yang ingin dituju. Pastikan dapat dibuka.'),
('8','Layanan penayangan atau jangkauan konten TikTok sesuai paket yang dipilih.','Masukkan tautan konten TikTok yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('9','Layanan berbagi ulang konten TikTok sesuai jumlah pesanan.','Masukkan tautan postingan TikTok yang dapat dibuka.'),
('10','Layanan komentar atau balasan pada konten TikTok sesuai ketentuan paket.','Masukkan tautan postingan TikTok. Jika paket mendukung komentar custom, tulis satu komentar per baris.'),
('11','Layanan penambahan subscribers pada akun atau kanal YouTube sesuai jumlah pesanan.','Masukkan tautan akun, profil, atau kanal YouTube yang benar. Tidak perlu memberikan kata sandi.'),
('12','Layanan penayangan atau jangkauan konten YouTube sesuai paket yang dipilih.','Masukkan tautan konten YouTube yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('13','Layanan likes untuk konten YouTube sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten YouTube yang ingin dituju. Pastikan dapat dibuka.'),
('14','Layanan YouTube Watch Hours sesuai pilihan jumlah atau paket yang tersedia.','Masukkan tautan atau informasi tujuan yang benar dan dapat diakses.'),
('15','Layanan likes untuk konten Facebook sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten Facebook yang ingin dituju. Pastikan dapat dibuka.'),
('16','Layanan penambahan followers pada akun atau kanal Facebook sesuai jumlah pesanan.','Masukkan tautan akun, profil, atau kanal Facebook yang benar. Tidak perlu memberikan kata sandi.'),
('17','Layanan likes untuk konten Facebook sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten Facebook yang ingin dituju. Pastikan dapat dibuka.'),
('18','Layanan penayangan atau jangkauan konten Facebook sesuai paket yang dipilih.','Masukkan tautan konten Facebook yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('19','Layanan penambahan followers pada akun atau kanal X sesuai jumlah pesanan.','Masukkan tautan akun, profil, atau kanal X yang benar. Tidak perlu memberikan kata sandi.'),
('20','Layanan likes untuk konten X sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten X yang ingin dituju. Pastikan dapat dibuka.'),
('21','Layanan berbagi ulang konten X sesuai jumlah pesanan.','Masukkan tautan postingan X yang dapat dibuka.'),
('22','Layanan penayangan atau jangkauan konten X sesuai paket yang dipilih.','Masukkan tautan konten X yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('23','Layanan penambahan members pada akun atau kanal Telegram sesuai jumlah pesanan.','Masukkan tautan akun, profil, atau kanal Telegram yang benar. Tidak perlu memberikan kata sandi.'),
('24','Layanan penayangan atau jangkauan konten Telegram sesuai paket yang dipilih.','Masukkan tautan konten Telegram yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('25','Layanan reactions untuk konten Telegram sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten Telegram yang ingin dituju. Pastikan dapat dibuka.'),
('26','Layanan penambahan members pada akun atau kanal WhatsApp sesuai jumlah pesanan.','Masukkan tautan akun, profil, atau kanal WhatsApp yang benar. Tidak perlu memberikan kata sandi.'),
('27','Layanan reactions untuk konten WhatsApp sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten WhatsApp yang ingin dituju. Pastikan dapat dibuka.'),
('28','Layanan WA Centang Biru sesuai pilihan jumlah atau paket yang tersedia.','Masukkan tautan atau informasi tujuan yang benar dan dapat diakses.'),
('29','Layanan penambahan members pada akun atau kanal WhatsApp sesuai jumlah pesanan.','Masukkan tautan akun, profil, atau kanal WhatsApp yang benar. Tidak perlu memberikan kata sandi.'),
('30','Paket Spotify Premium 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('31','Paket Spotify Premium 3 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('32','Paket Spotify Premium 1 Tahun sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('33','Layanan Spotify Plays untuk kebutuhan konten dan promosi musik.','Masukkan tautan lagu atau playlist Spotify yang benar dan dapat diakses.'),
('34','Paket CapCut Pro 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('35','Paket CapCut Pro 3 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('36','Paket CapCut Pro 1 Tahun sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('38','Paket Canva Pro 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('39','Paket Canva Pro 6 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('40','Paket Canva Pro 1 Tahun sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('41','Paket Canva Pro Lifetime sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('45','Paket ChatGPT Plus 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('49','Paket ChatGPT Plus 3 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('50','Paket ChatGPT Plus 1 Tahun sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('51','Paket Claude Pro 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('52','Paket Claude Pro 3 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('53','Paket Claude Pro 1 Tahun sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('54','Paket Gemini Advanced / AI Pro 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('55','Paket Gemini Advanced 3 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('56','Paket Gemini Advanced 1 Tahun sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('57','Paket Perplexity Pro 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('58','Paket Grok Premium 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('59','Paket Midjourney Standard 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('60','Paket Meitu Wink VIP 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('61','Paket Meitu Wink VIP 3 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('62','Paket Meitu Wink VIP 1 Tahun sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('63','Paket Meitu Wink VIP+ 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('42','Paket Netflix Premium 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('43','Paket YouTube Premium 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('44','Paket Disney+ Hotstar 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('46','Paket VPN Premium 1 Bulan sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('47','Paket Cloud Storage 100GB sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('48','Paket Microsoft 365 1 Tahun sesuai masa berlaku dan ketentuan aktivasi yang tercantum pada layanan.','Masukkan email aktif yang dapat diakses untuk informasi pesanan dan aktivasi. Jangan mengirim kata sandi akun.'),
('new-001','Layanan penayangan atau jangkauan konten Instagram sesuai paket yang dipilih.','Masukkan tautan konten Instagram yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('new-002','Layanan likes untuk konten Instagram sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten Instagram yang ingin dituju. Pastikan dapat dibuka.'),
('new-003','Layanan penayangan atau jangkauan konten Instagram sesuai paket yang dipilih.','Masukkan tautan konten Instagram yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('new-004','Layanan saves untuk konten Instagram sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten Instagram yang ingin dituju. Pastikan dapat dibuka.'),
('new-005','Layanan kunjungan ke profil Instagram sesuai jumlah yang dipesan. Statistik dapat dipantau melalui fitur analitik akun jika tersedia.','Masukkan tautan profil Instagram yang benar dan dapat diakses. Periksa jumlah pesanan sebelum melanjutkan.'),
('new-006','Layanan berbagi ulang konten Instagram sesuai jumlah pesanan.','Masukkan tautan postingan Instagram yang dapat dibuka.'),
('new-007','Layanan saves untuk konten TikTok sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten TikTok yang ingin dituju. Pastikan dapat dibuka.'),
('new-008','Layanan kunjungan ke profil TikTok sesuai jumlah yang dipesan. Statistik dapat dipantau melalui fitur analitik akun jika tersedia.','Masukkan tautan profil TikTok yang benar dan dapat diakses. Periksa jumlah pesanan sebelum melanjutkan.'),
('new-009','Layanan TikTok Live Promotion sesuai pilihan jumlah atau paket yang tersedia.','Masukkan tautan atau informasi tujuan yang benar dan dapat diakses.'),
('new-010','Layanan berbagi ulang konten TikTok sesuai jumlah pesanan.','Masukkan tautan postingan TikTok yang dapat dibuka.'),
('new-011','Layanan TikTok Repost Campaign sesuai pilihan jumlah atau paket yang tersedia.','Masukkan tautan atau informasi tujuan yang benar dan dapat diakses.'),
('new-012','Layanan plus untuk konten TikTok sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten TikTok yang ingin dituju. Pastikan dapat dibuka.'),
('new-013','Layanan penayangan atau jangkauan konten YouTube sesuai paket yang dipilih.','Masukkan tautan konten YouTube yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('new-014','Layanan likes untuk konten YouTube sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten YouTube yang ingin dituju. Pastikan dapat dibuka.'),
('new-015','Layanan YouTube Channel Promotion sesuai pilihan jumlah atau paket yang tersedia.','Masukkan tautan atau informasi tujuan yang benar dan dapat diakses.'),
('new-016','Layanan berbagi ulang konten YouTube sesuai jumlah pesanan.','Masukkan tautan postingan YouTube yang dapat dibuka.'),
('new-017','Layanan likes untuk konten YouTube sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten YouTube yang ingin dituju. Pastikan dapat dibuka.'),
('new-018','Layanan penayangan atau jangkauan konten Facebook sesuai paket yang dipilih.','Masukkan tautan konten Facebook yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('new-019','Layanan berbagi ulang konten Facebook sesuai jumlah pesanan.','Masukkan tautan postingan Facebook yang dapat dibuka.'),
('new-020','Layanan penayangan atau jangkauan konten Facebook sesuai paket yang dipilih.','Masukkan tautan konten Facebook yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('new-021','Layanan Facebook Page Promotion sesuai pilihan jumlah atau paket yang tersedia.','Masukkan tautan atau informasi tujuan yang benar dan dapat diakses.'),
('new-022','Layanan penayangan atau jangkauan konten X sesuai paket yang dipilih.','Masukkan tautan konten X yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('new-023','Layanan penayangan atau jangkauan konten X sesuai paket yang dipilih.','Masukkan tautan konten X yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('new-024','Layanan bookmarks untuk konten X sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten X yang ingin dituju. Pastikan dapat dibuka.'),
('new-025','Layanan kunjungan ke profil X sesuai jumlah yang dipesan. Statistik dapat dipantau melalui fitur analitik akun jika tersedia.','Masukkan tautan profil X yang benar dan dapat diakses. Periksa jumlah pesanan sebelum melanjutkan.'),
('new-026','Layanan Telegram Channel Promotion sesuai pilihan jumlah atau paket yang tersedia.','Masukkan tautan atau informasi tujuan yang benar dan dapat diakses.'),
('new-027','Layanan plus untuk konten Telegram sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten Telegram yang ingin dituju. Pastikan dapat dibuka.'),
('new-028','Layanan Telegram Poll Participation sesuai pilihan jumlah atau paket yang tersedia.','Masukkan tautan atau informasi tujuan yang benar dan dapat diakses.'),
('new-029','Layanan Spotify Track Promotion untuk kebutuhan konten dan promosi musik.','Masukkan tautan lagu atau playlist Spotify yang benar dan dapat diakses.'),
('new-030','Layanan Spotify Playlist Pitching untuk kebutuhan konten dan promosi musik.','Masukkan tautan lagu atau playlist Spotify yang benar dan dapat diakses.'),
('new-031','Layanan distribusi konten komunitas untuk kebutuhan komunikasi dan distribusi konten.','Masukkan tautan konten atau brief pekerjaan, termasuk platform dan tujuan kampanye.'),
('new-032','Layanan kampanye kreator mikro untuk kebutuhan komunikasi dan distribusi konten.','Masukkan tautan konten atau brief pekerjaan, termasuk platform dan tujuan kampanye.'),
('new-033','Layanan share konten oleh peserta untuk kebutuhan komunikasi dan distribusi konten.','Masukkan tautan konten atau brief pekerjaan, termasuk platform dan tujuan kampanye.'),
('new-034','Layanan kampanye komentar terbuka untuk kebutuhan komunikasi dan distribusi konten.','Masukkan tautan konten atau brief pekerjaan, termasuk platform dan tujuan kampanye.'),
('new-035','Layanan pengumpulan masukan audiens untuk kebutuhan komunikasi dan distribusi konten.','Masukkan tautan konten atau brief pekerjaan, termasuk platform dan tujuan kampanye.'),
('new-036','Layanan audit google business profile untuk pengelolaan informasi dan respons pelanggan di Google Business Profile.','Masukkan tautan Google Maps tempat terkait dan jelaskan kebutuhan bisnis secara ringkas.'),
('new-037','Layanan optimasi informasi bisnis untuk pengelolaan informasi dan respons pelanggan di Google Business Profile.','Masukkan tautan Google Maps tempat terkait dan jelaskan kebutuhan bisnis secara ringkas.'),
('new-038','Layanan balasan ulasan pelanggan untuk pengelolaan informasi dan respons pelanggan di Google Business Profile.','Masukkan tautan Google Maps tempat terkait dan jelaskan kebutuhan bisnis secara ringkas.'),
('new-039','Layanan panduan mendapat ulasan autentik untuk pengelolaan informasi dan respons pelanggan di Google Business Profile.','Masukkan tautan Google Maps tempat terkait dan jelaskan kebutuhan bisnis secara ringkas.'),
('new-040','Jasa audit landing page untuk kebutuhan konten atau bisnis digital.','Jelaskan kebutuhan, tujuan, dan referensi pekerjaan secara ringkas.'),
('new-041','Jasa optimasi copywriting produk untuk kebutuhan konten atau bisnis digital.','Jelaskan kebutuhan, tujuan, dan referensi pekerjaan secara ringkas.'),
('new-042','Jasa paket deskripsi produk untuk kebutuhan konten atau bisnis digital.','Jelaskan kebutuhan, tujuan, dan referensi pekerjaan secara ringkas.'),
('new-043','Jasa audit seo dasar untuk kebutuhan konten atau bisnis digital.','Jelaskan kebutuhan, tujuan, dan referensi pekerjaan secara ringkas.'),
('new-044','Jasa desain thumbnail konten untuk kebutuhan konten atau bisnis digital.','Jelaskan kebutuhan, tujuan, dan referensi pekerjaan secara ringkas.'),
('new-045','Jasa desain feed promosi untuk kebutuhan konten atau bisnis digital.','Jelaskan kebutuhan, tujuan, dan referensi pekerjaan secara ringkas.'),
('new-046','Jasa desain story promosi untuk kebutuhan konten atau bisnis digital.','Jelaskan kebutuhan, tujuan, dan referensi pekerjaan secara ringkas.'),
('new-047','Jasa paket caption produk untuk kebutuhan konten atau bisnis digital.','Jelaskan kebutuhan, tujuan, dan referensi pekerjaan secara ringkas.'),
('threads-01','Layanan penambahan followers pada akun atau kanal  sesuai jumlah pesanan.','Masukkan tautan akun, profil, atau kanal  yang benar. Tidak perlu memberikan kata sandi.'),
('threads-02','Layanan likes untuk konten  sesuai jumlah yang dipilih.','Masukkan tautan postingan atau konten  yang ingin dituju. Pastikan dapat dibuka.'),
('threads-03','Layanan penayangan atau jangkauan konten  sesuai paket yang dipilih.','Masukkan tautan konten  yang dapat diakses. Pastikan tautan menuju konten yang tepat.'),
('threads-04','Layanan berbagi ulang konten  sesuai jumlah pesanan.','Masukkan tautan postingan  yang dapat dibuka.'),
('threads-05','Layanan berbagi ulang konten  sesuai jumlah pesanan.','Masukkan tautan postingan  yang dapat dibuka.'),
('threads-06','Layanan komentar atau balasan pada konten  sesuai ketentuan paket.','Masukkan tautan postingan . Jika paket mendukung komentar custom, tulis satu komentar per baris.'),
('threads-07','Layanan komentar atau balasan pada konten  sesuai ketentuan paket.','Masukkan tautan postingan . Jika paket mendukung komentar custom, tulis satu komentar per baris.'),
('threads-08','Layanan kunjungan ke profil  sesuai jumlah yang dipesan. Statistik dapat dipantau melalui fitur analitik akun jika tersedia.','Masukkan tautan profil  yang benar dan dapat diakses. Periksa jumlah pesanan sebelum melanjutkan.'),
('threads-09','Layanan berbagi ulang konten  sesuai jumlah pesanan.','Masukkan tautan postingan  yang dapat dibuka.')
)
UPDATE public.naikin_products p SET description=d.description,requirements=d.requirements
FROM descriptions d WHERE p.id=d.id;

-- Sembunyikan kategori yang tidak lagi digunakan tanpa menghapus riwayat pesanan.
UPDATE public.naikin_products SET active=false WHERE category IN ('design','website');

-- Nonaktifkan produk lama kampanye/Google Business agar tidak bertabrakan dengan paket V1-V3.
UPDATE public.naikin_products SET active=false WHERE category IN ('campaign','googlebusiness');

-- Batas Profile Visits sampai satu juta, tetap mempertahankan step_qty dan min_qty.
UPDATE public.naikin_products SET max_qty=1000000
WHERE lower(name) LIKE '%profile visits%' AND qty_type='unit' AND max_qty<1000000;

-- Enam paket baru. Harga usulan perlu disesuaikan dengan penyedia sebelum dijual.
INSERT INTO public.naikin_products
(id,category,name,description,requirements,qty_type,unit_label,duration,min_qty,max_qty,step_qty,price,price_per_unit,active,sort_order,custom_comments_enabled)
VALUES
('buzzer-v1','campaign','Buzzer Indonesia V1 — Custom Comment','Tentukan teks komentar sendiri untuk konten yang kamu pilih. Satu baris dihitung sebagai satu komentar.','Masukkan tautan postingan Instagram, TikTok, YouTube, atau Threads. Tulis satu komentar per baris; misalnya pesanan 3 komentar memerlukan 3 baris. Pastikan konten dapat dibuka.','unit','Komentar','',1,1000,1,0,1500,true,6500,true),
('buzzer-v2','campaign','Buzzer Indonesia V2 — AI Positive','Penyusunan komentar bernada positif dengan bantuan AI berdasarkan topik konten dan arahan yang diberikan.','Masukkan tautan postingan Instagram, TikTok, YouTube, atau Threads. Sertakan konteks atau topik konten dalam informasi pesanan agar draf komentar relevan. Pembuatan dan publikasi komentar memerlukan proses penyedia.','unit','Komentar','',1,1000,1,0,1200,true,6501,false),
('buzzer-v3','campaign','Buzzer Indonesia V3 — AI Critical','Penyusunan komentar kritis dan masukan yang relevan dengan isi konten menggunakan bantuan AI.','Masukkan tautan postingan Instagram, TikTok, YouTube, atau Threads. Jelaskan aspek yang ingin dikritisi; misalnya kualitas layanan atau kejelasan informasi. Komentar harus didasarkan pada informasi yang benar.','unit','Komentar','',1,1000,1,0,1400,true,6502,false),
('maps-v1','googlebusiness','Review Google Maps V1 — Custom Review','Tulis ulasan berdasarkan pengalaman sendiri dan pilih rating 1 sampai 5 bintang. Satu baris dihitung sebagai satu ulasan.','Masukkan tautan lokasi Google Maps, pilih rating, dan tulis satu ulasan per baris. Contoh: 3 ulasan berarti 3 baris teks. Gunakan hanya pengalaman yang benar-benar terjadi.','unit','Ulasan','',1,1000,1,0,2500,true,6503,true),
('maps-v2','googlebusiness','Review Google Maps V2 — AI Positive','Bantuan penyusunan draf ulasan positif berdasarkan pengalaman pelanggan dan informasi tempat, dengan pilihan rating 5 bintang.','Masukkan tautan Google Maps dan informasi pengalaman nyata tentang tempat tersebut. Contoh: menu, pelayanan, atau fasilitas yang benar-benar digunakan. AI membantu merapikan draf; tidak otomatis menerbitkan ulasan.','unit','Ulasan','',1,1000,1,0,2000,true,6504,false),
('maps-v3','googlebusiness','Review Google Maps V3 — AI Critical','Bantuan penyusunan draf ulasan kritis sesuai pengalaman pelanggan, dengan pilihan rating 1 sampai 3 bintang.','Masukkan tautan Google Maps dan uraikan masalah yang benar-benar dialami, misalnya antrean atau fasilitas. AI membantu merapikan draf tanpa menambah kejadian yang tidak terjadi.','unit','Ulasan','',1,1000,1,0,2300,true,6505,false)
ON CONFLICT (id) DO UPDATE SET category=EXCLUDED.category,name=EXCLUDED.name,
description=EXCLUDED.description,requirements=EXCLUDED.requirements,
qty_type=EXCLUDED.qty_type,unit_label=EXCLUDED.unit_label,
min_qty=EXCLUDED.min_qty,max_qty=EXCLUDED.max_qty,step_qty=EXCLUDED.step_qty,
price_per_unit=EXCLUDED.price_per_unit,custom_comments_enabled=EXCLUDED.custom_comments_enabled,
active=EXCLUDED.active,sort_order=EXCLUDED.sort_order;
COMMIT;

SELECT id,name,category,price_per_unit,active FROM public.naikin_products
WHERE id LIKE 'buzzer-v%' OR id LIKE 'maps-v%' ORDER BY id;
