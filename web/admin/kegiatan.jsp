<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Kegiatan - Admin Masjid</title>
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

        .alert-info {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1565c0;
            border-left: 4px solid #2196f3;
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
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 22px;
        }

        .form-group {
            margin-bottom: 18px;
        }

        .form-group.full {
            grid-column: 1/-1;
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
        .form-group select,
        .form-group textarea {
            width: 100%;
            padding: 14px 18px;
            border: 2px solid #e8e8e8;
            border-radius: 12px;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s;
            font-size: 0.95rem;
        }

        .form-group input:focus,
        .form-group select:focus,
        .form-group textarea:focus {
            outline: none;
            border-color: #1a5d3a;
            box-shadow: 0 0 0 4px rgba(26, 93, 58, 0.1);
        }

        .form-group textarea {
            min-height: 100px;
            resize: vertical;
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

        .form-actions {
            margin-top: 25px;
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
        }

        .filter-section {
            display: flex;
            gap: 15px;
            align-items: flex-end;
            flex-wrap: wrap;
            margin-bottom: 25px;
            padding: 20px;
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            border-radius: 12px;
        }

        .filter-section .form-group {
            margin-bottom: 0;
            flex: 1;
            min-width: 150px;
        }

        .search-box {
            position: relative;
            flex: 2;
            min-width: 250px;
        }

        .search-box input {
            padding-left: 45px;
        }

        .search-box i {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
        }

        .result-info {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            padding: 12px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            color: #e65100;
            font-weight: 500;
        }

        .table-wrapper {
            overflow-x: auto;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            min-width: 800px;
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

        .badge.idarah {
            background: linear-gradient(135deg, #e3f2fd, #bbdefb);
            color: #1565c0;
        }

        .badge.imarah {
            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
            color: #2e7d32;
        }

        .badge.riayah {
            background: linear-gradient(135deg, #fff3e0, #ffe0b2);
            color: #ef6c00;
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
            max-width: 520px;
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

            .filter-section {
                flex-direction: column;
            }
        }
    </style>
</head>

<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="logo"><i class="fas fa-mosque"></i></div>
            <h2>Masjid Jabalussalam</h2>
            <p>Admin Panel</p>
            <span class="role-badge" id="roleBadge"><i class="fas fa-user-tag"></i> Admin</span>
        </div>
        <ul class="nav-menu">
            <li><a href="dashboard.jsp"><i class="fas fa-gauge-high"></i><span>Dashboard</span></a></li>
            <li id="menuKegiatan"><a href="kegiatan.jsp" class="active"><i class="fas fa-calendar-days"></i><span>Kelola
                        Kegiatan</span></a></li>
            <li id="menuKeuangan"><a href="keuangan.jsp"><i class="fas fa-money-bill-wave"></i><span>Kelola
                        Keuangan</span></a></li>
            <li id="menuArsip"><a href="arsip.jsp"><i class="fas fa-folder-open"></i><span>Kelola Arsip</span></a></li>
            <li id="menuUsers"><a href="users.jsp"><i class="fas fa-users-cog"></i><span>Kelola User</span></a></li>
            <li class="logout"><a href="../LogoutServlet"><i
                        class="fas fa-right-from-bracket"></i><span>Logout</span></a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <i class="fas fa-calendar-days"></i>
            <h1>Kelola Kegiatan</h1>
        </div>

        <div id="alertContainer"></div>

        <div class="card">
            <h3><i class="fas fa-plus-circle"></i> Tambah Kegiatan Baru</h3>
            <form id="addForm">
                <div class="form-grid">
                    <div class="form-group">
                        <label><i class="fas fa-pen"></i> Nama Kegiatan</label>
                        <input type="text" name="nama_kegiatan" id="addNama" required
                            placeholder="Masukkan nama kegiatan">
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-calendar"></i> Tanggal</label>
                        <input type="date" name="tanggal" id="addTanggal" required>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-clock"></i> Waktu</label>
                        <input type="time" name="waktu" id="addWaktu" required>
                    </div>
                    <div class="form-group full">
                        <label><i class="fas fa-file-alt"></i> Deskripsi</label>
                        <textarea name="deskripsi" id="addDeskripsi"
                            placeholder="Masukkan deskripsi kegiatan"></textarea>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan</button>
                    <button type="reset" class="btn btn-secondary"><i class="fas fa-rotate-left"></i> Reset</button>
                </div>
            </form>
        </div>

        <div class="card">
            <h3><i class="fas fa-list"></i> Daftar Kegiatan</h3>

            <div class="filter-section">
                <div class="search-box form-group">
                    <i class="fas fa-search"></i>
                    <input type="text" id="searchInput" placeholder="Cari nama kegiatan atau deskripsi...">
                </div>
                <div class="form-group">
                    <label><i class="fas fa-layer-group"></i> Bidang</label>
                    <select id="filterBidang">
                        <option value="">Semua</option>
                        <option value="Idarah">Idarah</option>
                        <option value="Imarah">Imarah</option>
                        <option value="Riayah">Riayah</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-calendar-alt"></i> Dari</label>
                    <input type="date" id="startDate">
                </div>
                <div class="form-group">
                    <label><i class="fas fa-calendar-alt"></i> Sampai</label>
                    <input type="date" id="endDate">
                </div>
                <button type="button" class="btn btn-info" onclick="applyFilter()"><i class="fas fa-search"></i>
                    Cari</button>
                <button type="button" class="btn btn-secondary" onclick="resetFilter()"><i class="fas fa-times"></i>
                    Reset</button>
            </div>

            <div id="resultInfo" class="result-info" style="display:none;">
                <i class="fas fa-info-circle"></i>
                <span id="resultText"></span>
            </div>

            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th><i class="fas fa-hashtag"></i> No</th>
                            <th><i class="fas fa-pen"></i> Nama Kegiatan</th>
                            <th><i class="fas fa-layer-group"></i> Bidang</th>
                            <th><i class="fas fa-calendar"></i> Tanggal</th>
                            <th><i class="fas fa-clock"></i> Waktu</th>
                            <th><i class="fas fa-file-alt"></i> Deskripsi</th>
                            <th><i class="fas fa-cog"></i> Aksi</th>
                        </tr>
                    </thead>
                    <tbody id="kegiatanBody">
                        <tr>
                            <td colspan="7" class="loading"><i class="fas fa-spinner"></i> Memuat data...</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal" id="editModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-pen-to-square"></i> Edit Kegiatan</h3>
                <button class="modal-close" onclick="closeEdit()"><i class="fas fa-times"></i></button>
            </div>
            <form id="editForm">
                <input type="hidden" name="id" id="editId">
                <div class="form-group">
                    <label><i class="fas fa-pen"></i> Nama Kegiatan</label>
                    <input type="text" name="nama_kegiatan" id="editNama" required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-calendar"></i> Tanggal</label>
                    <input type="date" name="tanggal" id="editTanggal" required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-clock"></i> Waktu</label>
                    <input type="time" name="waktu" id="editWaktu" required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-file-alt"></i> Deskripsi</label>
                    <textarea name="deskripsi" id="editDeskripsi"></textarea>
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
        function loadData(params) {
            let url = '../api/kegiatan-admin';
            if (params) {
                url += '?' + params;
            }

            document.getElementById('kegiatanBody').innerHTML = '<tr><td colspan="7" class="loading"><i class="fas fa-spinner fa-spin"></i> Memuat data...</td></tr>';

            fetch(url)
                .then(response => response.json())
                .then(data => {
                    if (data.error) {
                        document.getElementById('kegiatanBody').innerHTML = '<tr><td colspan="7" class="no-data"><i class="fas fa-exclamation-triangle"></i>Error: ' + data.error + '</td></tr>';
                        return;
                    }

                    if (params) {
                        document.getElementById('resultInfo').style.display = 'flex';
                        document.getElementById('resultText').textContent = 'Ditemukan ' + data.count + ' kegiatan';
                    } else {
                        document.getElementById('resultInfo').style.display = 'none';
                    }

                    let tableHtml = '';
                    if (data.data && data.data.length > 0) {
                        data.data.forEach(function (item, index) {
                            let bidangClass = item.bidang.toLowerCase();
                            let bidangIcon = 'fa-folder';
                            if (item.bidang === 'Idarah') bidangIcon = 'fa-briefcase';
                            else if (item.bidang === 'Imarah') bidangIcon = 'fa-hands-praying';
                            else if (item.bidang === 'Riayah') bidangIcon = 'fa-tools';

                            tableHtml += '<tr>';
                            tableHtml += '<td>' + (index + 1) + '</td>';
                            tableHtml += '<td><strong>' + item.nama_kegiatan + '</strong></td>';
                            tableHtml += '<td><span class="badge ' + bidangClass + '"><i class="fas ' + bidangIcon + '"></i> ' + item.bidang + '</span></td>';
                            tableHtml += '<td>' + item.tanggal + '</td>';
                            tableHtml += '<td>' + item.waktu + '</td>';
                            tableHtml += '<td>' + (item.deskripsi || '-') + '</td>';
                            tableHtml += '<td>';
                            tableHtml += '<button class="btn-edit" onclick="openEdit(' + item.id + ', \'' + escapeJs(item.nama_kegiatan) + '\', \'' + item.tanggal + '\', \'' + item.waktu + '\', \'' + escapeJs(item.deskripsi) + '\')"><i class="fas fa-pen-to-square"></i> Edit</button>';
                            tableHtml += '<button class="btn-delete" onclick="deleteKegiatan(' + item.id + ')"><i class="fas fa-trash-can"></i> Hapus</button>';
                            tableHtml += '</td>';
                            tableHtml += '</tr>';
                        });
                    } else {
                        tableHtml = '<tr><td colspan="7" class="no-data"><i class="fas fa-calendar-xmark"></i>Belum ada data kegiatan</td></tr>';
                    }
                    document.getElementById('kegiatanBody').innerHTML = tableHtml;
                })
                .catch(error => {
                    document.getElementById('kegiatanBody').innerHTML = '<tr><td colspan="7" class="no-data"><i class="fas fa-exclamation-triangle"></i>Error: ' + error.message + '</td></tr>';
                });
        }

        function escapeJs(str) {
            if (!str) return '';
            return str.replace(/\\/g, '\\\\').replace(/'/g, "\\'").replace(/"/g, '\\"');
        }

        function applyFilter() {
            let params = [];
            let search = document.getElementById('searchInput').value.trim();
            let bidang = document.getElementById('filterBidang').value;
            let startDate = document.getElementById('startDate').value;
            let endDate = document.getElementById('endDate').value;

            if (search) params.push('search=' + encodeURIComponent(search));
            if (bidang) params.push('bidang=' + encodeURIComponent(bidang));
            if (startDate && endDate) {
                params.push('start=' + startDate);
                params.push('end=' + endDate);
            }

            loadData(params.length > 0 ? params.join('&') : '');
        }

        function resetFilter() {
            document.getElementById('searchInput').value = '';
            document.getElementById('filterBidang').value = '';
            document.getElementById('startDate').value = '';
            document.getElementById('endDate').value = '';
            document.getElementById('resultInfo').style.display = 'none';
            loadData();
        }

        function openEdit(id, nama, tgl, wkt, desk) {
            document.getElementById('editId').value = id;
            document.getElementById('editNama').value = nama;
            document.getElementById('editTanggal').value = tgl;
            document.getElementById('editWaktu').value = wkt;
            document.getElementById('editDeskripsi').value = desk;
            document.getElementById('editModal').classList.add('show');
        }

        function closeEdit() {
            document.getElementById('editModal').classList.remove('show');
        }

        function deleteKegiatan(id) {
            if (confirm('Yakin hapus kegiatan ini?')) {
                fetch('../KegiatanServlet', {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                    body: 'action=delete&id=' + id
                })
                    .then(response => response.text())
                    .then(result => {
                        applyFilter();
                        document.getElementById('alertContainer').innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Kegiatan berhasil dihapus!</div>';
                        setTimeout(() => { document.getElementById('alertContainer').innerHTML = ''; }, 3000);
                    });
            }
        }

        document.getElementById('addForm').addEventListener('submit', function (e) {
            e.preventDefault();
            let formData = new FormData(this);
            formData.append('action', 'add');

            fetch('../KegiatanServlet', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
                .then(response => response.text())
                .then(result => {
                    this.reset();
                    applyFilter();
                    document.getElementById('alertContainer').innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Kegiatan berhasil ditambahkan!</div>';
                    setTimeout(() => { document.getElementById('alertContainer').innerHTML = ''; }, 3000);
                });
        });

        document.getElementById('editForm').addEventListener('submit', function (e) {
            e.preventDefault();
            let formData = new FormData(this);
            formData.append('action', 'edit');

            fetch('../KegiatanServlet', {
                method: 'POST',
                body: new URLSearchParams(formData)
            })
                .then(response => response.text())
                .then(result => {
                    closeEdit();
                    applyFilter();
                    document.getElementById('alertContainer').innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Kegiatan berhasil diperbarui!</div>';
                    setTimeout(() => { document.getElementById('alertContainer').innerHTML = ''; }, 3000);
                });
        });

        document.getElementById('editModal').addEventListener('click', function (e) {
            if (e.target === this) closeEdit();
        });

        document.getElementById('searchInput').addEventListener('keypress', function (e) {
            if (e.key === 'Enter') applyFilter();
        });

        loadData();
    </script>
</body>

</html>