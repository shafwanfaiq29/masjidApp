<%@page import="java.sql.*" %>
<%@page import="com.masjid.config.Koneksi" %>
<%@page contentType="text/html" pageEncoding="UTF-8" %>
<% 
    if (session.getAttribute("adminId")==null) { 
        response.sendRedirect("../login.jsp"); 
        return; 
    }
    
    request.setCharacterEncoding("UTF-8");
    String action = request.getParameter("action");
    String redirectUrl = "keuangan.jsp";
    Connection con = null;
    PreparedStatement ps = null;
    
    // Get jenis_laporan early to use in redirect
    String jenisLaporan = request.getParameter("jenis_laporan");
    if (jenisLaporan == null || jenisLaporan.trim().isEmpty()) {
        jenisLaporan = "Masjid";
    }

    try {
        con = Koneksi.getKoneksi();
        if (con == null) {
            throw new Exception("Database connection failed");
        }

        if ("add".equals(action)) {
            String tanggal = request.getParameter("tanggal");
            String keterangan = request.getParameter("keterangan");
            String jumlahStr = request.getParameter("jumlah");
            String jenisInput = request.getParameter("jenis");
            String kategori = jenisInput;
            String jenis = "Debit";
            
            if ("Pemasukan".equalsIgnoreCase(jenisInput)) {
                jenis = "Kredit";
            } else if ("Pengeluaran".equalsIgnoreCase(jenisInput)) {
                jenis = "Debit";
            }
            
            if (jumlahStr == null || jumlahStr.isEmpty()) {
                throw new Exception("Jumlah harus diisi");
            }
            double jumlah = Double.parseDouble(jumlahStr);
            
            String sql = "INSERT INTO keuangan (tanggal, keterangan, kategori, jenis, jumlah, jenis_laporan) VALUES (?, ?, ?, ?, ?, ?)";
            ps = con.prepareStatement(sql);
            ps.setString(1, tanggal);
            ps.setString(2, keterangan);
            ps.setString(3, kategori);
            ps.setString(4, jenis);
            ps.setDouble(5, jumlah);
            ps.setString(6, jenisLaporan);
            ps.executeUpdate();
            
            redirectUrl += "?success=add";
            
        } else if ("edit".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr == null) throw new Exception("ID not found");
            int id = Integer.parseInt(idStr);
            
            String tanggal = request.getParameter("tanggal");
            String keterangan = request.getParameter("keterangan");
            String jumlahStr = request.getParameter("jumlah");
            String jenisInput = request.getParameter("jenis");
            String kategori = jenisInput;
            String jenis = "Debit";
            
            if ("Pemasukan".equalsIgnoreCase(jenisInput)) {
                jenis = "Kredit";
            } else if ("Pengeluaran".equalsIgnoreCase(jenisInput)) {
                jenis = "Debit";
            }
            double jumlah = Double.parseDouble(jumlahStr);
            
            String sql = "UPDATE keuangan SET tanggal=?, keterangan=?, kategori=?, jenis=?, jumlah=?, jenis_laporan=? WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setString(1, tanggal);
            ps.setString(2, keterangan);
            ps.setString(3, kategori);
            ps.setString(4, jenis);
            ps.setDouble(5, jumlah);
            ps.setString(6, jenisLaporan);
            ps.setInt(7, id);
            ps.executeUpdate();
            
            redirectUrl += "?success=edit";
            
        } else if ("delete".equals(action)) {
            String idStr = request.getParameter("id");
            if (idStr == null) throw new Exception("ID not found");
            int id = Integer.parseInt(idStr);
            
            String sql = "DELETE FROM keuangan WHERE id=?";
            ps = con.prepareStatement(sql);
            ps.setInt(1, id);
            ps.executeUpdate();
            
            redirectUrl += "?success=delete";
        }
        
    } catch (Exception e) {
        e.printStackTrace();
        String msg = e.getMessage();
        if (msg == null) msg = "Unknown Error";
        msg = msg.replace("'", "").replace("\"", "");
        redirectUrl += "?error=custom&msg=" + java.net.URLEncoder.encode(msg, "UTF-8");
    } finally {
        if (ps != null) try { ps.close(); } catch (Exception e) {}
        if (con != null) try { con.close(); } catch (Exception e) {}
    }

    // Append jenis_laporan to redirect URL
    if (redirectUrl.contains("?")) {
        redirectUrl += "&jenis_laporan=" + java.net.URLEncoder.encode(jenisLaporan, "UTF-8");
    } else {
        redirectUrl += "?jenis_laporan=" + java.net.URLEncoder.encode(jenisLaporan, "UTF-8");
    }

    response.sendRedirect(redirectUrl);
%>
