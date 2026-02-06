<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Admin - Masjid Jabalussalam</title>
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
            min-height: 100vh;
            background: linear-gradient(135deg, #0d4f2b 0%, #1a7544 25%, #0d3320 50%, #1a5d3a 75%, #0d4f2b 100%);
            background-size: 400% 400%;
            animation: gradientShift 15s ease infinite;
            display: flex;
            justify-content: center;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        @keyframes gradientShift {
            0% {
                background-position: 0% 50%;
            }

            50% {
                background-position: 100% 50%;
            }

            100% {
                background-position: 0% 50%;
            }
        }

        .pattern-overlay {
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-image: url("data:image/svg+xml,%3Csvg width='60' height='60' viewBox='0 0 60 60' xmlns='http://www.w3.org/2000/svg'%3E%3Cpath d='M30 0L30 60M0 30L60 30' stroke='rgba(255,255,255,0.02)' stroke-width='1' fill='none'/%3E%3C/svg%3E");
            pointer-events: none;
        }

        .bg-decoration {
            position: absolute;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.03);
        }

        .bg-decoration:nth-child(1) {
            width: 400px;
            height: 400px;
            top: -100px;
            right: -100px;
        }

        .bg-decoration:nth-child(2) {
            width: 300px;
            height: 300px;
            bottom: -50px;
            left: -50px;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.98);
            border-radius: 24px;
            padding: 50px 45px;
            box-shadow: 0 25px 60px rgba(0, 0, 0, 0.3);
            width: 100%;
            max-width: 420px;
            margin: 20px;
            position: relative;
            z-index: 1;
        }

        .login-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 5px;
            background: linear-gradient(90deg, #1a5d3a, #2e8b57, #ffd700);
            border-radius: 24px 24px 0 0;
        }

        .login-header {
            text-align: center;
            margin-bottom: 35px;
        }

        .login-header .icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #1a5d3a 0%, #2e8b57 100%);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 20px;
            box-shadow: 0 10px 30px rgba(26, 93, 58, 0.3);
        }

        .login-header .icon i {
            font-size: 35px;
            color: white;
        }

        .login-header h2 {
            color: #1a5d3a;
            font-size: 1.8rem;
            font-weight: 700;
        }

        .login-header p {
            color: #888;
            font-size: 0.95rem;
            margin-top: 5px;
        }

        .form-group {
            margin-bottom: 22px;
        }

        .form-group label {
            display: block;
            color: #444;
            font-weight: 500;
            margin-bottom: 10px;
            font-size: 0.95rem;
        }

        .form-group label i {
            margin-right: 8px;
            color: #1a5d3a;
        }

        .input-wrapper {
            position: relative;
        }

        .input-wrapper i {
            position: absolute;
            left: 18px;
            top: 50%;
            transform: translateY(-50%);
            color: #999;
            font-size: 1.1rem;
            transition: color 0.3s ease;
        }

        .form-group input {
            width: 100%;
            padding: 16px 18px 16px 50px;
            border: 2px solid #e8e8e8;
            border-radius: 12px;
            font-size: 1rem;
            font-family: 'Poppins', sans-serif;
            transition: all 0.3s ease;
            background: #fafafa;
        }

        .form-group input:focus {
            outline: none;
            border-color: #1a5d3a;
            background: #fff;
            box-shadow: 0 0 0 4px rgba(26, 93, 58, 0.1);
        }

        .form-group input:focus+i,
        .input-wrapper:focus-within i {
            color: #1a5d3a;
        }

        .btn-login {
            width: 100%;
            padding: 16px;
            background: linear-gradient(135deg, #1a5d3a 0%, #2e8b57 100%);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 1.1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            font-family: 'Poppins', sans-serif;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
        }

        .btn-login i {
            font-size: 1.2rem;
        }

        .btn-login:hover {
            transform: translateY(-3px);
            box-shadow: 0 15px 35px rgba(26, 93, 58, 0.35);
        }

        .btn-login:active {
            transform: translateY(-1px);
        }

        .error-message {
            background: linear-gradient(135deg, #ffebee 0%, #ffcdd2 100%);
            color: #c62828;
            padding: 14px 18px;
            border-radius: 12px;
            margin-bottom: 25px;
            text-align: center;
            font-size: 0.95rem;
            display: none;
            align-items: center;
            justify-content: center;
            gap: 10px;
            border-left: 4px solid #f44336;
        }

        .error-message.show {
            display: flex;
        }

        .error-message i {
            font-size: 1.2rem;
        }

        .back-link {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            margin-top: 28px;
            color: #777;
            text-decoration: none;
            font-size: 0.95rem;
            transition: all 0.3s ease;
            padding: 12px;
            border-radius: 10px;
        }

        .back-link:hover {
            color: #1a5d3a;
            background: rgba(26, 93, 58, 0.05);
        }

        .back-link i {
            transition: transform 0.3s ease;
        }

        .back-link:hover i {
            transform: translateX(-5px);
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 40px 30px;
                margin: 15px;
            }

            .login-header h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>

<body>
    <div class="pattern-overlay"></div>
    <div class="bg-decoration"></div>
    <div class="bg-decoration"></div>
    <div class="login-container">
        <div class="login-header">
            <div class="icon"><i class="fas fa-user-shield"></i></div>
            <h2>Login Admin</h2>
            <p>Masjid Jabalussalam</p>
        </div>
        <div id="errorMessage" class="error-message">
            <i class="fas fa-exclamation-circle"></i>
            <span id="errorText">Username atau password salah!</span>
        </div>
        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label><i class="fas fa-user"></i>Username</label>
                <div class="input-wrapper">
                    <input type="text" id="username" name="username" required placeholder="Masukkan username">
                    <i class="fas fa-user"></i>
                </div>
            </div>
            <div class="form-group">
                <label><i class="fas fa-lock"></i>Password</label>
                <div class="input-wrapper">
                    <input type="password" id="password" name="password" required placeholder="Masukkan password">
                    <i class="fas fa-lock"></i>
                </div>
            </div>
            <button type="submit" class="btn-login">
                <i class="fas fa-right-to-bracket"></i>
                Masuk
            </button>
        </form>
        <a href="pilih-role.jsp" class="back-link">
            <i class="fas fa-arrow-left"></i>
            Kembali ke Halaman Utama
        </a>
    </div>
    <script>
        // Check for error parameter in URL
        const urlParams = new URLSearchParams(window.location.search);
        const error = urlParams.get('error');
        if (error) {
            const errorDiv = document.getElementById('errorMessage');
            const errorText = document.getElementById('errorText');
            errorDiv.classList.add('show');
            if (error === '1') {
                errorText.textContent = 'Username atau password salah!';
            } else {
                errorText.textContent = 'Terjadi kesalahan sistem. Silakan coba lagi.';
            }
        }
    </script>
</body>

</html>