<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%
    String numParam = request.getParameter("num"); 
    String idParam = request.getParameter("id");   
    String textParam = request.getParameter("commentText");

    if (numParam != null && idParam != null && textParam != null) {
        try {
            int num = Integer.parseInt(numParam);

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                String dbURL = "jdbc:mysql://localhost:3306/nyamnyam?useUnicode=true&characterEncoding=utf8";
                String dbID = "root";
                String dbPassword = "1234";
                String driverName = "com.mysql.jdbc.Driver";
                Class.forName(driverName);
                conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

                String insertCommentQuery = "INSERT INTO comment (num, id, text, date) VALUES (?, ?, ?, ?)";
                pstmt = conn.prepareStatement(insertCommentQuery);
                pstmt.setInt(1, num);
                pstmt.setString(2, idParam);
                pstmt.setString(3, textParam);
                pstmt.setString(4, new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date()));
                pstmt.executeUpdate();
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        } catch (NumberFormatException e) {
        }
    }
    response.sendRedirect("discussionView.jsp?num=" + numParam);
%>