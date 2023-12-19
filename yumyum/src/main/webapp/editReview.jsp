<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>서평 수정</title>
    <link rel="stylesheet" href="main.css">        
    <style>
        body {
            background-color: #fdf6e3; 
            font-family: 'Cafe24Ssurround';
            color: #333; 
            text-align: center; 
            padding: 20px; 
            margin: 0;
        }

        form {
            background-color: #fff8dc; 
            border-radius: 10px; 
            display: flex; 
            flex-direction: column; 
            align-items: center;
            justify-content: space-around; 
            padding: 20px;
            margin: 20px auto;
            box-shadow: 0 4px 8px rgba(0,0,0,0.1); 
            width: 60%; 
        }

        select {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            width: 80%; 
            box-sizing: border-box; 
            margin-bottom: 10px;
        }

        input[type="text"] {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            width: 80%; 
            box-sizing: border-box; 
            margin-bottom: 10px; 
        }

        input[type="submit"] {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            background-color: #f4a460; 
            color: white; 
            cursor: pointer; 
            width: 80%; 
        }

        input[type="submit"]:hover {
            background-color: #c85a17; 
        }

        textarea {
            border: 1px solid #deb887; 
            border-radius: 5px; 
            padding: 10px; 
            font-size: 16px; 
            width: 80%;
            box-sizing: border-box; 
            margin-bottom: 10px; 
        }
    </style>
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

    String dbURL = "jdbc:mysql://localhost:3306/nyamnyam?useUnicode=true&characterEncoding=UTF-8";
    String dbID = "root";
    String dbPassword = "1234";
    String driverName = "com.mysql.jdbc.Driver";

    try {
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        
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
        <label for="starScore" style="display:inline-block; margin-bottom:10px;">별점</label>
        <select name="starScore" id="starScore" style="width:20%; margin-bottom:10px; vertical-align: top;">
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
        </select><br>
        <textarea name="review" rows="5" cols="50"><%=review%></textarea><br>
        <input type="submit" value="수정">
    </form>
</body>
</html>
