<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>모임 글 작성</title>
</head>
<body>
<%String id = request.getParameter("id");%>
	<form action="mtWriteDB.jsp?id=<%= id %>" method="post">
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