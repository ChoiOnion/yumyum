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
    <style>
    ul {
  list-style-type: none; /* 목록의 기본 스타일(숫자)을 숨김 */
  counter-reset: my-counter; /* 사용자 정의 카운터 초기화 */
  text-align:left;
  padding-left:65px;
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
    // 게시글 번호를 파라미터로부터 가져옴
    String numParam = request.getParameter("num");
    if (numParam != null) {
        try {
            int num = Integer.parseInt(numParam);
            
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            PreparedStatement pstmtComments = null;
            ResultSet rsComments = null;

            try {
                String dbURL = "jdbc:mysql://localhost:3306/nyamnyam?useUnicode=true&characterEncoding=utf8";
                String dbID = "root";
                String dbPassword = "1234";
                String driverName = "com.mysql.jdbc.Driver";
                Class.forName(driverName);
                conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

                String sql = "SELECT * FROM discussion WHERE num = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, num);
                rs = pstmt.executeQuery();

                if (rs.next()) {
                    String title = rs.getString("title");
                    String id = rs.getString("id");
                    String text = rs.getString("text");
                    String date = new SimpleDateFormat("yyyy-MM-dd").format(rs.getTimestamp("date"));

                    String commentSql = "SELECT * FROM comment WHERE num = ?";
                    pstmtComments = conn.prepareStatement(commentSql);
                    pstmtComments.setInt(1, num);
                    rsComments = pstmtComments.executeQuery();
%>
                    <h2><%= title %></h2>
                    <p style="width:80%; background-color: #FFEBC2;">작성자: <%= id %> | 작성 날짜: <%= date %></p><br>
                    <p style="width:80%; height:150px"><%= text %></p><br>
    				<button id="boardButton">게시글 목록</button><br>
                    <hr>
                     <ul>
<%
                    while (rsComments.next()) {
                        String commentUserId = rsComments.getString("id");
                        String commentText = rsComments.getString("text");
                        String commentDate = new SimpleDateFormat("yyyy-MM-dd").format(rsComments.getTimestamp("date"));
%>
                        <li style="margin-left:5%"><strong><%= commentUserId %></strong>: <%= commentText %> (작성일: <%= commentDate %>)</li>
<%
                    }
%>
                    </ul>
                    <form action="addComment.jsp" method="post" style="width:80%">
                        <input type="hidden" name="num" value="<%= num %>">
                        <input type="hidden" name="id" value="<%= loggedInUserId %>">
                        <textarea id="commentText" name="commentText" style="width:80%" required></textarea>
                        <input type="submit" value="댓글 등록">
                    </form>
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
            window.location.href = 'discussionBoard.jsp';
        });
    }
};
</script>
</body>
</html>
