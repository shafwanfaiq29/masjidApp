<%@page import="java.text.NumberFormat"%>
<%@page import="java.util.Locale"%>
<%@page import="java.sql.*"%>
<%@page import="com.masjid.config.Koneksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
if (session.getAttribute("adminId") == null) {
    response.sendRedirect("../login.jsp");
    return;
}

Locale localeID = new Locale("in", "ID");
NumberFormat formatRupiah = NumberFormat.getCurrencyInstance(localeID);

double totalPemasukan = 0, totalPengeluaran = 0;
Connection conSum = null;
try {
    conSum = Koneksi.getKoneksi();
    if (conSum != null) {
        Statement st = conSum.createStatement();
        ResultSet rs = st.executeQuery("SELECT kategori, SUM(jumlah) as total FROM keuangan GROUP BY kategori");
        while (rs.next()) {
            if ("Pemasukan".equalsIgnoreCase(rs.getString("kategori"))) {
                totalPemasukan = rs.getDouble("total");
            } else {
                totalPengeluaran = rs.getDouble("total");
            }
        }
        rs.close();
        st.close();
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (conSum != null) try { conSum.close(); } catch (Exception e) {}
}
double saldo = totalPemasukan - totalPengeluaran;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Keuangan - Admin Masjid</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background: linear-gradient(135deg, #f0f2f5 0%, #e8eef3 100%); min-height: 100vh; }
        .sidebar { position: fixed; left: 0; top: 0; width: 280px; height: 100vh; background: linear-gradient(180deg, #1a5d3a 0%, #0d3320 100%); padding: 25px 20px; z-index: 100; box-shadow: 4px 0 20px rgba(0, 0, 0, 0.1); }
        .sidebar-header { text-align: center; padding: 25px 0 35px; border-bottom: 1px solid rgba(255, 255, 255, 0.1); margin-bottom: 30px; }
        .sidebar-header .logo { font-size: 50px; color: #ffd700; margin-bottom: 15px; }
        .sidebar-header h2 { color: white; font-size: 1.15rem; }
        .sidebar-header p { color: rgba(255, 255, 255, 0.6); font-size: 0.85rem; margin-top: 5px; }
        .nav-menu { list-style: none; }
        .nav-menu li { margin-bottom: 8px; }
        .nav-menu a { display: flex; align-items: center; gap: 14px; padding: 16px 20px; color: rgba(255, 255, 255, 0.8); text-decoration: none; border-radius: 12px; transition: all 0.3s ease; }
        .nav-menu a i { font-size: 1.2rem; width: 24px; text-align: center; }
        .nav-menu a:hover, .nav-menu a.active { background: rgba(255, 255, 255, 0.15); color: white; transform: translateX(5px); }
        .nav-menu a.active { background: linear-gradient(90deg, rgba(255, 215, 0, 0.2), transparent); border-left: 3px solid #ffd700; }
        .nav-menu .logout { margin-top: 30px; border-top: 1px solid rgba(255, 255, 255, 0.1); padding-top: 25px; }
        .nav-menu .logout a { color: #ff6b6b; }
        .main-content { margin-left: 280px; padding: 35px; }
        .header { margin-bottom: 30px; display: flex; align-items: center; gap: 12px; }
        .header h1 { color: #333; font-size: 1.8rem; }
        .header i { color: #1a5d3a; font-size: 1.6rem; }
        .alert { padding: 16px 22px; border-radius: 12px; margin-bottom: 25px; display: flex; align-items: center; gap: 12px; font-size: 0.95rem; }
        .alert i { font-size: 1.2rem; }
        .alert-success { background: linear-gradient(135deg, #e8f5e9, #c8e6c9); color: #2e7d32; border-left: 4px solid #4caf50; }
        .alert-error { background: linear-gradient(135deg, #ffebee, #ffcdd2); color: #c62828; border-left: 4px solid #f44336; }
        .summary-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(220px, 1fr)); gap: 22px; margin-bottom: 30px; }
        .summary-card { background: white; border-radius: 16px; padding: 25px; box-shadow: 0 8px 25px rgba(0, 0, 0, 0.05); text-align: center; position: relative; overflow: hidden; transition: all 0.3s ease; }
        .summary-card:hover { transform: translateY(-5px); box-shadow: 0 15px 35px rgba(0, 0, 0, 0.1); }
        .summary-card::before { content: ''; position: absolute; top: 0; left: 0; right: 0; height: 4px; }
        .summary-card.pemasukan::before { background: linear-gradient(90deg, #4caf50, #81c784); }
        .summary-card.pengeluaran::before { background: linear-gradient(90deg, #f44336, #e57373); }
        .summary-card.saldo::before { background: linear-gradient(90deg, #ff9800, #ffb74d); }
        .summary-card .icon-wrapper { width: 55px; height: 55px; border-radius: 50%; display: flex; align-items: center; justify-content: center; margin: 0 auto 15px; font-size: 24px; }
        .summary-card.pemasukan .icon-wrapper { background: linear-gradient(135deg, #e8f5e9, #c8e6c9); color: #4caf50; }
        .summary-card.pengeluaran .icon-wrapper { background: linear-gradient(135deg, #ffebee, #ffcdd2); color: #f44336; }
        .summary-card.saldo .icon-wrapper { background: linear-gradient(135deg, #fff3e0, #ffe0b2); color: #ff9800; }
        .summary-card h4 { color: #888; font-size: 0.85rem; margin-bottom: 8px; font-weight: 500; }
        .summary-card .amount { font-size: 1.3rem; font-weight: 700; }
        .summary-card.pemasukan .amount { color: #4caf50; }
        .summary-card.pengeluaran .amount { color: #f44336; }
        .summary-card.saldo .amount { color: #ff9800; }
        .card { background: white; border-radius: 18px; padding: 35px; box-shadow: 0 8px 25px rgba(0, 0, 0, 0.05); margin-bottom: 30px; }
        .card h3 { color: #333; margin-bottom: 28px; font-size: 1.25rem; padding-bottom: 18px; border-bottom: 2px solid #f0f0f0; display: flex; align-items: center; gap: 10px; }
        .card h3 i { color: #1a5d3a; }
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 22px; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: flex; align-items: center; gap: 8px; color: #555; font-weight: 500; margin-bottom: 10px; }
        .form-group label i { color: #1a5d3a; }
        .form-group input, .form-group select { width: 100%; padding: 14px 18px; border: 2px solid #e8e8e8; border-radius: 12px; font-family: 'Poppins', sans-serif; transition: all 0.3s; font-size: 0.95rem; }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #1a5d3a; box-shadow: 0 0 0 4px rgba(26, 93, 58, 0.1); }
        .btn { padding: 14px 32px; border: none; border-radius: 12px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; transition: all 0.3s; display: inline-flex; align-items: center; gap: 10px; font-size: 0.95rem; }
        .btn i { font-size: 1rem; }
        .btn-primary { background: linear-gradient(135deg, #1a5d3a, #2e8b57); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(26, 93, 58, 0.3); }
        .btn-secondary { background: linear-gradient(135deg, #f5f7fa, #e4e8ec); color: #555; }
        .form-actions { margin-top: 25px; display: flex; gap: 15px; }
        .table-wrapper { overflow-x: auto; }
        table { width: 100%; border-collapse: collapse; min-width: 800px; }
        thead { background: linear-gradient(135deg, #f8f9fa, #e9ecef); }
        th { padding: 16px 14px; text-align: left; font-weight: 600; color: #555; font-size: 0.88rem; }
        th i { margin-right: 6px; color: #1a5d3a; }
        td { padding: 16px 14px; border-bottom: 1px solid #f0f0f0; font-size: 0.9rem; }
        tr { transition: background 0.2s; }
        tr:hover { background: #fafafa; }
        .amount-cell { text-align: right; font-weight: 600; font-family: 'Courier New', monospace; }
        .badge { display: inline-flex; align-items: center; gap: 6px; padding: 6px 14px; border-radius: 20px; font-size: 0.82rem; font-weight: 500; }
        .badge.pemasukan { background: linear-gradient(135deg, #e8f5e9, #c8e6c9); color: #388e3c; }
        .badge.pengeluaran { background: linear-gradient(135deg, #ffebee, #ffcdd2); color: #d32f2f; }
        .badge.debit { background: linear-gradient(135deg, #fff3e0, #ffe0b2); color: #f57c00; }
        .badge.kredit { background: linear-gradient(135deg, #e3f2fd, #bbdefb); color: #1976d2; }
        .btn-edit, .btn-delete { padding: 10px 16px; border: none; border-radius: 10px; cursor: pointer; font-family: 'Poppins', sans-serif; transition: all 0.3s; margin-right: 6px; display: inline-flex; align-items: center; gap: 6px; font-size: 0.82rem; font-weight: 500; }
        .btn-edit { background: linear-gradient(135deg, #e3f2fd, #bbdefb); color: #1976d2; }
        .btn-edit:hover { background: linear-gradient(135deg, #bbdefb, #90caf9); transform: translateY(-2px); }
        .btn-delete { background: linear-gradient(135deg, #ffebee, #ffcdd2); color: #d32f2f; }
        .btn-delete:hover { background: linear-gradient(135deg, #ffcdd2, #ef9a9a); transform: translateY(-2px); }
        .no-data { text-align: center; padding: 60px; color: #999; }
        .no-data i { font-size: 50px; margin-bottom: 15px; color: #ddd; display: block; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 1000; justify-content: center; align-items: center; backdrop-filter: blur(5px); }
        .modal.show { display: flex; }
        .modal-content { background: white; border-radius: 20px; padding: 35px; width: 90%; max-width: 520px; max-height: 90vh; overflow-y: auto; box-shadow: 0 25px 50px rgba(0, 0, 0, 0.2); }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; padding-bottom: 18px; border-bottom: 2px solid #f0f0f0; }
        .modal-header h3 { color: #333; display: flex; align-items: center; gap: 10px; }
        .modal-header h3 i { color: #1a5d3a; }
        .modal-close { background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #999; transition: color 0.3s; width: 40px; height: 40px; border-radius: 50%; display: flex; align-items: center; justify-content: center; }
        .modal-close:hover { color: #333; background: #f0f0f0; }
        @media (max-width: 992px) { .sidebar { width: 80px; padding: 15px 10px; } .sidebar-header h2, .sidebar-header p, .nav-menu a span { display: none; } .sidebar-header .logo { font-size: 35px; } .nav-menu a { justify-content: center; padding: 14px; } .main-content { margin-left: 80px; } }
        @media (max-width: 768px) { .sidebar { display: none; } .main-content { margin-left: 0; padding: 20px; } }
        /* Mobile Back Button - Only visible on mobile */
        .mobile-back-btn { display: none; }
        @media (max-width: 768px) {
            .mobile-back-btn {
                display: flex;
                position: fixed;
                bottom: 20px;
                left: 15px;
                z-index: 1000;
                width: 42px;
                height: 42px;
                background: linear-gradient(135deg, #1a5d3a, #2e8b57);
                border-radius: 50%;
                align-items: center;
                justify-content: center;
                text-decoration: none;
                color: white;
                font-size: 1.1rem;
                box-shadow: 0 4px 15px rgba(0, 0, 0, 0.2);
                transition: all 0.3s ease;
            }
            .mobile-back-btn:hover, .mobile-back-btn:active {
                transform: scale(1.1);
                background: linear-gradient(135deg, #0d3320, #1a5d3a);
            }
        }
    </style>
</head>
<body>
    <a href="dashboard.jsp" class="mobile-back-btn" title="Kembali ke Dashboard"><i class="fas fa-arrow-left"></i></a>
    <div class="sidebar">
        <div class="sidebar-header">
            <div class="logo"><i class="fas fa-mosque"></i></div>
            <h2>Masjid Jabalussalam</h2>
            <p>Admin Panel</p>
        </div>
        <ul class="nav-menu">
            <li><a href="dashboard.jsp"><i class="fas fa-gauge-high"></i><span>Dashboard</span></a></li>
            <li><a href="kegiatan.jsp"><i class="fas fa-calendar-days"></i><span>Kelola Kegiatan</span></a></li>
            <li><a href="keuangan.jsp" class="active"><i class="fas fa-money-bill-wave"></i><span>Kelola Keuangan</span></a></li>
            <li class="logout"><a href="../LogoutServlet"><i class="fas fa-right-from-bracket"></i><span>Logout</span></a></li>
        </ul>
    </div>

    <div class="main-content">
        <div class="header">
            <i class="fas fa-money-bill-wave"></i>
            <h1>Kelola Keuangan</h1>
        </div>

        <% if ("add".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Transaksi berhasil ditambahkan!</div>
        <% } else if ("edit".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Transaksi berhasil diperbarui!</div>
        <% } else if ("delete".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success"><i class="fas fa-check-circle"></i> Transaksi berhasil dihapus!</div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error"><i class="fas fa-exclamation-circle"></i> Terjadi kesalahan. Silakan coba lagi.</div>
        <% } %>

        <div class="summary-cards">
            <div class="summary-card pemasukan">
                <div class="icon-wrapper"><i class="fas fa-arrow-trend-up"></i></div>
                <h4>Total Pemasukan</h4>
                <div class="amount"><%= formatRupiah.format(totalPemasukan) %></div>
            </div>
            <div class="summary-card pengeluaran">
                <div class="icon-wrapper"><i class="fas fa-arrow-trend-down"></i></div>
                <h4>Total Pengeluaran</h4>
                <div class="amount"><%= formatRupiah.format(totalPengeluaran) %></div>
            </div>
            <div class="summary-card saldo">
                <div class="icon-wrapper"><i class="fas fa-wallet"></i></div>
                <h4>Sisa Saldo</h4>
                <div class="amount"><%= formatRupiah.format(saldo) %></div>
            </div>
        </div>

        <div class="card">
            <h3><i class="fas fa-plus-circle"></i> Tambah Transaksi Baru</h3>
            <form action="../KeuanganServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-grid">
                    <div class="form-group">
                        <label><i class="fas fa-calendar"></i> Tanggal</label>
                        <input type="date" name="tanggal" required>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-tag"></i> Kategori</label>
                        <select name="kategori" required>
                            <option value="">-- Pilih --</option>
                            <option value="Pemasukan">Pemasukan</option>
                            <option value="Pengeluaran">Pengeluaran</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-exchange-alt"></i> Jenis</label>
                        <select name="jenis" required>
                            <option value="">-- Pilih --</option>
                            <option value="Debit">Debit</option>
                            <option value="Kredit">Kredit</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label><i class="fas fa-money-bill"></i> Jumlah (Rp)</label>
                        <input type="number" name="jumlah" required placeholder="Masukkan jumlah" min="0">
                    </div>
                    <div class="form-group" style="grid-column: 1 / -1;">
                        <label><i class="fas fa-file-alt"></i> Keterangan</label>
                        <input type="text" name="keterangan" required placeholder="Masukkan keterangan transaksi">
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
                            <th><i class="fas fa-exchange-alt"></i> Jenis</th>
                            <th style="text-align:right;"><i class="fas fa-money-bill"></i> Jumlah</th>
                            <th><i class="fas fa-cog"></i> Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
<%
boolean hasData = false;
Connection conList = null;
try {
    conList = Koneksi.getKoneksi();
    if (conList != null) {
        Statement st = conList.createStatement();
        ResultSet rs = st.executeQuery("SELECT * FROM keuangan ORDER BY tanggal DESC, id DESC");
        while (rs.next()) {
            hasData = true;
            int id = rs.getInt("id");
            String tgl = rs.getString("tanggal");
            String ket = rs.getString("keterangan");
            String kat = rs.getString("kategori");
            String jns = "Debit";
            try { jns = rs.getString("jenis"); if (jns == null) jns = "Debit"; } catch (Exception ex) {}
            double jml = rs.getDouble("jumlah");
            String katIcon = kat.equalsIgnoreCase("Pemasukan") ? "fa-arrow-up" : "fa-arrow-down";
            String jnsIcon = jns.equalsIgnoreCase("Debit") ? "fa-plus" : "fa-minus";
            String ketJs = ket.replace("'", "\\'").replace("\"", "\\\"");
%>
                        <tr>
                            <td><%= tgl %></td>
                            <td><%= ket %></td>
                            <td><span class="badge <%= kat.toLowerCase() %>"><i class="fas <%= katIcon %>"></i> <%= kat %></span></td>
                            <td><span class="badge <%= jns.toLowerCase() %>"><i class="fas <%= jnsIcon %>"></i> <%= jns %></span></td>
                            <td class="amount-cell"><%= formatRupiah.format(jml) %></td>
                            <td>
                                <button class="btn-edit" onclick="openEdit(<%= id %>, '<%= tgl %>', '<%= ketJs %>', '<%= kat %>', '<%= jns %>', <%= jml %>)">
                                    <i class="fas fa-pen-to-square"></i> Edit
                                </button>
                                <form action="../KeuanganServlet" method="post" style="display:inline;" onsubmit="return confirm('Yakin hapus transaksi ini?')">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="id" value="<%= id %>">
                                    <button type="submit" class="btn-delete"><i class="fas fa-trash-can"></i> Hapus</button>
                                </form>
                            </td>
                        </tr>
<%
        }
        rs.close();
        st.close();
    } else {
%>
                        <tr><td colspan="6" class="no-data"><i class="fas fa-database"></i>Koneksi database gagal</td></tr>
<%
    }
} catch (Exception e) {
%>
                        <tr><td colspan="6" class="no-data"><i class="fas fa-exclamation-triangle"></i>Error: <%= e.getMessage() %></td></tr>
<%
    e.printStackTrace();
} finally {
    if (conList != null) try { conList.close(); } catch (Exception ex) {}
}
if (!hasData) {
%>
                        <tr><td colspan="6" class="no-data"><i class="fas fa-inbox"></i>Belum ada data transaksi</td></tr>
<%
}
%>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div class="modal" id="editModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3><i class="fas fa-pen-to-square"></i> Edit Transaksi</h3>
                <button class="modal-close" onclick="closeEdit()"><i class="fas fa-times"></i></button>
            </div>
            <form action="../KeuanganServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" id="e_id">
                <div class="form-group">
                    <label><i class="fas fa-calendar"></i> Tanggal</label>
                    <input type="date" name="tanggal" id="e_tgl" required>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-tag"></i> Kategori</label>
                    <select name="kategori" id="e_kat" required>
                        <option value="Pemasukan">Pemasukan</option>
                        <option value="Pengeluaran">Pengeluaran</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-exchange-alt"></i> Jenis</label>
                    <select name="jenis" id="e_jns" required>
                        <option value="Debit">Debit</option>
                        <option value="Kredit">Kredit</option>
                    </select>
                </div>
                <div class="form-group">
                    <label><i class="fas fa-money-bill"></i> Jumlah (Rp)</label>
                    <input type="number" name="jumlah" id="e_jml" required min="0">
                </div>
                <div class="form-group">
                    <label><i class="fas fa-file-alt"></i> Keterangan</label>
                    <input type="text" name="keterangan" id="e_ket" required>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Simpan</button>
                    <button type="button" class="btn btn-secondary" onclick="closeEdit()"><i class="fas fa-times"></i> Batal</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openEdit(id, tgl, ket, kat, jns, jml) {
            document.getElementById('e_id').value = id;
            document.getElementById('e_tgl').value = tgl;
            document.getElementById('e_ket').value = ket;
            document.getElementById('e_kat').value = kat;
            document.getElementById('e_jns').value = jns;
            document.getElementById('e_jml').value = jml;
            document.getElementById('editModal').classList.add('show');
        }
        function closeEdit() {
            document.getElementById('editModal').classList.remove('show');
        }
        document.getElementById('editModal').addEventListener('click', function(e) {
            if (e.target === this) closeEdit();
        });
    </script>
</body>
</html>


