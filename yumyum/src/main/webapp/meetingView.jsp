<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 보기</title>
    <link rel="stylesheet" href="main.css">
</head>
<body>
<%

	String numParam = request.getParameter("num");
	String loggedInUserId = (String) session.getAttribute("id");
	if (loggedInUserId == null) {
		out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
		return;
	}
%>
<script>
function participate() {
    var xmlhttp = new XMLHttpRequest();
    var url = "mtParticipate.jsp?num=<%=numParam%>&id=<%=loggedInUserId%>";
    xmlhttp.open("POST", url, true);
    xmlhttp.send();
    xmlhttp.onreadystatechange = function() {
        if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
        	window.alert(xmlhttp.responseText);
        	location.reload();
        }
    };
}
</script>
<%
    if (numParam != null) {
        try {
            int num = Integer.parseInt(numParam);
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
                String dbID = "root";
                String dbPassword = "1234";
                String driverName = "com.mysql.jdbc.Driver";
                Class.forName(driverName);
                conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

                String sql = "SELECT * FROM meeting WHERE num = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, num);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String title = rs.getString("title");
                    String id = rs.getString("id");
                    String text = rs.getString("text");
                    String place = rs.getString("place");
                    String meetingDate = rs.getString("meetingDate");
                    int participant = rs.getInt("participant");
                    int headcount = rs.getInt("headcount");
                    String date = new SimpleDateFormat("yyyy-MM-dd").format(rs.getTimestamp("date"));

%>
                    <h2><%= title %></h2>
                    <p style="width:80%; background-color: #FFEBC2;">작성자: <%= id %> | 작성 날짜: <%= date %><br><br>모임 장소: <%= place %> | 
                    					  모임 날짜: <%= meetingDate %> | 모임 인원: <%= participant %> / <%= headcount %> <br>
                    <p style="width:80%; height:150px"><%= text %></p><br>
                    <button onclick="participate()">참여</button>
    				<button id="boardButton">게시글 목록</button><br>
    				<table id="postTable"></table>
<%
                } else {
                    out.println("해당 번호의 게시글을 찾을 수 없습니다.");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        } catch (NumberFormatException e) {
            out.println("올바르지 않은 게시글 번호입니다.");
        }
    } else {
        out.println("게시글 번호를 지정해주세요.");
    }
%>
<script>
	window.onload = function() {
	    var boardButton = document.getElementById('boardButton');
	    if (boardButton) {
	    	boardButton.addEventListener('click', function() {
	            window.location.href = 'meetingBoard.jsp';
	        });
	    }
		loadParticipation();
	};
	
    function loadParticipation() {
        var xmlhttp = new XMLHttpRequest();
        xmlhttp.onreadystatechange = function() {
            if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                document.getElementById("postTable").innerHTML = xmlhttp.responseText;
            }
        };
        var numParam = getParameterByName('num');
        xmlhttp.open("GET", "getParticipation.jsp?num="+numParam, true);
        xmlhttp.send();
    }
</script>
</body>
</html>
