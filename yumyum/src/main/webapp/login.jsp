<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Sign up</title>
    <link rel="stylesheet" href="login.css">
</head>
 
<body>
    <header>
        <h1 class="heading">�ȳ� ��Ŭ��</h1>
    </header>
 
    <div class="container">
        <div class="slider"></div>
        <div class="btn">
            <button class="login">�α���</button>
            <button class="signup">ȸ������</button>
        </div>
 
        <div class="form-section">
            <!-- Existing login form (previous code) -->
            <div class="login-box">
                <form method="post" action="loginAction.jsp">
                    <input type="text" class="email ele" name="userId" placeholder="���̵�">
                    <input type="password" class="password ele" name="userPassword" placeholder="��й�ȣ">
                    <button class="clkbtn" type="submit">Login</button>
                </form>
            </div>
 
            <!-- ȸ������ �� -->
            <div class="signup-box">
                <form method="post" action="joinAction.jsp">
                    <input type="text" class="name ele" name="userId" placeholder="���̵�">
                    <input type="password" class="password ele" name="userPassword" placeholder="��й�ȣ">
                    <input type="text" class="name ele" name="userName" placeholder="�̸�">
                    <input type="email" class="email ele" name="userEmail" placeholder="�̸���">
                    <input type="text" class="name ele" name="userPhone" placeholder="��ȭ��ȣ">
                    <div class="form-group mb-3">
                        <div class="btn-group" data-toggle="buttons">
                            <input type="radio" class="btn-check" name="userSex" id="����" value="����" autocomplete="off" checked>
                            <label class="btn btn-secondary" for="����">����</label>
                            <input type="radio" class="btn-check" name="userSex" id="����" value="����" autocomplete="off">
                            <label class="btn btn-secondary" for="����">����</label>
                        </div>
                    </div>
                    
                    <button class="clkbtn" type="submit">ȸ������</button>
                </form>
            </div>
        </div>
    </div>
    <script src="login.js"></script>
</body>
</html>
