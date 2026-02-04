-- ============================================
-- Tabel Arsip Dokumen untuk Website Masjid
-- Jalankan script ini di phpMyAdmin
-- ============================================

USE db_masjid;

-- Buat tabel arsip
CREATE TABLE IF NOT EXISTS arsip (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nama_dokumen VARCHAR(255) NOT NULL,
    deskripsi TEXT,
    file_name VARCHAR(255) NOT NULL,
    kategori ENUM('Surat Masuk', 'Surat Keluar', 'Laporan', 'SK', 'Proposal', 'Lainnya') NOT NULL DEFAULT 'Lainnya',
    tanggal_upload DATE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample data arsip
INSERT INTO arsip (nama_dokumen, deskripsi, file_name, kategori, tanggal_upload) VALUES
('SK Pengurus DKM 2026', 'Surat Keputusan pengangkatan pengurus DKM periode 2026-2028', 'sk_pengurus_2026.pdf', 'SK', '2026-01-15'),
('Laporan Keuangan Januari 2026', 'Laporan keuangan bulanan bulan Januari 2026', 'laporan_jan_2026.pdf', 'Laporan', '2026-02-01'),
('Proposal Renovasi Masjid', 'Proposal pengajuan dana renovasi masjid tahap 2', 'proposal_renovasi.pdf', 'Proposal', '2026-01-20');

-- Verifikasi
SELECT * FROM arsip;
