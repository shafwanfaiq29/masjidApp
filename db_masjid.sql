-- ============================================
-- Database Setup untuk Website Masjid Jabalussalam
-- Jalankan script ini di phpMyAdmin atau MySQL Workbench
-- ============================================

-- Buat database
CREATE DATABASE IF NOT EXISTS db_masjid;
USE db_masjid;

-- ============================================
-- TABEL ADMIN
-- ============================================
DROP TABLE IF EXISTS admin;
CREATE TABLE admin (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nama VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert admin default
INSERT INTO admin (username, password, nama) VALUES 
('admin', 'admin123', 'Administrator Masjid');

-- ============================================
-- TABEL KEGIATAN
-- ============================================
DROP TABLE IF EXISTS kegiatan;
CREATE TABLE kegiatan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama_kegiatan VARCHAR(255) NOT NULL,
    tanggal DATE NOT NULL,
    waktu TIME NOT NULL,
    deskripsi TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data kegiatan
INSERT INTO kegiatan (nama_kegiatan, tanggal, waktu, deskripsi) VALUES
('Kajian Rutin Ba''da Maghrib', '2026-02-07', '18:30:00', 'Kajian kitab fiqih bersama Ustadz Ahmad. Tema: Tata Cara Sholat yang Benar'),
('Pengajian Akbar Bulanan', '2026-02-15', '08:00:00', 'Pengajian bulanan dengan tema "Meningkatkan Iman di Era Digital". Pembicara: Ustadz Dr. Abdullah'),
('Kerja Bakti Masjid', '2026-02-20', '07:00:00', 'Kerja bakti membersihkan masjid dan lingkungan sekitar. Diharapkan kehadiran seluruh jamaah'),
('Sholat Jumat Berjamaah', '2026-02-21', '12:00:00', 'Sholat Jumat dengan Khotib Ustadz Muhammad Ali'),
('Tahsin Al-Quran', '2026-02-22', '16:00:00', 'Kelas tahsin untuk memperbaiki bacaan Al-Quran. Terbuka untuk semua level'),
('Kajian Muslimah', '2026-02-23', '09:00:00', 'Kajian khusus muslimah dengan tema "Wanita Sholehah dalam Islam"'),
('Buka Puasa Bersama', '2026-03-01', '17:45:00', 'Buka puasa bersama jamaah masjid. Tersedia ta''jil dan makanan berbuka'),
('Santunan Anak Yatim', '2026-03-05', '10:00:00', 'Pemberian santunan kepada anak yatim di sekitar masjid');

-- ============================================
-- TABEL KEUANGAN
-- ============================================
DROP TABLE IF EXISTS keuangan;
CREATE TABLE keuangan (
    id INT PRIMARY KEY AUTO_INCREMENT,
    tanggal DATE NOT NULL,
    keterangan VARCHAR(255) NOT NULL,
    kategori ENUM('Pemasukan', 'Pengeluaran') NOT NULL,
    jenis ENUM('Debit', 'Kredit') NOT NULL DEFAULT 'Debit',
    jumlah DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data keuangan - PEMASUKAN (Kredit = uang masuk)
INSERT INTO keuangan (tanggal, keterangan, kategori, jenis, jumlah) VALUES
('2026-01-05', 'Infaq Jumat Minggu 1', 'Pemasukan', 'Kredit', 3500000),
('2026-01-12', 'Infaq Jumat Minggu 2', 'Pemasukan', 'Kredit', 2800000),
('2026-01-15', 'Donasi Warga Bpk. Ahmad', 'Pemasukan', 'Kredit', 5000000),
('2026-01-19', 'Infaq Jumat Minggu 3', 'Pemasukan', 'Kredit', 3200000),
('2026-01-20', 'Donasi Anonim', 'Pemasukan', 'Kredit', 1000000),
('2026-01-26', 'Infaq Jumat Minggu 4', 'Pemasukan', 'Kredit', 2900000),
('2026-02-01', 'Infaq Kotak Amal Januari', 'Pemasukan', 'Kredit', 4500000),
('2026-02-02', 'Infaq Jumat Minggu 1', 'Pemasukan', 'Kredit', 3100000),
('2026-02-03', 'Donasi Ibu Hj. Fatimah', 'Pemasukan', 'Kredit', 2000000);

-- Insert sample data keuangan - PENGELUARAN (Debit = uang keluar)
INSERT INTO keuangan (tanggal, keterangan, kategori, jenis, jumlah) VALUES
('2026-01-05', 'Pembayaran Listrik Januari', 'Pengeluaran', 'Debit', 850000),
('2026-01-10', 'Pembelian Perlengkapan Kebersihan', 'Pengeluaran', 'Debit', 350000),
('2026-01-15', 'Honor Imam dan Marbot', 'Pengeluaran', 'Debit', 2000000),
('2026-01-20', 'Perbaikan AC Masjid', 'Pengeluaran', 'Debit', 1500000),
('2026-01-25', 'Pembelian Karpet Tambahan', 'Pengeluaran', 'Debit', 3000000),
('2026-02-01', 'Pembayaran Air PDAM', 'Pengeluaran', 'Debit', 250000),
('2026-02-02', 'Pembelian Al-Quran 20 eksemplar', 'Pengeluaran', 'Debit', 1000000),
('2026-02-03', 'Konsumsi Pengajian', 'Pengeluaran', 'Debit', 500000);

-- ============================================
-- VERIFIKASI DATA
-- ============================================
SELECT 'Admin' as Tabel, COUNT(*) as Jumlah FROM admin
UNION ALL
SELECT 'Kegiatan' as Tabel, COUNT(*) as Jumlah FROM kegiatan
UNION ALL
SELECT 'Keuangan' as Tabel, COUNT(*) as Jumlah FROM keuangan;
