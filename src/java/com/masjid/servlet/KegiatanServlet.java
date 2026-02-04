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

@WebServlet("/KegiatanServlet")
public class KegiatanServlet extends HttpServlet {
    
    // Check if admin is logged in
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
        
        try {
            Connection con = Koneksi.getKoneksi();
            
            if ("add".equals(action)) {
                // Tambah kegiatan baru
                String namaKegiatan = request.getParameter("nama_kegiatan");
                String tanggal = request.getParameter("tanggal");
                String waktu = request.getParameter("waktu");
                String deskripsi = request.getParameter("deskripsi");
                
                // Bidang otomatis dari role user yang login
                HttpSession session = request.getSession();
                String role = (String) session.getAttribute("adminRole");
                String bidang = "Imarah"; // default
                if ("Idarah".equals(role)) bidang = "Idarah";
                else if ("Imarah".equals(role)) bidang = "Imarah";
                else if ("Riayah".equals(role)) bidang = "Riayah";
                // Admin tetap bisa input semua, default Imarah
                
                String sql = "INSERT INTO kegiatan (nama_kegiatan, tanggal, waktu, deskripsi, bidang) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, namaKegiatan);
                ps.setString(2, tanggal);
                ps.setString(3, waktu);
                ps.setString(4, deskripsi);
                ps.setString(5, bidang);
                ps.executeUpdate();
                
                response.sendRedirect("admin/kegiatan.jsp?success=add");
                
            } else if ("edit".equals(action)) {
                // Edit kegiatan - bidang tidak diubah, tetap seperti aslinya
                int id = Integer.parseInt(request.getParameter("id"));
                String namaKegiatan = request.getParameter("nama_kegiatan");
                String tanggal = request.getParameter("tanggal");
                String waktu = request.getParameter("waktu");
                String deskripsi = request.getParameter("deskripsi");
                
                String sql = "UPDATE kegiatan SET nama_kegiatan=?, tanggal=?, waktu=?, deskripsi=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, namaKegiatan);
                ps.setString(2, tanggal);
                ps.setString(3, waktu);
                ps.setString(4, deskripsi);
                ps.setInt(5, id);
                ps.executeUpdate();
                
                response.sendRedirect("admin/kegiatan.jsp?success=edit");
                
            } else if ("delete".equals(action)) {
                // Hapus kegiatan
                int id = Integer.parseInt(request.getParameter("id"));
                
                String sql = "DELETE FROM kegiatan WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                ps.executeUpdate();
                
                response.sendRedirect("admin/kegiatan.jsp?success=delete");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/kegiatan.jsp?error=1");
        }
    }
}
