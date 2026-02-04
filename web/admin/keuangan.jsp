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
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Poppins', sans-serif; background: #f0f2f5; min-height: 100vh; }
        .sidebar { position: fixed; left: 0; top: 0; width: 260px; height: 100vh; background: linear-gradient(180deg, #1a5d3a 0%, #0d3320 100%); padding: 20px; z-index: 100; }
        .sidebar-header { text-align: center; padding: 20px 0 30px; border-bottom: 1px solid rgba(255,255,255,0.1); margin-bottom: 30px; }
        .sidebar-header h2 { color: white; font-size: 1.1rem; }
        .sidebar-header p { color: rgba(255,255,255,0.6); font-size: 0.8rem; }
        .nav-menu { list-style: none; }
        .nav-menu li { margin-bottom: 8px; }
        .nav-menu a { display: flex; align-items: center; padding: 14px 18px; color: rgba(255,255,255,0.8); text-decoration: none; border-radius: 10px; transition: all 0.3s ease; }
        .nav-menu a:hover, .nav-menu a.active { background: rgba(255,255,255,0.15); color: white; }
        .nav-menu .logout { margin-top: 30px; border-top: 1px solid rgba(255,255,255,0.1); padding-top: 20px; }
        .nav-menu .logout a { color: #ff6b6b; }
        .main-content { margin-left: 260px; padding: 30px; }
        .header { margin-bottom: 30px; }
        .header h1 { color: #333; font-size: 1.8rem; }
        .alert { padding: 15px 20px; border-radius: 10px; margin-bottom: 20px; }
        .alert-success { background: #e8f5e9; color: #2e7d32; border-left: 4px solid #4caf50; }
        .alert-error { background: #ffebee; color: #c62828; border-left: 4px solid #f44336; }
        .summary-cards { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .summary-card { background: white; border-radius: 12px; padding: 20px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); text-align: center; }
        .summary-card.pemasukan { border-top: 4px solid #4caf50; }
        .summary-card.pengeluaran { border-top: 4px solid #f44336; }
        .summary-card.saldo { border-top: 4px solid #ff9800; }
        .summary-card h4 { color: #666; font-size: 0.85rem; margin-bottom: 8px; }
        .summary-card .amount { font-size: 1.2rem; font-weight: 700; }
        .summary-card.pemasukan .amount { color: #4caf50; }
        .summary-card.pengeluaran .amount { color: #f44336; }
        .summary-card.saldo .amount { color: #ff9800; }
        .card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); margin-bottom: 30px; }
        .card h3 { color: #333; margin-bottom: 25px; font-size: 1.2rem; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0; }
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(180px, 1fr)); gap: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; color: #555; font-weight: 500; margin-bottom: 8px; }
        .form-group input, .form-group select { width: 100%; padding: 12px 15px; border: 2px solid #e8e8e8; border-radius: 10px; font-family: 'Poppins', sans-serif; }
        .form-group input:focus, .form-group select:focus { outline: none; border-color: #1a5d3a; }
        .btn { padding: 12px 30px; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; transition: all 0.3s; }
        .btn-primary { background: linear-gradient(135deg, #1a5d3a, #2e8b57); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(26,93,58,0.3); }
        .btn-secondary { background: #f5f5f5; color: #333; }
        .form-actions { margin-top: 20px; display: flex; gap: 15px; }
        table { width: 100%; border-collapse: collapse; }
        thead { background: #f8f9fa; }
        th { padding: 15px 12px; text-align: left; font-weight: 600; color: #555; font-size: 0.9rem; }
        td { padding: 15px 12px; border-bottom: 1px solid #f0f0f0; font-size: 0.9rem; }
        tr:hover { background: #fafafa; }
        .amount-cell { text-align: right; font-weight: 600; font-family: 'Courier New', monospace; }
        .badge { display: inline-block; padding: 5px 12px; border-radius: 20px; font-size: 0.8rem; }
        .badge.pemasukan { background: #e8f5e9; color: #4caf50; }
        .badge.pengeluaran { background: #ffebee; color: #f44336; }
        .badge.debit { background: #fff3e0; color: #ff9800; }
        .badge.kredit { background: #e3f2fd; color: #1976d2; }
        .btn-edit, .btn-delete { padding: 8px 15px; border: none; border-radius: 8px; cursor: pointer; font-family: 'Poppins', sans-serif; margin-right: 5px; font-size: 0.85rem; }
        .btn-edit { background: #e3f2fd; color: #1976d2; }
        .btn-delete { background: #ffebee; color: #d32f2f; }
        .no-data { text-align: center; padding: 50px; color: #999; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal.show { display: flex; }
        .modal-content { background: white; border-radius: 15px; padding: 30px; width: 90%; max-width: 500px; }
        .modal-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }
        .modal-header h3 { color: #333; }
        .modal-close { background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #999; }
    </style>
</head>
<body>
    <div class="sidebar">
        <div class="sidebar-header">
            <h2>Masjid Jabalussalam</h2>
            <p>Admin Panel</p>
        </div>
        <ul class="nav-menu">
            <li><a href="dashboard.jsp">Dashboard</a></li>
            <li><a href="kegiatan.jsp">Kelola Kegiatan</a></li>
            <li><a href="keuangan.jsp" class="active">Kelola Keuangan</a></li>
            <li class="logout"><a href="../LogoutServlet">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header"><h1>Kelola Keuangan</h1></div>
        
        <% if ("add".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">Transaksi berhasil ditambahkan!</div>
        <% } else if ("edit".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">Transaksi berhasil diperbarui!</div>
        <% } else if ("delete".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">Transaksi berhasil dihapus!</div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">Terjadi kesalahan. Silakan coba lagi.</div>
        <% } %>
        
        <div class="summary-cards">
            <div class="summary-card pemasukan">
                <h4>Total Pemasukan</h4>
                <div class="amount"><%= formatRupiah.format(totalPemasukan) %></div>
            </div>
            <div class="summary-card pengeluaran">
                <h4>Total Pengeluaran</h4>
                <div class="amount"><%= formatRupiah.format(totalPengeluaran) %></div>
            </div>
            <div class="summary-card saldo">
                <h4>Sisa Saldo</h4>
                <div class="amount"><%= formatRupiah.format(saldo) %></div>
            </div>
        </div>
        
        <div class="card">
            <h3>Tambah Transaksi Baru</h3>
            <form action="../KeuanganServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Tanggal</label>
                        <input type="date" name="tanggal" required>
                    </div>
                    <div class="form-group">
                        <label>Kategori</label>
                        <select name="kategori" required>
                            <option value="">-- Pilih --</option>
                            <option value="Pemasukan">Pemasukan</option>
                            <option value="Pengeluaran">Pengeluaran</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Jenis</label>
                        <select name="jenis" required>
                            <option value="">-- Pilih --</option>
                            <option value="Debit">Debit</option>
                            <option value="Kredit">Kredit</option>
                        </select>
                    </div>
                    <div class="form-group">
                        <label>Jumlah (Rp)</label>
                        <input type="number" name="jumlah" required placeholder="Masukkan jumlah" min="0">
                    </div>
                    <div class="form-group" style="grid-column: 1 / -1;">
                        <label>Keterangan</label>
                        <input type="text" name="keterangan" required placeholder="Masukkan keterangan transaksi">
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Simpan</button>
                    <button type="reset" class="btn btn-secondary">Reset</button>
                </div>
            </form>
        </div>
        
        <div class="card">
            <h3>Daftar Transaksi</h3>
            <div style="overflow-x: auto;">
            <table>
                <thead>
                    <tr>
                        <th>Tanggal</th>
                        <th>Keterangan</th>
                        <th>Kategori</th>
                        <th>Jenis</th>
                        <th style="text-align:right;">Jumlah</th>
                        <th>Aksi</th>
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
                            while(rs.next()) {
                                hasData = true;
                                int id = rs.getInt("id");
                                String tgl = rs.getString("tanggal");
                                String ket = rs.getString("keterangan");
                                String kat = rs.getString("kategori");
                                String jns = "Debit";
                                try { jns = rs.getString("jenis"); if (jns == null) jns = "Debit"; } catch (Exception ex) {}
                                double jml = rs.getDouble("jumlah");
                %>
                    <tr>
                        <td><%= tgl %></td>
                        <td><%= ket %></td>
                        <td><span class="badge <%= kat.toLowerCase() %>"><%= kat %></span></td>
                        <td><span class="badge <%= jns.toLowerCase() %>"><%= jns %></span></td>
                        <td class="amount-cell"><%= formatRupiah.format(jml) %></td>
                        <td>
                            <button class="btn-edit" onclick="openEdit(<%= id %>, '<%= tgl %>', '<%= ket.replace("'", "\\'") %>', '<%= kat %>', '<%= jns %>', <%= jml %>)">Edit</button>
                            <form action="../KeuanganServlet" method="post" style="display:inline;" onsubmit="return confirm('Yakin hapus?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= id %>">
                                <button type="submit" class="btn-delete">Hapus</button>
                            </form>
                        </td>
                    </tr>
                <%
                            }
                            rs.close();
                            st.close();
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' class='no-data'>Error: " + e.getMessage() + "</td></tr>");
                        e.printStackTrace();
                    } finally {
                        if (conList != null) try { conList.close(); } catch (Exception e) {}
                    }
                    if (!hasData) {
                %>
                    <tr><td colspan="6" class="no-data">Belum ada data transaksi</td></tr>
                <% } %>
                </tbody>
            </table>
            </div>
        </div>
    </div>
    
    <div class="modal" id="editModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Transaksi</h3>
                <button class="modal-close" onclick="closeEdit()">&times;</button>
            </div>
            <form action="../KeuanganServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" id="e_id">
                <div class="form-group">
                    <label>Tanggal</label>
                    <input type="date" name="tanggal" id="e_tgl" required>
                </div>
                <div class="form-group">
                    <label>Kategori</label>
                    <select name="kategori" id="e_kat" required>
                        <option value="Pemasukan">Pemasukan</option>
                        <option value="Pengeluaran">Pengeluaran</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Jenis</label>
                    <select name="jenis" id="e_jns" required>
                        <option value="Debit">Debit</option>
                        <option value="Kredit">Kredit</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Jumlah (Rp)</label>
                    <input type="number" name="jumlah" id="e_jml" required min="0">
                </div>
                <div class="form-group">
                    <label>Keterangan</label>
                    <input type="text" name="keterangan" id="e_ket" required>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Simpan</button>
                    <button type="button" class="btn btn-secondary" onclick="closeEdit()">Batal</button>
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
