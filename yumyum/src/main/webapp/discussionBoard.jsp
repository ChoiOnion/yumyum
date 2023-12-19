<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>독서 토론 게시판</title>

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
            xmlhttp.open("GET", "getDiscussion.jsp?id=+<%=loggedInUserId%>", true);
            
            xmlhttp.send();
        }
        
        window.onload = function() {
            loadPosts();
            
            var mainButton = document.getElementById('mainButton');
            if (mainButton) {
                mainButton.addEventListener('click', function() {
                    window.location.href = 'main.jsp';
                });
            }
            

            var writeButton = document.getElementById('writeButton');
            if (writeButton) {
            	writeButton.addEventListener('click', function() {
                    window.location.href = 'discussionWrite.jsp';
                });
            }
        };

    </script>
</body>
</html>