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

@WebServlet("/api/kegiatan-admin")
public class KegiatanAdminServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        String startDate = request.getParameter("start");
        String endDate = request.getParameter("end");
        String search = request.getParameter("search");
        String bidang = request.getParameter("bidang");
        
        Connection con = null;
        try {
            con = Koneksi.getKoneksi();
            StringBuilder json = new StringBuilder();
            json.append("{\"data\":[");
            
            // Build dynamic query
            StringBuilder sql = new StringBuilder("SELECT * FROM kegiatan WHERE 1=1");
            
            if (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty()) {
                sql.append(" AND tanggal BETWEEN ? AND ?");
            }
            if (search != null && !search.isEmpty()) {
                sql.append(" AND (nama_kegiatan LIKE ? OR deskripsi LIKE ?)");
            }
            if (bidang != null && !bidang.isEmpty()) {
                sql.append(" AND bidang = ?");
            }
            sql.append(" ORDER BY tanggal ASC");
            
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
            if (bidang != null && !bidang.isEmpty()) {
                ps.setString(paramIndex++, bidang);
            }
            
            ResultSet rs = ps.executeQuery();
            
            boolean first = true;
            int count = 0;
            while (rs.next()) {
                if (!first) json.append(",");
                first = false;
                count++;
                
                int id = rs.getInt("id");
                String nama = escapeJson(rs.getString("nama_kegiatan"));
                String tgl = rs.getString("tanggal");
                String wkt = rs.getString("waktu");
                String desk = escapeJson(rs.getString("deskripsi"));
                String bid = "Imarah";
                try { 
                    bid = rs.getString("bidang"); 
                    if (bid == null) bid = "Imarah"; 
                } catch (Exception ex) {}
                
                json.append("{");
                json.append("\"id\":").append(id).append(",");
                json.append("\"nama_kegiatan\":\"").append(nama != null ? nama : "").append("\",");
                json.append("\"tanggal\":\"").append(tgl != null ? tgl : "").append("\",");
                json.append("\"waktu\":\"").append(wkt != null ? wkt : "").append("\",");
                json.append("\"deskripsi\":\"").append(desk != null ? desk : "").append("\",");
                json.append("\"bidang\":\"").append(bid).append("\"");
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
