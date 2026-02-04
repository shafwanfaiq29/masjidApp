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
        .events-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 25px; }
        .event-card { background: white; border-radius: 15px; padding: 25px; box-shadow: 0 5px 20px rgba(0,0,0,0.08); transition: transform 0.3s, box-shadow 0.3s; }
        .event-card:hover { transform: translateY(-5px); box-shadow: 0 15px 30px rgba(0,0,0,0.15); }
        .event-date { display: inline-flex; align-items: center; gap: 8px; background: #e8f5e9; color: #1a5d3a; padding: 8px 15px; border-radius: 25px; font-size: 0.85rem; font-weight: 500; margin-bottom: 15px; }
        .event-card h3 { color: #333; font-size: 1.3rem; margin-bottom: 10px; }
        .event-time { color: #1a5d3a; font-weight: 500; margin-bottom: 10px; display: flex; align-items: center; gap: 8px; }
        .event-desc { color: #666; font-size: 0.95rem; line-height: 1.6; }
        .no-events { text-align: center; padding: 60px; color: #999; }
        .no-events .icon { font-size: 60px; margin-bottom: 20px; }
        footer { background: #1a5d3a; color: white; text-align: center; padding: 30px; margin-top: 50px; }
        @media (max-width: 768px) {
            .nav-links { display: none; }
            .hero h1 { font-size: 1.8rem; }
            .events-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <nav>
        <div class="nav-container">
            <a href="index.jsp" class="nav-brand">Masjid Jabalussalam</a>
            <div class="nav-links">
                <a href="index.jsp">Beranda</a>
                <a href="kegiatan.jsp" class="active">Kegiatan</a>
                <a href="keuangan.jsp">Keuangan</a>
                <a href="pilih-role.jsp">Login Admin</a>
            </div>
        </div>
    </nav>
    
    <div class="hero">
        <h1>Jadwal Kegiatan</h1>
        <p>Informasi kegiatan dan acara di Masjid Jabalussalam</p>
    </div>
    
    <div class="container">
        <div class="events-grid">
        <%
            boolean hasData = false;
            try {
                Connection con = Koneksi.getKoneksi();
                if (con != null) {
                    Statement st = con.createStatement();
                    ResultSet rs = st.executeQuery("SELECT * FROM kegiatan ORDER BY tanggal ASC");
                    while(rs.next()) {
                        hasData = true;
                        String nama = rs.getString("nama_kegiatan");
                        String tgl = rs.getString("tanggal");
                        String wkt = rs.getString("waktu");
                        String desk = rs.getString("deskripsi");
                        if (desk == null) desk = "";
        %>
            <div class="event-card">
                <div class="event-date"><%= tgl %></div>
                <h3><%= nama %></h3>
                <div class="event-time"><%= wkt != null ? wkt : "-" %></div>
                <p class="event-desc"><%= desk.isEmpty() ? "Deskripsi tidak tersedia" : desk %></p>
            </div>
        <%
                    }
                }
            } catch (Exception e) {
                out.println("<div class='no-events'>Error: " + e.getMessage() + "</div>");
            }
            if (!hasData) {
        %>
            <div class="no-events" style="grid-column: 1 / -1;">
                <div class="icon">📅</div>
                <h3>Belum Ada Kegiatan</h3>
                <p>Saat ini belum ada jadwal kegiatan yang tersedia</p>
            </div>
        <% } %>
        </div>
    </div>
    
    <footer>
        <p>2026 Masjid Jabalussalam - Semoga Berkah</p>
    </footer>
</body>
</html>
