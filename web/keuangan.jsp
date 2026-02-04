<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.sql.*"%>
<%@page import="com.masjid.config.Koneksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    Locale localeID = new Locale("in", "ID");
    NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);
    
    double totalPemasukan = 0, totalPengeluaran = 0;
    Connection conSum = null;
    try {
        conSum = Koneksi.getKoneksi();
        if (conSum != null) {
            Statement st = conSum.createStatement();
            ResultSet rs = st.executeQuery("SELECT kategori, SUM(jumlah) as total FROM keuangan GROUP BY kategori");
            while (rs.next()) {
                if ("Pemasukan".equalsIgnoreCase(rs.getString("kategori"))) {
                    totalPemasukan = rs.getDouble("total");
                } else {
                    totalPengeluaran = rs.getDouble("total");
                }
            }
            rs.close();
            st.close();
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (conSum != null) try { conSum.close(); } catch (Exception e) {}
    }
    double saldo = totalPemasukan - totalPengeluaran;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Keuangan - Masjid Jabalussalam</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background: #f5f5f5; color: #333; }
        nav { background: linear-gradient(135deg, #1a5d3a, #0d3320); padding: 15px 0; position: sticky; top: 0; z-index: 100; }
        .nav-container { max-width: 1200px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between; align-items: center; }
        .nav-brand { color: white; font-size: 1.5rem; font-weight: 700; text-decoration: none; }
        .nav-links { display: flex; gap: 30px; }
        .nav-links a { color: rgba(255,255,255,0.8); text-decoration: none; font-weight: 500; transition: color 0.3s; }
        .nav-links a:hover, .nav-links a.active { color: white; }
        .hero { background: linear-gradient(135deg, #1a5d3a, #0d3320); padding: 60px 20px; text-align: center; color: white; }
        .hero h1 { font-size: 2.5rem; margin-bottom: 10px; }
        .hero p { color: rgba(255,255,255,0.8); font-size: 1.1rem; }
        .container { max-width: 1200px; margin: 0 auto; padding: 40px 20px; }
        .summary-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .summary-card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); text-align: center; }
        .summary-card.pemasukan { border-top: 5px solid #4caf50; }
        .summary-card.pengeluaran { border-top: 5px solid #f44336; }
        .summary-card.saldo { border-top: 5px solid #ff9800; }
        .summary-card .icon { font-size: 40px; margin-bottom: 15px; }
        .summary-card h3 { color: #666; font-size: 0.9rem; margin-bottom: 10px; text-transform: uppercase; letter-spacing: 1px; }
        .summary-card .amount { font-size: 1.8rem; font-weight: 700; }
        .summary-card.pemasukan .amount { color: #4caf50; }
        .summary-card.pengeluaran .amount { color: #f44336; }
        .summary-card.saldo .amount { color: #ff9800; }
        .section-title { font-size: 1.5rem; color: #333; margin-bottom: 25px; }
        .table-container { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 600px; }
        thead { background: #f8f9fa; }
        th { padding: 15px 20px; text-align: left; font-weight: 600; color: #555; border-bottom: 2px solid #e8e8e8; }
        td { padding: 15px 20px; border-bottom: 1px solid #f0f0f0; }
        tr:hover { background: #fafafa; }
        .badge { display: inline-block; padding: 5px 15px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; }
        .badge.pemasukan { background: #e8f5e9; color: #4caf50; }
        .badge.pengeluaran { background: #ffebee; color: #f44336; }
        .badge.debit { background: #fff3e0; color: #ff9800; }
        .badge.kredit { background: #e3f2fd; color: #1976d2; }
        .amount-cell { text-align: right; font-weight: 600; font-family: 'Courier New', monospace; }
        .no-data { text-align: center; padding: 50px; color: #999; }
        footer { background: #1a5d3a; color: white; text-align: center; padding: 30px; margin-top: 50px; }
        @media (max-width: 768px) {
            .nav-links { display: none; }
            .hero h1 { font-size: 1.8rem; }
        }
    </style>
</head>
<body>
    <nav>
        <div class="nav-container">
            <a href="index.jsp" class="nav-brand">Masjid Jabalussalam</a>
            <div class="nav-links">
                <a href="index.jsp">Beranda</a>
                <a href="kegiatan.jsp">Kegiatan</a>
                <a href="keuangan.jsp" class="active">Keuangan</a>
                <a href="pilih-role.jsp">Login Admin</a>
            </div>
        </div>
    </nav>
    
    <div class="hero">
        <h1>Laporan Keuangan</h1>
        <p>Transparansi pengelolaan keuangan Masjid Jabalussalam</p>
    </div>
    
    <div class="container">
        <div class="summary-cards">
            <div class="summary-card pemasukan">
                <div class="icon">+</div>
                <h3>Total Pemasukan</h3>
                <div class="amount"><%= formatRupiah.format(totalPemasukan) %></div>
            </div>
            <div class="summary-card pengeluaran">
                <div class="icon">-</div>
                <h3>Total Pengeluaran</h3>
                <div class="amount"><%= formatRupiah.format(totalPengeluaran) %></div>
            </div>
            <div class="summary-card saldo">
                <div class="icon">=</div>
                <h3>Sisa Saldo Kas</h3>
                <div class="amount"><%= formatRupiah.format(saldo) %></div>
            </div>
        </div>
        
        <h2 class="section-title">Riwayat Transaksi</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Tanggal</th>
                        <th>Keterangan</th>
                        <th>Kategori</th>
                        <th>Jenis</th>
                        <th style="text-align:right;">Jumlah</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    boolean hasData = false;
                    Connection conList = null;
                    try {
                        conList = Koneksi.getKoneksi();
                        if (conList != null) {
                            Statement stList = conList.createStatement();
                            ResultSet rsList = stList.executeQuery("SELECT * FROM keuangan ORDER BY tanggal DESC, id DESC");
                            while(rsList.next()) {
                                hasData = true;
                                String tgl = rsList.getString("tanggal");
                                String ket = rsList.getString("keterangan");
                                String kat = rsList.getString("kategori");
                                String jns = "Debit";
                                try { jns = rsList.getString("jenis"); if (jns == null) jns = "Debit"; } catch (Exception ex) {}
                                double jml = rsList.getDouble("jumlah");
                %>
                    <tr>
                        <td><%= tgl %></td>
                        <td><%= ket %></td>
                        <td><span class="badge <%= kat.toLowerCase() %>"><%= kat %></span></td>
                        <td><span class="badge <%= jns.toLowerCase() %>"><%= jns %></span></td>
                        <td class="amount-cell"><%= formatRupiah.format(jml) %></td>
                    </tr>
                <%
                            }
                            rsList.close();
                            stList.close();
                        } else {
                            out.println("<tr><td colspan='5' class='no-data'>Koneksi database gagal</td></tr>");
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='5' class='no-data'>Error: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace();
                    } finally {
                        if (conList != null) try { conList.close(); } catch (Exception e) {}
                    }
                    if (!hasData) {
                %>
                    <tr><td colspan="5" class="no-data">Belum ada data transaksi</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <footer>
        <p>Masjid Jabalussalam</p>
    </footer>
</body>
</html>
