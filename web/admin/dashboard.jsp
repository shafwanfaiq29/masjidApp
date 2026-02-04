<%@page import="java.sql.*"%>
<%@page import="com.masjid.config.Koneksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("adminId") == null) {
    response.sendRedirect("../login.jsp");
    return;
}
String adminNama = (String) session.getAttribute("adminNama");
String adminRole = (String) session.getAttribute("adminRole");
if (adminNama == null) adminNama = "Admin";
if (adminRole == null) adminRole = "Admin";

boolean isAdmin = "Admin".equals(adminRole);
boolean isIdarah = "Idarah".equals(adminRole);
boolean isImarah = "Imarah".equals(adminRole);
boolean isRiayah = "Riayah".equals(adminRole);

boolean canAccessKegiatan = isAdmin || isImarah;
boolean canAccessKeuangan = isAdmin || isRiayah;
boolean canAccessArsip = isAdmin || isIdarah;
boolean canAccessUsers = isAdmin;

int totalKegiatan = 0;
double totalPemasukan = 0, totalPengeluaran = 0, saldo = 0;
int totalArsip = 0;

try {
    Connection con = Koneksi.getKoneksi();
    if (con != null) {
        Statement st1 = con.createStatement();
        ResultSet rs1 = st1.executeQuery("SELECT COUNT(*) as total FROM kegiatan");
        if (rs1.next()) totalKegiatan = rs1.getInt("total");
        
        Statement st2 = con.createStatement();
        ResultSet rs2 = st2.executeQuery("SELECT kategori, SUM(jumlah) as total FROM keuangan GROUP BY kategori");
        while (rs2.next()) {
            if ("Pemasukan".equalsIgnoreCase(rs2.getString("kategori"))) {
                totalPemasukan = rs2.getDouble("total");
            } else {
                totalPengeluaran = rs2.getDouble("total");
            }
        }
        saldo = totalPemasukan - totalPengeluaran;
        
        try {
            Statement st3 = con.createStatement();
            ResultSet rs3 = st3.executeQuery("SELECT COUNT(*) as total FROM arsip");
            if (rs3.next()) totalArsip = rs3.getInt("total");
        } catch (Exception ex) {}
        
        con.close();
    }
} catch (Exception e) { e.printStackTrace(); }
java.text.NumberFormat formatRupiah = java.text.NumberFormat.getCurrencyInstance(new java.util.Locale("in", "ID"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard Admin - Masjid Jabalussalam</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background: linear-gradient(135deg, #f0f2f5 0%, #e8eef3 100%); min-height: 100vh; }
        .sidebar { position: fixed; left: 0; top: 0; width: 280px; height: 100vh; background: linear-gradient(180deg, #1a5d3a 0%, #0d3320 100%); padding: 25px 20px; z-index: 100; box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1); overflow-y: auto; }
        .sidebar-header { text-align: center; padding: 25px 0 35px; border-bottom: 1px solid rgba(255, 255, 255, 0.1); margin-bottom: 30px; }
        .sidebar-header .logo { font-size: 50px; color: #ffd700; margin-bottom: 15px; }
        .sidebar-header h2 { color: white; font-size: 1.15rem; }
        .sidebar-header p { color: rgba(255, 255, 255, 0.6); font-size: 0.85rem; margin-top: 5px; }
        .role-badge { display: inline-block; padding: 4px 12px; background: rgba(255, 215, 0, 0.2); color: #ffd700; border-radius: 15px; font-size: 0.75rem; margin-top: 8px; }
        .nav-menu { list-style: none; }
        .nav-menu li { margin-bottom: 8px; }
        .nav-menu a { display: flex; align-items: center; gap: 14px; padding: 16px 20px; color: rgba(255, 255, 255, 0.8); text-decoration: none; border-radius: 12px; transition: all 0.3s ease; font-size: 0.95rem; }
        .nav-menu a i { font-size: 1.2rem; width: 24px; text-align: center; }
        .nav-menu a:hover, .nav-menu a.active { background: rgba(255, 255, 255, 0.15); color: white; transform: translateX(5px); }
        .nav-menu a.active { background: linear-gradient(90deg, rgba(255, 215, 0, 0.2), transparent); border-left: 3px solid #ffd700; }
        .nav-menu .logout { margin-top: 30px; border-top: 1px solid rgba(255, 255, 255, 0.1); padding-top: 25px; }
        .nav-menu .logout a { color: #ff6b6b; }
        .main-content { margin-left: 280px; padding: 35px; }
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 35px; flex-wrap: wrap; gap: 15px; }
        .header h1 { color: #333; font-size: 1.8rem; display: flex; align-items: center; gap: 12px; }
        .header h1 i { color: #1a5d3a; }
        .welcome { background: linear-gradient(135deg, #1a5d3a, #2e8b57); color: white; padding: 12px 25px; border-radius: 12px; display: flex; align-items: center; gap: 10px; font-size: 0.95rem; }
        .welcome i { font-size: 1.3rem; }
        .stats-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 25px; margin-bottom: 35px; }
        .stat-card { background: white; border-radius: 18px; padding: 28px; display: flex; align-items: center; gap: 20px; box-shadow: 0 8px 25px rgba(0, 0, 0, 0.05); transition: all 0.3s ease; position: relative; overflow: hidden; }
        .stat-card:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1); }
        .stat-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; }
        .stat-card.kegiatan::before { background: linear-gradient(90deg, #1976d2, #64b5f6); }
        .stat-card.pemasukan::before { background: linear-gradient(90deg, #388e3c, #81c784); }
        .stat-card.pengeluaran::before { background: linear-gradient(90deg, #d32f2f, #e57373); }
        .stat-card.saldo::before { background: linear-gradient(90deg, #f57c00, #ffb74d); }
        .stat-card.arsip::before { background: linear-gradient(90deg, #7b1fa2, #ba68c8); }
        .icon-box { width: 65px; height: 65px; border-radius: 16px; display: flex; align-items: center; justify-content: center; font-size: 28px; }
        .stat-card.kegiatan .icon-box { background: linear-gradient(135deg, #e3f2fd, #bbdefb); color: #1976d2; }
        .stat-card.pemasukan .icon-box { background: linear-gradient(135deg, #e8f5e9, #c8e6c9); color: #388e3c; }
        .stat-card.pengeluaran .icon-box { background: linear-gradient(135deg, #ffebee, #ffcdd2); color: #d32f2f; }
        .stat-card.saldo .icon-box { background: linear-gradient(135deg, #fff3e0, #ffe0b2); color: #f57c00; }
        .stat-card.arsip .icon-box { background: linear-gradient(135deg, #f3e5f5, #e1bee7); color: #7b1fa2; }
        .stat-info h3 { color: #888; font-size: 0.88rem; margin-bottom: 6px; font-weight: 500; }
        .stat-info .value { color: #333; font-size: 1.5rem; font-weight: 700; }
        .quick-actions { background: white; border-radius: 18px; padding: 30px; box-shadow: 0 8px 25px rgba(0, 0, 0, 0.05); }
        .quick-actions h3 { color: #333; margin-bottom: 25px; font-size: 1.2rem; display: flex; align-items: center; gap: 10px; }
        .quick-actions h3 i { color: #1a5d3a; }
        .action-buttons { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 18px; }
        .action-btn { display: flex; align-items: center; justify-content: center; gap: 10px; padding: 18px 25px; background: linear-gradient(135deg, #1a5d3a, #2e8b57); color: white; text-decoration: none; border-radius: 14px; font-weight: 500; transition: all 0.3s ease; font-size: 0.95rem; }
        .action-btn:hover { transform: translateY(-3px); box-shadow: 0 10px 25px rgba(26, 93, 58, 0.3); }
        .action-btn.secondary { background: linear-gradient(135deg, #f5f7fa, #e4e8ec); color: #555; }
        .action-btn.secondary:hover { box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1); }
        .action-btn i { font-size: 1.1rem; }
        @media (max-width: 992px) { .sidebar { width: 80px; padding: 15px 10px; } .sidebar-header h2, .sidebar-header p, .nav-menu a span, .role-badge { display: none; } .sidebar-header .logo { font-size: 35px; } .nav-menu a { justify-content: center; padding: 14px; } .main-content { margin-left: 80px; } }
        @media (max-width: 768px) { .sidebar { display: none; } .main-content { margin-left: 0; padding: 20px; } .header { flex-direction: column; align-items: flex-start; } }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="logo"><i class="fas fa-mosque"></i></div>
            <h2>Masjid Jabalussalam</h2>
            <p>Admin Panel</p>
            <span class="role-badge"><i class="fas fa-user-tag"></i> <%= adminRole %></span>
        </div>
        <ul class="nav-menu">
            <li><a href="dashboard.jsp" class="active"><i class="fas fa-gauge-high"></i><span>Dashboard</span></a></li>
            <% if (canAccessKegiatan) { %>
            <li><a href="kegiatan.jsp"><i class="fas fa-calendar-days"></i><span>Kelola Kegiatan</span></a></li>
            <% } %>
            <% if (canAccessKeuangan) { %>
            <li><a href="keuangan.jsp"><i class="fas fa-money-bill-wave"></i><span>Kelola Keuangan</span></a></li>
            <% } %>
            <% if (canAccessArsip) { %>
            <li><a href="arsip.jsp"><i class="fas fa-folder-open"></i><span>Kelola Arsip</span></a></li>
            <% } %>
            <% if (canAccessUsers) { %>
            <li><a href="users.jsp"><i class="fas fa-users-cog"></i><span>Kelola User</span></a></li>
            <% } %>
            <li class="logout"><a href="../LogoutServlet"><i class="fas fa-right-from-bracket"></i><span>Logout</span></a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <h1><i class="fas fa-gauge-high"></i> Dashboard</h1>
            <div class="welcome">
                <i class="fas fa-user-circle"></i>
                Selamat datang, <strong><%= adminNama %></strong>! (<%= adminRole %>)
            </div>
        </div>

        <div class="stats-grid">
            <% if (canAccessKegiatan) { %>
            <div class="stat-card kegiatan">
                <div class="icon-box"><i class="fas fa-calendar-check"></i></div>
                <div class="stat-info">
                    <h3>Total Kegiatan</h3>
                    <div class="value"><%= totalKegiatan %></div>
                </div>
            </div>
            <% } %>
            <% if (canAccessKeuangan) { %>
            <div class="stat-card pemasukan">
                <div class="icon-box"><i class="fas fa-arrow-trend-up"></i></div>
                <div class="stat-info">
                    <h3>Total Pemasukan</h3>
                    <div class="value"><%= formatRupiah.format(totalPemasukan) %></div>
                </div>
            </div>
            <div class="stat-card pengeluaran">
                <div class="icon-box"><i class="fas fa-arrow-trend-down"></i></div>
                <div class="stat-info">
                    <h3>Total Pengeluaran</h3>
                    <div class="value"><%= formatRupiah.format(totalPengeluaran) %></div>
                </div>
            </div>
            <div class="stat-card saldo">
                <div class="icon-box"><i class="fas fa-wallet"></i></div>
                <div class="stat-info">
                    <h3>Sisa Saldo Kas</h3>
                    <div class="value"><%= formatRupiah.format(saldo) %></div>
                </div>
            </div>
            <% } %>
            <% if (canAccessArsip) { %>
            <div class="stat-card arsip">
                <div class="icon-box"><i class="fas fa-folder-open"></i></div>
                <div class="stat-info">
                    <h3>Total Arsip</h3>
                    <div class="value"><%= totalArsip %></div>
                </div>
            </div>
            <% } %>
        </div>

        <div class="quick-actions">
            <h3><i class="fas fa-bolt"></i> Aksi Cepat</h3>
            <div class="action-buttons">
                <% if (canAccessKegiatan) { %>
                <a href="kegiatan.jsp" class="action-btn"><i class="fas fa-calendar-plus"></i> Kelola Kegiatan</a>
                <% } %>
                <% if (canAccessKeuangan) { %>
                <a href="keuangan.jsp" class="action-btn"><i class="fas fa-coins"></i> Kelola Keuangan</a>
                <% } %>
                <% if (canAccessArsip) { %>
                <a href="arsip.jsp" class="action-btn"><i class="fas fa-folder-open"></i> Kelola Arsip</a>
                <% } %>
                <% if (canAccessUsers) { %>
                <a href="users.jsp" class="action-btn"><i class="fas fa-users-cog"></i> Kelola User</a>
                <% } %>
                <a href="../index.jsp" class="action-btn secondary" target="_blank"><i class="fas fa-external-link-alt"></i> Lihat Website</a>
            </div>
        </div>
    </div>
</body>
</html>
