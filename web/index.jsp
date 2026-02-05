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
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
            <style>
                * {
                    margin: 0;
                    padding: 0;
                    box-sizing: border-box;
                }

                body {
                    font-family: 'Poppins', sans-serif;
                    background: linear-gradient(135deg, #f8faf9 0%, #e8f5e9 100%);
                    min-height: 100vh;
                }

                /* Header */
                header {
                    background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 50%, #1a7544 100%);
                    color: white;
                    padding: 50px 20px;
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
                    background-image: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M30 0L30 60M0 30L60 30' stroke='rgba(255,255,255,0.03)' stroke-width='1' fill='none'/%3E%3C/svg%3E");
                    pointer-events: none;
                }

                .header-content {
                    position: relative;
                    z-index: 1;
                }

                .header-icon {
                    font-size: 70px;
                    color: #ffd700;
                    margin-bottom: 15px;
                    text-shadow: 0 0 30px rgba(255, 215, 0, 0.4);
                    animation: pulse 2s ease-in-out infinite;
                }

                @keyframes pulse {

                    0%,
                    100% {
                        transform: scale(1);
                    }

                    50% {
                        transform: scale(1.05);
                    }
                }

                header h1 {
                    font-size: 2.5rem;
                    font-weight: 700;
                    margin-bottom: 10px;
                    letter-spacing: 1px;
                }

                header .tagline {
                    font-size: 1rem;
                    opacity: 0.9;
                    font-weight: 300;
                }

                /* Navigation */
                nav {
                    background: #fff;
                    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.08);
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
                    display: flex;
                    align-items: center;
                    gap: 8px;
                    padding: 18px 30px;
                    color: #444;
                    text-decoration: none;
                    font-weight: 500;
                    transition: all 0.3s ease;
                    position: relative;
                }

                nav ul li a i {
                    font-size: 1.1rem;
                    color: #1a5d3a;
                }

                nav ul li a:hover,
                nav ul li a.active {
                    color: #1a5d3a;
                    background: linear-gradient(180deg, transparent 0%, rgba(26, 93, 58, 0.05) 100%);
                }

                nav ul li a::after {
                    content: '';
                    position: absolute;
                    bottom: 0;
                    left: 50%;
                    width: 0;
                    height: 3px;
                    background: linear-gradient(90deg, #1a5d3a, #2e8b57);
                    transition: all 0.3s ease;
                    transform: translateX(-50%);
                    border-radius: 3px 3px 0 0;
                }

                nav ul li a:hover::after,
                nav ul li a.active::after {
                    width: 70%;
                }

                /* Main Content */
                .container {
                    max-width: 1200px;
                    margin: 0 auto;
                    padding: 50px 20px;
                }

                .welcome-section {
                    background: white;
                    border-radius: 24px;
                    padding: 60px;
                    text-align: center;
                    box-shadow: 0 10px 40px rgba(0, 0, 0, 0.06);
                    margin-bottom: 50px;
                    position: relative;
                    overflow: hidden;
                }

                .welcome-section::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    height: 5px;
                    background: linear-gradient(90deg, #1a5d3a, #2e8b57, #ffd700);
                }

                .welcome-section .icon {
                    font-size: 80px;
                    color: #1a5d3a;
                    margin-bottom: 25px;
                }

                .welcome-section h2 {
                    color: #1a5d3a;
                    font-size: 2.2rem;
                    margin-bottom: 20px;
                    font-weight: 700;
                }

                .welcome-section p {
                    color: #666;
                    font-size: 1.1rem;
                    line-height: 1.9;
                    max-width: 700px;
                    margin: 0 auto;
                }

                /* Feature Cards */
                .features {
                    display: grid;
                    grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
                    gap: 30px;
                    margin-top: 20px;
                }

                .feature-card {
                    background: white;
                    border-radius: 20px;
                    padding: 40px 35px;
                    text-align: center;
                    box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
                    transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                    text-decoration: none;
                    color: inherit;
                    position: relative;
                    overflow: hidden;
                }

                .feature-card::before {
                    content: '';
                    position: absolute;
                    top: 0;
                    left: 0;
                    right: 0;
                    bottom: 0;
                    background: linear-gradient(135deg, rgba(26, 93, 58, 0.02) 0%, transparent 100%);
                    opacity: 0;
                    transition: opacity 0.3s ease;
                }

                .feature-card:hover {
                    transform: translateY(-12px);
                    box-shadow: 0 20px 50px rgba(26, 93, 58, 0.15);
                }

                .feature-card:hover::before {
                    opacity: 1;
                }

                .feature-card .icon-wrapper {
                    width: 90px;
                    height: 90px;
                    margin: 0 auto 25px;
                    border-radius: 20px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    font-size: 40px;
                    transition: all 0.3s ease;
                }

                .feature-card:nth-child(1) .icon-wrapper {
                    background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
                    color: #1976d2;
                }

                .feature-card:nth-child(2) .icon-wrapper {
                    background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
                    color: #388e3c;
                }

                .feature-card:nth-child(3) .icon-wrapper {
                    background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
                    color: #d32f2f;
                }

                .feature-card.youtube .icon-wrapper {
                    background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
                    color: #ff0000;
                }

                .feature-card.youtube:hover {
                    border-color: #ff0000;
                }

                .feature-card.youtube:hover .icon-wrapper {
                    background: linear-gradient(135deg, #ff0000 0%, #cc0000 100%);
                    color: white;
                }

                .feature-card:hover .icon-wrapper {
                    transform: scale(1.1) rotate(5deg);
                }

                .feature-card h3 {
                    color: #333;
                    font-size: 1.4rem;
                    margin-bottom: 12px;
                    font-weight: 600;
                }

                .feature-card p {
                    color: #777;
                    font-size: 0.95rem;
                    line-height: 1.6;
                }

                .feature-card .arrow {
                    display: inline-flex;
                    align-items: center;
                    gap: 8px;
                    margin-top: 20px;
                    color: #1a5d3a;
                    font-weight: 500;
                    font-size: 0.9rem;
                }

                .feature-card .arrow i {
                    transition: transform 0.3s ease;
                }

                .feature-card:hover .arrow i {
                    transform: translateX(5px);
                }

                /* Footer */
                footer {
                    background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 100%);
                    color: white;
                    text-align: center;
                    padding: 30px;
                    margin-top: 50px;
                }

                footer p {
                    opacity: 0.9;
                    font-size: 0.95rem;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    gap: 10px;
                }

                footer i {
                    color: #ffd700;
                }

                /* Responsive */
                @media (max-width: 768px) {
                    header h1 {
                        font-size: 1.8rem;
                    }

                    .header-icon {
                        font-size: 50px;
                    }

                    nav ul {
                        flex-wrap: wrap;
                    }

                    nav ul li a {
                        padding: 12px 15px;
                        font-size: 0.9rem;
                    }

                    .welcome-section {
                        padding: 40px 25px;
                    }

                    .welcome-section h2 {
                        font-size: 1.6rem;
                    }

                    .features {
                        grid-template-columns: 1fr;
                    }
                }
            </style>
        </head>

        <body>
            <header>
                <div class="header-content">
                    <div class="header-icon">
                        <i class="fas fa-mosque"></i>
                    </div>
                    <h1>Dewan Kemakmuran Masjid Jabalussalam</h1>
                    <p class="tagline">Mewujudkan tata kelola masjid yang transparan, akuntable dan modern</p>
                </div>
            </header>

            <nav>
                <ul>
                    <li><a href="index.jsp" class="active"><i class="fas fa-home"></i> Beranda</a></li>
                    <li><a href="kegiatan.jsp"><i class="fas fa-calendar-days"></i> Jadwal Kegiatan</a></li>
                    <li><a href="keuangan.jsp"><i class="fas fa-money-bill-wave"></i> Laporan Keuangan</a></li>
                    <li><a href="pilih-role.jsp"><i class="fas fa-arrow-left"></i> Kembali</a></li>
                </ul>
            </nav>

            <div class="container">
                <div class="welcome-section">
                    <div class="icon">
                        <i class="fas fa-mosque"></i>
                    </div>
                    <h2>Selamat Datang di Masjid Jabalussalam</h2>
                    <p>
                        Website resmi Masjid Jabalussalam hadir untuk memberikan informasi tata kelola 
                        yang transparan, akuntabel dan modern dalam melayani jamaah.
                        
                    </p>
                </div>

                <div class="features">
                    <a href="kegiatan.jsp" class="feature-card">
                        <div class="icon-wrapper">
                            <i class="fas fa-calendar-days"></i>
                        </div>
                        <h3>Jadwal Kegiatan</h3>
                        <p>Lihat jadwal kegiatan dan acara yang akan datang di Masjid Jabalussalam</p>
                        <span class="arrow">Lihat Jadwal <i class="fas fa-arrow-right"></i></span>
                    </a>

                    <a href="keuangan.jsp" class="feature-card">
                        <div class="icon-wrapper">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                        <h3>Laporan Keuangan</h3>
                        <p>Transparansi pengelolaan keuangan masjid untuk jamaah dan donatur</p>
                        <span class="arrow">Lihat Laporan <i class="fas fa-arrow-right"></i></span>
                    </a>

                    <a href="http://www.youtube.com/@jabalussalamchannel" target="_blank" class="feature-card youtube">
                        <div class="icon-wrapper">
                            <i class="fab fa-youtube"></i>
                        </div>
                        <h3>YouTube Channel</h3>
                        <p>Tonton kajian, ceramah, dan kegiatan masjid di channel YouTube kami</p>
                        <span class="arrow">Kunjungi Channel <i class="fas fa-external-link-alt"></i></span>
                    </a>
                </div>
            </div>

            <footer>
                <p><i class="fas fa-mosque"></i> Masjid Jabalussalam </p>
            </footer>
        </body>

        </html>