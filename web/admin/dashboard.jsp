<%@page import="java.sql.*"%>
<%@page import="com.masjid.config.Koneksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
    String adminNama = (String) session.getAttribute("adminNama");
    if (adminNama == null) adminNama = "Admin";
    
    int totalKegiatan = 0;
    double totalPemasukan = 0;
    double totalPengeluaran = 0;
    double saldo = 0;
    
    try {
        Connection con = Koneksi.getKoneksi();
        if (con != null) {
            Statement st1 = con.createStatement();
            ResultSet rs1 = st1.executeQuery("SELECT COUNT(*) as total FROM kegiatan");
            if (rs1.next()) {
                totalKegiatan = rs1.getInt("total");
            }
            
            Statement st2 = con.createStatement();
            ResultSet rs2 = st2.executeQuery("SELECT kategori, SUM(jumlah) as total FROM keuangan GROUP BY kategori");
            while (rs2.next()) {
                String kategori = rs2.getString("kategori");
                double total = rs2.getDouble("total");
                if ("Pemasukan".equalsIgnoreCase(kategori)) {
                    totalPemasukan = total;
                } else {
                    totalPengeluaran = total;
                }
            }
            saldo = totalPemasukan - totalPengeluaran;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    
    java.text.NumberFormat formatRupiah = java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("in", "ID"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Masjid Jabalussalam</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background: #f0f2f5; min-height: 100vh; }
        .sidebar { position: fixed; left: 0; top: 0; width: 260px; height: 100vh; background: linear-gradient(180deg, #1a5d3a 0%, #0d3320 100%); padding: 20px; z-index: 100; }
        .sidebar-header { text-align: center; padding: 20px 0 30px; border-bottom: 1px solid rgba(255,255,255,0.1); margin-bottom: 30px; }
        .sidebar-header h2 { color: white; font-size: 1.1rem; font-weight: 600; }
        .sidebar-header p { color: rgba(255,255,255,0.6); font-size: 0.8rem; }
        .nav-menu { list-style: none; }
        .nav-menu li { margin-bottom: 8px; }
        .nav-menu a { display: flex; align-items: center; padding: 14px 18px; color: rgba(255,255,255,0.8); text-decoration: none; border-radius: 10px; transition: all 0.3s ease; font-size: 0.95rem; }
        .nav-menu a:hover, .nav-menu a.active { background: rgba(255,255,255,0.15); color: white; }
        .nav-menu .logout { margin-top: 30px; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 20px; }
        .nav-menu .logout a { color: #ff6b6b; }
        .main-content { margin-left: 260px; padding: 30px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
        .header h1 { color: #333; font-size: 1.8rem; }
        .header .welcome { color: #666; font-size: 0.95rem; }
        .header .welcome strong { color: #1a5d3a; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 25px; margin-bottom: 40px; }
        .stat-card { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 20px; }
        .stat-card .icon-box { width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 28px; }
        .stat-card.kegiatan .icon-box { background: #e3f2fd; }
        .stat-card.pemasukan .icon-box { background: #e8f5e9; }
        .stat-card.pengeluaran .icon-box { background: #ffebee; }
        .stat-card.saldo .icon-box { background: #fff3e0; }
        .stat-card .stat-info h3 { color: #666; font-size: 0.85rem; font-weight: 500; margin-bottom: 5px; }
        .stat-card .stat-info .value { font-size: 1.5rem; font-weight: 700; color: #333; }
        .quick-actions { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); }
        .quick-actions h3 { color: #333; margin-bottom: 20px; font-size: 1.2rem; }
        .action-buttons { display: flex; gap: 15px; flex-wrap: wrap; }
        .action-btn { display: inline-flex; align-items: center; gap: 10px; padding: 15px 25px; background: linear-gradient(135deg, #1a5d3a, #2e8b57); color: white; text-decoration: none; border-radius: 10px; font-weight: 500; transition: all 0.3s ease; }
        .action-btn:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(26,93,58,0.3); }
        .action-btn.secondary { background: #f5f5f5; color: #333; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>Masjid Jabalussalam</h2>
            <p>Admin Panel</p>
        </div>
        <ul class="nav-menu">
            <li><a href="dashboard.jsp" class="active">Dashboard</a></li>
            <li><a href="kegiatan.jsp">Kelola Kegiatan</a></li>
            <li><a href="keuangan.jsp">Kelola Keuangan</a></li>
            <li class="logout"><a href="../LogoutServlet">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header">
            <h1>Dashboard</h1>
            <div class="welcome">Selamat datang, <strong><%= adminNama %></strong>!</div>
        </div>
        
        <div class="stats-grid">
            <div class="stat-card kegiatan">
                <div class="icon-box">K</div>
                <div class="stat-info">
                    <h3>Total Kegiatan</h3>
                    <div class="value"><%= totalKegiatan %></div>
                </div>
            </div>
            <div class="stat-card pemasukan">
                <div class="icon-box">+</div>
                <div class="stat-info">
                    <h3>Total Pemasukan</h3>
                    <div class="value" style="color: #4caf50;"><%= formatRupiah.format(totalPemasukan) %></div>
                </div>
            </div>
            <div class="stat-card pengeluaran">
                <div class="icon-box">-</div>
                <div class="stat-info">
                    <h3>Total Pengeluaran</h3>
                    <div class="value" style="color: #f44336;"><%= formatRupiah.format(totalPengeluaran) %></div>
                </div>
            </div>
            <div class="stat-card saldo">
                <div class="icon-box">=</div>
                <div class="stat-info">
                    <h3>Sisa Saldo Kas</h3>
                    <div class="value" style="color: #ff9800;"><%= formatRupiah.format(saldo) %></div>
                </div>
            </div>
        </div>
        
        <div class="quick-actions">
            <h3>Aksi Cepat</h3>
            <div class="action-buttons">
                <a href="kegiatan.jsp" class="action-btn">Kelola Kegiatan</a>
                <a href="keuangan.jsp" class="action-btn">Kelola Keuangan</a>
                <a href="../index.jsp" class="action-btn secondary" target="_blank">Lihat Website</a>
            </div>
        </div>
    </div>
</body>
</html>
