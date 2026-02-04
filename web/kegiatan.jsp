<%@page import="java.sql.*"%>
<%@page import="com.masjid.config.Koneksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jadwal Kegiatan - Masjid Jabalussalam</title>
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
        .hero { background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 50%, #1a7544 100%); padding: 70px 20px; text-align: center; color: white; position: relative; overflow: hidden; }
        .hero-content { position: relative; z-index: 1; }
        .hero-icon { font-size: 60px; color: #ffd700; margin-bottom: 20px; text-shadow: 0 0 30px rgba(255, 215, 0, 0.4); }
        .hero h1 { font-size: 2.5rem; margin-bottom: 12px; font-weight: 700; }
        .hero p { color: rgba(255, 255, 255, 0.9); font-size: 1.1rem; max-width: 500px; margin: 0 auto; }
        .container { max-width: 1200px; margin: 0 auto; padding: 50px 20px; }
        .events-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(360px, 1fr)); gap: 30px; }
        .event-card { background: white; border-radius: 20px; padding: 30px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06); transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275); position: relative; overflow: hidden; }
        .event-card::before { content: ''; position: absolute; top: 0; left: 0; width: 5px; height: 100%; background: linear-gradient(180deg, #1a5d3a, #2e8b57); }
        .event-card:hover { transform: translateY(-8px); box-shadow: 0 20px 50px rgba(26, 93, 58, 0.15); }
        .event-date { display: inline-flex; align-items: center; gap: 10px; background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%); color: #1a5d3a; padding: 10px 18px; border-radius: 30px; font-size: 0.9rem; font-weight: 600; margin-bottom: 18px; }
        .event-date i { font-size: 1rem; }
        .event-card h3 { color: #333; font-size: 1.35rem; margin-bottom: 12px; font-weight: 600; }
        .event-time { color: #1a5d3a; font-weight: 500; margin-bottom: 15px; display: flex; align-items: center; gap: 10px; font-size: 1rem; }
        .event-time i { font-size: 1.1rem; color: #2e8b57; }
        .event-desc { color: #666; font-size: 0.95rem; line-height: 1.7; }
        .no-events { text-align: center; padding: 80px 40px; color: #888; background: white; border-radius: 20px; box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06); grid-column: 1 / -1; }
        .no-events .icon { font-size: 70px; margin-bottom: 25px; color: #ccc; }
        .no-events h3 { color: #666; font-size: 1.4rem; margin-bottom: 10px; }
        .no-events p { color: #999; }
        footer { background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 100%); color: white; text-align: center; padding: 30px; margin-top: 50px; }
        footer p { display: flex; align-items: center; justify-content: center; gap: 10px; font-size: 0.95rem; }
        footer i { color: #ffd700; }
        @media (max-width: 768px) { .nav-links { display: none; } .hero h1 { font-size: 1.8rem; } .hero-icon { font-size: 45px; } .events-grid { grid-template-columns: 1fr; } }
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
                <a href="kegiatan.jsp" class="active"><i class="fas fa-calendar-days"></i> Kegiatan</a>
                <a href="keuangan.jsp"><i class="fas fa-money-bill-wave"></i> Keuangan</a>
                <a href="pilih-role.jsp"><i class="fas fa-right-to-bracket"></i> Login Admin</a>
            </div>
        </div>
    </nav>

    <div class="hero">
        <div class="hero-content">
            <div class="hero-icon">
                <i class="fas fa-calendar-days"></i>
            </div>
            <h1>Jadwal Kegiatan</h1>
            <p>Informasi kegiatan dan acara di Masjid Jabalussalam</p>
        </div>
    </div>

    <div class="container">
        <div class="events-grid">
<%
boolean hasData = false;
Connection con = null;
try {
    con = Koneksi.getKoneksi();
    if (con != null) {
        Statement st = con.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM kegiatan ORDER BY tanggal ASC");
        while (rs.next()) {
            hasData = true;
            String nama = rs.getString("nama_kegiatan");
            String tgl = rs.getString("tanggal");
            String wkt = rs.getString("waktu");
            String desk = rs.getString("deskripsi");
            if (desk == null) desk = "";
%>
            <div class="event-card">
                <div class="event-date">
                    <i class="fas fa-calendar"></i>
                    <%= tgl %>
                </div>
                <h3><%= nama %></h3>
                <div class="event-time">
                    <i class="fas fa-clock"></i>
                    <%= wkt != null ? wkt : "-" %>
                </div>
                <p class="event-desc"><%= desk.isEmpty() ? "Deskripsi tidak tersedia" : desk %></p>
            </div>
<%
        }
        rs.close();
        st.close();
    }
} catch (Exception e) {
%>
            <div class="no-events">
                <div class="icon"><i class="fas fa-exclamation-triangle"></i></div>
                <h3>Error</h3>
                <p><%= e.getMessage() %></p>
            </div>
<%
} finally {
    if (con != null) {
        try { con.close(); } catch (Exception ex) { }
    }
}
if (!hasData) {
%>
            <div class="no-events">
                <div class="icon"><i class="fas fa-calendar-xmark"></i></div>
                <h3>Belum Ada Kegiatan</h3>
                <p>Saat ini belum ada jadwal kegiatan yang tersedia</p>
            </div>
<%
}
%>
        </div>
    </div>

    <footer>
        <p><i class="fas fa-mosque"></i> 2026 Masjid Jabalussalam - Semoga Berkah</p>
    </footer>
</body>
</html>


