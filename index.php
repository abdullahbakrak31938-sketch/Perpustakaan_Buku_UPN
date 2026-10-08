<?php
session_start();
require_once __DIR__ . '/Services/koneksi.php';

// Mencari anggota dengan nama dan ID yang dimasukkan.
function cariAnggota(string $nama, string $idAnggota): ?array
{
    $nama = trim($nama);
    $idAnggota = strtoupper(trim($idAnggota));

    if ($nama === '' || $idAnggota === '') {
        return null;
    }

    $sql = 'SELECT id_anggota, nama, tgl_daftar
            FROM anggota
            WHERE LOWER(TRIM(nama)) = LOWER(:nama)
              AND UPPER(id_anggota) = :id_anggota
            LIMIT 1';

    $query = db()->prepare($sql);
    $query->execute([
        ':nama' => $nama,
        ':id_anggota' => $idAnggota,
    ]);

    $anggota = $query->fetch();

    if (!$anggota) {
        return null;
    }

    return $anggota;
}

// Mengambil daftar buku yang pernah dipinjam oleh anggota.
function ambilRiwayat(string $idAnggota): array
{
    $sql = 'SELECT buku.judul, peminjaman.tgl_pinjam,
                   peminjaman.batas_kembali, peminjaman.tgl_kembali,
                   peminjaman.denda
            FROM peminjaman
            INNER JOIN buku ON buku.id_buku = peminjaman.id_buku
            WHERE peminjaman.id_anggota = :id_anggota
            ORDER BY peminjaman.tgl_pinjam DESC';

    $query = db()->prepare($sql);
    $query->execute([':id_anggota' => $idAnggota]);

    return $query->fetchAll();
}

// Mengubah karakter khusus supaya teks aman ditampilkan di halaman.
function amankanTeks($teks): string
{
    return htmlspecialchars((string) $teks, ENT_QUOTES, 'UTF-8');
}

// Mengubah angka menjadi format mata uang Rupiah.
function formatRupiah(int $jumlah): string
{
    return 'Rp ' . number_format($jumlah, 0, ',', '.');
}

// Mengubah tanggal database menjadi format yang mudah dibaca.
function formatTanggal(?string $tanggal): string
{
    if ($tanggal === null || $tanggal === '') {
        return '-';
    }

    $namaBulan = [
        1 => 'Jan', 2 => 'Feb', 3 => 'Mar', 4 => 'Apr',
        5 => 'Mei', 6 => 'Jun', 7 => 'Jul', 8 => 'Agu',
        9 => 'Sep', 10 => 'Okt', 11 => 'Nov', 12 => 'Des',
    ];

    $waktu = strtotime($tanggal);

    if ($waktu === false) {
        return '-';
    }

    $hari = date('j', $waktu);
    $bulan = $namaBulan[(int) date('n', $waktu)];
    $tahun = date('Y', $waktu);

    return $hari . ' ' . $bulan . ' ' . $tahun;
}

// Membuat token keamanan untuk form.
if (!isset($_SESSION['csrf'])) {
    $_SESSION['csrf'] = bin2hex(random_bytes(16));
}

// Memproses form login dan keluar.
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    try {
        $tokenForm = $_POST['csrf'] ?? '';

        if (!hash_equals($_SESSION['csrf'], $tokenForm)) {
            throw new RuntimeException('Sesi tidak valid, silakan coba lagi.');
        }

        $aksi = $_POST['aksi'] ?? '';

        if ($aksi === 'login') {
            $nama = $_POST['nama'] ?? '';
            $idAnggota = $_POST['id_anggota'] ?? '';
            $anggota = cariAnggota($nama, $idAnggota);

            if ($anggota === null) {
                throw new RuntimeException('Nama atau ID anggota tidak cocok.');
            }

            session_regenerate_id(true);
            $_SESSION['user'] = $anggota;
        } elseif ($aksi === 'logout') {
            unset($_SESSION['user']);
        }
    } catch (RuntimeException $ex) {
        $_SESSION['flash'] = ['error', $ex->getMessage()];
    } catch (PDOException $ex) {
        $_SESSION['flash'] = ['error', 'Database bermasalah: ' . $ex->getMessage()];
    }

    header('Location: index.php');
    exit;
}

// Mengambil pesan sementara, lalu menghapusnya agar tidak muncul terus.
$pesan = $_SESSION['flash'] ?? null;
unset($_SESSION['flash']);
$anggotaLogin = $_SESSION['user'] ?? null;
$tokenCsrf = $_SESSION['csrf'];
?>
<!DOCTYPE html>
<html lang="id">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Perpustakaan Kota</title>
  <link rel="stylesheet" href="style.css">
</head>
<body>
<?php if ($pesan): ?>
  <div class="flash <?= amankanTeks($pesan[0]) ?>" role="status">
    <?= amankanTeks($pesan[1]) ?>
  </div>
<?php endif; ?>

<?php if ($anggotaLogin === null): ?>
  <main class="login">
    <h1>Perpustakaan Kota</h1>
    <p>Masuk dengan nama dan ID anggota untuk melihat riwayat peminjamanmu.</p>

    <form method="post">
      <input type="hidden" name="csrf" value="<?= amankanTeks($tokenCsrf) ?>">
      <input type="hidden" name="aksi" value="login">

      <label>
        Nama lengkap
        <input type="text" name="nama" required autofocus>
      </label>

      <label>
        ID anggota
        <input type="text" name="id_anggota" required>
      </label>

      <button class="btn">Masuk</button>
    </form>
  </main>
<?php else:
  $riwayat = ambilRiwayat($anggotaLogin['id_anggota']);
?>
  <header class="top">
    <div>
      <span class="welcome-badge">Member</span>
      <h1>Halo, <?= amankanTeks($anggotaLogin['nama']) ?></h1>
      <p>
        <?= amankanTeks($anggotaLogin['id_anggota']) ?>
        · anggota sejak <?= formatTanggal($anggotaLogin['tgl_daftar']) ?>
      </p>
    </div>

    <form method="post">
      <input type="hidden" name="csrf" value="<?= amankanTeks($tokenCsrf) ?>">
      <input type="hidden" name="aksi" value="logout">
      <button class="btn ghost">Keluar</button>
    </form>
  </header>

  <main class="dashboard">
    <section class="panel">
      <div class="panel-head">
        <div>
          <span class="mini-label">Catatan</span>
          <h2>Riwayat peminjaman</h2>
        </div>
      </div>

      <?php if (empty($riwayat)): ?>
        <p class="empty">Belum ada buku yang pernah dipinjam/dikembalikan.</p>
      <?php else: ?>
        <div class="scroll">
          <table>
            <tr>
              <th>Judul</th>
              <th>Dipinjam</th>
              <th>Batas</th>
              <th>Dikembalikan</th>
              <th>Denda</th>
            </tr>

            <?php foreach ($riwayat as $peminjaman): ?>
              <tr>
                <td><?= amankanTeks($peminjaman['judul']) ?></td>
                <td><?= formatTanggal($peminjaman['tgl_pinjam']) ?></td>
                <td><?= formatTanggal($peminjaman['batas_kembali']) ?></td>
                <td><?= formatTanggal($peminjaman['tgl_kembali']) ?></td>
                <td>
                  <?= $peminjaman['denda']
                      ? formatRupiah((int) $peminjaman['denda'])
                      : '-' ?>
                </td>
              </tr>
            <?php endforeach; ?>
          </table>
        </div>
      <?php endif; ?>
    </section>
  </main>
<?php endif; ?>
</body>
</html>