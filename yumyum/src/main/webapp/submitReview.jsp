<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>서평 제출</title>
</head>
<body>
    <%
    String loggedInUserId = (String) session.getAttribute("id");
    if (loggedInUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        return;
    }

    String bookId = request.getParameter("bookId");
    String review = request.getParameter("review");
    float starScore = Float.parseFloat(request.getParameter("starScore"));

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam?useUnicode=true&characterEncoding=UTF-8";
        String dbID = "root";
        String dbPassword = "1234";
        String driverName = "com.mysql.jdbc.Driver";
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        // 서평과 별점 저장
        String sql = "UPDATE record SET review = ?, starScore = ? WHERE bookId = ? AND id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, review);
        pstmt.setFloat(2, starScore);
        pstmt.setString(3, bookId);
        pstmt.setString(4, loggedInUserId);
        int rowsAffected = pstmt.executeUpdate();

        if (rowsAffected > 0) {
        	out.println("<script>alert('서평 저장이 완료되었습니다.'); window.location.href = 'readingReview.jsp';</script>");
            return;
        } else {
            out.println("<p>서평 저장에 실패했습니다.</p>");
        }
    } catch(Exception e) {
        out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    %>
</body>
</html>
