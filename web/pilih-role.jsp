<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Masjid Jabalussalam - Selamat Datang</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 50%, #1a5d3a 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }
        .bg-decoration { position: absolute; border-radius: 50%; background: rgba(255, 255, 255, 0.03); }
        .bg-decoration:nth-child(1) { width: 400px; height: 400px; top: -100px; right: -100px; }
        .bg-decoration:nth-child(2) { width: 300px; height: 300px; bottom: -50px; left: -50px; }
        .container { text-align: center; z-index: 1; padding: 20px; }
        .mosque-icon { font-size: 80px; margin-bottom: 10px; animation: float 3s ease-in-out infinite; }
        @keyframes float { 0%, 100% { transform: translateY(0); } 50% { transform: translateY(-10px); } }
        h1 { color: #fff; font-size: 2.5rem; font-weight: 700; margin-bottom: 10px; text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3); }
        .tagline { color: rgba(255, 255, 255, 0.8); font-size: 1.1rem; margin-bottom: 40px; font-weight: 300; }
        .welcome-text { color: rgba(255, 255, 255, 0.9); font-size: 1rem; margin-bottom: 30px; }
        .role-buttons { display: flex; gap: 20px; justify-content: center; flex-wrap: wrap; }
        .role-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            padding: 40px 50px;
            text-decoration: none;
            color: #fff;
            transition: all 0.3s ease;
            min-width: 200px;
        }
        .role-card:hover { transform: translateY(-10px); background: rgba(255, 255, 255, 0.2); box-shadow: 0 20px 40px rgba(0, 0, 0, 0.3); }
        .role-card .icon { font-size: 50px; margin-bottom: 15px; display: block; }
        .role-card h3 { font-size: 1.3rem; font-weight: 600; margin-bottom: 8px; }
        .role-card p { font-size: 0.85rem; color: rgba(255, 255, 255, 0.7); }
        .footer-text { margin-top: 50px; color: rgba(255, 255, 255, 0.5); font-size: 0.85rem; }
    </style>
</head>
<body>
    <div class="bg-decoration"></div>
    <div class="bg-decoration"></div>
    <div class="container">
        <div class="mosque-icon">&#128332;</div>
        <h1>Masjid Jabalussalam</h1>
        <p class="tagline">Pusat Informasi dan Transparansi Keuangan Masjid</p>
        <p class="welcome-text">Silakan pilih cara Anda mengakses website:</p>
        <div class="role-buttons">
            <a href="index.jsp" class="role-card">
                <span class="icon">&#128101;</span>
                <h3>Masyarakat</h3>
                <p>Lihat informasi kegiatan<br>dan laporan keuangan</p>
            </a>
            <a href="login.jsp" class="role-card">
                <span class="icon">&#128274;</span>
                <h3>Admin</h3>
                <p>Kelola data kegiatan<br>dan keuangan masjid</p>
            </a>
        </div>
        <p class="footer-text">Masjid Jabalussalam</p>
    </div>
</body>
</html>
