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
        /* 추가된 CSS 시작 */
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
            flex-direction: column; /* 수직 정렬 추가 */
            align-items: center; /* 수직 정렬 추가 */
            justify-content: space-around; 
            padding: 20px;
            margin: 20px auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); 
            width: 60%; /* 폼의 전체 너비 조정 */
        }

        select {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            width: 80%; /* 드롭다운의 너비 조정 */
            box-sizing: border-box; 
            margin-bottom: 10px; /* 드롭다운과 검색란 사이 간격 추가 */
        }

        input[type="text"] {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            width: 80%; /* 검색란의 너비 조정 */
            box-sizing: border-box; 
            margin-bottom: 10px; /* 검색란과 검색 버튼 사이 간격 추가 */
        }

        input[type="submit"] {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            background-color: #f4a460; 
            color: white; 
            cursor: pointer; 
            width: 80%; /* 검색 버튼의 너비 조정 */
        }

        input[type="submit"]:hover {
            background-color: #c85a17; 
        }

        textarea {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            width: 80%; /* 텍스트 영역의 너비 조정 */
            box-sizing: border-box; 
            margin-bottom: 10px; /* 텍스트 영역과 검색 버튼 사이 간격 추가 */
        }

        /* 추가된 CSS 끝 */
    </style>
</head>
<body>
<%String idParam = request.getParameter("id");%>
    <form action="disWriteDB.jsp?id=<%=idParam%>" method="post">
        제목: <input type="text" name="title" required><br>
        내용: <textarea name="text" required></textarea><br>
        <input type="submit" value="확인">
    </form>
</body>
</html>