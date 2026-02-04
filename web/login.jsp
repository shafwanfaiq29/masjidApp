<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin - Masjid Jabalussalam</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Poppins', sans-serif;
            min-height: 100vh;
            background: linear-gradient(135deg, #1a5d3a 0%, #0d3320 50%, #1a5d3a 100%);
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .login-container {
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            padding: 50px 40px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 400px;
            margin: 20px;
        }
        .login-header { text-align: center; margin-bottom: 30px; }
        .login-header h2 { color: #1a5d3a; font-size: 1.8rem; font-weight: 600; }
        .login-header p { color: #666; font-size: 0.9rem; margin-top: 5px; }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; color: #333; font-weight: 500; margin-bottom: 8px; font-size: 0.95rem; }
        .form-group input {
            width: 100%; padding: 15px; border: 2px solid #e0e0e0;
            border-radius: 10px; font-size: 1rem; font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
        }
        .form-group input:focus { outline: none; border-color: #1a5d3a; box-shadow: 0 0 0 3px rgba(26, 93, 58, 0.1); }
        .btn-login {
            width: 100%; padding: 15px; background: linear-gradient(135deg, #1a5d3a, #2e8b57);
            color: white; border: none; border-radius: 10px; font-size: 1.1rem;
            font-weight: 600; cursor: pointer; transition: all 0.3s ease; font-family: 'Poppins', sans-serif;
        }
        .btn-login:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(26, 93, 58, 0.3); }
        .error-message { background: #ffe6e6; color: #d32f2f; padding: 12px; border-radius: 8px; margin-bottom: 20px; text-align: center; font-size: 0.9rem; }
        .back-link { display: block; text-align: center; margin-top: 25px; color: #666; text-decoration: none; font-size: 0.9rem; transition: color 0.3s ease; }
        .back-link:hover { color: #1a5d3a; }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h2>Login Admin</h2>
            <p>Masjid Jabalussalam</p>
        </div>
        
        <% if (request.getParameter("error") != null) { %>
        <div class="error-message">
            <% if ("1".equals(request.getParameter("error"))) { %>
                Username atau password salah!
            <% } else { %>
                Terjadi kesalahan sistem. Silakan coba lagi.
            <% } %>
        </div>
        <% } %>
        
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input type="text" id="username" name="username" required placeholder="Masukkan username">
            </div>
            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required placeholder="Masukkan password">
            </div>
            <button type="submit" class="btn-login">Masuk</button>
        </form>
        
        <a href="pilih-role.jsp" class="back-link">Kembali ke Halaman Utama</a>
    </div>
</body>
</html>
