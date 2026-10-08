# Sistem Peminjaman Buku Perpustakaan (PHP + MySQL)

```
perpustakaan/
├── .vscode/launch.json      konfigurasi debug VS Code
├── database/
│   ├── schema.sql           buat database, tabel, dan data contoh
│   └── querys.sql           kumpulan query siap pakai
├── services/
│   ├── koneksi.php          koneksi database (PDO)
│   └── PerpusService.php    login, pinjam, kembali, katalog
├── index.php                halaman login + dashboard
├── style.css
└── README.md
```

## Tabel
- **buku**: id_buku, judul, penulis, penerbit, tahun_terbit, kategori, deskripsi, stok
- **anggota**: id_anggota, nama, email, telepon, alamat, tgl_daftar
- **peminjaman** (penghubung): siapa meminjam buku apa, tgl_pinjam, batas_kembali, tgl_kembali, denda, status

## Cara pakai (Laragon + DBeaver)
1. Salin folder `perpustakaan` ke `C:\laragon\www\`.
2. Buka Laragon, klik **Start All** (Apache + MySQL).
3. Buka DBeaver, buat koneksi baru **MySQL**: host `127.0.0.1`, port `3306`, user `root`, password kosong.
   (Jika DBeaver meminta, aktifkan `allowPublicKeyRetrieval=true` di Driver properties.)
4. Buka `database/schema.sql` di DBeaver, tekan **Alt+X** (Execute Script). Database `perpustakaan` akan terbentuk.
5. Buka http://localhost/perpustakaan (atau http://perpustakaan.test jika auto virtual host aktif).
6. Login dengan salah satu akun contoh:

| Nama | ID anggota |
|---|---|
| Budi Santoso | AGT001 |
| Siti Aminah | AGT002 |
| Rizky Pratama | AGT003 |
| Dewi Lestari | AGT004 |

## Aturan
- Lama pinjam 7 hari, maksimal 3 buku sekaligus.
- Denda Rp 1.000 per hari keterlambatan.
- Ubah aturan di bagian atas `services/PerpusService.php`.
- Jika password MySQL Anda tidak kosong, ubah `services/koneksi.php`.
