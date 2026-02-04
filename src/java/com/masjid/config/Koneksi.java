package com.masjid.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class Koneksi {
    
    public static Connection getKoneksi() {
        Connection connect = null;
        try {
            String url = "jdbc:mysql://localhost:3307/db_masjid";
            String user = "root";
            String password = "";
            
            Class.forName("com.mysql.cj.jdbc.Driver");
            connect = DriverManager.getConnection(url, user, password);
        } catch (ClassNotFoundException e) {
            System.out.println("Driver tidak ditemukan: " + e.getMessage());
            e.printStackTrace();
        } catch (SQLException e) {
            System.out.println("Koneksi Gagal: " + e.getMessage());
            e.printStackTrace();
        }
        return connect;
    }
}
