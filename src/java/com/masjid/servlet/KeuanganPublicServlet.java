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

@WebServlet("/api/keuangan")
public class KeuanganPublicServlet extends HttpServlet {
    
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
            json.append("{");
            
            // Get OVERALL totals (all time - no filter)
            double overallPemasukan = 0;
            double overallPengeluaran = 0;
            
            String sqlOverall = "SELECT kategori, SUM(jumlah) as total FROM keuangan GROUP BY kategori";
            PreparedStatement psOverall = con.prepareStatement(sqlOverall);
            ResultSet rsOverall = psOverall.executeQuery();
            while (rsOverall.next()) {
                String kat = rsOverall.getString("kategori");
                double total = rsOverall.getDouble("total");
                if ("Pemasukan".equalsIgnoreCase(kat)) {
                    overallPemasukan = total;
                } else {
                    overallPengeluaran = total;
                }
            }
            rsOverall.close();
            psOverall.close();
            
            double overallSaldo = overallPemasukan - overallPengeluaran;
            
            json.append("\"overallPemasukan\":").append(overallPemasukan).append(",");
            json.append("\"overallPengeluaran\":").append(overallPengeluaran).append(",");
            json.append("\"overallSaldo\":").append(overallSaldo).append(",");
            
            // Build WHERE clause for filters
            StringBuilder whereClause = new StringBuilder();
            boolean hasDateFilter = startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty();
            boolean hasSearch = search != null && !search.isEmpty();
            boolean hasKategori = kategori != null && !kategori.isEmpty();
            boolean hasFilter = hasDateFilter || hasSearch || hasKategori;
            
            if (hasFilter) {
                whereClause.append(" WHERE 1=1");
                if (hasDateFilter) {
                    whereClause.append(" AND tanggal BETWEEN ? AND ?");
                }
                if (hasSearch) {
                    whereClause.append(" AND keterangan LIKE ?");
                }
                if (hasKategori) {
                    whereClause.append(" AND kategori = ?");
                }
            }
            
            // Get FILTERED totals
            double totalPemasukan = 0;
            double totalPengeluaran = 0;
            
            String sqlSum = "SELECT kategori, SUM(jumlah) as total FROM keuangan" + whereClause.toString() + " GROUP BY kategori";
            PreparedStatement psSum = con.prepareStatement(sqlSum);
            int paramIdx = 1;
            if (hasDateFilter) {
                psSum.setString(paramIdx++, startDate);
                psSum.setString(paramIdx++, endDate);
            }
            if (hasSearch) {
                psSum.setString(paramIdx++, "%" + search + "%");
            }
            if (hasKategori) {
                psSum.setString(paramIdx++, kategori);
            }
            ResultSet rsSum = psSum.executeQuery();
            while (rsSum.next()) {
                String kat = rsSum.getString("kategori");
                double total = rsSum.getDouble("total");
                if ("Pemasukan".equalsIgnoreCase(kat)) {
                    totalPemasukan = total;
                } else {
                    totalPengeluaran = total;
                }
            }
            rsSum.close();
            psSum.close();
            
            double saldo = totalPemasukan - totalPengeluaran;
            
            json.append("\"filteredPemasukan\":").append(totalPemasukan).append(",");
            json.append("\"filteredPengeluaran\":").append(totalPengeluaran).append(",");
            json.append("\"filteredSaldo\":").append(saldo).append(",");
            json.append("\"hasFilter\":").append(hasFilter).append(",");
            
            // Get transactions
            json.append("\"transaksi\":[");
            
            String sqlList = "SELECT * FROM keuangan" + whereClause.toString() + " ORDER BY tanggal DESC, id DESC";
            PreparedStatement psList = con.prepareStatement(sqlList);
            paramIdx = 1;
            if (hasDateFilter) {
                psList.setString(paramIdx++, startDate);
                psList.setString(paramIdx++, endDate);
            }
            if (hasSearch) {
                psList.setString(paramIdx++, "%" + search + "%");
            }
            if (hasKategori) {
                psList.setString(paramIdx++, kategori);
            }
            ResultSet rsList = psList.executeQuery();
            
            boolean first = true;
            while (rsList.next()) {
                if (!first) json.append(",");
                first = false;
                
                int id = rsList.getInt("id");
                String tgl = rsList.getString("tanggal");
                String ket = escapeJson(rsList.getString("keterangan"));
                String kat = rsList.getString("kategori");
                String jns = "Debit";
                try { 
                    jns = rsList.getString("jenis"); 
                    if (jns == null) jns = "Debit"; 
                } catch (Exception ex) {}
                double jml = rsList.getDouble("jumlah");
                
                json.append("{");
                json.append("\"id\":").append(id).append(",");
                json.append("\"tanggal\":\"").append(tgl != null ? tgl : "").append("\",");
                json.append("\"keterangan\":\"").append(ket != null ? ket : "").append("\",");
                json.append("\"kategori\":\"").append(kat != null ? kat : "").append("\",");
                json.append("\"jenis\":\"").append(jns).append("\",");
                json.append("\"jumlah\":").append(jml);
                json.append("}");
            }
            rsList.close();
            psList.close();
            
            json.append("]}");
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
