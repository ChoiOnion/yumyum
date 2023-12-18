<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<% request.setCharacterEncoding("UTF-8");%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>서평 작성</title>
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
    String loggedInUserId = (String) session.getAttribute("id");
    if (loggedInUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        return;
    }

    String bookId = request.getParameter("bookId");
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String title = "", writer = "";
    Date startDate = null, endDate = null;

    try {
        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam?useUnicode=true&characterEncoding=UTF-8";
        String dbID = "root";
        String dbPassword = "1234";
        String driverName = "com.mysql.jdbc.Driver";
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        String sql = "SELECT b.title, b.writer, r.startDate, r.endDate FROM record r JOIN book b ON r.bookId = b.bookId WHERE r.bookId = ? AND r.id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, bookId);
        pstmt.setString(2, loggedInUserId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            title = rs.getString("title");
            writer = rs.getString("writer");
            startDate = rs.getDate("startDate");
            endDate = rs.getDate("endDate");
        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    %>
    <h2>서평 작성: <%= title %> (<%= writer %>)</h2>
    <p>독서 시작 날짜: <%= startDate %></p>
    <p>독서 종료 날짜: <%= endDate %></p>

    <form action="submitReview.jsp" method="post">
        <input type="hidden" name="bookId" value="<%= bookId %>">
        <textarea name="review" rows="5" cols="50" placeholder="서평을 입력해 주세요."></textarea><br>
        <label for="starScore" style="display:inline-block; margin-bottom:10px;">별점</label>
        <select name="starScore" id="starScore" style="width:20%; margin-bottom:10px; vertical-align: top;">
            <option value="1">1</option>
            <option value="2">2</option>
            <option value="3">3</option>
            <option value="4">4</option>
            <option value="5">5</option>
        </select><br>
        <input type="submit" value="서평 제출">
    </form>
</body>
</html>
