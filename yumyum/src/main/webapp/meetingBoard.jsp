<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>독서 모임 게시판</title>
    <link rel="stylesheet" href="main.css">
</head>
<body>
<%
String loggedInUserId = (String) session.getAttribute("id");
if (loggedInUserId == null) {
    out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
    return;
}
%>
    <table border="1" id="postTable">
        <tr>
            <th>글 번호</th>
            <th>글 제목</th>
            <th>글쓴이</th>
            <th>모임 장소</th>
            <th>모임 날짜</th>
            <th>모임 인원</th>
            <th>작성 날짜</th>
        </tr>
    </table>
    <button id="mainButton" style=align:left;>메인</button>
    <button id="writeButton"style=align:right;>글 작성</button><br>
    <script>
        function loadPosts() {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    document.getElementById("postTable").innerHTML = xmlhttp.responseText;
                }
            };
            xmlhttp.open("GET", "getMeeting.jsp?id=<%=loggedInUserId%>", true);
            xmlhttp.send();
        }

        // 페이지 로딩 시 게시판 목록을 가져옴
        window.onload = function() {
            loadPosts();
            
            // 메인 버튼 이벤트 리스너 추가
            var mainButton = document.getElementById('mainButton');
            if (mainButton) {
                mainButton.addEventListener('click', function() {
                    window.location.href = 'main.jsp';
                });
            }

            // 글 작성 버튼 이벤트 리스너 추가
            var writeButton = document.getElementById('writeButton');
            if (writeButton) {
                writeButton.addEventListener('click', function() {
                    window.location.href = 'meetingWrite.jsp';
                });
            }
        };
    </script>
</body>
</html>
