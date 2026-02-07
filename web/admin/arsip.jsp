<%@page import="java.sql.*" %>
    <%@page import="com.masjid.config.Koneksi" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <% if(session.getAttribute("adminId")==null){ response.sendRedirect("../login.jsp"); return; } String
                adminRole=(String)session.getAttribute("adminRole"); if(adminRole==null) adminRole="Admin" ; boolean
                isAdmin=adminRole.contains("Admin"); boolean canAccessKegiatan=isAdmin||adminRole.contains("Imarah");
                boolean canAccessKeuangan=isAdmin||adminRole.contains("Riayah"); boolean
                canAccessArsip=isAdmin||adminRole.contains("Idarah"); boolean canAccessUsers=isAdmin;
                if(!canAccessArsip){ response.sendRedirect("dashboard.jsp?error=access"); return; } %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Kelola Arsip - Admin Masjid</title>
                    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
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
                            background: linear-gradient(135deg, #e8f5e9, #c8e6c9);
                            color: #2e7d32;
                        }

                        .btn-view,
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
                            text-decoration: none;
                        }

                        .btn-view {
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
                            <span class="role-badge"><i class="fas fa-user-tag"></i>
                                <%=adminRole%>
                            </span>
                        </div>
                        <ul class="nav-menu">
                            <li><a href="dashboard.jsp"><i class="fas fa-gauge-high"></i><span>Dashboard</span></a></li>
                            <% if(canAccessKegiatan) { %>
                                <li><a href="kegiatan.jsp"><i class="fas fa-calendar-days"></i><span>Kelola
                                            Kegiatan</span></a></li>
                                <% } %>
                                    <% if(canAccessKeuangan) { %>
                                        <li><a href="keuangan.jsp"><i class="fas fa-money-bill-wave"></i><span>Kelola
                                                    Keuangan</span></a></li>
                                        <% } %>
                                            <% if(canAccessArsip) { %>
                                                <li><a href="arsip.jsp" class="active"><i
                                                            class="fas fa-folder-open"></i><span>Kelola Arsip</span></a>
                                                </li>
                                                <% } %>
                                                    <% if(canAccessUsers) { %>
                                                        <li><a href="users.jsp"><i
                                                                    class="fas fa-users-cog"></i><span>Kelola
                                                                    User</span></a></li>
                                                        <% } %>
                                                            <li class="logout"><a href="../LogoutServlet"><i
                                                                        class="fas fa-right-from-bracket"></i><span>Logout</span></a>
                                                            </li>
                        </ul>
                    </div>

                    <div class="main-content">
                        <div class="header">
                            <i class="fas fa-folder-open"></i>
                            <h1>Kelola Arsip Dokumen</h1>
                        </div>

                        <div id="alertContainer"></div>

                        <div class="card">
                            <h3><i class="fas fa-upload"></i> Upload Dokumen Baru</h3>
                            <form action="../ArsipServlet" method="post" enctype="multipart/form-data" id="uploadForm">
                                <input type="hidden" name="action" value="add">
                                <div class="form-grid">
                                    <div class="form-group">
                                        <label><i class="fas fa-file-pdf"></i> File PDF</label>
                                        <input type="file" name="file" accept=".pdf" required>
                                    </div>
                                    <div class="form-group">
                                        <label><i class="fas fa-pen"></i> Nama Dokumen</label>
                                        <input type="text" name="nama_dokumen" required
                                            placeholder="Masukkan nama dokumen">
                                    </div>
                                    <div class="form-group">
                                        <label><i class="fas fa-tag"></i> Kategori</label>
                                        <select name="kategori" required>
                                            <option value="">-- Pilih --</option>
                                            <option value="Surat Masuk">Surat Masuk</option>
                                            <option value="Surat Keluar">Surat Keluar</option>
                                            <option value="Laporan">Laporan</option>
                                            <option value="SK">SK</option>
                                            <option value="Proposal">Proposal</option>
                                            <option value="Lainnya">Lainnya</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label><i class="fas fa-calendar"></i> Tanggal</label>
                                        <input type="date" name="tanggal" required>
                                    </div>
                                    <div class="form-group" style="grid-column:1/-1;">
                                        <label><i class="fas fa-file-alt"></i> Deskripsi</label>
                                        <textarea name="deskripsi" placeholder="Masukkan deskripsi dokumen"></textarea>
                                    </div>
                                </div>
                                <div class="form-actions">
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-upload"></i>
                                        Upload</button>
                                    <button type="reset" class="btn btn-secondary"><i class="fas fa-rotate-left"></i>
                                        Reset</button>
                                </div>
                            </form>
                        </div>

                        <div class="card">
                            <h3><i class="fas fa-list"></i> Daftar Arsip Dokumen</h3>

                            <div class="filter-section">
                                <div class="search-box form-group">
                                    <i class="fas fa-search"></i>
                                    <input type="text" id="searchInput"
                                        placeholder="Cari nama dokumen atau deskripsi...">
                                </div>
                                <div class="form-group">
                                    <label><i class="fas fa-tag"></i> Kategori</label>
                                    <select id="filterKategori">
                                        <option value="">Semua</option>
                                        <option value="Surat Masuk">Surat Masuk</option>
                                        <option value="Surat Keluar">Surat Keluar</option>
                                        <option value="Laporan">Laporan</option>
                                        <option value="SK">SK</option>
                                        <option value="Proposal">Proposal</option>
                                        <option value="Lainnya">Lainnya</option>
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
                                <button type="button" class="btn btn-info" onclick="applyFilter()"><i
                                        class="fas fa-search"></i>
                                    Cari</button>
                                <button type="button" class="btn btn-secondary" onclick="resetFilter()"><i
                                        class="fas fa-times"></i>
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
                                            <th><i class="fas fa-file-pdf"></i> Nama Dokumen</th>
                                            <th><i class="fas fa-tag"></i> Kategori</th>
                                            <th><i class="fas fa-file-alt"></i> Deskripsi</th>
                                            <th><i class="fas fa-calendar"></i> Tanggal</th>
                                            <th><i class="fas fa-cog"></i> Aksi</th>
                                        </tr>
                                    </thead>
                                    <tbody id="arsipBody">
                                        <tr>
                                            <td colspan="6" class="loading"><i class="fas fa-spinner"></i> Memuat
                                                data...</td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <script>
                        function loadData(params) {
                            let url = '../api/arsip';
                            if (params) {
                                url += '?' + params;
                            }

                            document.getElementById('arsipBody').innerHTML = '<tr><td colspan="6" class="loading"><i class="fas fa-spinner fa-spin"></i> Memuat data...</td></tr>';

                            fetch(url)
                                .then(response => response.json())
                                .then(data => {
                                    if (data.error) {
                                        document.getElementById('arsipBody').innerHTML = '<tr><td colspan="6" class="no-data"><i class="fas fa-exclamation-triangle"></i>Error: ' + data.error + '</td></tr>';
                                        return;
                                    }

                                    // Show result info if filter is applied
                                    if (params) {
                                        document.getElementById('resultInfo').style.display = 'flex';
                                        document.getElementById('resultText').textContent = 'Ditemukan ' + data.count + ' dokumen';
                                    } else {
                                        document.getElementById('resultInfo').style.display = 'none';
                                    }

                                    let tableHtml = '';
                                    if (data.data && data.data.length > 0) {
                                        data.data.forEach(function (item, index) {
                                            tableHtml += '<tr>';
                                            tableHtml += '<td>' + (index + 1) + '</td>';
                                            tableHtml += '<td><strong>' + item.nama_dokumen + '</strong></td>';
                                            tableHtml += '<td><span class="badge">' + item.kategori + '</span></td>';
                                            tableHtml += '<td>' + item.deskripsi + '</td>';
                                            tableHtml += '<td>' + item.tanggal + '</td>';
                                            tableHtml += '<td>';
                                            tableHtml += '<a href="../ArsipServlet?action=download&id=' + item.id + '" target="_blank" class="btn-view"><i class="fas fa-eye"></i> Lihat</a>';
                                            tableHtml += '<button class="btn-delete" onclick="deleteArsip(' + item.id + ')"><i class="fas fa-trash-can"></i> Hapus</button>';
                                            tableHtml += '</td>';
                                            tableHtml += '</tr>';
                                        });
                                    } else {
                                        tableHtml = '<tr><td colspan="6" class="no-data"><i class="fas fa-folder-open"></i>Belum ada dokumen arsip</td></tr>';
                                    }
                                    document.getElementById('arsipBody').innerHTML = tableHtml;
                                })
                                .catch(error => {
                                    document.getElementById('arsipBody').innerHTML = '<tr><td colspan="6" class="no-data"><i class="fas fa-exclamation-triangle"></i>Error: ' + error.message + '</td></tr>';
                                });
                        }

                        function applyFilter() {
                            let params = [];

                            let search = document.getElementById('searchInput').value.trim();
                            let kategori = document.getElementById('filterKategori').value;
                            let startDate = document.getElementById('startDate').value;
                            let endDate = document.getElementById('endDate').value;

                            if (search) {
                                params.push('search=' + encodeURIComponent(search));
                            }
                            if (kategori) {
                                params.push('kategori=' + encodeURIComponent(kategori));
                            }
                            if (startDate && endDate) {
                                params.push('start=' + startDate);
                                params.push('end=' + endDate);
                            }

                            loadData(params.length > 0 ? params.join('&') : '');
                        }

                        function resetFilter() {
                            document.getElementById('searchInput').value = '';
                            document.getElementById('filterKategori').value = '';
                            document.getElementById('startDate').value = '';
                            document.getElementById('endDate').value = '';
                            document.getElementById('resultInfo').style.display = 'none';
                            loadData();
                        }

                        function deleteArsip(id) {
                            if (confirm('Yakin hapus dokumen ini?')) {
                                fetch('../ArsipServlet', {
                                    method: 'POST',
                                    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
                                    body: 'action=delete&id=' + id
                                })
                                    .then(response => response.text())
                                    .then(result => {
                                        applyFilter();
                                        document.getElementById('alertContainer').innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Dokumen berhasil dihapus!</div>';
                                        setTimeout(() => { document.getElementById('alertContainer').innerHTML = ''; }, 3000);
                                    });
                            }
                        }

                        // Search on Enter key
                        document.getElementById('searchInput').addEventListener('keypress', function (e) {
                            if (e.key === 'Enter') {
                                applyFilter();
                            }
                        });

                        // Check URL params for alerts
                        const urlParams = new URLSearchParams(window.location.search);
                        if (urlParams.get('success') === 'add') {
                            document.getElementById('alertContainer').innerHTML = '<div class="alert alert-success"><i class="fas fa-check-circle"></i> Dokumen berhasil diupload!</div>';
                            setTimeout(() => { document.getElementById('alertContainer').innerHTML = ''; }, 3000);
                        } else if (urlParams.get('error') === 'notpdf') {
                            document.getElementById('alertContainer').innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Hanya file PDF yang diperbolehkan!</div>';
                        } else if (urlParams.get('error') === 'nofile') {
                            document.getElementById('alertContainer').innerHTML = '<div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Silakan pilih file untuk diupload!</div>';
                        }

                        // Load initial data
                        loadData();
                    </script>
                </body>

                </html>