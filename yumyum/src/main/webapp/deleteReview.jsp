<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>서평 삭제</title>
</head>
<body>
    <%
    String loggedInUserId = (String) session.getAttribute("id");
    if (loggedInUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        return;
    }

    String bookId = request.getParameter("bookId");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam?useUnicode=true&characterEncoding=UTF-8";
        String dbID = "root";
        String dbPassword = "1234";
        String driverName = "com.mysql.jdbc.Driver";
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        //서평 삭제
        String sqlDeleteReview = "UPDATE record SET review = NULL, starScore = NULL WHERE bookId = ? AND id = ?";
        pstmt = conn.prepareStatement(sqlDeleteReview);
        pstmt.setString(1, bookId);
        pstmt.setString(2, loggedInUserId);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
            out.println("<script>alert('서평이 삭제되었습니다.'); window.location.href = 'readingReview.jsp';</script>");
        } else {
            out.println("<script>alert('서평 삭제에 실패했습니다.'); window.location.href = 'readingReview.jsp';</script>");
        }
    } catch(Exception e) {
        out.println("<script>alert('오류가 발생했습니다: " + e.getMessage() + "'); window.location.href = 'readingReview.jsp';</script>");
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    %>
</body>
</html>
