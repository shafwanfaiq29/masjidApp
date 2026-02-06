package com.masjid.servlet;

import com.masjid.config.Koneksi;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/api/kegiatan")
public class KegiatanPublicServlet extends HttpServlet {
    
    private static final String[] NAMA_BULAN = {
        "Januari", "Februari", "Maret", "April", "Mei", "Juni",
        "Juli", "Agustus", "September", "Oktober", "November", "Desember"
    };
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String action = request.getParameter("action");
        String tahunStr = request.getParameter("tahun");
        String bulanStr = request.getParameter("bulan");
        
        int tahun = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
        if (tahunStr != null && !tahunStr.isEmpty()) {
            try {
                tahun = Integer.parseInt(tahunStr);
            } catch (NumberFormatException e) {}
        }
        
        Connection con = null;
        try {
            con = Koneksi.getKoneksi();
            
            if ("count".equals(action)) {
                // Hitung kegiatan per bulan untuk 12 bulan
                StringBuilder json = new StringBuilder();
                json.append("{\"tahun\":").append(tahun).append(",\"data\":[");
                
                for (int i = 1; i <= 12; i++) {
                    int count = 0;
                    String sql = "SELECT COUNT(*) as total FROM kegiatan WHERE YEAR(tanggal) = ? AND MONTH(tanggal) = ?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setInt(1, tahun);
                    ps.setInt(2, i);
                    ResultSet rs = ps.executeQuery();
                    if (rs.next()) {
                        count = rs.getInt("total");
                    }
                    rs.close();
                    ps.close();
                    
                    if (i > 1) json.append(",");
                    json.append("{\"bulan\":").append(i);
                    json.append(",\"nama\":\"").append(NAMA_BULAN[i-1]).append("\"");
                    json.append(",\"count\":").append(count).append("}");
                }
                json.append("]}");
                out.print(json.toString());
                
            } else if ("list".equals(action) && bulanStr != null) {
                // Ambil kegiatan per bulan tertentu
                int bulan = Integer.parseInt(bulanStr);
                StringBuilder json = new StringBuilder();
                json.append("{\"tahun\":").append(tahun);
                json.append(",\"bulan\":").append(bulan);
                json.append(",\"namaBulan\":\"").append(NAMA_BULAN[bulan-1]).append("\"");
                json.append(",\"data\":[");
                
                String sql = "SELECT * FROM kegiatan WHERE YEAR(tanggal) = ? AND MONTH(tanggal) = ? ORDER BY tanggal ASC";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, tahun);
                ps.setInt(2, bulan);
                ResultSet rs = ps.executeQuery();
                
                boolean first = true;
                while (rs.next()) {
                    if (!first) json.append(",");
                    first = false;
                    
                    String nama = rs.getString("nama_kegiatan");
                    String tgl = rs.getString("tanggal");
                    String waktu = rs.getString("waktu");
                    String desk = rs.getString("deskripsi");
                    
                    // Escape string untuk JSON
                    nama = escapeJson(nama);
                    waktu = escapeJson(waktu);
                    desk = escapeJson(desk);
                    
                    // Format tanggal
                    String displayDate = tgl;
                    try {
                        String[] parts = tgl.split("-");
                        if (parts.length >= 3) {
                            int day = Integer.parseInt(parts[2]);
                            int month = Integer.parseInt(parts[1]);
                            displayDate = day + " " + NAMA_BULAN[month-1] + " " + parts[0];
                        }
                    } catch (Exception e) {}
                    
                    json.append("{");
                    json.append("\"nama\":\"").append(nama).append("\"");
                    json.append(",\"tanggal\":\"").append(displayDate).append("\"");
                    json.append(",\"waktu\":\"").append(waktu != null ? waktu : "-").append("\"");
                    json.append(",\"deskripsi\":\"").append(desk != null ? desk : "").append("\"");
                    json.append("}");
                }
                rs.close();
                ps.close();
                
                json.append("]}");
                out.print(json.toString());
            }
            
        } catch (Exception e) {
            out.print("{\"error\":\"" + escapeJson(e.getMessage()) + "\"}");
        } finally {
            if (con != null) {
                try { con.close(); } catch (Exception ex) {}
            }
        }
    }
    
    private String escapeJson(String str) {
        if (str == null) return "";
        return str.replace("\\", "\\\\")
                  .replace("\"", "\\\"")
                  .replace("\n", "\\n")
                  .replace("\r", "\\r")
                  .replace("\t", "\\t");
    }
}
