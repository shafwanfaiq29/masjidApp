-- Script to fix the 'kategori' column limitation
-- This is necessary because 'kategori' was previously an ENUM('Pemasukan', 'Pengeluaran')
-- but the new feature requires specific categories like 'Infaq', 'Operasional', etc.

USE db_masjid;

-- 1. Change kategori column to VARCHAR to allow any text
ALTER TABLE keuangan MODIFY COLUMN kategori VARCHAR(100) NOT NULL;

-- 2. Ensure 'jenis' column exists (in case update_keuangan.sql wasn't run)
-- Note: usage of valid SQL for MariaDB/MySQL
SET @exist := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA='db_masjid' AND TABLE_NAME='keuangan' AND COLUMN_NAME='jenis');
SET @sql := IF(@exist > 0, 'SELECT 1', 'ALTER TABLE keuangan ADD COLUMN jenis ENUM("Debit", "Kredit") NOT NULL DEFAULT "Debit" AFTER kategori');
PREPARE stmt FROM @sql;
EXECUTE stmt;

-- 3. Update existing data to set correct 'jenis' if it's currently default (Debit) but category is 'Pemasukan'
UPDATE keuangan SET jenis = 'Kredit' WHERE kategori = 'Pemasukan' AND jenis = 'Debit';
