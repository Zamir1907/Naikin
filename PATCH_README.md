# Naikin Patch 005 — Deposit QRIS persisten

**Pasang di atas Patch 004.** Paket hanya berisi file yang berubah atau ditambahkan.

1. Backup `js/app.js` lama.
2. Salin `js/app.js` dari ZIP ini ke folder proyek `js/`, pilih Replace.
3. Di Supabase SQL Editor jalankan **hanya** `supabase/005_deposit_admin_alert.sql` setelah migrasi 004. Tidak perlu menjalankan ulang 001–004.
4. Refresh localhost (`Ctrl+Shift+R`).

## Perilaku
- Deposit dibuat dan tersimpan di database sebelum QRIS ditampilkan.
- Refresh, Back, atau menutup tab tidak menghapus deposit. Halaman Deposit menampilkan riwayat dengan tombol **Lanjutkan** untuk deposit pending dan **Lihat Detail** untuk lainnya.
- Tombol **Saya Sudah Bayar** baru aktif 20 detik setelah `created_at` deposit. Waktu tunggu tidak ditampilkan dan tidak diulang ketika refresh.
- Konfirmasi pengguna mengubah status ke `user_confirmed` melalui RPC lama. Tidak otomatis menambah saldo.
- Admin mendapat notifikasi ketika status pertama kali berubah ke `user_confirmed`. Periksa dana masuk secara manual sebelum menyetujui.
- Permintaan baru dengan nominal sama ketika masih ada deposit pending akan membuka deposit yang sudah ada untuk mengurangi duplikasi.
- Tidak ada unggah screenshot pembayaran.

## Batas pengujian
JavaScript dicek sintaksnya dan ZIP diperiksa integritasnya. Uji transaksi langsung memerlukan project Supabase milikmu; jangan menganggap pembayaran terverifikasi otomatis.
