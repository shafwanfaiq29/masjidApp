-- ============================================
-- Update Database untuk Role-Based Access Control
-- Jalankan script ini di phpMyAdmin
-- ============================================

USE db_masjid;

-- Tambah kolom role ke tabel admin
ALTER TABLE admin ADD COLUMN role ENUM('Admin', 'Idarah', 'Imarah', 'Riayah') NOT NULL DEFAULT 'Admin';

-- Update admin yang sudah ada menjadi Admin
UPDATE admin SET role = 'Admin' WHERE id = 1;

-- Insert user untuk setiap bidang
INSERT INTO admin (username, password, nama, role) VALUES
('idarah', 'idarah123', 'Bidang Idarah', 'Idarah'),
('imarah', 'imarah123', 'Bidang Imarah', 'Imarah'),
('riayah', 'riayah123', 'Bidang Riayah', 'Riayah');

-- Verifikasi data
SELECT id, username, nama, role FROM admin;

-- ============================================
-- Keterangan Hak Akses:
-- Admin   : Akses penuh semua fitur
-- Idarah  : Hanya akses Arsip Dokumen
-- Imarah  : Hanya akses Kegiatan
-- Riayah  : Hanya akses Keuangan
-- ============================================
