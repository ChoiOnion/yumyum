<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
	<h1 class="heading">냠냠 북클럽</h1>
    <img src="https://github.com/Manmandarin/abc/blob/main/%EB%A1%9C%EA%B3%A0.png?raw=true" alt="냠냠 북클럽 로고">
</header>
 
    <div class="container">
        <div class="slider"></div>
        <div class="btn">
            <button class="login">로그인</button>
            <button class="signup">회원가입</button>
        </div>
 
        <div class="form-section">
            <div class="login-box">
                <form method="post" action="loginAction.jsp">
                    <input type="text" class="email ele" name="id" placeholder="아이디">
                    <input type="password" class="password ele" name="pwd" placeholder="비밀번호">
                    <button class="clkbtn" type="submit">Login</button>
                </form>
            </div>
 
            <div class="signup-box">
                <form method="post" action="joinAction.jsp">
                    <input type="text" class="name ele" name="id" placeholder="아이디">
                    <input type="password" class="password ele" name="pwd" placeholder="비밀번호">
                    <input type="text" class="name ele" name="name" placeholder="이름">
                    <input type="email" class="email ele" name="mail" placeholder="이메일">
                    <input type="text" class="name ele" name="phoneNum" placeholder="전화번호">
                    <div class="form-group mb-3">
                        <div class="btn-group" data-toggle="buttons">
                            <input type="radio" class="btn-check" name="gender" id="남자" value="남자" autocomplete="off" checked>
                            <label class="gender ele" for="남자">남자</label>
                            <input type="radio" class="btn-check" name="gender" id="여자" value="여자" autocomplete="off">
                            <label class="gender ele" for="여자">여자</label>
                        </div>
                    </div>
                    
                    <button class="clkbtn" type="submit">Sign up</button>
                </form>
            </div>
        </div>
    </div>
    <script src="login.js"></script>
</body>
</html>
