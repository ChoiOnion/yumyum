<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>서평 수정</title>
</head>
<body>
    <%
    String bookId = request.getParameter("bookId");
    String loggedInUserId = (String) session.getAttribute("id");
    if (loggedInUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    String review = "";
    float starScore = 0;

    // Database connection parameters
    String dbURL = "jdbc:mysql://localhost:3306/nyamnyam?useUnicode=true&characterEncoding=UTF-8";
    String dbID = "root";
    String dbPassword = "1234";
    String driverName = "com.mysql.jdbc.Driver";

    try {
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        // Only fetch review if request is not a POST (to avoid overwriting user's current edit)
        if(!"POST".equalsIgnoreCase(request.getMethod())) {
            String sql = "SELECT review, starScore FROM record WHERE bookId = ? AND id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, bookId);
            pstmt.setString(2, loggedInUserId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                review = rs.getString("review");
                starScore = rs.getFloat("starScore");
            }
        }
    } catch(Exception e) {
        out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    // Handling form submission
    if("POST".equalsIgnoreCase(request.getMethod())) {
        review = request.getParameter("review");
        try {
            starScore = Float.parseFloat(request.getParameter("starScore"));
        } catch(NumberFormatException e) {
            out.println("<p>잘못된 별점 형식입니다.</p>");
        }

        try {
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

            String sql = "UPDATE record SET review = ?, starScore = ? WHERE bookId = ? AND id = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, review);
            pstmt.setFloat(2, starScore);
            pstmt.setString(3, bookId);
            pstmt.setString(4, loggedInUserId);
            int affectedRows = pstmt.executeUpdate();

            if(affectedRows > 0) {
                out.println("<script>alert('수정이 완료되었습니다.'); location.href='readingReview.jsp';</script>");
            } else {
                out.println("<p>서평 수정에 실패했습니다.</p>");
            }
            return;
        } catch(Exception e) {
            out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
            e.printStackTrace();
        } finally {
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
    %>
    <form action="editReview.jsp?bookId=<%=bookId%>" method="POST">
        <h1>서평 수정</h1>
            <p>
        <label>별점: 
            <select name="starScore">
                <option value="1" <%= starScore == 1.0 ? "selected" : "" %>>1</option>
                <option value="2" <%= starScore == 2.0 ? "selected" : "" %>>2</option>
                <option value="3" <%= starScore == 3.0 ? "selected" : "" %>>3</option>
                <option value="4" <%= starScore == 4.0 ? "selected" : "" %>>4</option>
                <option value="5" <%= starScore == 5.0 ? "selected" : "" %>>5</option>
            </select>
        </label>
    </p>

        <p><label>서평: <textarea name="review" rows="5" cols="50"><%=review%></textarea></label></p>
        <p><input type="submit" value="수정"></p>
    </form>
</body>
</html>
