<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Jadwal Kegiatan - Masjid Jabalussalam</title>
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
            color: #333;
            min-height: 100vh;
        }

        nav {
            background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 100%);
            padding: 0;
            position: sticky;
            top: 0;
            z-index: 100;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.15);
        }

        .nav-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .nav-brand {
            color: white;
            font-size: 1.4rem;
            font-weight: 700;
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 18px 0;
        }

        .nav-brand i {
            font-size: 1.6rem;
            color: #ffd700;
        }

        .nav-links {
            display: flex;
            gap: 5px;
        }

        .nav-links a {
            color: rgba(255, 255, 255, 0.85);
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s;
            padding: 20px 22px;
            display: flex;
            align-items: center;
            gap: 8px;
            position: relative;
        }

        .nav-links a i {
            font-size: 1.1rem;
        }

        .nav-links a::after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 50%;
            width: 0;
            height: 3px;
            background: #ffd700;
            transition: all 0.3s ease;
            transform: translateX(-50%);
        }

        .nav-links a:hover,
        .nav-links a.active {
            color: white;
            background: rgba(255, 255, 255, 0.1);
        }

        .nav-links a:hover::after,
        .nav-links a.active::after {
            width: 60%;
        }

        .hero {
            background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 50%, #1a7544 100%);
            padding: 70px 20px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }

        .hero-content {
            position: relative;
            z-index: 1;
        }

        .hero-icon {
            font-size: 60px;
            color: #ffd700;
            margin-bottom: 20px;
            text-shadow: 0 0 30px rgba(255, 215, 0, 0.4);
        }

        .hero h1 {
            font-size: 2.5rem;
            margin-bottom: 12px;
            font-weight: 700;
        }

        .hero p {
            color: rgba(255, 255, 255, 0.9);
            font-size: 1.1rem;
            max-width: 500px;
            margin: 0 auto;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 50px 20px;
        }

        .year-selector {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 20px;
            margin-bottom: 40px;
        }

        .year-selector button {
            width: 45px;
            height: 45px;
            background: white;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #1a5d3a;
            border: none;
            cursor: pointer;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            transition: all 0.3s;
            font-size: 1rem;
        }

        .year-selector button:hover {
            background: #1a5d3a;
            color: white;
            transform: scale(1.1);
        }

        .year-selector .year-display {
            font-size: 2rem;
            font-weight: 700;
            color: #1a5d3a;
            min-width: 120px;
            text-align: center;
        }

        .month-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 20px;
        }

        .month-card {
            background: white;
            border-radius: 16px;
            padding: 30px 20px;
            text-align: center;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
            transition: all 0.3s ease;
            cursor: pointer;
            text-decoration: none;
            color: inherit;
            border: 2px solid transparent;
            position: relative;
            overflow: hidden;
        }

        .month-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: linear-gradient(90deg, #1a5d3a, #2e8b57);
            transform: scaleX(0);
            transition: transform 0.3s;
        }

        .month-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 35px rgba(26, 93, 58, 0.15);
            border-color: #1a5d3a;
        }

        .month-card:hover::before {
            transform: scaleX(1);
        }

        .month-icon {
            width: 60px;
            height: 60px;
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
        }

        .month-icon i {
            font-size: 1.5rem;
            color: #1a5d3a;
        }

        .month-name {
            font-size: 1.1rem;
            font-weight: 600;
            margin-bottom: 5px;
        }

        .month-count {
            font-size: 0.85rem;
            opacity: 0.7;
        }

        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 10px;
            background: white;
            color: #1a5d3a;
            padding: 12px 25px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
            transition: all 0.3s;
            cursor: pointer;
            border: none;
            font-size: 1rem;
        }

        .back-btn:hover {
            background: #1a5d3a;
            color: white;
            transform: translateX(-5px);
        }

        .section-title {
            text-align: center;
            margin-bottom: 40px;
        }

        .section-title h2 {
            font-size: 1.8rem;
            color: #1a5d3a;
            margin-bottom: 10px;
        }

        .section-title p {
            color: #666;
        }

        .events-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(340px, 1fr));
            gap: 25px;
        }

        .event-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.06);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }

        .event-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 5px;
            height: 100%;
            background: linear-gradient(180deg, #1a5d3a, #2e8b57);
        }

        .event-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 35px rgba(26, 93, 58, 0.12);
        }

        .event-date {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: linear-gradient(135deg, #e8f5e9 0%, #c8e6c9 100%);
            color: #1a5d3a;
            padding: 8px 15px;
            border-radius: 25px;
            font-size: 0.85rem;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .event-card h3 {
            color: #333;
            font-size: 1.2rem;
            margin-bottom: 12px;
            font-weight: 600;
        }

        .event-time {
            color: #1a5d3a;
            font-weight: 500;
            margin-bottom: 12px;
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 0.95rem;
        }

        .event-time i {
            font-size: 1rem;
            color: #2e8b57;
        }

        .event-desc {
            color: #666;
            font-size: 0.9rem;
            line-height: 1.7;
        }

        .no-events {
            text-align: center;
            padding: 60px 40px;
            color: #888;
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
            grid-column: 1 / -1;
        }

        .no-events .icon {
            font-size: 60px;
            margin-bottom: 20px;
            color: #ccc;
        }

        .no-events h3 {
            color: #666;
            font-size: 1.3rem;
            margin-bottom: 10px;
        }

        .no-events p {
            color: #999;
        }

        .loading {
            text-align: center;
            padding: 40px;
            color: #1a5d3a;
        }

        .loading i {
            font-size: 2rem;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% {
                transform: rotate(0deg);
            }

            100% {
                transform: rotate(360deg);
            }
        }

        footer {
            background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 100%);
            color: white;
            text-align: center;
            padding: 30px;
            margin-top: 50px;
        }

        footer p {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            font-size: 0.95rem;
        }

        footer i {
            color: #ffd700;
        }

        @media (max-width: 900px) {
            .month-grid {
                grid-template-columns: repeat(3, 1fr);
            }
        }

        @media (max-width: 768px) {
            .nav-links {
                display: none;
            }

            .hero h1 {
                font-size: 1.8rem;
            }

            .hero-icon {
                font-size: 45px;
            }

            .month-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 15px;
            }

            .month-card {
                padding: 20px 15px;
            }

            .month-icon {
                width: 50px;
                height: 50px;
            }

            .events-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>

<body>
    <nav>
        <div class="nav-container">
            <a href="index.jsp" class="nav-brand"><i class="fas fa-mosque"></i> Masjid Jabalussalam</a>
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
            <div class="hero-icon"><i class="fas fa-calendar-days"></i></div>
            <h1>Jadwal Kegiatan</h1>
            <p>Informasi Kegiatan Masjid Jabalussalam</p>
        </div>
    </div>
    <div class="container">
        <div id="content">
            <div class="loading"><i class="fas fa-spinner"></i>
                <p>Memuat data...</p>
            </div>
        </div>
    </div>
    <footer>
        <p><i class="fas fa-mosque"></i> Masjid Jabalussalam </p>
    </footer>

    <script>
        let currentYear = new Date().getFullYear();
        let currentView = 'months';
        let selectedMonth = null;

        function loadMonths() {
            currentView = 'months';
            const content = document.getElementById('content');
            content.innerHTML = '<div class="loading"><i class="fas fa-spinner"></i><p>Memuat data...</p></div>';

            fetch('api/kegiatan?action=count&tahun=' + currentYear)
                .then(response => response.json())
                .then(data => {
                    let html = '<div class="year-selector">';
                    html += '<button onclick="changeYear(-1)"><i class="fas fa-chevron-left"></i></button>';
                    html += '<span class="year-display">' + currentYear + '</span>';
                    html += '<button onclick="changeYear(1)"><i class="fas fa-chevron-right"></i></button>';
                    html += '</div>';
                    html += '<div class="month-grid">';

                    if (data.data) {
                        data.data.forEach(function (item) {
                            html += '<div class="month-card" onclick="loadEvents(' + item.bulan + ')">';
                            html += '<div class="month-icon"><i class="fas fa-calendar-alt"></i></div>';
                            html += '<div class="month-name">' + item.nama + '</div>';
                            html += '<div class="month-count">' + item.count + ' Kegiatan</div>';
                            html += '</div>';
                        });
                    }

                    html += '</div>';
                    content.innerHTML = html;
                })
                .catch(error => {
                    content.innerHTML = '<div class="no-events"><div class="icon"><i class="fas fa-exclamation-triangle"></i></div><h3>Error</h3><p>' + error.message + '</p></div>';
                });
        }

        function loadEvents(bulan) {
            currentView = 'events';
            selectedMonth = bulan;
            const content = document.getElementById('content');
            content.innerHTML = '<div class="loading"><i class="fas fa-spinner"></i><p>Memuat kegiatan...</p></div>';

            fetch('api/kegiatan?action=list&tahun=' + currentYear + '&bulan=' + bulan)
                .then(response => response.json())
                .then(data => {
                    let html = '<button class="back-btn" onclick="loadMonths()"><i class="fas fa-arrow-left"></i> Kembali ke Daftar Bulan</button>';
                    html += '<div class="section-title">';
                    html += '<h2><i class="fas fa-calendar-check"></i> Kegiatan ' + data.namaBulan + ' ' + data.tahun + '</h2>';
                    html += '<p>Daftar kegiatan masjid pada bulan ' + data.namaBulan + ' ' + data.tahun + '</p>';
                    html += '</div>';
                    html += '<div class="events-grid">';

                    if (data.data && data.data.length > 0) {
                        data.data.forEach(function (item) {
                            html += '<div class="event-card">';
                            html += '<div class="event-date"><i class="fas fa-calendar"></i> ' + item.tanggal + '</div>';
                            html += '<h3>' + item.nama + '</h3>';
                            html += '<div class="event-time"><i class="fas fa-clock"></i> ' + item.waktu + '</div>';
                            html += '<p class="event-desc">' + (item.deskripsi || 'Deskripsi tidak tersedia') + '</p>';
                            html += '</div>';
                        });
                    } else {
                        html += '<div class="no-events">';
                        html += '<div class="icon"><i class="fas fa-calendar-xmark"></i></div>';
                        html += '<h3>Belum Ada Kegiatan</h3>';
                        html += '<p>Tidak ada kegiatan pada bulan ' + data.namaBulan + ' ' + data.tahun + '</p>';
                        html += '</div>';
                    }

                    html += '</div>';
                    content.innerHTML = html;
                })
                .catch(error => {
                    content.innerHTML = '<div class="no-events"><div class="icon"><i class="fas fa-exclamation-triangle"></i></div><h3>Error</h3><p>' + error.message + '</p></div>';
                });
        }

        function changeYear(delta) {
            currentYear += delta;
            loadMonths();
        }

        // Load initial view
        loadMonths();
    </script>
</body>

</html>