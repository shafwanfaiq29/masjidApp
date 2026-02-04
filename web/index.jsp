<%-- Document : index Created on : Feb 3, 2026 Author : USER --%>

    <%@page contentType="text/html" pageEncoding="UTF-8" %>
        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Masjid Jabalussalam - Beranda</title>
            <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Poppins', sans-serif;
                    background: #f8f9fa;
                    min-height: 100vh;
                }

                /* Header */
                header {
                    background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 100%);
                    color: white;
                    padding: 40px 20px;
                    text-align: center;
                    position: relative;
                    overflow: hidden;
                }

                header::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><circle cx="50" cy="50" r="40" fill="none" stroke="rgba(255,255,255,0.05)" stroke-width="0.5"/></svg>');
                    background-size: 50px 50px;
                }

                header h1 {
                    font-size: 2.5rem;
                    font-weight: 700;
                    margin-bottom: 10px;
                    position: relative;
                    z-index: 1;
                }

                header .tagline {
                    font-size: 1rem;
                    opacity: 0.9;
                    font-weight: 300;
                    position: relative;
                    z-index: 1;
                }

                /* Navigation */
                nav {
                    background: #fff;
                    box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
                    position: sticky;
                    top: 0;
                    z-index: 100;
                }

                nav ul {
                    list-style: none;
                    display: flex;
                    justify-content: center;
                    padding: 0;
                    margin: 0;
                }

                nav ul li a {
                    display: block;
                    padding: 18px 30px;
                    color: #333;
                    text-decoration: none;
                    font-weight: 500;
                    transition: all 0.3s ease;
                    position: relative;
                }

                nav ul li a:hover,
                nav ul li a.active {
                    color: #1a5d3a;
                    background: rgba(26, 93, 58, 0.05);
                }

                nav ul li a::after {
                    content: '';
                    position: absolute;
                    bottom: 0;
                    left: 50%;
                    width: 0;
                    height: 3px;
                    background: #1a5d3a;
                    transition: all 0.3s ease;
                    transform: translateX(-50%);
                }

                nav ul li a:hover::after,
                nav ul li a.active::after {
                    width: 60%;
                }

                /* Main Content */
                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 40px 20px;
                }

                .welcome-section {
                    background: white;
                    border-radius: 20px;
                    padding: 50px;
                    text-align: center;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.08);
                    margin-bottom: 40px;
                }

                .welcome-section .icon {
                    font-size: 80px;
                    margin-bottom: 20px;
                }

                .welcome-section h2 {
                    color: #1a5d3a;
                    font-size: 2rem;
                    margin-bottom: 15px;
                }

                .welcome-section p {
                    color: #666;
                    font-size: 1.1rem;
                    line-height: 1.8;
                    max-width: 700px;
                    margin: 0 auto;
                }

                /* Feature Cards */
                .features {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
                    gap: 30px;
                    margin-top: 40px;
                }

                .feature-card {
                    background: white;
                    border-radius: 15px;
                    padding: 35px;
                    text-align: center;
                    box-shadow: 0 5px 20px rgba(0, 0, 0, 0.08);
                    transition: all 0.3s ease;
                    text-decoration: none;
                    color: inherit;
                }

                .feature-card:hover {
                    transform: translateY(-10px);
                    box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
                }

                .feature-card .icon {
                    font-size: 50px;
                    margin-bottom: 20px;
                }

                .feature-card h3 {
                    color: #1a5d3a;
                    font-size: 1.3rem;
                    margin-bottom: 10px;
                }

                .feature-card p {
                    color: #777;
                    font-size: 0.95rem;
                }

                /* Footer */
                footer {
                    background: #1a5d3a;
                    color: white;
                    text-align: center;
                    padding: 25px;
                    margin-top: 50px;
                }

                footer p {
                    opacity: 0.9;
                    font-size: 0.9rem;
                }
            </style>
        </head>

        <body>
            <header>
                <h1>🕌 Masjid Jabalussalam</h1>
                <p class="tagline">Pusat Informasi dan Transparansi Keuangan Masjid</p>
            </header>

            <nav>
                <ul>
                    <li><a href="index.jsp" class="active">Beranda</a></li>
                    <li><a href="kegiatan.jsp">Jadwal Kegiatan</a></li>
                    <li><a href="keuangan.jsp">Laporan Keuangan</a></li>
                    <li><a href="pilih-role.jsp">Kembali</a></li>
                </ul>
            </nav>

            <div class="container">
                <div class="welcome-section">
                    <div class="icon">🕌</div>
                    <h2>Masjid Jabalussalam</h2>
                    <p>
                        Selamat datang di website resmi Masjid Jabalussalam. Website ini berfungsi untuk
                        memberikan transparansi laporan keuangan masjid serta informasi jadwal kegiatan
                        terkini kepada seluruh jamaah dan masyarakat sekitar.
                    </p>
                </div>

                <div class="features">
                    <a href="kegiatan.jsp" class="feature-card">
                        <div class="icon">📅</div>
                        <h3>Jadwal Kegiatan</h3>
                        <p>Lihat jadwal kegiatan dan acara yang akan datang di Masjid Jabalussalam</p>
                    </a>

                    <a href="keuangan.jsp" class="feature-card">
                        <div class="icon">💰</div>
                        <h3>Laporan Keuangan</h3>
                        <p>Transparansi pengelolaan keuangan masjid untuk jamaah dan donatur</p>
                    </a>

                    <div class="feature-card">
                        <div class="icon">🤲</div>
                        <h3>Donasi & Infaq</h3>
                        <p>Mari berkontribusi untuk kemakmuran masjid dan kegiatan dakwah</p>
                    </div>
                </div>
            </div>

            <footer>
                <p>Masjid Jabalussalam</p>
            </footer>
        </body>

        </html>