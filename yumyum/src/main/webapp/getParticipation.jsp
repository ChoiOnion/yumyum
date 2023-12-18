<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<% 
    request.setCharacterEncoding("UTF-8");
    String idParam = request.getParameter("id");
    String numParam = request.getParameter("num");
    if (idParam == null) {
    	idParam = "null";
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>모임 참여자</title>
</head>
<body>
    <%
        Connection conn = null;
        PreparedStatement pstmtCheck = null;
        PreparedStatement pstmt = null;
        ResultSet rsCheck = null;
        ResultSet rs = null;

        StringBuilder tableHTML = new StringBuilder();

        try {
            int num = Integer.parseInt(numParam);
            String dbURL = "jdbc:mysql://localhost:3306/nyamnyam?characterEncoding=UTF-8";
            String dbID = "root";
            String dbPassword = "1234";
            String driverName = "com.mysql.jdbc.Driver";
            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

            // participant 테이블에서 idParam과 numParam이 일치하는지 확인하는 쿼리
            String sqlCheck = "SELECT COUNT(*) AS count FROM participant WHERE id = ? AND num = ?";
            pstmtCheck = conn.prepareStatement(sqlCheck);
            pstmtCheck.setString(1, idParam);
            pstmtCheck.setInt(2, num);
            rsCheck = pstmtCheck.executeQuery();
            rsCheck.next();
            int count = rsCheck.getInt("count");

            if (count > 0) { // idParam과 numParam이 일치하는 경우에만 참여자 목록을 가져옴
                // participant 테이블과 member 테이블을 id를 기준으로 조인하여 id와 name을 가져오는 쿼리
                String sql = "SELECT p.id, m.name FROM participant p JOIN member m ON p.id = m.id WHERE p.num = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, num);
                rs = pstmt.executeQuery();

                tableHTML.append("<table border=\"1\">");
                tableHTML.append("<tr>");
                tableHTML.append("<th>참여자 아이디</th>");
                tableHTML.append("<th>참여자 이름</th>");
                tableHTML.append("</tr>");

                while (rs.next()) {
                    String id = rs.getString("id");
                    String name = rs.getString("name");

                    tableHTML.append("<tr>");
                    tableHTML.append("<td>").append(id).append("</td>");
                    tableHTML.append("<td>").append(name).append("</td>");
                    tableHTML.append("</tr>");
                }

                tableHTML.append("</table>");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                if (rsCheck != null) rsCheck.close();
                if (pstmtCheck != null) pstmtCheck.close();
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    %>
    <%= tableHTML.toString() %>
</body>
</html>