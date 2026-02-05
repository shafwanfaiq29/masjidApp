<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Masjid Jabalussalam - Selamat Datang</title>
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
                min-height: 100vh;
                background: linear-gradient(135deg, #0d4f2b 0%, #1a7544 25%, #0d3320 50%, #1a5d3a 75%, #0d4f2b 100%);
                background-size: 400% 400%;
                animation: gradientShift 15s ease infinite;
                display: flex;
                justify-content: center;
                align-items: center;
                position: relative;
                overflow-x: hidden;
                overflow-y: auto;
                padding: 40px 20px;
            }

            @keyframes gradientShift {
                0% {
                    background-position: 0% 50%;
                }

                50% {
                    background-position: 100% 50%;
                }

                100% {
                    background-position: 0% 50%;
                }
            }

            /* Decorative Elements */
            .bg-decoration {
                position: absolute;
                border-radius: 50%;
                background: rgba(255, 255, 255, 0.03);
                animation: float 6s ease-in-out infinite;
            }

            .bg-decoration:nth-child(1) {
                width: 500px;
                height: 500px;
                top: -150px;
                right: -150px;
                animation-delay: 0s;
            }

            .bg-decoration:nth-child(2) {
                width: 400px;
                height: 400px;
                bottom: -100px;
                left: -100px;
                animation-delay: 2s;
            }

            .bg-decoration:nth-child(3) {
                width: 200px;
                height: 200px;
                top: 50%;
                left: 10%;
                animation-delay: 4s;
            }

            @keyframes float {

                0%,
                100% {
                    transform: translateY(0) rotate(0deg);
                }

                50% {
                    transform: translateY(-20px) rotate(5deg);
                }
            }

            /* Islamic Pattern Overlay */
            .pattern-overlay {
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background-image: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M30 0L30 60M0 30L60 30M0 0L60 60M60 0L0 60' stroke='rgba(255,255,255,0.02)' stroke-width='1' fill='none'/%3E%3C/svg%3E");
                pointer-events: none;
            }

            .container {
                text-align: center;
                z-index: 1;
                padding: 20px;
                max-width: 800px;
            }

            .mosque-icon {
                font-size: 100px;
                margin-bottom: 20px;
                color: #ffd700;
                text-shadow: 0 0 30px rgba(255, 215, 0, 0.5);
                animation: mosqueFloat 3s ease-in-out infinite;
            }

            @keyframes mosqueFloat {

                0%,
                100% {
                    transform: translateY(0) scale(1);
                }

                50% {
                    transform: translateY(-15px) scale(1.02);
                }
            }

            h1 {
                color: #fff;
                font-size: 2.8rem;
                font-weight: 700;
                margin-bottom: 10px;
                text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.3);
                letter-spacing: 1px;
            }

            .tagline {
                color: rgba(255, 255, 255, 0.9);
                font-size: 1.1rem;
                margin-bottom: 15px;
                font-weight: 300;
            }

            .arabic-text {
                color: #ffd700;
                font-size: 1.5rem;
                margin-bottom: 40px;
                font-style: italic;
            }

            .welcome-text {
                color: rgba(255, 255, 255, 0.9);
                font-size: 1rem;
                margin-bottom: 35px;
                background: rgba(255, 255, 255, 0.1);
                padding: 15px 30px;
                border-radius: 50px;
                display: inline-block;
                backdrop-filter: blur(10px);
            }

            .role-buttons {
                display: flex;
                gap: 30px;
                justify-content: center;
                flex-wrap: wrap;
            }

            .role-card {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 24px;
                padding: 45px 55px;
                text-decoration: none;
                color: #fff;
                transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                min-width: 220px;
                position: relative;
                overflow: hidden;
            }

            .role-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                bottom: 0;
                background: linear-gradient(135deg, rgba(255, 255, 255, 0.1) 0%, transparent 100%);
                opacity: 0;
                transition: opacity 0.3s ease;
            }

            .role-card:hover {
                transform: translateY(-15px) scale(1.02);
                background: rgba(255, 255, 255, 0.2);
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4);
                border-color: rgba(255, 215, 0, 0.5);
            }

            .role-card:hover::before {
                opacity: 1;
            }

            .role-card .icon {
                font-size: 55px;
                margin-bottom: 20px;
                display: block;
                color: #ffd700;
                transition: all 0.3s ease;
            }

            .role-card:hover .icon {
                transform: scale(1.1);
                text-shadow: 0 0 20px rgba(255, 215, 0, 0.5);
            }

            .role-card h3 {
                font-size: 1.4rem;
                font-weight: 600;
                margin-bottom: 10px;
            }

            .role-card p {
                font-size: 0.9rem;
                color: rgba(255, 255, 255, 0.8);
                line-height: 1.5;
            }

            .footer-text {
                margin-top: 60px;
                color: rgba(255, 255, 255, 0.6);
                font-size: 0.9rem;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 10px;
            }

            .footer-text i {
                color: #ffd700;
            }

            /* Responsive */
            @media (max-width: 768px) {
                h1 {
                    font-size: 2rem;
                }

                .mosque-icon {
                    font-size: 70px;
                }

                .role-card {
                    padding: 35px 40px;
                    min-width: 180px;
                }

                .role-buttons {
                    gap: 20px;
                }
            }
        </style>
    </head>

    <body>
        <div class="pattern-overlay"></div>
        <div class="bg-decoration"></div>
        <div class="bg-decoration"></div>
        <div class="bg-decoration"></div>

        <div class="container">
            <div class="mosque-icon">
                <i class="fas fa-mosque"></i>
            </div>
            <h1>Dewan Kemakmuran Masjid Jabalussalam</h1>
            <p class="tagline">Mewujudkan tata kelola masjid yang transparan, akuntabel dan modern</p>
            <p class="arabic-text">بِسْمِ اللَّهِ الرَّحْمَنِ الرَّحِيم</p>
            <p class="welcome-text">
                <i class="fas fa-hand-point-right"></i>&nbsp; Silakan pilih cara Anda mengakses website
            </p>

            <div class="role-buttons">
                <a href="index.jsp" class="role-card">
                    <span class="icon"><i class="fas fa-users"></i></span>
                    <h3>Masyarakat</h3>
                    <p>Lihat informasi kegiatan<br>dan laporan keuangan</p>
                </a>
                <a href="login.jsp" class="role-card">
                    <span class="icon"><i class="fas fa-user-shield"></i></span>
                    <h3>Admin</h3>
                    <p>Kelola data kegiatan<br>dan keuangan masjid</p>
                </a>
            </div>

            <p class="footer-text">
                <i class="fas fa-mosque"></i> Masjid Jabalussalam <i class="fas fa-heart"></i>
            </p>
        </div>
    </body>

    </html>