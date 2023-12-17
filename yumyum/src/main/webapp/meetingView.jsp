<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>게시글 보기</title>
</head>
<body>

<%
    // 게시글 번호를 파라미터로부터 가져옴
    String numParam = request.getParameter("num");
    
    if (numParam != null) {
        try {
            int num = Integer.parseInt(numParam);
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;

            try {
                String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
                String dbID = "root";
                String dbPassword = "Puppy0423!";
                String driverName = "com.mysql.jdbc.Driver";
                Class.forName(driverName);
                conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

                // 해당 게시글 조회
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
                    <p>작성자: <%= id %></p>
                    <p>작성 날짜: <%= date %></p>
                    <p>모임 장소: <%= place %></p>
                    <p>모임 날짜: <%= meetingDate %></p>
                    <p>모임 인원: <%= participant %> / <%= headcount %></p>
                    <p>내용: <%= text %></p>
                    <button onclick="participate(<%= numParam %>)">참여</button><br>
                    <button><a href="meetingBoard.html">글 목록</a></button>
<script>
function participate(num) {
    var xmlhttp = new XMLHttpRequest();
    var url = "mtParticipate.jsp?num="+num;
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
                } else {
                    // 해당 번호의 게시글이 없을 경우 처리
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

</body>
</html>
