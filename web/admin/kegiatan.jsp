<%@page import="java.sql.*"%>
<%@page import="com.masjid.config.Koneksi"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    if (session.getAttribute("adminId") == null) {
        response.sendRedirect("../login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kelola Kegiatan - Admin Masjid</title>
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
        .card { background: white; border-radius: 15px; padding: 30px; box-shadow: 0 5px 15px rgba(0,0,0,0.05); margin-bottom: 30px; }
        .card h3 { color: #333; margin-bottom: 25px; font-size: 1.2rem; padding-bottom: 15px; border-bottom: 2px solid #f0f0f0; }
        .form-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group.full { grid-column: 1 / -1; }
        .form-group label { display: block; color: #555; font-weight: 500; margin-bottom: 8px; }
        .form-group input, .form-group textarea { width: 100%; padding: 12px 15px; border: 2px solid #e8e8e8; border-radius: 10px; font-family: 'Poppins', sans-serif; transition: border-color 0.3s; }
        .form-group input:focus, .form-group textarea:focus { outline: none; border-color: #1a5d3a; }
        .form-group textarea { min-height: 80px; resize: vertical; }
        .btn { padding: 12px 30px; border: none; border-radius: 10px; font-weight: 600; cursor: pointer; font-family: 'Poppins', sans-serif; transition: all 0.3s; }
        .btn-primary { background: linear-gradient(135deg, #1a5d3a, #2e8b57); color: white; }
        .btn-primary:hover { transform: translateY(-2px); box-shadow: 0 5px 15px rgba(26,93,58,0.3); }
        .btn-secondary { background: #f5f5f5; color: #333; }
        .form-actions { margin-top: 20px; display: flex; gap: 15px; }
        table { width: 100%; border-collapse: collapse; }
        thead { background: #f8f9fa; }
        th { padding: 15px 20px; text-align: left; font-weight: 600; color: #555; }
        td { padding: 15px 20px; border-bottom: 1px solid #f0f0f0; }
        tr:hover { background: #fafafa; }
        .btn-edit, .btn-delete { padding: 8px 15px; border: none; border-radius: 8px; cursor: pointer; font-family: 'Poppins', sans-serif; transition: all 0.3s; margin-right: 5px; }
        .btn-edit { background: #e3f2fd; color: #1976d2; }
        .btn-delete { background: #ffebee; color: #d32f2f; }
        .no-data { text-align: center; padding: 50px; color: #999; }
        .modal { display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.5); z-index: 1000; justify-content: center; align-items: center; }
        .modal.show { display: flex; }
        .modal-content { background: white; border-radius: 15px; padding: 30px; width: 90%; max-width: 500px; max-height: 90vh; overflow-y: auto; }
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
            <li><a href="kegiatan.jsp" class="active">Kelola Kegiatan</a></li>
            <li><a href="keuangan.jsp">Kelola Keuangan</a></li>
            <li class="logout"><a href="../LogoutServlet">Logout</a></li>
        </ul>
    </div>
    
    <div class="main-content">
        <div class="header"><h1>Kelola Kegiatan</h1></div>
        
        <% if ("add".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">Kegiatan berhasil ditambahkan!</div>
        <% } else if ("edit".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">Kegiatan berhasil diperbarui!</div>
        <% } else if ("delete".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success">Kegiatan berhasil dihapus!</div>
        <% } %>
        <% if (request.getParameter("error") != null) { %>
            <div class="alert alert-error">Terjadi kesalahan. Silakan coba lagi.</div>
        <% } %>
        
        <div class="card">
            <h3>Tambah Kegiatan Baru</h3>
            <form action="../KegiatanServlet" method="post">
                <input type="hidden" name="action" value="add">
                <div class="form-grid">
                    <div class="form-group">
                        <label>Nama Kegiatan</label>
                        <input type="text" name="nama_kegiatan" required placeholder="Masukkan nama kegiatan">
                    </div>
                    <div class="form-group">
                        <label>Tanggal</label>
                        <input type="date" name="tanggal" required>
                    </div>
                    <div class="form-group">
                        <label>Waktu</label>
                        <input type="time" name="waktu" required>
                    </div>
                    <div class="form-group full">
                        <label>Deskripsi</label>
                        <textarea name="deskripsi" placeholder="Masukkan deskripsi kegiatan"></textarea>
                    </div>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Simpan</button>
                    <button type="reset" class="btn btn-secondary">Reset</button>
                </div>
            </form>
        </div>
        
        <div class="card">
            <h3>Daftar Kegiatan</h3>
            <table>
                <thead>
                    <tr>
                        <th>No</th>
                        <th>Nama Kegiatan</th>
                        <th>Tanggal</th>
                        <th>Waktu</th>
                        <th>Deskripsi</th>
                        <th>Aksi</th>
                    </tr>
                </thead>
                <tbody>
                <%
                    int no = 1;
                    boolean hasData = false;
                    try {
                        Connection con = Koneksi.getKoneksi();
                        if (con != null) {
                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery("SELECT * FROM kegiatan ORDER BY tanggal ASC");
                            while(rs.next()) {
                                hasData = true;
                                int id = rs.getInt("id");
                                String nama = rs.getString("nama_kegiatan");
                                String tgl = rs.getString("tanggal");
                                String wkt = rs.getString("waktu");
                                String desk = rs.getString("deskripsi");
                                if (desk == null) desk = "";
                %>
                    <tr>
                        <td><%= no++ %></td>
                        <td><strong><%= nama %></strong></td>
                        <td><%= tgl %></td>
                        <td><%= wkt %></td>
                        <td><%= desk.isEmpty() ? "-" : desk %></td>
                        <td>
                            <button class="btn-edit" onclick="openEdit(<%= id %>, '<%= nama.replace("'", "\\'") %>', '<%= tgl %>', '<%= wkt %>', '<%= desk.replace("'", "\\'").replace("\n", " ").replace("\r", "") %>')">Edit</button>
                            <form action="../KegiatanServlet" method="post" style="display:inline;" onsubmit="return confirm('Yakin hapus?')">
                                <input type="hidden" name="action" value="delete">
                                <input type="hidden" name="id" value="<%= id %>">
                                <button type="submit" class="btn-delete">Hapus</button>
                            </form>
                        </td>
                    </tr>
                <%
                            }
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6' class='no-data'>Error: " + e.getMessage() + "</td></tr>");
                    }
                    if (!hasData) {
                %>
                    <tr><td colspan="6" class="no-data">Belum ada data kegiatan</td></tr>
                <% } %>
                </tbody>
            </table>
        </div>
    </div>
    
    <div class="modal" id="editModal">
        <div class="modal-content">
            <div class="modal-header">
                <h3>Edit Kegiatan</h3>
                <button class="modal-close" onclick="closeEdit()">&times;</button>
            </div>
            <form action="../KegiatanServlet" method="post">
                <input type="hidden" name="action" value="edit">
                <input type="hidden" name="id" id="e_id">
                <div class="form-group">
                    <label>Nama Kegiatan</label>
                    <input type="text" name="nama_kegiatan" id="e_nama" required>
                </div>
                <div class="form-group">
                    <label>Tanggal</label>
                    <input type="date" name="tanggal" id="e_tgl" required>
                </div>
                <div class="form-group">
                    <label>Waktu</label>
                    <input type="time" name="waktu" id="e_wkt" required>
                </div>
                <div class="form-group">
                    <label>Deskripsi</label>
                    <textarea name="deskripsi" id="e_desk"></textarea>
                </div>
                <div class="form-actions">
                    <button type="submit" class="btn btn-primary">Simpan</button>
                    <button type="button" class="btn btn-secondary" onclick="closeEdit()">Batal</button>
                </div>
            </form>
        </div>
    </div>
    
    <script>
        function openEdit(id, nama, tgl, wkt, desk) {
            document.getElementById('e_id').value = id;
            document.getElementById('e_nama').value = nama;
            document.getElementById('e_tgl').value = tgl;
            document.getElementById('e_wkt').value = wkt;
            document.getElementById('e_desk').value = desk;
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
