<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Laporan Keuangan - Masjid Jabalussalam</title>
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

        .section-header {
            font-size: 1.3rem;
            color: #1a5d3a;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-weight: 600;
        }

        .section-header i {
            font-size: 1.2rem;
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin-bottom: 40px;
        }

        .summary-card {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
            text-align: center;
            position: relative;
            overflow: hidden;
            transition: all 0.3s ease;
        }

        .summary-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.1);
        }

        .summary-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
        }

        .summary-card.pemasukan::before {
            background: linear-gradient(90deg, #4caf50, #81c784);
        }

        .summary-card.pengeluaran::before {
            background: linear-gradient(90deg, #f44336, #e57373);
        }

        .summary-card.saldo::before {
            background: linear-gradient(90deg, #ff9800, #ffb74d);
        }

        .summary-card .icon-wrapper {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 15px;
            font-size: 26px;
        }

        .summary-card.pemasukan .icon-wrapper {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #4caf50;
        }

        .summary-card.pengeluaran .icon-wrapper {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #f44336;
        }

        .summary-card.saldo .icon-wrapper {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #ff9800;
        }

        .summary-card h3 {
            color: #666;
            font-size: 0.85rem;
            margin-bottom: 10px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 500;
        }

        .summary-card .amount {
            font-size: 1.6rem;
            font-weight: 700;
        }

        .summary-card.pemasukan .amount {
            color: #4caf50;
        }

        .summary-card.pengeluaran .amount {
            color: #f44336;
        }

        .summary-card.saldo .amount {
            color: #ff9800;
        }

        .filter-section {
            background: white;
            border-radius: 20px;
            padding: 25px 30px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
            margin-bottom: 30px;
        }

        .filter-title {
            font-size: 1.1rem;
            color: #1a5d3a;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }

        .filter-form {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
            align-items: flex-end;
        }

        .filter-group {
            flex: 1;
            min-width: 200px;
        }

        .filter-group label {
            display: block;
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .filter-group input {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e8e8e8;
            border-radius: 10px;
            font-size: 0.95rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s;
        }

        .filter-group input:focus {
            outline: none;
            border-color: #1a5d3a;
            box-shadow: 0 0 0 3px rgba(26, 93, 58, 0.1);
        }

        .filter-buttons {
            display: flex;
            gap: 10px;
        }

        .btn-filter {
            padding: 12px 25px;
            border-radius: 10px;
            font-size: 0.95rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s;
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            gap: 8px;
            border: none;
        }

        .btn-filter.primary {
            background: linear-gradient(135deg, #1a5d3a 0%, #2e8b57 100%);
            color: white;
        }

        .btn-filter.primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(26, 93, 58, 0.3);
        }

        .btn-filter.secondary {
            background: #f5f5f5;
            color: #666;
        }

        .btn-filter.secondary:hover {
            background: #e8e8e8;
        }

        .filtered-section {
            display: none;
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border-radius: 20px;
            padding: 25px;
            margin-bottom: 40px;
        }

        .filtered-section.show {
            display: block;
        }

        .filtered-header {
            font-size: 1.1rem;
            color: #1565c0;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 600;
        }

        .filtered-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .filtered-card {
            background: white;
            border-radius: 16px;
            padding: 25px;
            text-align: center;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.08);
        }

        .filtered-card h4 {
            color: #666;
            font-size: 0.8rem;
            margin-bottom: 8px;
            text-transform: uppercase;
            letter-spacing: 1px;
            font-weight: 500;
        }

        .filtered-card .amount {
            font-size: 1.4rem;
            font-weight: 700;
        }

        .filtered-card.pemasukan .amount {
            color: #4caf50;
        }

        .filtered-card.pengeluaran .amount {
            color: #f44336;
        }

        .filtered-card.saldo .amount {
            color: #1565c0;
        }

        .date-range-info {
            font-size: 0.9rem;
            color: #1565c0;
            margin-bottom: 15px;
        }

        .section-title {
            font-size: 1.5rem;
            color: #333;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .section-title i {
            color: #1a5d3a;
        }

        .table-container {
            background: white;
            border-radius: 20px;
            padding: 30px;
            box-shadow: 0 8px 30px rgba(0, 0, 0, 0.06);
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 600px;
        }

        thead {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }

        th {
            padding: 18px 20px;
            text-align: left;
            font-weight: 600;
            color: #555;
            border-bottom: 2px solid #e8e8e8;
            font-size: 0.9rem;
        }

        td {
            padding: 18px 20px;
            border-bottom: 1px solid #f0f0f0;
        }

        tr {
            transition: background 0.2s ease;
        }

        tr:hover {
            background: #fafafa;
        }

        .badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .badge.pemasukan {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #388e3c;
        }

        .badge.pengeluaran {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #d32f2f;
        }

        .badge.debit {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #f57c00;
        }

        .badge.kredit {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1976d2;
        }

        .amount-cell {
            text-align: right;
            font-weight: 600;
            font-family: 'Courier New', monospace;
            font-size: 0.95rem;
        }

        .no-data {
            text-align: center;
            padding: 60px;
            color: #999;
        }

        .no-data i {
            font-size: 50px;
            margin-bottom: 15px;
            color: #ddd;
            display: block;
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

            .summary-cards {
                grid-template-columns: 1fr;
            }

            .filter-form {
                flex-direction: column;
            }

            .filter-group {
                min-width: 100%;
            }

            .filtered-cards {
                grid-template-columns: 1fr;
            }

            .filtered-cards {
                grid-template-columns: 1fr;
            }
        }

        .report-tabs {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 40px;
        }

        .tab-btn {
            padding: 12px 30px;
            border: none;
            background: white;
            color: #666;
            border-radius: 30px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .tab-btn.active {
            background: #1a5d3a;
            color: white;
            box-shadow: 0 8px 20px rgba(26, 93, 58, 0.3);
            transform: translateY(-2px);
        }

        .tab-btn:hover:not(.active) {
            background: #f0f0f0;
            transform: translateY(-2px);
        }
    </style>
</head>

<body>
    <nav>
        <div class="nav-container">
            <a href="index.jsp" class="nav-brand"><i class="fas fa-mosque"></i> Masjid Jabalussalam</a>
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
            <div class="hero-icon"><i class="fas fa-money-bill-wave"></i></div>
            <h1>Laporan Keuangan</h1>
            <p>Transparansi pengelolaan keuangan Masjid Jabalussalam</p>
        </div>
    </div>
    <div class="container">
        <!-- Tabs Section -->
        <div class="report-tabs">
            <button class="tab-btn active" onclick="switchTab('Masjid', this)">
                <i class="fas fa-mosque"></i> Kas Masjid
            </button>
            <button class="tab-btn" onclick="switchTab('Jumat Barokah', this)">
                <i class="fas fa-box-open"></i> Jumat Barokah
            </button>
        </div>

        <!-- Total Keseluruhan -->
        <h3 class="section-header"><i class="fas fa-chart-pie"></i> Total Keseluruhan </h3>
        <div id="overallCards" class="summary-cards">
            <div class="loading"><i class="fas fa-spinner"></i>
                <p>Memuat data...</p>
            </div>
        </div>

        <!-- Filter Rentang Waktu -->
        <div class="filter-section">
            <div class="filter-title"><i class="fas fa-filter"></i> Filter Berdasarkan Rentang Waktu</div>
            <div class="filter-form">
                <div class="filter-group">
                    <label><i class="fas fa-calendar"></i> Tanggal Mulai</label>
                    <input type="date" id="startDate">
                </div>
                <div class="filter-group">
                    <label><i class="fas fa-calendar"></i> Tanggal Akhir</label>
                    <input type="date" id="endDate">
                </div>
                <div class="filter-buttons">
                    <button class="btn-filter primary" onclick="applyFilter()"><i class="fas fa-search"></i>
                        Tampilkan</button>
                    <button class="btn-filter secondary" onclick="resetFilter()"><i class="fas fa-undo"></i>
                        Reset</button>
                </div>
            </div>
        </div>

        <!-- Total Berdasarkan Rentang Waktu -->
        <div id="filteredSection" class="filtered-section">
            <div class="filtered-header"><i class="fas fa-calendar-check"></i> Total Berdasarkan Rentang Waktu</div>
            <div id="dateRangeInfo" class="date-range-info"></div>
            <div id="filteredCards" class="filtered-cards"></div>
        </div>

        <h2 class="section-title"><i class="fas fa-list-ul"></i> Riwayat Transaksi</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th><i class="fas fa-calendar"></i> Tanggal</th>
                        <th><i class="fas fa-file-alt"></i> Keterangan</th>
                        <th><i class="fas fa-tag"></i> Kategori</th>
                        <th style="text-align:right;"><i class="fas fa-money-bill"></i> Jumlah</th>
                    </tr>
                </thead>
                <tbody id="transactionBody">
                    <tr>
                        <td colspan="5" class="loading"><i class="fas fa-spinner"></i> Memuat data...</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <footer>
        <p><i class="fas fa-mosque"></i> Masjid Jabalussalam </p>
    </footer>
    <script>
        let currentStartDate = '';
        let currentEndDate = '';
        let currentJenisLaporan = 'Masjid';

        function formatRupiah(num) {
            return 'Rp' + num.toLocaleString('id-ID', {
                minimumFractionDigits: 0, maximumFractionDigits: 0
            });
        }

        function formatDate(dateStr) {
            const months = ['Januari',
                'Februari',
                'Maret',
                'April',
                'Mei',
                'Juni',
                'Juli',
                'Agustus',
                'September',
                'Oktober',
                'November',
                'Desember'];
            const parts = dateStr.split('-');

            if (parts.length >= 3) {
                return parseInt(parts[2]) + ' ' + months[parseInt(parts[1]) - 1] + ' ' + parts[0];
            }

            return dateStr;
        }

        function switchTab(jenis, btn) {
            // Update UI
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            btn.classList.add('active');

            // Update State
            currentJenisLaporan = jenis;

            // Reload Data
            resetFilter();
        }

        function loadData(startDate, endDate) {
            let url = 'api/keuangan?jenis_laporan=' + encodeURIComponent(currentJenisLaporan);

            if (startDate && endDate) {
                url += '&start=' + startDate + '&end=' + endDate;
                currentStartDate = startDate;
                currentEndDate = endDate;
            }

            else {
                currentStartDate = '';
                currentEndDate = '';
            }

            fetch(url)
                .then(response => response.text()) // Get raw text first
                .then(text => {
                    let data;
                    try {
                        data = JSON.parse(text); // Try to parse JSON
                    } catch (e) {
                        // If parse fails, it's likely an HTML error page. Show it.
                        console.error("Server Error:", text);
                        document.getElementById('overallCards').innerHTML =
                            '<div class="no-data" style="color:red; text-align:left; overflow:auto;"><i class="fas fa-bug"></i> <b>Server Error (Raw):</b><br><pre>' +
                            text.replace(/</g, "&lt;").replace(/>/g, "&gt;") + // Escape HTML to show plain text code
                            '</pre></div>';
                        throw new Error("Invalid JSON response");
                    }

                    if (data.error) {
                        document.getElementById('overallCards').innerHTML = '<div class="no-data"><i class="fas fa-exclamation-triangle"></i>Error: ' + data.error + '</div>';
                        return;
                    }

                    // Update OVERALL summary cards (always shows all-time totals)
                    let overallHtml = '';
                    overallHtml += '<div class="summary-card pemasukan"><div class="icon-wrapper"><i class="fas fa-arrow-trend-up"></i></div><h3>Total Pemasukan</h3><div class="amount">' + formatRupiah(data.overallPemasukan) + '</div></div>';
                    overallHtml += '<div class="summary-card pengeluaran"><div class="icon-wrapper"><i class="fas fa-arrow-trend-down"></i></div><h3>Total Pengeluaran</h3><div class="amount">' + formatRupiah(data.overallPengeluaran) + '</div></div>';
                    overallHtml += '<div class="summary-card saldo"><div class="icon-wrapper"><i class="fas fa-wallet"></i></div><h3>Sisa Saldo Kas</h3><div class="amount">' + formatRupiah(data.overallSaldo) + '</div></div>';
                    document.getElementById('overallCards').innerHTML = overallHtml;

                    // Update FILTERED section if filter is applied
                    const filteredSection = document.getElementById('filteredSection');

                    if (data.hasFilter) {
                        filteredSection.classList.add('show');
                        document.getElementById('dateRangeInfo').innerHTML = '<i class="fas fa-calendar-alt"></i> Periode: ' + formatDate(currentStartDate) + ' - ' + formatDate(currentEndDate);

                        let filteredHtml = '';
                        filteredHtml += '<div class="filtered-card pemasukan"><h4>Pemasukan</h4><div class="amount">' + formatRupiah(data.filteredPemasukan) + '</div></div>';
                        filteredHtml += '<div class="filtered-card pengeluaran"><h4>Pengeluaran</h4><div class="amount">' + formatRupiah(data.filteredPengeluaran) + '</div></div>';
                        filteredHtml += '<div class="filtered-card saldo"><h4>Saldo Periode</h4><div class="amount">' + formatRupiah(data.filteredSaldo) + '</div></div>';
                        document.getElementById('filteredCards').innerHTML = filteredHtml;
                    }

                    else {
                        filteredSection.classList.remove('show');
                    }

                    // Update transaction table
                    let tableHtml = '';

                    if (data.transaksi && data.transaksi.length > 0) {
                        data.transaksi.forEach(function (item) {
                            let katClass = item.kategori.toLowerCase();
                            let katIcon = item.kategori === 'Pemasukan' ? 'fa-arrow-up' : 'fa-arrow-down';

                            tableHtml += '<tr>';
                            tableHtml += '<td>' + formatDate(item.tanggal) + '</td>';
                            tableHtml += '<td>' + item.keterangan + '</td>';
                            tableHtml += '<td><span class="badge ' + katClass + '"><i class="fas ' + katIcon + '"></i> ' + item.kategori + '</span></td>';
                            tableHtml += '<td class="amount-cell">' + formatRupiah(item.jumlah) + '</td>';
                            tableHtml += '</tr>';
                        });
                    }

                    else {
                        let debugMsg = "";
                        if (data.debug_available_types) {
                            debugMsg = "<br><small>Debug Info: DB contains report types: [" + data.debug_available_types + "]</small>";
                        }
                        tableHtml = '<tr><td colspan="4" class="no-data"><i class="fas fa-inbox"></i>Belum ada data transaksi' + debugMsg + '</td></tr>';
                    }

                    document.getElementById('transactionBody').innerHTML = tableHtml;

                }).catch(error => {
                    document.getElementById('overallCards').innerHTML = '<div class="no-data"><i class="fas fa-exclamation-triangle"></i>Error: ' + error.message + '</div>';
                });
        }

        function applyFilter() {
            let startDate = document.getElementById('startDate').value;
            let endDate = document.getElementById('endDate').value;

            if (startDate && endDate) {
                loadData(startDate, endDate);
            }

            else {
                alert('Silakan pilih tanggal mulai dan tanggal akhir');
            }
        }

        function resetFilter() {
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.getElementById('filteredSection').classList.remove('show');
            loadData();
        }

        // Load initial data
        loadData();
    </script>
</body>

</html>