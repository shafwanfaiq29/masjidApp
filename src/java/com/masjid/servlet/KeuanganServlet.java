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
import javax.servlet.http.HttpSession;

@WebServlet("/KeuanganServlet")
public class KeuanganServlet extends HttpServlet {
    
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("adminId") != null;
    }
    
    private String escapeJson(String input) {
        if (input == null) return "";
        return input.replace("\\", "\\\\")
                    .replace("\"", "\\\"")
                    .replace("\n", " ")
                    .replace("\r", " ")
                    .replace("\t", " ");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isLoggedIn(request)) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Unauthorized");
            return;
        }

        String action = request.getParameter("action");
        
        if ("get_data".equals(action)) {
            handleGetData(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid action");
        }
    }

    private void handleGetData(HttpServletRequest request, HttpServletResponse response) 
            throws IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();
        
        StringBuilder jsonOutput = new StringBuilder();
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            String startDate = request.getParameter("start");
            String endDate = request.getParameter("end");
            String search = request.getParameter("search");
            String kategori = request.getParameter("kategori");
            String jenisLaporan = request.getParameter("jenis_laporan");
            
            if (jenisLaporan == null || jenisLaporan.trim().isEmpty()) {
                jenisLaporan = "Masjid";
            }

            con = Koneksi.getKoneksi();
            if (con == null) {
                throw new Exception("No DB Connection");
            }

            // --- CALCULATION OF OVERALL TOTALS (ALL TIME) ---
            double overallPemasukan = 0;
            double overallPengeluaran = 0;

            String sqlOverall = "SELECT jenis, SUM(jumlah) as total FROM keuangan ";
            if ("Masjid".equals(jenisLaporan)) {
                sqlOverall += " WHERE (jenis_laporan = ? OR jenis_laporan IS NULL OR jenis_laporan = '')";
            } else {
                sqlOverall += " WHERE jenis_laporan = ?";
            }
            sqlOverall += " GROUP BY jenis";

            ps = con.prepareStatement(sqlOverall);
            ps.setString(1, jenisLaporan);
            rs = ps.executeQuery();

            while (rs.next()) {
                String jns = rs.getString("jenis");
                if (jns == null) jns = "";
                double total = rs.getDouble("total");

                if ("Kredit".equalsIgnoreCase(jns) || "Pemasukan".equalsIgnoreCase(jns)) {
                    overallPemasukan += total;
                } else if ("Debit".equalsIgnoreCase(jns) || "Pengeluaran".equalsIgnoreCase(jns)) {
                    overallPengeluaran += total;
                }
            }
            rs.close();
            ps.close();

            double overallSaldo = overallPemasukan - overallPengeluaran;

            // --- FILTER LOGIC ---
            StringBuilder whereClause = new StringBuilder();
            if ("Masjid".equals(jenisLaporan)) {
                whereClause.append(" WHERE (jenis_laporan = ? OR jenis_laporan IS NULL OR jenis_laporan = '')");
            } else {
                whereClause.append(" WHERE jenis_laporan = ?");
            }

            boolean hasDateFilter = (startDate != null && !startDate.isEmpty() && endDate != null && !endDate.isEmpty());
            boolean hasSearch = (search != null && !search.isEmpty());
            boolean hasKategori = (kategori != null && !kategori.isEmpty());
            boolean hasFilter = hasDateFilter || hasSearch || hasKategori;

            if (hasDateFilter) {
                whereClause.append(" AND tanggal BETWEEN ? AND ?");
            }
            if (hasSearch) {
                whereClause.append(" AND keterangan LIKE ?");
            }
            if (hasKategori) {
                whereClause.append(" AND kategori = ?");
            }

            // --- CALCULATION OF FILTERED TOTALS ---
            double filteredPemasukan = 0;
            double filteredPengeluaran = 0;

            String sqlSum = "SELECT jenis, SUM(jumlah) as total FROM keuangan " + whereClause.toString() + " GROUP BY jenis";
            ps = con.prepareStatement(sqlSum);
            
            int idx = 1;
            ps.setString(idx++, jenisLaporan);
            if (hasDateFilter) {
                ps.setString(idx++, startDate);
                ps.setString(idx++, endDate);
            }
            if (hasSearch) {
                ps.setString(idx++, "%" + search + "%");
            }
            if (hasKategori) {
                ps.setString(idx++, kategori);
            }

            rs = ps.executeQuery();
            while (rs.next()) {
                String jns = rs.getString("jenis");
                if (jns == null) jns = "";
                double total = rs.getDouble("total");

                if ("Kredit".equalsIgnoreCase(jns) || "Pemasukan".equalsIgnoreCase(jns)) {
                    filteredPemasukan += total;
                } else if ("Debit".equalsIgnoreCase(jns) || "Pengeluaran".equalsIgnoreCase(jns)) {
                    filteredPengeluaran += total;
                }
            }
            rs.close();
            ps.close();

            double filteredSaldo = filteredPemasukan - filteredPengeluaran;

            // --- FETCH TRANSACTIONS LIST ---
            StringBuilder jsonList = new StringBuilder();
            jsonList.append("[");

            String sqlList = "SELECT * FROM keuangan " + whereClause.toString() + " ORDER BY tanggal DESC, id DESC";
            ps = con.prepareStatement(sqlList);
            
            idx = 1;
            ps.setString(idx++, jenisLaporan);
            if (hasDateFilter) {
                ps.setString(idx++, startDate);
                ps.setString(idx++, endDate);
            }
            if (hasSearch) {
                ps.setString(idx++, "%" + search + "%");
            }
            if (hasKategori) {
                ps.setString(idx++, kategori);
            }

            rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    jsonList.append(",");
                }
                first = false;

                int id = rs.getInt("id");
                String tgl = rs.getString("tanggal");
                String ket = escapeJson(rs.getString("keterangan"));
                String kat = escapeJson(rs.getString("kategori"));
                
                String jns = rs.getString("jenis");
                if (jns == null) jns = "";
                
                String displayJenis = jns;
                if ("Kredit".equalsIgnoreCase(jns)) displayJenis = "Pemasukan";
                else if ("Debit".equalsIgnoreCase(jns)) displayJenis = "Pengeluaran";

                double jml = rs.getDouble("jumlah");

                jsonList.append("{");
                jsonList.append("\"id\":").append(id).append(",");
                jsonList.append("\"tanggal\":\"").append(tgl).append("\",");
                jsonList.append("\"keterangan\":\"").append(ket).append("\",");
                jsonList.append("\"kategori\":\"").append(kat).append("\",");
                jsonList.append("\"jenis\":\"").append(displayJenis).append("\",");
                jsonList.append("\"jumlah\":").append(jml);
                jsonList.append("}");
            }
            jsonList.append("]");

            // --- CONSTRUCT FINAL JSON ---
            jsonOutput.append("{");
            jsonOutput.append("\"status\":\"success\",");
            jsonOutput.append("\"jenisLaporan\":\"").append(jenisLaporan).append("\",");
            jsonOutput.append("\"overallPemasukan\":").append(overallPemasukan).append(",");
            jsonOutput.append("\"overallPengeluaran\":").append(overallPengeluaran).append(",");
            jsonOutput.append("\"overallSaldo\":").append(overallSaldo).append(",");
            jsonOutput.append("\"hasFilter\":").append(hasFilter).append(",");
            jsonOutput.append("\"filteredPemasukan\":").append(filteredPemasukan).append(",");
            jsonOutput.append("\"filteredPengeluaran\":").append(filteredPengeluaran).append(",");
            jsonOutput.append("\"filteredSaldo\":").append(filteredSaldo).append(",");
            jsonOutput.append("\"transaksi\":").append(jsonList.toString());
            jsonOutput.append("}");

            out.print(jsonOutput.toString());

        } catch (Exception e) {
            String msg = escapeJson(e.getMessage());
            if (msg.isEmpty()) msg = "Unknown Server Error " + e.getClass().getName();
            
            out.print("{\"error\":\"" + msg + "\"}");
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) {}
            if (ps != null) try { ps.close(); } catch (Exception e) {}
            if (con != null) try { con.close(); } catch (Exception e) {}
        }
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
        String redirectUrl = "admin/keuangan.jsp";
        
        // Get jenis_laporan early
        String jenisLaporan = request.getParameter("jenis_laporan");
        if (jenisLaporan == null || jenisLaporan.trim().isEmpty()) {
            jenisLaporan = "Masjid";
        }
        
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
                String kategori = jenisInput;
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
                
                redirectUrl += "?success=add";
                
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String tanggal = request.getParameter("tanggal");
                String keterangan = request.getParameter("keterangan");
                String jenisInput = request.getParameter("jenis");
                String kategori = jenisInput;
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
                
                redirectUrl += "?success=edit";
                
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                
                String sql = "DELETE FROM keuangan WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                ps.executeUpdate();
                ps.close();
                
                redirectUrl += "?success=delete";
            }
            
            // Append jenis_laporan to redirect URL
            String encodedJenis = java.net.URLEncoder.encode(jenisLaporan, "UTF-8");
            if (redirectUrl.contains("?")) {
                redirectUrl += "&jenis_laporan=" + encodedJenis;
            } else {
                redirectUrl += "?jenis_laporan=" + encodedJenis;
            }
            
            response.sendRedirect(redirectUrl);
            
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
