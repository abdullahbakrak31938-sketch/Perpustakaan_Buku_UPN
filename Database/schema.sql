-- MySQL dump 10.13  Distrib 8.0.19, for Win64 (x86_64)
--
-- Host: localhost    Database: perpustakaan
-- ------------------------------------------------------
-- Server version	8.4.3

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `anggota`
--

DROP TABLE IF EXISTS `anggota`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `anggota` (
  `id_anggota` varchar(10) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `alamat` varchar(200) DEFAULT NULL,
  `tgl_daftar` date NOT NULL DEFAULT (curdate()),
  PRIMARY KEY (`id_anggota`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `anggota`
--

LOCK TABLES `anggota` WRITE;
/*!40000 ALTER TABLE `anggota` DISABLE KEYS */;
INSERT INTO `anggota` VALUES ('AA003','ahmad','ahmadd@gmail.com','081234557','Ampel','2026-01-08'),('AAA001','Syafik','Syafik@gmail.com','81234543','Bonddowoso','2026-10-08'),('AAA002','Alok','alok@gmail.com','081234556','Ampel','2026-01-08'),('AAA004','muhamad','muhammad@gmail.com','081234558','Jakarta','2026-01-08'),('AAA005','alex','alaex@gmail.com','081234559','Surabaya','2026-01-05'),('AAA006','asep','asep@gmail.com','081234554','Semarang','2026-01-08');
/*!40000 ALTER TABLE `anggota` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `buku`
--

DROP TABLE IF EXISTS `buku`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `buku` (
  `id_buku` varchar(10) NOT NULL,
  `judul` varchar(150) NOT NULL,
  `penulis` varchar(100) NOT NULL,
  `penerbit` varchar(100) NOT NULL,
  `tahun_terbit` year NOT NULL,
  `kategori` varchar(50) NOT NULL,
  `deskripsi` text NOT NULL,
  `stok` int NOT NULL,
  PRIMARY KEY (`id_buku`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `buku`
--

LOCK TABLES `buku` WRITE;
/*!40000 ALTER TABLE `buku` DISABLE KEYS */;
INSERT INTO `buku` VALUES ('BK001','Laskar Pelangi','Andrea Hirata','Bentang Pustaka',2005,'Novel','Kisah sepuluh anak dari keluarga sederhana di Belitung yang bersekolah di sekolah reyot dan tetap berjuang meraih mimpi bersama guru-guru yang penuh dedikasi.',2),('BK002','Bumi Manusia','Pramoedya Ananta Toer','Hasta Mitra',1980,'Novel Sejarah','Novel tentang Minke, pemuda pribumi terpelajar di masa kolonial Hindia Belanda, yang jatuh cinta sekaligus berhadapan dengan ketidakadilan zamannya.',1),('BK003','Negeri 5 Menara','Ahmad Fuadi','Gramedia Pustaka Utama',2009,'Novel','Perjalanan enam santri di pondok pesantren Jawa Timur yang belajar bahwa siapa yang bersungguh-sungguh pasti berhasil.',2),('BK004','Filosofi Teras','Henry Manampiring','Kompas',2018,'Pengembangan Diri','Pengantar filsafat Stoa yang dikemas praktis untuk menghadapi emosi negatif, stres, dan hal-hal di luar kendali dalam kehidupan modern.',1),('BK005','Atomic Habits','James Clear','Gramedia Pustaka Utama',2019,'Pengembangan Diri','Panduan membangun kebiasaan baik dan meninggalkan kebiasaan buruk lewat perubahan kecil yang konsisten dan berdampak besar dalam jangka panjang.',3),('BK006','Clean Code','Robert C. Martin','Prentice Hall',2008,'Teknologi','Buku tentang cara menulis kode yang rapi, mudah dibaca, dan mudah dirawat, lengkap dengan contoh refactoring dari kasus nyata.',2),('BK007','Sapiens','Yuval Noah Harari','Kepustakaan Populer Gramedia',2017,'Sejarah','Sejarah singkat umat manusia dari zaman batu hingga era modern, membahas revolusi kognitif, pertanian, dan ilmu pengetahuan.',2),('BK008','Bumi','Tere Liye','Gramedia Pustaka Utama',2014,'Fantasi','Petualangan Raib, gadis remaja yang bisa menghilang, bersama dua sahabatnya menjelajahi dunia paralel yang tersembunyi.',2);
/*!40000 ALTER TABLE `buku` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `peminjaman`
--

DROP TABLE IF EXISTS `peminjaman`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `peminjaman` (
  `id_pinjam` int unsigned NOT NULL AUTO_INCREMENT,
  `id_anggota` varchar(10) NOT NULL,
  `id_buku` varchar(10) NOT NULL,
  `tgl_pinjam` date NOT NULL,
  `batas_kembali` date NOT NULL,
  `tgl_kembali` date DEFAULT NULL,
  `status` enum('dipinjam','dikembalikan') NOT NULL DEFAULT 'dipinjam',
  `denda` int unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id_pinjam`),
  KEY `fk_pinjam_anggota` (`id_anggota`),
  KEY `fk_pinjam_buku` (`id_buku`),
  KEY `idx_status` (`status`),
  CONSTRAINT `fk_pinjam_anggota` FOREIGN KEY (`id_anggota`) REFERENCES `anggota` (`id_anggota`) ON UPDATE CASCADE,
  CONSTRAINT `fk_pinjam_buku` FOREIGN KEY (`id_buku`) REFERENCES `buku` (`id_buku`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `peminjaman`
--

LOCK TABLES `peminjaman` WRITE;
/*!40000 ALTER TABLE `peminjaman` DISABLE KEYS */;
INSERT INTO `peminjaman` VALUES (1,'AA003','BK003','2026-09-11','2026-09-22','2026-09-22','dikembalikan',0),(2,'AAA001','BK001','2026-09-11','2026-09-22','2026-09-22','dikembalikan',0),(3,'AAA002','BK002','2026-09-11','2026-09-22','2026-09-22','dikembalikan',0),(4,'AAA004','BK004','2026-09-11','2026-09-22','2026-09-22','dikembalikan',0),(5,'AAA005','BK005','2026-09-11','2026-09-22','2026-09-22','dikembalikan',0),(6,'AAA006','BK006','2026-09-01','2026-09-02','2026-09-02','dikembalikan',0);
/*!40000 ALTER TABLE `peminjaman` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping routines for database 'perpustakaan'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-08 20:43:09
