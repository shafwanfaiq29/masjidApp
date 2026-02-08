package com.masjid.util;

import com.masjid.config.Koneksi;
import java.sql.Connection;
import java.sql.Statement;
import java.sql.SQLException;

public class DatabaseHelper {
    public static void main(String[] args) {
        Connection con = Koneksi.getKoneksi();
        if (con != null) {
            try {
                Statement stmt = con.createStatement();
                String sql = "ALTER TABLE keuangan ADD COLUMN IF NOT EXISTS jenis_laporan VARCHAR(50) DEFAULT 'Masjid'";
                stmt.executeUpdate(sql);
                System.out.println("Schema update applied successfully: Added jenis_laporan column.");
                
                // Update existing records to have 'Masjid' if null (though DEFAULT should handle new ones)
                // MySQL adds the column with the default value for existing rows if NOT NULL is specified, 
                // but here it is nullable. Let's force update to be sure.
                String updateSql = "UPDATE keuangan SET jenis_laporan = 'Masjid' WHERE jenis_laporan IS NULL";
                stmt.executeUpdate(updateSql);
                System.out.println("Existing records updated with default jenis_laporan.");
                
            } catch (SQLException e) {
                System.out.println("Error applying schema update: " + e.getMessage());
                e.printStackTrace();
            } finally {
                try { con.close(); } catch (SQLException e) {}
            }
        } else {
            System.out.println("Failed to connect to database.");
        }
    }
}
