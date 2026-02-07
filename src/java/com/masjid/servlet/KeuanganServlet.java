package com.masjid.servlet;

import com.masjid.config.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/KeuanganServlet")
public class KeuanganServlet extends HttpServlet {
    
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("adminId") != null;
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isLoggedIn(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        Connection con = null;
        
        try {
            con = Koneksi.getKoneksi();
            
            if (con == null) {
                System.out.println("ERROR: Koneksi database null!");
                response.sendRedirect("admin/keuangan.jsp?error=db");
                return;
            }
            
            if ("add".equals(action)) {
                String tanggal = request.getParameter("tanggal");
                String keterangan = request.getParameter("keterangan");
                String jenisInput = request.getParameter("jenis");
                String kategori = jenisInput; // Use jenis as kategori to satisfy potential ENUM constraints
                String jenisLaporan = request.getParameter("jenis_laporan"); // New parameter
                if (jenisLaporan == null || jenisLaporan.isEmpty()) jenisLaporan = "Masjid"; // Default

                String jenis = "Debit";
                if ("Pemasukan".equalsIgnoreCase(jenisInput)) {
                    jenis = "Kredit";
                } else if ("Pengeluaran".equalsIgnoreCase(jenisInput)) {
                    jenis = "Debit";
                }
                double jumlah = Double.parseDouble(request.getParameter("jumlah"));
                
                String sql = "INSERT INTO keuangan (tanggal, keterangan, kategori, jenis, jumlah, jenis_laporan) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, tanggal);
                ps.setString(2, keterangan);
                ps.setString(3, kategori);
                ps.setString(4, jenis);
                ps.setDouble(5, jumlah);
                ps.setString(6, jenisLaporan);
                ps.executeUpdate();
                ps.close();
                
                response.sendRedirect("admin/keuangan.jsp?success=add");
                
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String tanggal = request.getParameter("tanggal");
                String keterangan = request.getParameter("keterangan");
                String jenisInput = request.getParameter("jenis");
                String kategori = jenisInput; // Use jenis as kategori
                String jenisLaporan = request.getParameter("jenis_laporan"); // New parameter
                if (jenisLaporan == null || jenisLaporan.isEmpty()) jenisLaporan = "Masjid";

                String jenis = "Debit";
                if ("Pemasukan".equalsIgnoreCase(jenisInput)) {
                    jenis = "Kredit";
                } else if ("Pengeluaran".equalsIgnoreCase(jenisInput)) {
                    jenis = "Debit";
                }
                double jumlah = Double.parseDouble(request.getParameter("jumlah"));
                
                String sql = "UPDATE keuangan SET tanggal=?, keterangan=?, kategori=?, jenis=?, jumlah=?, jenis_laporan=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, tanggal);
                ps.setString(2, keterangan);
                ps.setString(3, kategori);
                ps.setString(4, jenis);
                ps.setDouble(5, jumlah);
                ps.setString(6, jenisLaporan);
                ps.setInt(7, id);
                ps.executeUpdate();
                ps.close();
                
                response.sendRedirect("admin/keuangan.jsp?success=edit");
                
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                
                String sql = "DELETE FROM keuangan WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                ps.executeUpdate();
                ps.close();
                
                response.sendRedirect("admin/keuangan.jsp?success=delete");
            }
            
        } catch (Exception e) {
            System.out.println("ERROR in KeuanganServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("admin/keuangan.jsp?error=1");
        } finally {
            if (con != null) {
                try { con.close(); } catch (Exception e) {}
            }
        }
    }
}
