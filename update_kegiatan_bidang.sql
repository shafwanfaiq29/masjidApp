-- ============================================
-- Update tabel kegiatan untuk menambah kolom bidang
-- Jalankan script ini di phpMyAdmin atau MySQL
-- ============================================

USE db_masjid;

-- Tambah kolom bidang ke tabel kegiatan
ALTER TABLE kegiatan 
ADD COLUMN bidang ENUM('Idarah', 'Imarah', 'Riayah') NOT NULL DEFAULT 'Imarah' 
AFTER deskripsi;

-- Update data contoh dengan bidang yang sesuai
UPDATE kegiatan SET bidang = 'Imarah' WHERE nama_kegiatan LIKE '%Kajian%' OR nama_kegiatan LIKE '%Pengajian%' OR nama_kegiatan LIKE '%Tahsin%' OR nama_kegiatan LIKE '%Sholat%' OR nama_kegiatan LIKE '%Buka Puasa%';
UPDATE kegiatan SET bidang = 'Riayah' WHERE nama_kegiatan LIKE '%Kerja Bakti%';
UPDATE kegiatan SET bidang = 'Idarah' WHERE nama_kegiatan LIKE '%Santunan%';

-- Verifikasi perubahan
SELECT id, nama_kegiatan, bidang FROM kegiatan;
