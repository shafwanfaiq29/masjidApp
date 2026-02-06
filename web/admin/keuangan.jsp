<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Keuangan - Admin Masjid</title>
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
            background: linear-gradient(135deg, #f0f2f5 0%, #e8eef3 100%);
            min-height: 100vh;
        }

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 280px;
            height: 100vh;
            background: linear-gradient(180deg, #1a5d3a 0%, #0d3320 100%);
            padding: 25px 20px;
            z-index: 100;
            box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1);
            overflow-y: auto;
        }

        .sidebar-header {
            text-align: center;
            padding: 25px 0 35px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            margin-bottom: 30px;
        }

        .sidebar-header .logo {
            font-size: 50px;
            color: #ffd700;
            margin-bottom: 15px;
        }

        .sidebar-header h2 {
            color: white;
            font-size: 1.15rem;
        }

        .sidebar-header p {
            color: rgba(255, 255, 255, 0.6);
            font-size: 0.85rem;
            margin-top: 5px;
        }

        .role-badge {
            display: inline-block;
            padding: 4px 12px;
            background: rgba(255, 215, 0, 0.2);
            color: #ffd700;
            border-radius: 15px;
            font-size: 0.75rem;
            margin-top: 8px;
        }

        .nav-menu {
            list-style: none;
        }

        .nav-menu li {
            margin-bottom: 8px;
        }

        .nav-menu a {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 16px 20px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            border-radius: 12px;
            transition: all 0.3s ease;
        }

        .nav-menu a i {
            font-size: 1.2rem;
            width: 24px;
            text-align: center;
        }

        .nav-menu a:hover,
        .nav-menu a.active {
            background: rgba(255, 255, 255, 0.15);
            color: white;
            transform: translateX(5px);
        }

        .nav-menu a.active {
            background: linear-gradient(90deg, rgba(255, 215, 0, 0.2), transparent);
            border-left: 3px solid #ffd700;
        }

        .nav-menu .logout {
            margin-top: 30px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 25px;
        }

        .nav-menu .logout a {
            color: #ff6b6b;
        }

        .main-content {
            margin-left: 280px;
            padding: 35px;
        }

        .header {
            margin-bottom: 30px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .header h1 {
            color: #333;
            font-size: 1.8rem;
        }

        .header i {
            color: #1a5d3a;
            font-size: 1.6rem;
        }

        .alert {
            padding: 16px 22px;
            border-radius: 12px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 0.95rem;
        }

        .alert-success {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2e7d32;
            border-left: 4px solid #4caf50;
        }

        .alert-error {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #c62828;
            border-left: 4px solid #f44336;
        }

        .summary-cards {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }

        .summary-card {
            background: white;
            border-radius: 16px;
            padding: 22px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.05);
            position: relative;
            overflow: hidden;
        }

        .summary-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 4px;
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
            width: 50px;
            height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
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

        .summary-card h4 {
            color: #888;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .summary-card .amount {
            color: #333;
            font-size: 1.3rem;
            font-weight: 700;
        }

        .card {
            background: white;
            border-radius: 18px;
            padding: 35px;
            box-shadow: 0 8px 25px rgba(0, 0, 0, 0.05);
            margin-bottom: 30px;
        }

        .card h3 {
            color: #333;
            margin-bottom: 28px;
            font-size: 1.25rem;
            padding-bottom: 18px;
            border-bottom: 2px solid #f0f0f0;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .card h3 i {
            color: #1a5d3a;
        }

        .form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 22px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group label {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #555;
            font-weight: 500;
            margin-bottom: 10px;
        }

        .form-group label i {
            color: #1a5d3a;
        }

        .form-group input,
        .form-group select {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e8e8e8;
            border-radius: 12px;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s;
            font-size: 0.95rem;
        }

        .form-group input:focus,
        .form-group select:focus {
            outline: none;
            border-color: #1a5d3a;
            box-shadow: 0 0 0 4px rgba(26, 93, 58, 0.1);
        }

        .btn {
            padding: 14px 32px;
            border: none;
            border-radius: 12px;
            font-weight: 600;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s;
            display: inline-flex;
            align-items: center;
            gap: 10px;
            font-size: 0.95rem;
            text-decoration: none;
        }

        .btn-primary {
            background: linear-gradient(135deg, #1a5d3a, #2e8b57);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(26, 93, 58, 0.3);
        }

        .btn-secondary {
            background: linear-gradient(135deg, #f5f7fa, #e4e8ec);
            color: #555;
        }

        .btn-info {
            background: linear-gradient(135deg, #2196f3, #64b5f6);
            color: white;
        }

        .btn-print {
            background: linear-gradient(135deg, #9c27b0, #ba68c8);
            color: white;
        }

        .btn-print:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 20px rgba(156, 39, 176, 0.3);
        }

        .form-actions {
            margin-top: 25px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .filter-form {
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
            margin-bottom: 25px;
            padding: 20px;
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            border-radius: 12px;
        }

        .filter-form .form-group {
            margin-bottom: 0;
        }

        .filter-results {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 20px;
        }

        .filter-results h4 {
            color: #2e7d32;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .filter-results-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
        }

        .filter-result-item {
            background: white;
            padding: 15px;
            border-radius: 10px;
            text-align: center;
        }

        .filter-result-item .label {
            font-size: 0.8rem;
            color: #666;
            margin-bottom: 5px;
        }

        .filter-result-item .value {
            font-size: 1rem;
            font-weight: 700;
        }

        .filter-result-item .value.pemasukan {
            color: #4caf50;
        }

        .filter-result-item .value.pengeluaran {
            color: #f44336;
        }

        .filter-result-item .value.saldo {
            color: #ff9800;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 700px;
        }

        thead {
            background: linear-gradient(135deg, #f8f9fa, #e9ecef);
        }

        th {
            padding: 16px 14px;
            text-align: left;
            font-weight: 600;
            color: #555;
            font-size: 0.88rem;
        }

        th i {
            margin-right: 6px;
            color: #1a5d3a;
        }

        td {
            padding: 16px 14px;
            border-bottom: 1px solid #f0f0f0;
            font-size: 0.9rem;
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
            font-size: 0.82rem;
            font-weight: 500;
        }

        .badge.pemasukan {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2e7d32;
        }

        .badge.pengeluaran {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #c62828;
        }

        .btn-edit,
        .btn-delete {
            padding: 10px 18px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s;
            margin-right: 8px;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 0.85rem;
            font-weight: 500;
        }

        .btn-edit {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1976d2;
        }

        .btn-delete {
            background: linear-gradient(135deg, #ffebee, #ffcdd2);
            color: #d32f2f;
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

        .modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 1000;
            justify-content: center;
            align-items: center;
            backdrop-filter: blur(5px);
        }

        .modal.show {
            display: flex;
        }

        .modal-content {
            background: white;
            border-radius: 20px;
            padding: 35px;
            width: 90%;
            max-width: 480px;
            max-height: 90vh;
            overflow-y: auto;
        }

        .modal-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 28px;
            padding-bottom: 18px;
            border-bottom: 2px solid #f0f0f0;
        }

        .modal-header h3 {
            color: #333;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal-header h3 i {
            color: #1a5d3a;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 1.5rem;
            cursor: pointer;
            color: #999;
        }

        .print-only {
            display: none;
        }

        @media print {
            body {
                background: white !important;
                color: black !important;
            }

            .sidebar,
            .no-print,
            .btn,
            .btn-edit,
            .btn-delete,
            #summaryCards,
            form[action*="Servlet"],
            .filter-form,
            .header {
                display: none !important;
            }

            .main-content {
                margin-left: 0 !important;
                padding: 0 !important;
                width: 100% !important;
            }

            .card {
                box-shadow: none !important;
                border: none !important;
                padding: 0 !important;
                margin: 0 !important;
            }

            .card h3 {
                display: none !important;
            }

            .print-header {
                display: block !important;
                text-align: center;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 2px solid #000;
            }

            .print-header h1 {
                font-size: 18pt;
                color: #000;
                margin-bottom: 5px;
            }

            .print-header p {
                font-size: 11pt;
                color: #000;
            }

            .print-only {
                display: block !important;
            }

            .print-summary-top {
                display: flex;
                justify-content: space-between;
                margin-bottom: 20px;
                border: 1px solid #000;
                padding: 10px;
            }

            .print-summary-item {
                text-align: center;
                flex: 1;
            }

            .print-summary-item h4 {
                font-size: 10pt;
                margin-bottom: 5px;
                font-weight: normal;
            }

            .print-summary-item .amount {
                font-size: 12pt;
                font-weight: bold;
            }

            .print-summary-bottom {
                margin-top: 20px;
                text-align: right;
                border-top: 2px solid #000;
                padding-top: 10px;
            }

            .print-summary-bottom .label {
                font-size: 12pt;
                font-weight: bold;
                margin-right: 10px;
            }

            .print-summary-bottom .amount {
                font-size: 14pt;
                font-weight: bold;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                border: 1px solid #000;
                font-size: 10pt;
            }

            th,
            td {
                border: 1px solid #000 !important;
                padding: 5px 8px !important;
                text-align: left;
                color: #000 !important;
            }

            th {
                background-color: #f0f0f0 !important;
                -webkit-print-color-adjust: exact;
            }

            /* Hide icons in print for cleaner look */
            i {
                display: none !important;
            }

            /* Remove badges styles in print */
            .badge {
                background: none !important;
                padding: 0 !important;
                color: #000 !important;
                border: none;
            }
        }

        .print-header {
            display: none;
        }

        @media (max-width: 992px) {
            .sidebar {
                width: 80px;
                padding: 15px 10px;
            }

            .sidebar-header h2,
            .sidebar-header p,
            .nav-menu a span,
            .role-badge {
                display: none;
            }

            .sidebar-header .logo {
                font-size: 35px;
            }

            .nav-menu a {
                justify-content: center;
                padding: 14px;
            }

            .main-content {
                margin-left: 80px;
            }
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .main-content {
                margin-left: 0;
                padding: 20px;
            }
        }
    </style>
</head>

<body>
    <div class="print-header">
        <h1>Masjid Jabalussalam</h1>
        <p>Laporan Keuangan</p>
        <p id="printDateRange">Semua Waktu</p>
    </div>

    <!-- Top Summary for Print: Pemasukan & Pengeluaran for the selected period -->
    <div class="print-only print-summary-top">
        <div class="print-summary-item">
            <h4>Total Pemasukan (Periode Ini)</h4>
            <div class="amount" id="printPemasukan">Rp0</div>
        </div>
        <div class="print-summary-item">
            <h4>Total Pengeluaran (Periode Ini)</h4>
            <div class="amount" id="printPengeluaran">Rp0</div>
        </div>
    </div>

    <div class="sidebar no-print">
        <div class="sidebar-header">
            <div class="logo"><i class="fas fa-mosque"></i></div>
            <h2>Masjid Jabalussalam</h2>
            <p>Admin Panel</p>
            <span class="role-badge" id="roleBadge"><i class="fas fa-user-tag"></i> Admin</span>
        </div>
        <ul class="nav-menu">
            <li><a href="dashboard.jsp"><i class="fas fa-gauge-high"></i><span>Dashboard</span></a></li>
            <li id="menuKegiatan"><a href="kegiatan.jsp"><i class="fas fa-calendar-days"></i><span>Kelola
                        Kegiatan</span></a></li>
            <li id="menuKeuangan"><a href="keuangan.jsp" class="active"><i
                        class="fas fa-money-bill-wave"></i><span>Kelola Keuangan</span></a></li>
            <li id="menuArsip"><a href="arsip.jsp"><i class="fas fa-folder-open"></i><span>Kelola Arsip</span></a></li>
            <li id="menuUsers"><a href="users.jsp"><i class="fas fa-users-cog"></i><span>Kelola User</span></a></li>
            <li class="logout"><a href="../LogoutServlet"><i
                        class="fas fa-right-from-bracket"></i><span>Logout</span></a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header no-print">
            <i class="fas fa-money-bill-wave"></i>
            <h1>Kelola Keuangan</h1>
        </div>

        <div id="alertContainer"></div>

        <div id="summaryCards" class="summary-cards"></div>

        <div class="card">
            <h3><i class="fas fa-filter"></i> Filter & Cetak Laporan</h3>
            <div class="filter-form no-print">
                <div class="form-group" style="flex: 2; min-width: 200px;">
                    <label><i class="fas fa-search"></i> Cari Keterangan</label>
                    <input type="text" id="searchInput" placeholder="Cari keterangan transaksi...">
                </div>
                <div class="form-group">
                    <label><i class="fas fa-tag"></i> Kategori</label>
                    <select id="filterKategori">
                        <option value="">Semua</option>
                        <option value="Pemasukan">Pemasukan</option>
                        <option value="Pengeluaran">Pengeluaran</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-calendar-alt"></i> Tanggal Mulai</label>
                    <input type="date" id="startDate">
                </div>
                <div class="form-group">
                    <label><i class="fas fa-calendar-alt"></i> Tanggal Akhir</label>
                    <input type="date" id="endDate">
                </div>
                <button type="button" class="btn btn-info" onclick="applyFilter()"><i class="fas fa-search"></i>
                    Tampilkan</button>
                <button type="button" class="btn btn-print" onclick="printReport()"><i class="fas fa-print"></i> Cetak
                    Laporan</button>
                <button type="button" class="btn btn-secondary" onclick="resetFilter()"><i class="fas fa-times"></i>
                    Reset</button>
            </div>
            <div id="filterResults" class="filter-results" style="display:none;">
                <h4><i class="fas fa-chart-pie"></i> <span id="filterPeriod"></span></h4>
                <div class="filter-results-grid">
                    <div class="filter-result-item">
                        <div class="label">Pemasukan</div>
                        <div class="value pemasukan" id="filteredPemasukan">Rp0</div>
                    </div>
                    <div class="filter-result-item">
                        <div class="label">Pengeluaran</div>
                        <div class="value pengeluaran" id="filteredPengeluaran">Rp0</div>
                    </div>
                    <div class="filter-result-item">
                        <div class="label">Selisih</div>
                        <div class="value saldo" id="filteredSaldo">Rp0</div>
                    </div>
                </div>
            </div>
        </div>

        <div class="card no-print">
            <h3><i class="fas fa-plus-circle"></i> Tambah Transaksi Baru</h3>
            <form id="addForm">
                <div class="form-grid">
                    <div class="form-group">
                        <label><i class="fas fa-calendar"></i> Tanggal</label>
                        <input type="date" name="tanggal" id="addTanggal" required>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-tag"></i> Kategori</label>
                        <select name="kategori" id="addKategori" required>
                            <option value="">-- Pilih --</option>
                            <option value="Pemasukan">Pemasukan</option>
                            <option value="Pengeluaran">Pengeluaran</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-money-bill"></i> Jumlah (Rp)</label>
                        <input type="number" name="jumlah" id="addJumlah" required placeholder="Masukkan jumlah"
                            min="0">
                    </div>
                    <div class="form-group" style="grid-column:1/-1;">
                        <label><i class="fas fa-file-alt"></i> Keterangan</label>
                        <input type="text" name="keterangan" id="addKeterangan" required
                            placeholder="Masukkan keterangan transaksi">
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan</button>
                    <button type="reset" class="btn btn-secondary"><i class="fas fa-rotate-left"></i> Reset</button>
                </div>
            </form>
        </div>

        <div class="card">
            <h3><i class="fas fa-list"></i> Daftar Transaksi</h3>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th><i class="fas fa-calendar"></i> Tanggal</th>
                            <th><i class="fas fa-file-alt"></i> Keterangan</th>
                            <th><i class="fas fa-tag"></i> Kategori</th>
                            <th><i class="fas fa-money-bill"></i> Jumlah</th>
                            <th class="no-print"><i class="fas fa-cog"></i> Aksi</th>
                        </tr>
                    </thead>
                    <tbody id="transactionBody">
                        <tr>
                            <td colspan="5" class="no-data"><i class="fas fa-spinner fa-spin"></i> Memuat data...</td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Bottom Summary for Print: Overall Balance -->
            <div class="print-only print-summary-bottom">
                <span class="label">Sisa Saldo Keseluruhan:</span>
                <span class="amount" id="printSaldo">Rp0</span>
            </div>
        </div>
    </div>

    <div class="modal" id="editModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-pen-to-square"></i> Edit Transaksi</h3>
                <button class="modal-close" onclick="closeEdit()"><i class="fas fa-times"></i></button>
            </div>
            <form id="editForm">
                <input type="hidden" name="id" id="editId">
                <div class="form-group">
                    <label><i class="fas fa-calendar"></i> Tanggal</label>
                    <input type="date" name="tanggal" id="editTanggal" required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-file-alt"></i> Keterangan</label>
                    <input type="text" name="keterangan" id="editKeterangan" required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-tag"></i> Kategori</label>
                    <select name="kategori" id="editKategori" required>
                        <option value="Pemasukan">Pemasukan</option>
                        <option value="Pengeluaran">Pengeluaran</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-money-bill"></i> Jumlah (Rp)</label>
                    <input type="number" name="jumlah" id="editJumlah" required min="0">
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan</button>
                    <button type="button" class="btn btn-secondary" onclick="closeEdit()"><i class="fas fa-times"></i>
                        Batal</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        let currentStartDate = '';
        let currentEndDate = '';

        function formatRupiah(num) {
            return 'Rp' + num.toLocaleString('id-ID', { minimumFractionDigits: 0, maximumFractionDigits: 0 });
        }

        function formatDate(dateStr) {
            const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
            const parts = dateStr.split('-');
            if (parts.length >= 3) {
                return parseInt(parts[2]) + ' ' + months[parseInt(parts[1]) - 1] + ' ' + parts[0];
            }
            return dateStr;
        }

        function loadData(startDate, endDate) {
            let url = '../api/keuangan';
            if (startDate && endDate) {
                url += '?start=' + startDate + '&end=' + endDate;
                currentStartDate = startDate;
                currentEndDate = endDate;
            } else {
                currentStartDate = '';
                currentEndDate = '';
            }

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        document.getElementById('alertContainer').innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Error: ' + data.error + '</div>';
                        return;
                    }

                    // Update summary cards
                    let summaryHtml = '';
                    summaryHtml += '<div class="summary-card pemasukan"><div class="icon-wrapper"><i class="fas fa-arrow-trend-up"></i></div><h4>Total Pemasukan</h4><div class="amount">' + formatRupiah(data.overallPemasukan) + '</div></div>';
                    summaryHtml += '<div class="summary-card pengeluaran"><div class="icon-wrapper"><i class="fas fa-arrow-trend-down"></i></div><h4>Total Pengeluaran</h4><div class="amount">' + formatRupiah(data.overallPengeluaran) + '</div></div>';
                    summaryHtml += '<div class="summary-card saldo"><div class="icon-wrapper"><i class="fas fa-wallet"></i></div><h4>Sisa Saldo</h4><div class="amount">' + formatRupiah(data.overallSaldo) + '</div></div>';
                    document.getElementById('summaryCards').innerHTML = summaryHtml;

                    // Update print summary elements
                    if (document.getElementById('printPemasukan')) {
                        document.getElementById('printPemasukan').textContent = formatRupiah(data.filteredPemasukan);
                        document.getElementById('printPengeluaran').textContent = formatRupiah(data.filteredPengeluaran);
                        document.getElementById('printSaldo').textContent = formatRupiah(data.overallSaldo);
                    }

                    // Update filtered results if filter is applied
                    if (data.hasFilter) {
                        document.getElementById('filterResults').style.display = 'block';
                        document.getElementById('filterPeriod').textContent = formatDate(currentStartDate) + ' s/d ' + formatDate(currentEndDate);
                        document.getElementById('filteredPemasukan').textContent = formatRupiah(data.filteredPemasukan);
                        document.getElementById('filteredPengeluaran').textContent = formatRupiah(data.filteredPengeluaran);
                        document.getElementById('filteredSaldo').textContent = formatRupiah(data.filteredSaldo);
                    } else {
                        document.getElementById('filterResults').style.display = 'none';
                    }

                    // Update transaction table
                    let tableHtml = '';
                    if (data.transaksi && data.transaksi.length > 0) {
                        data.transaksi.forEach(function (item, index) {
                            let katClass = item.kategori.toLowerCase();
                            let katIcon = item.kategori === 'Pemasukan' ? 'fa-arrow-up' : 'fa-arrow-down';

                            tableHtml += '<tr>';
                            tableHtml += '<td>' + item.tanggal + '</td>';
                            tableHtml += '<td>' + item.keterangan + '</td>';
                            tableHtml += '<td><span class="badge ' + katClass + '"><i class="fas ' + katIcon + '"></i> ' + item.kategori + '</span></td>';
                            tableHtml += '<td><strong>' + formatRupiah(item.jumlah) + '</strong></td>';
                            tableHtml += '<td class="no-print">';
                            tableHtml += '<button class="btn-edit" onclick="openEdit(' + item.id + ', \'' + item.tanggal + '\', \'' + escapeJs(item.keterangan) + '\', \'' + item.kategori + '\', ' + item.jumlah + ')"><i class="fas fa-pen-to-square"></i> Edit</button>';
                            tableHtml += '<button class="btn-delete" onclick="deleteTransaction(' + item.id + ')"><i class="fas fa-trash-can"></i> Hapus</button>';
                            tableHtml += '</td>';
                            tableHtml += '</tr>';
                        });
                    } else {
                        tableHtml = '<tr><td colspan="5" class="no-data"><i class="fas fa-wallet"></i>Belum ada data transaksi</td></tr>';
                    }
                    document.getElementById('transactionBody').innerHTML = tableHtml;
                })
                .catch(error => {
                    document.getElementById('alertContainer').innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Error: ' + error.message + '</div>';
                });
        }

        function escapeJs(str) {
            if (!str) return '';
            return str.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '\\"');
        }

        function applyFilter() {
            let startDate = document.getElementById('startDate').value;
            let endDate = document.getElementById('endDate').value;
            if (startDate && endDate) {
                loadData(startDate, endDate);
            } else {
                alert('Silakan pilih tanggal mulai dan tanggal akhir');
            }
        }

        function resetFilter() {
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.getElementById('filterResults').style.display = 'none';
            loadData();
        }

        function printReport() {
            let startDate = document.getElementById('startDate').value;
            let endDate = document.getElementById('endDate').value;

            if (!startDate || !endDate) {
                alert('Silakan pilih rentang tanggal terlebih dahulu sebelum mencetak laporan');
                return;
            }

            // Update print header with date range
            document.getElementById('printDateRange').textContent = 'Periode: ' + formatDate(startDate) + ' s/d ' + formatDate(endDate);

            // Trigger print
            window.print();
        }

        function openEdit(id, tgl, ket, kat, jml) {
            document.getElementById('editId').value = id;
            document.getElementById('editTanggal').value = tgl;
            document.getElementById('editKeterangan').value = ket;
            document.getElementById('editKategori').value = kat;
            document.getElementById('editJumlah').value = jml;
            document.getElementById('editModal').classList.add('show');
        }

        function closeEdit() {
            document.getElementById('editModal').classList.remove('show');
        }

        function deleteTransaction(id) {
            if (confirm('Yakin hapus transaksi ini?')) {
                fetch('../KeuanganServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=delete&id=' + id
                })
                    .then(response => response.text())
                    .then(result => {
                        loadData(currentStartDate, currentEndDate);
                        document.getElementById('alertContainer').innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Transaksi berhasil dihapus!</div>';
                        setTimeout(() => { document.getElementById('alertContainer').innerHTML = ''; }, 3000);
                    });
            }
        }

        // Form submissions
        document.getElementById('addForm').addEventListener('submit', function (e) {
            e.preventDefault();
            let formData = new FormData(this);
            formData.append('action', 'add');

            fetch('../KeuanganServlet', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
                .then(response => response.text())
                .then(result => {
                    this.reset();
                    loadData(currentStartDate, currentEndDate);
                    document.getElementById('alertContainer').innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Transaksi berhasil ditambahkan!</div>';
                    setTimeout(() => { document.getElementById('alertContainer').innerHTML = ''; }, 3000);
                });
        });

        document.getElementById('editForm').addEventListener('submit', function (e) {
            e.preventDefault();
            let formData = new FormData(this);
            formData.append('action', 'edit');

            fetch('../KeuanganServlet', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
                .then(response => response.text())
                .then(result => {
                    closeEdit();
                    loadData(currentStartDate, currentEndDate);
                    document.getElementById('alertContainer').innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Transaksi berhasil diperbarui!</div>';
                    setTimeout(() => { document.getElementById('alertContainer').innerHTML = ''; }, 3000);
                });
        });

        document.getElementById('editModal').addEventListener('click', function (e) {
            if (e.target === this) closeEdit();
        });

        // Load initial data
        loadData();
    </script>
</body>

</html>