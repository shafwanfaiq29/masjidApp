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
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background: linear-gradient(135deg, #f8faf9 0%, #e8f5e9 100%); color: #333; min-height: 100vh; }
        nav { background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 100%); padding: 0; position: sticky; top: 0; z-index: 100; box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15); }
        .nav-container { max-width: 1200px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between; align-items: center; }
        .nav-brand { color: white; font-size: 1.4rem; font-weight: 700; text-decoration: none; display: flex; align-items: center; gap: 12px; padding: 18px 0; }
        .nav-brand i { font-size: 1.6rem; color: #ffd700; }
        .nav-links { display: flex; gap: 5px; }
        .nav-links a { color: rgba(255, 255, 255, 0.85); text-decoration: none; font-weight: 500; transition: all 0.3s; padding: 20px 22px; display: flex; align-items: center; gap: 8px; position: relative; }
        .nav-links a i { font-size: 1.1rem; }
        .nav-links a::after { content: ''; position: absolute; bottom: 0; left: 50%; width: 0; height: 3px; background: #ffd700; transition: all 0.3s ease; transform: translateX(-50%); }
        .nav-links a:hover, .nav-links a.active { color: white; background: rgba(255, 255, 255, 0.1); }
        .nav-links a:hover::after, .nav-links a.active::after { width: 60%; }
        .hero { background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 50%, #1a7544 100%); padding: 70px 20px; text-align: center; color: white; }
        .hero-content { position: relative; z-index: 1; }
        .hero-icon { font-size: 60px; color: #ffd700; margin-bottom: 20px; text-shadow: 0 0 30px rgba(255, 215, 0, 0.4); }
        .hero h1 { font-size: 2.5rem; margin-bottom: 12px; font-weight: 700; }
        .hero p { color: rgba(255, 255, 255, 0.9); font-size: 1.1rem; max-width: 500px; margin: 0 auto; }
        .container { max-width: 1200px; margin: 0 auto; padding: 50px 20px; }
        .summary-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 25px; margin-bottom: 50px; }
        .summary-card { background: white; border-radius: 20px; padding: 35px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06); text-align: center; position: relative; overflow: hidden; transition: all 0.3s ease; }
        .summary-card:hover { transform: translateY(-5px); box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1); }
        .summary-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 5px; }
        .summary-card.pemasukan::before { background: linear-gradient(90deg, #4caf50, #81c784); }
        .summary-card.pengeluaran::before { background: linear-gradient(90deg, #f44336, #e57373); }
        .summary-card.saldo::before { background: linear-gradient(90deg, #ff9800, #ffb74d); }
        .summary-card .icon-wrapper { width: 70px; height: 70px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 20px; font-size: 30px; }
        .summary-card.pemasukan .icon-wrapper { background: linear-gradient(135deg, #e8f5e9, #c8e6c9); color: #4caf50; }
        .summary-card.pengeluaran .icon-wrapper { background: linear-gradient(135deg, #ffebee, #ffcdd2); color: #f44336; }
        .summary-card.saldo .icon-wrapper { background: linear-gradient(135deg, #fff3e0, #ffe0b2); color: #ff9800; }
        .summary-card h3 { color: #666; font-size: 0.95rem; margin-bottom: 12px; text-transform: uppercase; letter-spacing: 1px; font-weight: 500; }
        .summary-card .amount { font-size: 1.9rem; font-weight: 700; }
        .summary-card.pemasukan .amount { color: #4caf50; }
        .summary-card.pengeluaran .amount { color: #f44336; }
        .summary-card.saldo .amount { color: #ff9800; }
        .section-title { font-size: 1.5rem; color: #333; margin-bottom: 25px; display: flex; align-items: center; gap: 12px; }
        .section-title i { color: #1a5d3a; }
        .table-container { background: white; border-radius: 20px; padding: 30px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06); overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 600px; }
        thead { background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%); }
        th { padding: 18px 20px; text-align: left; font-weight: 600; color: #555; border-bottom: 2px solid #e8e8e8; font-size: 0.9rem; }
        td { padding: 18px 20px; border-bottom: 1px solid #f0f0f0; }
        tr { transition: background 0.2s ease; }
        tr:hover { background: #fafafa; }
        .badge { display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; border-radius: 20px; font-size: 0.85rem; font-weight: 500; }
        .badge.pemasukan { background: linear-gradient(135deg, #e8f5e9, #c8e6c9); color: #388e3c; }
        .badge.pengeluaran { background: linear-gradient(135deg, #ffebee, #ffcdd2); color: #d32f2f; }
        .badge.debit { background: linear-gradient(135deg, #fff3e0, #ffe0b2); color: #f57c00; }
        .badge.kredit { background: linear-gradient(135deg, #e3f2fd, #bbdefb); color: #1976d2; }
        .amount-cell { text-align: right; font-weight: 600; font-family: 'Courier New', monospace; font-size: 0.95rem; }
        .no-data { text-align: center; padding: 60px; color: #999; }
        .no-data i { font-size: 50px; margin-bottom: 15px; color: #ddd; display: block; }
        footer { background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 100%); color: white; text-align: center; padding: 30px; margin-top: 50px; }
        footer p { display: flex; align-items: center; justify-content: center; gap: 10px; font-size: 0.95rem; }
        footer i { color: #ffd700; }
        @media (max-width: 768px) { .nav-links { display: none; } .hero h1 { font-size: 1.8rem; } .hero-icon { font-size: 45px; } .summary-cards { grid-template-columns: 1fr; } }
            </style>
</head>
<body>
    <nav>
        <div class="nav-container">
            <a href="index.jsp" class="nav-brand">
                <i class="fas fa-mosque"></i>
                Masjid Jabalussalam
            </a>
            <div class="nav-links">
                <a href="index.jsp"><i class="fas fa-home"></i> Beranda</a>
                <a href="kegiatan.jsp"><i class="fas fa-calendar-days"></i> Kegiatan</a>
                <a href="keuangan.jsp" class="active"><i class="fas fa-money-bill-wave"></i> Keuangan</a>
                <a href="pilih-role.jsp"><i class="fas fa-right-to-bracket"></i> Login Admin</a>
            </div>
        </div>
    </nav>

    <div class="hero">
        <div class="hero-content">
            <div class="hero-icon">
                <i class="fas fa-money-bill-wave"></i>
            </div>
            <h1>Laporan Keuangan</h1>
            <p>Transparansi pengelolaan keuangan Masjid Jabalussalam</p>
        </div>
    </div>

    <div class="container">
        <div class="summary-cards">
            <div class="summary-card pemasukan">
                <div class="icon-wrapper"><i class="fas fa-arrow-trend-up"></i></div>
                <h3>Total Pemasukan</h3>
                <div class="amount"><%= formatRupiah.format(totalPemasukan) %></div>
            </div>
            <div class="summary-card pengeluaran">
                <div class="icon-wrapper"><i class="fas fa-arrow-trend-down"></i></div>
                <h3>Total Pengeluaran</h3>
                <div class="amount"><%= formatRupiah.format(totalPengeluaran) %></div>
            </div>
            <div class="summary-card saldo">
                <div class="icon-wrapper"><i class="fas fa-wallet"></i></div>
                <h3>Sisa Saldo Kas</h3>
                <div class="amount"><%= formatRupiah.format(saldo) %></div>
            </div>
        </div>

        <h2 class="section-title"><i class="fas fa-list-ul"></i> Riwayat Transaksi</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-calendar"></i> Tanggal</th>
                        <th><i class="fas fa-file-alt"></i> Keterangan</th>
                        <th><i class="fas fa-tag"></i> Kategori</th>
                        <th><i class="fas fa-exchange-alt"></i> Jenis</th>
                        <th style="text-align:right;"><i class="fas fa-money-bill"></i> Jumlah</th>
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
        while (rsList.next()) {
            hasData = true;
            String tgl = rsList.getString("tanggal");
            String ket = rsList.getString("keterangan");
            String kat = rsList.getString("kategori");
            String jns = "Debit";
            try { jns = rsList.getString("jenis"); if (jns == null) jns = "Debit"; } catch (Exception ex) {}
            double jml = rsList.getDouble("jumlah");
            String katIcon = kat.equalsIgnoreCase("Pemasukan") ? "fa-arrow-up" : "fa-arrow-down";
            String jnsIcon = jns.equalsIgnoreCase("Debit") ? "fa-plus" : "fa-minus";
%>
                    <tr>
                        <td><%= tgl %></td>
                        <td><%= ket %></td>
                        <td><span class="badge <%= kat.toLowerCase() %>"><i class="fas <%= katIcon %>"></i> <%= kat %></span></td>
                        <td><span class="badge <%= jns.toLowerCase() %>"><i class="fas <%= jnsIcon %>"></i> <%= jns %></span></td>
                        <td class="amount-cell"><%= formatRupiah.format(jml) %></td>
                    </tr>
<%
        }
        rsList.close();
        stList.close();
    } else {
%>
                    <tr><td colspan="5" class="no-data"><i class="fas fa-database"></i>Koneksi database gagal</td></tr>
<%
    }
} catch (Exception e) {
%>
                    <tr><td colspan="5" class="no-data"><i class="fas fa-exclamation-triangle"></i>Error: <%= e.getMessage() %></td></tr>
<%
    e.printStackTrace();
} finally {
    if (conList != null) try { conList.close(); } catch (Exception e) {}
}
if (!hasData) {
%>
                    <tr><td colspan="5" class="no-data"><i class="fas fa-inbox"></i>Belum ada data transaksi</td></tr>
<%
}
%>
                </tbody>
            </table>
        </div>
    </div>

    <footer>
        <p><i class="fas fa-mosque"></i> Masjid Jabalussalam - Transparansi Keuangan</p>
    </footer>
</body>
</html>


