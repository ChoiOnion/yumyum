<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    StringBuilder tableHTML = new StringBuilder();

    try {
        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
        String dbID = "root";
        String dbPassword = "Puppy0423!";
        String driverName = "com.mysql.jdbc.Driver";
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        String sql = "SELECT * FROM discussion ORDER BY date DESC";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        tableHTML.append("<tr>");
        tableHTML.append("<th>글 번호</th>");
        tableHTML.append("<th>글 제목</th>");
        tableHTML.append("<th>글쓴이</th>");
        tableHTML.append("<th>작성 날짜</th>");
        tableHTML.append("</tr>");

        while (rs.next()) {
            String num = rs.getString("num");
            String title = rs.getString("title");
            String id = rs.getString("id");
            String date = new SimpleDateFormat("yyyy-MM-dd").format(rs.getTimestamp("date"));

            tableHTML.append("<tr>");
            tableHTML.append("<td>").append(num).append("</td>");
            tableHTML.append("<td><a href=\"discussionView.jsp?num=").append(num).append("\">").append(title).append("</a></td>");
            tableHTML.append("<td>").append(id).append("</td>");
            tableHTML.append("<td>").append(date).append("</td>");
            tableHTML.append("</tr>");
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>독서 토론 게시판</title>
</head>
<body>
    <table border="1" id="postTable">
        <%= tableHTML.toString() %>
    </table>
</body>
</html>