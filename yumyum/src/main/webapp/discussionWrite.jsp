<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>토론 글 작성</title>
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