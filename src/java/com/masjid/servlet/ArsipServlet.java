package com.masjid.servlet;

import com.masjid.config.Koneksi;
import java.io.*;
import java.sql.*;
import java.text.SimpleDateFormat;
import java.util.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/ArsipServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1 MB
    maxFileSize = 1024 * 1024 * 10,       // 10 MB
    maxRequestSize = 1024 * 1024 * 50     // 50 MB
)
public class ArsipServlet extends HttpServlet {
    
    // DIRECTORY FOR PERSISTENT STORAGE (Project Source Folder)
    // NOTE: This path is hardcoded for the current environment. 
    // If the project is moved, this path MUST be updated.
    private static final String UPLOAD_PATH = "E:/semester 5/PBO/MasjidApp/web/uploads/arsip";
    
    private boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return session != null && session.getAttribute("adminId") != null;
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isLoggedIn(request)) {
            response.sendRedirect("login.jsp");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            Connection con = Koneksi.getKoneksi();
            
            if ("add".equals(action)) {
                // Get form parameters
                String namaDokumen = request.getParameter("nama_dokumen");
                String deskripsi = request.getParameter("deskripsi");
                String kategori = request.getParameter("kategori");
                String tanggal = request.getParameter("tanggal");
                
                // Handle file upload
                Part filePart = request.getPart("file");
                String originalFileName = getFileName(filePart);
                
                if (originalFileName == null || originalFileName.isEmpty()) {
                    response.sendRedirect("admin/arsip.jsp?error=nofile");
                    return;
                }
                
                // Check if PDF
                if (!originalFileName.toLowerCase().endsWith(".pdf")) {
                    response.sendRedirect("admin/arsip.jsp?error=notpdf");
                    return;
                }
                
                // Generate unique filename
                String timestamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(new Date());
                String fileName = timestamp + "_" + originalFileName.replaceAll("[^a-zA-Z0-9._-]", "_");
                
                // Ensure upload directory exists
                File uploadDir = new File(UPLOAD_PATH);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }
                
                // Save file to persistent location
                String filePath = UPLOAD_PATH + File.separator + fileName;
                filePart.write(filePath);
                
                // Save to database
                String sql = "INSERT INTO arsip (nama_dokumen, deskripsi, file_name, kategori, tanggal_upload) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, namaDokumen);
                ps.setString(2, deskripsi);
                ps.setString(3, fileName);
                ps.setString(4, kategori);
                ps.setString(5, tanggal);
                ps.executeUpdate();
                ps.close();
                
                response.sendRedirect("admin/arsip.jsp?success=add");
                
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                
                // Get file name first
                String sql = "SELECT file_name FROM arsip WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    String fileName = rs.getString("file_name");
                    // Delete file from disk (Persistent Location)
                    File file = new File(UPLOAD_PATH + File.separator + fileName);
                    if (file.exists()) {
                        file.delete();
                    }
                }
                rs.close();
                ps.close();
                
                // Delete from database
                sql = "DELETE FROM arsip WHERE id=?";
                ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                ps.executeUpdate();
                ps.close();
                
                response.sendRedirect("admin/arsip.jsp?success=delete");
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/arsip.jsp?error=1");
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        
        if ("download".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            
            try {
                Connection con = Koneksi.getKoneksi();
                String sql = "SELECT nama_dokumen, file_name FROM arsip WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                ResultSet rs = ps.executeQuery();
                
                if (rs.next()) {
                    String namaDokumen = rs.getString("nama_dokumen");
                    String fileName = rs.getString("file_name");
                    
                    // Read file from persistent location
                    File file = new File(UPLOAD_PATH + File.separator + fileName);
                    
                    if (file.exists()) {
                        response.setContentType("application/pdf");
                        response.setHeader("Content-Disposition", "inline; filename=\"" + namaDokumen + ".pdf\"");
                        response.setContentLength((int) file.length());
                        
                        FileInputStream fis = new FileInputStream(file);
                        OutputStream os = response.getOutputStream();
                        
                        byte[] buffer = new byte[4096];
                        int bytesRead;
                        while ((bytesRead = fis.read(buffer)) != -1) {
                            os.write(buffer, 0, bytesRead);
                        }
                        
                        fis.close();
                        os.flush();
                    } else {
                        response.sendError(HttpServletResponse.SC_NOT_FOUND, "File tidak ditemukan di server (Path: " + file.getAbsolutePath() + ")");
                    }
                }
                
                rs.close();
                ps.close();
                con.close();
                
            } catch (Exception e) {
                e.printStackTrace();
                response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            }
        }
    }
    
    private String getFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] tokens = contentDisp.split(";");
        for (String token : tokens) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }
}
