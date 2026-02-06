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

@WebServlet("/api/arsip")
public class ArsipPublicServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String startDate = request.getParameter("start");
        String endDate = request.getParameter("end");
        String search = request.getParameter("search");
        String kategori = request.getParameter("kategori");
        
        Connection con = null;
        try {
            con = Koneksi.getKoneksi();
            StringBuilder json = new StringBuilder();
            json.append("{\"data\":[");
            
            // Build dynamic query
            StringBuilder sql = new StringBuilder("SELECT * FROM arsip WHERE 1=1");
            
            if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                sql.append(" AND tanggal_upload BETWEEN ? AND ?");
            }
            if (search != null && !search.isEmpty()) {
                sql.append(" AND (nama_dokumen LIKE ? OR deskripsi LIKE ?)");
            }
            if (kategori != null && !kategori.isEmpty()) {
                sql.append(" AND kategori = ?");
            }
            sql.append(" ORDER BY created_at DESC");
            
            PreparedStatement ps = con.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                ps.setString(paramIndex++, startDate);
                ps.setString(paramIndex++, endDate);
            }
            if (search != null && !search.isEmpty()) {
                String searchPattern = "%" + search + "%";
                ps.setString(paramIndex++, searchPattern);
                ps.setString(paramIndex++, searchPattern);
            }
            if (kategori != null && !kategori.isEmpty()) {
                ps.setString(paramIndex++, kategori);
            }
            
            ResultSet rs = ps.executeQuery();
            
            boolean first = true;
            int count = 0;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                count++;
                
                int id = rs.getInt("id");
                String namaDokumen = escapeJson(rs.getString("nama_dokumen"));
                String kat = escapeJson(rs.getString("kategori"));
                String deskripsi = escapeJson(rs.getString("deskripsi"));
                String tanggal = rs.getString("tanggal_upload");
                
                json.append("{");
                json.append("\"id\":").append(id).append(",");
                json.append("\"nama_dokumen\":\"").append(namaDokumen != null ? namaDokumen : "").append("\",");
                json.append("\"kategori\":\"").append(kat != null ? kat : "").append("\",");
                json.append("\"deskripsi\":\"").append(deskripsi != null ? deskripsi : "-").append("\",");
                json.append("\"tanggal\":\"").append(tanggal != null ? tanggal : "").append("\"");
                json.append("}");
            }
            rs.close();
            ps.close();
            
            json.append("],\"count\":").append(count).append("}");
            out.print(json.toString());
            
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
