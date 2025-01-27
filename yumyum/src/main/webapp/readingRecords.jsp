<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="main.css">
    <title>도서검색 및 추가</title>
    
    <style>
.record2-item {
    border-bottom: 1px dashed #f4a406; 
    padding-bottom: 20px;
    margin-bottom: 20px;
    width: 60%; 
    box-sizing: border-box;
    margin-left: auto; 
    margin-right: auto; 
}

    .record2-item span {
        margin-right: 10px;
        font-size: 18px; 
    }

    .record2-item select, .record-item input[type="submit"] {
        padding: 8px 10px; 
        font-size: 14px; 
    }

    .record2-item form {
        display: flex;
        align-items: center;
    }

    .record2-item form select {
        margin-right: 10px;
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
    %>
    <jsp:include page="./navbar.jsp"></jsp:include>

    <form method="get">
        <select name="searchType">
            <option value="title">제목</option>
            <option value="writer">글쓴이</option>
            <option value="genre">장르</option>
        </select>
        <input type="text" name="searchQuery">
        <input type="submit" value="검색">
    </form>

    <form method="post">
    <div class="records-container">
        <%
        String searchType = request.getParameter("searchType");
        String searchQuery = request.getParameter("searchQuery");
        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam?useUnicode=true&characterEncoding=UTF-8";
        String dbID = "root";
        String dbPassword = "1234";
        String driverName = "com.mysql.jdbc.Driver";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        boolean hasResults = false;

        if ("GET".equalsIgnoreCase(request.getMethod()) && searchQuery != null && !searchQuery.trim().isEmpty()) {
            try {
                Class.forName(driverName);
                conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
                String safeSearchType = "title";

                switch (searchType) {
                    case "title":
                        safeSearchType = "title";
                        break;
                    case "writer":
                        safeSearchType = "writer";
                        break;
                    case "genre":
                        safeSearchType = "genre";
                        break;
                }

                String sql = "SELECT b.bookId, b.title, b.writer, b.genre, AVG(r.starScore) as avgScore " +
                        "FROM book b LEFT JOIN record r ON b.bookId = r.bookId " +
                        "WHERE " + safeSearchType + " LIKE ? " +
                        "GROUP BY b.bookId, b.title, b.writer, b.genre";
          		pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + searchQuery + "%");
                rs = pstmt.executeQuery();
                while(rs.next()) {
                    hasResults = true;
                    out.println("<div class='record-item'>");
                    out.println("<input type='checkbox' name='bookId' value='" + rs.getInt("bookId") + "'>");
                    out.println("<label>제목: " + rs.getString("title") + ", 글쓴이: " + rs.getString("writer") + ", 장르: " + rs.getString("genre") + ", 평균별점: " + String.format("%.1f", rs.getDouble("avgScore")) + "</label><br>");
                    out.println("</div>");
                }
            } catch(Exception e) {
                e.printStackTrace();
            } finally {
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }

            if (hasResults) {
                out.println("<input type='submit' value='도서 추가'>");
            } else {
                out.println("<p>검색 결과가 없습니다.</p>");
            }
        }

        String[] bookIds = request.getParameterValues("bookId");
        if (loggedInUserId != null && "POST".equalsIgnoreCase(request.getMethod()) && bookIds != null) {
            try {
                if (conn == null || conn.isClosed()) {
                    conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
                }

                for (String bookId : bookIds) {
                    Date currentDate = new Date();
                    java.sql.Date sqlDate = new java.sql.Date(currentDate.getTime());

                    String insertSql = "INSERT INTO record (id, bookId, startDate, status) VALUES (?, ?, ?, '독서중')";
                    pstmt = conn.prepareStatement(insertSql);
                    pstmt.setString(1, loggedInUserId);
                    pstmt.setInt(2, Integer.parseInt(bookId));
                    pstmt.setDate(3, sqlDate);
                    pstmt.executeUpdate();
                }
                out.println("<p>도서가 성공적으로 추가되었습니다.</p>");
            } catch(Exception e) {
                e.printStackTrace();
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
        %>
        </div>
    </form>

    <h2>독서 기록 목록</h2>
    <%
    if (loggedInUserId != null) {
        try {
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
            }
            String sql = "SELECT rr.bookId, rr.startDate, rr.endDate, rr.status, b.title, b.writer "
                       + "FROM record rr JOIN book b ON rr.bookId = b.bookId "
                       + "WHERE rr.id = ? ORDER BY rr.status DESC, rr.startDate DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loggedInUserId);
            rs = pstmt.executeQuery();

            int recordNumber = 1;
            while(rs.next()) {
                String bookId = rs.getString("bookId");
                String title = rs.getString("title");
                String writer = rs.getString("writer");
                String status = rs.getString("status");

                out.println("<div class='record2-item'>");
                out.println("<span>" + recordNumber + ".</span>");
                out.println("<span>" + title + " / " + writer + " / " + status + "</span>");
                out.println("<form method='post' style='display: inline;'>");
                out.println("<input type='hidden' name='bookId' value='" + bookId + "'>");
                out.println("<select name='newStatus'>");
                out.println("<option value='독서중'" + ("독서중".equals(status) ? " selected" : "") + ">독서중</option>");
                out.println("<option value='독서완료'" + ("독서완료".equals(status) ? " selected" : "") + ">독서완료</option>");
                out.println("</select>");
                out.println("<input type='submit' value='상태 변경 및 서평 작성'>");
                out.println("</form>");
                out.println("</div>");
                
                recordNumber++;
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
   
        PreparedStatement pstmtUpdate = null;
        try {
            String bookIdToUpdate = request.getParameter("bookId");
            String newStatus = request.getParameter("newStatus");

            if ("POST".equalsIgnoreCase(request.getMethod()) && bookIdToUpdate != null && newStatus != null) {
                if (conn == null || conn.isClosed()) {
                    conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
                }

                String updateSql = "UPDATE record SET status = ?, endDate = (CASE WHEN ? = '독서완료' THEN CURRENT_DATE() ELSE NULL END) WHERE bookId = ? AND id = ?";
                pstmtUpdate = conn.prepareStatement(updateSql);

                pstmtUpdate.setString(1, newStatus);
                pstmtUpdate.setString(2, newStatus);
                pstmtUpdate.setString(3, bookIdToUpdate);
                pstmtUpdate.setString(4, loggedInUserId);

                int rowsAffected = pstmtUpdate.executeUpdate();
                if (rowsAffected > 0 && "독서완료".equals(newStatus)) {
                    response.sendRedirect("writingReview.jsp?bookId=" + bookIdToUpdate); 
                    return;
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmtUpdate != null) try { pstmtUpdate.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
   
</body>
</html>
