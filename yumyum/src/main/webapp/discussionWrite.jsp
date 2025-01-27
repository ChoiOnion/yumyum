<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>토론 글 작성</title>
    <link rel="stylesheet" href="main.css">
        <style>
        body {
            background-color: #fdf6e3; 
            font-family: 'Cafe24Ssurround';
            color: #333; 
            text-align: center; 
            padding: 20px; 
            margin: 0;
        }

        form {
            background-color: #fff8dc; 
            border-radius: 10px; 
            display: flex; 
            flex-direction: column; 
            align-items: center; 
            justify-content: space-around; 
            padding: 20px;
            margin: 20px auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); 
            width: 60%; 
        }

        select {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            width: 80%; 
            box-sizing: border-box; 
            margin-bottom: 10px; 
        }

        input[type="text"] {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            width: 80%; 
            box-sizing: border-box; 
            margin-bottom: 10px; 
        }

        input[type="submit"] {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            background-color: #f4a460; 
            color: white; 
            cursor: pointer; 
            width: 80%; 
        }

        input[type="submit"]:hover {
            background-color: #c85a17; 
        }

        textarea {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            width: 80%;
            box-sizing: border-box; 
            margin-bottom: 10px; 
        }
    </style>
</head>
<body>
<%
	String loggedInUserId = (String) session.getAttribute("id");
	if (loggedInUserId == null) {
    	out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
    return;
	}
%>
    <form action="disWriteDB.jsp?id=<%=loggedInUserId%>" method="post">
        제목: <input type="text" name="title" required><br>
        내용: <textarea name="text" required></textarea><br>
        <input type="submit" value="확인">
    </form>
</body>
</html>