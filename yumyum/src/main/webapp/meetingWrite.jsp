<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 글 작성</title>
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
<%String id = request.getParameter("id");%>
	<form action="mtWriteDB.jsp?id=<%= id %>" method="post" >
        제목: <input type="text" name="title" required><br>
        모임 인원: <input type="number" name="headcount" min=2 required><br>
        모임 날짜: <input type="date" id="meetingDate" name="meetingDate" required><br>
        모임 장소: <input type="text" name="place" required><br>
        내용: <textarea name="text" required></textarea><br>
        <input type="submit" value="확인">
    </form>
    
<%
    String currentDate = java.time.LocalDate.now().toString();
%>

<script>
    document.getElementById('meetingDate').setAttribute('min', '<%= currentDate %>');
</script>

</body>
</html>