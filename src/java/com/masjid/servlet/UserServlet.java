package com.masjid.servlet;

import com.masjid.config.Koneksi;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/UserServlet")
public class UserServlet extends HttpServlet {
    
    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminId") == null) return false;
        String role = (String) session.getAttribute("adminRole");
        return "Admin".equals(role);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        if (!isAdmin(request)) {
            response.sendRedirect("admin/dashboard.jsp?error=access");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            Connection con = Koneksi.getKoneksi();
            
            if ("add".equals(action)) {
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String nama = request.getParameter("nama");
                String role = request.getParameter("role");
                
                String sql = "INSERT INTO admin (username, password, nama, role) VALUES (?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, username);
                ps.setString(2, password);
                ps.setString(3, nama);
                ps.setString(4, role);
                ps.executeUpdate();
                ps.close();
                
                response.sendRedirect("admin/users.jsp?success=add");
                
            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                String username = request.getParameter("username");
                String password = request.getParameter("password");
                String nama = request.getParameter("nama");
                String role = request.getParameter("role");
                
                String sql;
                PreparedStatement ps;
                
                if (password != null && !password.isEmpty()) {
                    sql = "UPDATE admin SET username=?, password=?, nama=?, role=? WHERE id=?";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, username);
                    ps.setString(2, password);
                    ps.setString(3, nama);
                    ps.setString(4, role);
                    ps.setInt(5, id);
                } else {
                    sql = "UPDATE admin SET username=?, nama=?, role=? WHERE id=?";
                    ps = con.prepareStatement(sql);
                    ps.setString(1, username);
                    ps.setString(2, nama);
                    ps.setString(3, role);
                    ps.setInt(4, id);
                }
                ps.executeUpdate();
                ps.close();
                
                response.sendRedirect("admin/users.jsp?success=edit");
                
            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                
                // Prevent deleting self
                HttpSession session = request.getSession();
                int currentId = (int) session.getAttribute("adminId");
                if (id == currentId) {
                    response.sendRedirect("admin/users.jsp?error=self");
                    return;
                }
                
                String sql = "DELETE FROM admin WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, id);
                ps.executeUpdate();
                ps.close();
                
                response.sendRedirect("admin/users.jsp?success=delete");
            }
            
            con.close();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin/users.jsp?error=1");
        }
    }
}
