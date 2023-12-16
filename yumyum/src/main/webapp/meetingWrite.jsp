<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 글 작성</title>
</head>
<body>
 <form action="mtWriteDB.jsp" method="post">
        제목: <input type="text" name="title" required><br>
        모임 인원: <input type="number" name="participant" required><br>
        모임 날짜: <input type="date" name="meetingDate"><br>
        모임 장소: <input type="text" name="place" required><br>
        내용: <textarea name="text" required></textarea><br>
        <input type="submit" value="확인">
    </form>
</body>
</html>