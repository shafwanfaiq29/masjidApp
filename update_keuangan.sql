-- Script untuk menambahkan kolom jenis ke tabel keuangan yang sudah ada
-- Jalankan script ini di phpMyAdmin jika tabel sudah ada

USE db_masjid;

-- Cek apakah kolom jenis sudah ada, jika belum tambahkan
ALTER TABLE keuangan ADD COLUMN IF NOT EXISTS jenis ENUM('Debit', 'Kredit') NOT NULL DEFAULT 'Debit' AFTER kategori;

-- Update data yang sudah ada: Pemasukan = Kredit, Pengeluaran = Debit
UPDATE keuangan SET jenis = 'Kredit' WHERE kategori = 'Pemasukan';
UPDATE keuangan SET jenis = 'Debit' WHERE kategori = 'Pengeluaran';

-- Verifikasi
SELECT * FROM keuangan ORDER BY tanggal DESC LIMIT 5;
