<%@page import="java.sql.*" %>
    <%@page import="com.masjid.config.Koneksi" %>
        <%@page contentType="text/html" pageEncoding="UTF-8" %>
            <% if(session.getAttribute("adminId")==null){ response.sendRedirect("../login.jsp"); return; } String
                adminRole=(String)session.getAttribute("adminRole"); if(adminRole==null) adminRole="Admin" ; boolean
                isAdmin=adminRole.contains("Admin"); boolean canAccessKegiatan=isAdmin||adminRole.contains("Imarah");
                boolean canAccessKeuangan=isAdmin||adminRole.contains("Riayah"); boolean
                canAccessArsip=isAdmin||adminRole.contains("Idarah"); boolean canAccessUsers=isAdmin;
                if(!canAccessKeuangan){ response.sendRedirect("dashboard.jsp?error=access"); return; } %>
                <!DOCTYPE html>
                <html>

                <head>
                    <meta charset="UTF-8">
                    <meta name="viewport" content="width=device-width, initial-scale=1.0">
                    <title>Kelola Keuangan - Admin Masjid</title>
                    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap"
                        rel="stylesheet">
                    <link rel="stylesheet"
                        href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
                    <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
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

                        .print-container {
                            display: none;
                        }

                        /* Print Styles */
                        @media print {
                            @page {
                                size: A4;
                                margin: 2cm;
                            }

                            body {
                                background-color: white !important;
                                -webkit-print-color-adjust: exact !important;
                                print-color-adjust: exact !important;
                            }

                            /* Hide Screen Elements */
                            .sidebar,
                            .header,
                            .card,
                            .summary-cards,
                            .alert,
                            .no-print,
                            .btn,
                            .modal,
                            #alertContainer {
                                display: none !important;
                            }

                            .main-content {
                                margin: 0 !important;
                                padding: 0 !important;
                                width: 100% !important;
                            }

                            /* Show Print Container */
                            .print-container {
                                display: block !important;
                                width: 100%;
                                font-family: 'Times New Roman', Times, serif;
                                color: black;
                            }

                            /* Header / Kop Surat */
                            .print-header {
                                text-align: center;
                                margin-bottom: 30px;
                            }

                            .print-header h1 {
                                font-size: 16pt;
                                font-weight: bold;
                                text-transform: uppercase;
                                margin: 0 0 5px 0;
                                line-height: 1.2;
                            }

                            .print-header h2 {
                                font-size: 12pt;
                                font-weight: normal;
                                margin: 0 0 10px 0;
                            }

                            .print-header .divider {
                                border-bottom: 3px solid black;
                                border-top: 1px solid black;
                                height: 3px;
                                width: 100%;
                                margin: 15px 0 20px 0;
                            }

                            .print-header p {
                                font-size: 12pt;
                                font-weight: bold;
                                margin: 5px 0;
                            }

                            .print-header .print-period {
                                font-weight: normal;
                                font-style: italic;
                                font-size: 11pt;
                            }

                            /* Sections & Tables */
                            .print-section {
                                margin-bottom: 30px;
                            }

                            .print-section h3 {
                                font-size: 12pt;
                                font-weight: bold;
                                text-decoration: underline;
                                margin-bottom: 10px;
                                text-transform: uppercase;
                            }

                            table {
                                width: 100%;
                                border-collapse: collapse;
                                border: 1px solid black;
                                font-size: 11pt;
                            }

                            th,
                            td {
                                border: 1px solid black;
                                padding: 6px 8px;
                                text-align: left;
                                vertical-align: top;
                            }

                            th {
                                background-color: #f0f0f0 !important;
                                font-weight: bold;
                                text-align: center;
                            }

                            .text-right {
                                text-align: right;
                            }

                            .text-center {
                                text-align: center;
                            }

                            /* Footer / Totals */
                            tfoot .total-row td {
                                font-weight: bold;
                                background-color: #f9f9f9 !important;
                            }

                            /* Summary Box / Grand Total */
                            .print-summary-box {
                                margin-top: 30px;
                                border: 2px solid black;
                                padding: 15px;
                                width: 50%;
                                margin-left: auto;
                                page-break-inside: avoid;
                            }

                            .summary-row {
                                display: flex;
                                justify-content: space-between;
                                margin-bottom: 8px;
                                font-size: 11pt;
                            }

                            .summary-row.grand-total {
                                border-top: 1px solid black;
                                padding-top: 8px;
                                font-weight: bold;
                                font-size: 12pt;
                            }

                            /* Signatures */
                            .print-footer {
                                margin-top: 60px;
                                display: flex;
                                justify-content: space-between;
                                page-break-inside: avoid;
                            }

                            .sign-box {
                                text-align: center;
                                width: 200px;
                            }

                            .sign-box p {
                                margin: 0;
                                font-size: 11pt;
                            }
                        }

                        /* Screen Responsive Fixes (unchanged) */
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

                        .text-center {
                            text-align: center !important;
                        }

                        .text-right {
                            text-align: right !important;
                        }

                        /* Tab Styles */
                        .report-tabs {
                            display: flex;
                            gap: 15px;
                            margin-bottom: 25px;
                        }

                        .report-tab {
                            padding: 15px 30px;
                            background: white;
                            border-radius: 12px;
                            cursor: pointer;
                            font-weight: 600;
                            color: #555;
                            transition: all 0.3s;
                            box-shadow: 0 4px 15px rgba(0, 0, 0, 0.05);
                            border: 2px solid transparent;
                            display: flex;
                            align-items: center;
                            gap: 10px;
                        }

                        .report-tab.active {
                            background: linear-gradient(135deg, #1a5d3a, #2e8b57);
                            color: white;
                            transform: translateY(-3px);
                            box-shadow: 0 8px 20px rgba(26, 93, 58, 0.2);
                        }

                        .report-tab:hover:not(.active) {
                            background: #f8f9fa;
                            transform: translateY(-2px);
                        }
                    </style>
                </head>

                <body>
                    <div class="sidebar">
                        <div class="sidebar-header">
                            <div class="logo"><i class="fas fa-mosque"></i></div>
                            <h2>Masjid Jabalussalam</h2>
                            <p>Admin Panel</p><span class="role-badge"><i class="fas fa-user-tag"></i>
                                <%=adminRole%>
                            </span>
                        </div>
                        <ul class="nav-menu">
                            <li><a href="dashboard.jsp"><i class="fas fa-gauge-high"></i><span>Dashboard</span></a></li>
                            <%if(canAccessKegiatan) { %>
                                <li><a href="kegiatan.jsp"><i class="fas fa-calendar-days"></i><span>Kelola
                                            Kegiatan</span></a></li>
                                <% } %>
                                    <%if(canAccessKeuangan) { %>
                                        <li><a href="keuangan.jsp" class="active"><i
                                                    class="fas fa-money-bill-wave"></i><span>Kelola Keuangan</span></a>
                                        </li>
                                        <% } %>
                                            <%if(canAccessArsip) { %>
                                                <li><a href="arsip.jsp"><i class="fas fa-folder-open"></i><span>Kelola
                                                            Arsip</span></a></li>
                                                <% } %>
                                                    <%if(canAccessUsers) { %>
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
                        <div class="header"><i class="fas fa-money-bill-wave"></i>
                            <h1>Kelola Keuangan</h1>
                        </div>
                        <div class="print-container">
                            <div class="print-header">
                                <h1>DEWAN KEMAKMURAN MASJID JABALUSSALAM</h1>
                                <h2>PERUMAHAN BUKIT DAMAI SENTOSA 1 BALIKPAPAN</h2>
                                <div class="divider"></div>
                                <p id="printTitle">LAPORAN KEUANGAN MASJID</p>
                                <p class="print-period">Periode: <span id="printPeriode">Semua Waktu</span></p>
                            </div>
                            <div class="print-section">
                                <h3>I. PEMASUKAN</h3>
                                <table>
                                    <thead>
                                        <tr>
                                            <th width="5%">No</th>
                                            <th width="20%" style="white-space: nowrap;">Tanggal</th>
                                            <th width="55%">Keterangan</th>
                                            <th width="20%" class="text-right">Jumlah</th>
                                        </tr>
                                    </thead>
                                    <tbody id="printPemasukanBody">
                                        <!-- Populated by JS -->
                                    </tbody>
                                    <tfoot>
                                        <tr class="total-row">
                                            <td colspan="3">Total Pemasukan</td>
                                            <td class="text-right" id="printTotalPemasukan">Rp0</td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                            <div class="print-section">
                                <h3>II. PENGELUARAN</h3>
                                <table>
                                    <thead>
                                        <tr>
                                            <th width="5%">No</th>
                                            <th width="20%" style="white-space: nowrap;">Tanggal</th>
                                            <th width="55%">Keterangan</th>
                                            <th width="20%" class="text-right">Jumlah</th>
                                        </tr>
                                    </thead>
                                    <tbody id="printPengeluaranBody">
                                        <!-- Populated by JS -->
                                    </tbody>
                                    <tfoot>
                                        <tr class="total-row">
                                            <td colspan="3">Total Pengeluaran</td>
                                            <td class="text-right" id="printTotalPengeluaran">Rp0</td>
                                        </tr>
                                    </tfoot>
                                </table>
                            </div>
                            <div class="print-summary-box">
                                <div class="summary-row"><span>Total Pemasukan</span><span
                                        id="summaryPemasukan">Rp0</span></div>
                                <div class="summary-row"><span>Total Pengeluaran</span><span
                                        id="summaryPengeluaran">Rp0</span></div>
                                <div class="summary-row grand-total"><span>TOTAL SALDO</span><span
                                        id="summarySaldo">Rp0</span></div>
                            </div>
                            <div class="print-footer"
                                style="display: flex; justify-content: space-between; margin-top: 50px;">
                                <div class="sign-box" style="text-align: center;">
                                    <p>Mengetahui,</p>
                                    <p>Ketua DKM</p><br><br><br>
                                    <p>(...........................)</p>
                                </div>
                                <div class="sign-box" style="text-align: center;">
                                    <p>Dibuat Oleh,</p>
                                    <p>Bendahara</p><br><br><br>
                                    <p>(...........................)</p>
                                </div>
                            </div>
                        </div>
                        <div id="alertContainer"></div>
                        <div class="summary-cards no-print">
                            <div class="summary-card pemasukan">
                                <div class="icon-wrapper"><i class="fas fa-arrow-down"></i></div>
                                <div>
                                    <h4>Total Pemasukan</h4>
                                    <div class="amount" id="totalPemasukan">Rp0</div>
                                </div>
                            </div>
                            <div class="summary-card pengeluaran">
                                <div class="icon-wrapper"><i class="fas fa-arrow-up"></i></div>
                                <div>
                                    <h4>Total Pengeluaran</h4>
                                    <div class="amount" id="totalPengeluaran">Rp0</div>
                                </div>
                            </div>
                            <div class="summary-card saldo">
                                <div class="icon-wrapper"><i class="fas fa-wallet"></i></div>
                                <div>
                                    <h4>Saldo Akhir</h4>
                                    <div class="amount" id="totalSaldo">Rp0</div>
                                </div>
                            </div>
                        </div>
                        <!-- Report Tabs -->
                        <div class="report-tabs no-print">
                            <div class="report-tab active" onclick="switchLaporan('Masjid')" id="tabMasjid">
                                <i class="fas fa-mosque"></i> Keuangan Masjid
                            </div>
                            <div class="report-tab" onclick="switchLaporan('Jumat Barokah')" id="tabJumat">
                                <i class="fas fa-hand-holding-heart"></i> Jumat Barokah
                            </div>
                        </div>

                        <!-- Form Card (Replaces Modal) -->
                        <div class="card no-print">
                            <h3><i class="fas fa-plus-circle"></i>Tambah / Edit Data Keuangan</h3>
                            <form id="keuanganForm" action="process_keuangan.jsp" method="post"><input type="hidden"
                                    name="action" id="formAction" value="add"><input type="hidden" name="id"
                                    id="dataId"><input type="hidden" name="jenis_laporan" id="jenisLaporanInput"
                                    value="Masjid">
                                <div class="form-grid">
                                    <div class="form-group"><label><i class="fas fa-exchange-alt"></i>Jenis
                                            Transaksi</label><select name="jenis" id="jenis" required>
                                            <option value="Pemasukan">Pemasukan</option>
                                            <option value="Pengeluaran">Pengeluaran</option>
                                        </select></div>
                                    <div class="form-group"><label><i class="fas fa-money-bill"></i>Jumlah
                                            (Rp)</label><input type="number" name="jumlah" id="jumlah" required min="1"
                                            placeholder="0"></div>
                                    <div class="form-group"><label><i class="fas fa-calendar"></i>Tanggal</label><input
                                            type="date" name="tanggal" id="tanggal" required></div>
                                    <div class="form-group full" style="grid-column: 1/-1;"><label><i
                                                class="fas fa-pen"></i>Keterangan</label><input type="text"
                                            name="keterangan" id="keterangan" required
                                            placeholder="Keterangan transaksi..."></div>
                                </div>
                                <div class="form-actions"><button type="submit" class="btn btn-primary"><i
                                            class="fas fa-save"></i>Simpan</button><button type="button"
                                        class="btn btn-secondary" onclick="resetForm()"><i
                                            class="fas fa-rotate-left"></i>Reset / Batal</button></div>
                            </form>
                        </div>
                        <div class="card no-print">
                            <h3><i class="fas fa-list"></i>Daftar Transaksi Keuangan</h3>
                            <div class="filter-form no-print">
                                <div class="form-group" style="flex: 2; min-width: 200px;">
                                    <label><i class="fas fa-search"></i>Cari Keterangan</label>
                                    <input type="text" id="searchInput" placeholder="Cari keterangan...">
                                </div>
                                <div class="form-group">
                                    <label><i class="fas fa-filter"></i>Jenis</label>
                                    <select id="filterJenis">
                                        <option value="">Semua</option>
                                        <option value="Pemasukan">Pemasukan</option>
                                        <option value="Pengeluaran">Pengeluaran</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label><i class="fas fa-calendar"></i>Dari</label>
                                    <input type="date" id="startDate">
                                </div>
                                <div class="form-group">
                                    <label><i class="fas fa-calendar"></i>Sampai</label>
                                    <input type="date" id="endDate">
                                </div>
                                <button type="button" class="btn btn-info" onclick="applyFilter()">
                                    <i class="fas fa-search"></i>Tampilkan
                                </button>
                                <button type="button" class="btn btn-secondary" onclick="resetFilter()">
                                    <i class="fas fa-sync"></i>Reset
                                </button>
                                <button type="button" class="btn btn-print" onclick="window.print()">
                                    <i class="fas fa-print"></i>Cetak
                                </button>
                            </div>
                            <div class="table-wrapper">
                                <table>
                                    <thead>
                                        <tr>
                                            <th class="text-center"><i class="fas fa-hashtag"></i>No</th>
                                            <th><i class="fas fa-calendar"></i>Tanggal</th>
                                            <th><i class="fas fa-pen"></i>Keterangan</th>
                                            <th><i class="fas fa-exchange-alt"></i>Jenis</th>
                                            <th class="text-right"><i class="fas fa-money-bill"></i>Jumlah</th>
                                            <th class="text-center"><i class="fas fa-cog"></i>Aksi</th>
                                        </tr>
                                    </thead>
                                    <tbody id="keuanganBody">
                                        <tr>
                                            <td colspan="7" class="loading"><i class="fas fa-spinner"></i>Memuat data...
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>

                        <script>const formatRupiah = (number) => {
                                return new Intl.NumberFormat('id-ID', {
                                    style: 'currency',
                                    currency: 'IDR',
                                    minimumFractionDigits: 0
                                }).format(number);
                            }

                                ;

                            const formatDate = (dateString) => {
                                const options = {
                                    day: 'numeric', month: 'long', year: 'numeric'
                                }

                                    ;
                                return new Date(dateString).toLocaleDateString('id-ID', options);
                            }

                                ;

                            // Initialize kategori (Removed)
                            // updateKategori();

                            let globalData = [];
                            let currentLaporanType = 'Masjid';

                            function switchLaporan(type) {
                                currentLaporanType = type;

                                // Update Tabs
                                document.querySelectorAll('.report-tab').forEach(t => t.classList.remove('active'));
                                if (type === 'Masjid') document.getElementById('tabMasjid').classList.add('active');
                                else document.getElementById('tabJumat').classList.add('active');

                                // Update Hidden Input
                                document.getElementById('jenisLaporanInput').value = type;

                                // Update Print Title
                                const title = type === 'Masjid' ? 'LAPORAN KEUANGAN MASJID' : 'LAPORAN KEUANGAN JUMAT BAROKAH';
                                document.getElementById('printTitle').textContent = title;

                                // Reload Data
                                loadData();
                            }

                            function loadData(params) {
                                let url = '../KeuanganServlet?action=get_data';
                                let queryParams = 'jenis_laporan=' + encodeURIComponent(currentLaporanType);

                                if (params) {
                                    url += '&' + queryParams + '&' + params;
                                } else {
                                    url += '&' + queryParams;
                                }

                                document.getElementById('keuanganBody').innerHTML = '<tr><td colspan="7" class="loading"><i class="fas fa-spinner fa-spin"></i> Memuat data...</td></tr>';

                                fetch(url)
                                    .then(response => response.text()) // Get text first
                                    .then(text => {
                                        let data;
                                        try {
                                            data = JSON.parse(text);
                                        } catch (e) {
                                            console.error("Server Error:", text);
                                            document.getElementById('keuanganBody').innerHTML = '<tr><td colspan="7" class="no-data" style="color:red; text-align:left;"><pre>' + text.replace(/</g, "&lt;") + '</pre></td></tr>';
                                            throw new Error("Invalid JSON");
                                        }

                                        if (data.error) {
                                            document.getElementById('keuanganBody').innerHTML = '<tr><td colspan="7" class="no-data">Error: ' + data.error + '</td></tr>';
                                            return;
                                        }

                                        globalData = data.transaksi || [];

                                        // Calculate totals
                                        let totalMasuk = 0;
                                        let totalKeluar = 0;

                                        // Arrays for print tables
                                        let pemasukanData = [];
                                        let pengeluaranData = [];

                                        let tableHtml = '';

                                        if (globalData.length > 0) {
                                            globalData.forEach((item, index) => {
                                                // Normalize
                                                let jenisDisplay = item.jenis;
                                                if (item.jenis === 'Kredit') jenisDisplay = 'Pemasukan';
                                                else if (item.jenis === 'Debit') jenisDisplay = 'Pengeluaran';

                                                // Update totals
                                                if (jenisDisplay === 'Pemasukan') {
                                                    totalMasuk += item.jumlah;
                                                    pemasukanData.push(item);
                                                } else {
                                                    totalKeluar += item.jumlah;
                                                    pengeluaranData.push(item);
                                                }

                                                // Main Table Row
                                                tableHtml += '<tr>' +
                                                    '<td class="text-center">' + (index + 1) + '</td>' +
                                                    '<td>' + formatDate(item.tanggal) + '</td>' +
                                                    '<td>' + (item.keterangan || '-') + '</td>' +
                                                    '<td><span class="badge ' + jenisDisplay.toLowerCase() + '">' + jenisDisplay + '</span></td>' +
                                                    '<td class="text-right">' + formatRupiah(item.jumlah) + '</td>' +
                                                    '<td class="text-center">' +
                                                    '<button class="btn-edit" onclick="editData(' + item.id + ')"><i class="fas fa-edit"></i> Edit</button>' +
                                                    '<button class="btn-delete" onclick="deleteData(' + item.id + ')"><i class="fas fa-trash"></i> Hapus</button>' +
                                                    '</td>' +
                                                    '</tr>';
                                            });
                                        } else {
                                            tableHtml = '<tr><td colspan="7" class="no-data">Belum ada data keuangan</td></tr>';
                                        }

                                        document.getElementById('keuanganBody').innerHTML = tableHtml;

                                        // Update Summary Cards
                                        document.getElementById('totalPemasukan').innerText = formatRupiah(totalMasuk);
                                        document.getElementById('totalPengeluaran').innerText = formatRupiah(totalKeluar);
                                        document.getElementById('totalSaldo').innerText = formatRupiah(totalMasuk - totalKeluar);

                                        // Update Print View
                                        updatePrintView(pemasukanData, pengeluaranData, totalMasuk, totalKeluar);

                                    }).catch(error => {
                                        console.error('Error:', error);
                                        // Don't overwrite if we already showed a specific error from the try-catch block
                                        if (!document.getElementById('keuanganBody').innerHTML.includes('pre')) {
                                            document.getElementById('keuanganBody').innerHTML = '<tr><td colspan="7" class="no-data">Gagal memuat data: ' + error.message + '</td></tr>';
                                        }
                                    });
                            }

                            function updatePrintView(pemasukan, pengeluaran, totalMasuk, totalKeluar) {
                                // Update Period
                                const startDate = document.getElementById('startDate').value;
                                const endDate = document.getElementById('endDate').value;

                                const periodText = (startDate && endDate) ?
                                    formatDate(startDate) + ' s/d ' + formatDate(endDate) : "Semua Waktu";
                                document.getElementById('printPeriode').textContent = periodText;

                                // Populate Pemasukan Table
                                let htmlMasuk = '';

                                if (pemasukan.length > 0) {
                                    pemasukan.forEach((item, index) => {
                                        htmlMasuk += '<tr>' +
                                            '<td class="text-center">' + (index + 1) + '</td>' +
                                            '<td>' + formatDate(item.tanggal) + '</td>' +
                                            '<td>' + (item.keterangan || '-') + '</td>' +
                                            '<td class="text-right">' + formatRupiah(item.jumlah) + '</td>' +
                                            '</tr>';
                                    });
                                } else {
                                    htmlMasuk = '<tr><td colspan="4" class="text-center">Tidak ada data pemasukan</td></tr>';
                                }

                                document.getElementById('printPemasukanBody').innerHTML = htmlMasuk;
                                document.getElementById('printTotalPemasukan').textContent = formatRupiah(totalMasuk);

                                // Populate Pengeluaran Table
                                let htmlKeluar = '';

                                if (pengeluaran.length > 0) {
                                    pengeluaran.forEach((item, index) => {
                                        htmlKeluar += '<tr>' +
                                            '<td class="text-center">' + (index + 1) + '</td>' +
                                            '<td>' + formatDate(item.tanggal) + '</td>' +
                                            '<td>' + (item.keterangan || '-') + '</td>' +
                                            '<td class="text-right">' + formatRupiah(item.jumlah) + '</td>' +
                                            '</tr>';
                                    });
                                } else {
                                    htmlKeluar = '<tr><td colspan="4" class="text-center">Tidak ada data pengeluaran</td></tr>';
                                }

                                document.getElementById('printPengeluaranBody').innerHTML = htmlKeluar;
                                document.getElementById('printTotalPengeluaran').textContent = formatRupiah(totalKeluar);

                                // Update Grand Total
                                document.getElementById('summaryPemasukan').textContent = formatRupiah(totalMasuk);
                                document.getElementById('summaryPengeluaran').textContent = formatRupiah(totalKeluar);
                                document.getElementById('summarySaldo').textContent = formatRupiah(totalMasuk - totalKeluar);
                            }

                            function applyFilter() {
                                let params = [];
                                const search = document.getElementById('searchInput').value;
                                const jenis = document.getElementById('filterJenis').value;
                                const startDate = document.getElementById('startDate').value;
                                const endDate = document.getElementById('endDate').value;

                                if (search) params.push('search=' + encodeURIComponent(search));
                                if (jenis) params.push('jenis=' + encodeURIComponent(jenis));
                                if (startDate) params.push('start=' + startDate);
                                if (endDate) params.push('end=' + endDate);

                                loadData(params.join('&'));
                            }

                            function resetFilter() {
                                document.getElementById('searchInput').value = '';
                                document.getElementById('filterJenis').value = '';
                                document.getElementById('startDate').value = '';
                                document.getElementById('endDate').value = '';
                                loadData();
                            }

                            // Form Handling
                            function editData(id) {
                                // Find the item data
                                const item = globalData.find(d => d.id === id);
                                if (!item) return;

                                document.getElementById('dataId').value = item.id;
                                document.getElementById('formAction').value = 'edit';

                                // Populate fields
                                document.getElementById('jenis').value = (item.jenis === 'Kredit' || item.jenis === 'Pemasukan') ? 'Pemasukan' : 'Pengeluaran';
                                // updateKategori(); // Removed

                                // document.getElementById('kategori').value = item.kategori; // Removed
                                document.getElementById('jumlah').value = item.jumlah;
                                document.getElementById('tanggal').value = item.tanggal;
                                document.getElementById('keterangan').value = item.keterangan;

                                // Change button text
                                const btn = document.querySelector('#keuanganForm button[type="submit"]');
                                btn.innerHTML = '<i class="fas fa-save"></i> Update';

                                // Scroll to form
                                document.querySelector('#keuanganForm').scrollIntoView({
                                    behavior: 'smooth'
                                });
                            }

                            function resetForm() {
                                document.getElementById('keuanganForm').reset();
                                document.getElementById('dataId').value = '';
                                document.getElementById('formAction').value = 'add';
                                document.getElementById('dataId').value = '';
                                document.getElementById('formAction').value = 'add';
                                // updateKategori(); // Removed

                                // Reset button text
                                const btn = document.querySelector('#keuanganForm button[type="submit"]');
                                btn.innerHTML = '<i class="fas fa-save"></i> Simpan';
                            }

                            function deleteData(id) {
                                Swal.fire({
                                    title: 'Apakah Anda yakin?',
                                    text: "Data yang dihapus tidak dapat dikembalikan!",
                                    icon: 'warning',
                                    showCancelButton: true,
                                    confirmButtonColor: '#d33',
                                    cancelButtonColor: '#3085d6',
                                    confirmButtonText: 'Ya, hapus!',
                                    cancelButtonText: 'Batal'
                                }).then((result) => {
                                    if (result.isConfirmed) {
                                        let type = currentLaporanType || 'Masjid';

                                        // Show loading
                                        Swal.fire({
                                            title: 'Menghapus data...',
                                            didOpen: () => Swal.showLoading()
                                        });

                                        fetch('process_keuangan.jsp?action=delete&id=' + id + '&jenis_laporan=' + encodeURIComponent(type), {
                                            method: 'POST'
                                        }).then(response => {
                                            window.location.href = 'keuangan.jsp?success=delete&jenis_laporan=' + encodeURIComponent(type);
                                        }).catch(error => {
                                            console.error('Error:', error);
                                            Swal.fire('Gagal', 'Terjadi kesalahan saat menghapus data', 'error');
                                        });
                                    }
                                });
                            }

                            // Show Alert
                            function showAlert(message, type) {
                                const container = document.getElementById('alertContainer');
                                const alertDiv = document.createElement('div');

                                alertDiv.className = `alert alert-${type}`;
                                alertDiv.innerHTML = '<i class="fas fa-' + (type === 'success' ? 'check' : 'exclamation') + '-circle"></i> ' + message;
                                container.appendChild(alertDiv);
                                setTimeout(() => alertDiv.remove(), 3000);
                            }

                            // Initial Load
                            const urlParamsInit = new URLSearchParams(window.location.search);
                            if (urlParamsInit.has('jenis_laporan')) {
                                switchLaporan(decodeURIComponent(urlParamsInit.get('jenis_laporan')));
                            } else {
                                switchLaporan('Masjid');
                            }

                            // Check for URL parameters for alerts
                            const urlParams = new URLSearchParams(window.location.search);
                            if (urlParams.has('success')) {
                                const action = urlParams.get('success');
                                let msg = 'Data berhasil disimpan!';
                                if (action === 'delete') msg = 'Data berhasil dihapus!';
                                else if (action === 'edit') msg = 'Data berhasil diperbarui!';
                                showAlert(msg, 'success');
                                // Clean URL
                                window.history.replaceState({}, document.title, window.location.pathname);
                            } else if (urlParams.has('error')) {
                                const err = urlParams.get('error');
                                let msg = 'Terjadi kesalahan saat memproses data.';
                                if (err === 'db') msg = 'Gagal terhubung ke database.';
                                if (err === 'custom' && urlParams.has('msg')) msg = decodeURIComponent(urlParams.get('msg'));
                                showAlert(msg, 'error');
                                // Clean URL
                                window.history.replaceState({}, document.title, window.location.pathname);
                            }



                        </script>
                    </div>
                </body>

                </html>