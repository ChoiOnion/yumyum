<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.Date"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="main.css">
    <title>도서검색 및 추가</title>
</head>
<body>
    <% 
    String loggedInUserId = (String) session.getAttribute("userId");
    if (loggedInUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        return;
    }
    %>
    <jsp:include page="./navbar.jsp"></jsp:include>

    <!-- 검색 폼 -->
    <form method="get">
        <select name="searchType">
            <option value="title">제목</option>
            <option value="writer">글쓴이</option>
            <option value="genre">장르</option>
        </select>
        <input type="text" name="searchQuery">
        <input type="submit" value="검색">
    </form>

    <!-- 검색 결과 및 도서 추가 폼 -->
    <form method="post">
        <%
        String searchType = request.getParameter("searchType");
        String searchQuery = request.getParameter("searchQuery");
        String dbURL = "jdbc:mysql://localhost:3306/loaddb";
        String dbID = "root";
        String dbPassword = "root";
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

                String sql = "SELECT * FROM book WHERE " + safeSearchType + " LIKE ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + searchQuery + "%");
                rs = pstmt.executeQuery();

                while(rs.next()) {
                    hasResults = true;
                    out.println("<input type='checkbox' name='bookId' value='" + rs.getInt("bookId") + "'>");
                    out.println("<label>제목: " + rs.getString("title") + ", 글쓴이: " + rs.getString("writer") + ", 장르: " + rs.getString("genre") + ", 별점: " + rs.getDouble("starScore") + "</label><br>");
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
        } else if ("GET".equalsIgnoreCase(request.getMethod())) {
            out.println("<p>검색어를 입력해주세요.</p>");
        }

        // 도서 추가
        String[] bookIds = request.getParameterValues("bookId");
        if (loggedInUserId != null && "POST".equalsIgnoreCase(request.getMethod()) && bookIds != null) {
            try {
                if (conn == null || conn.isClosed()) {
                    conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
                }

                for (String bookId : bookIds) {
                    Date currentDate = new Date();
                    java.sql.Date sqlDate = new java.sql.Date(currentDate.getTime());

                    String insertSql = "INSERT INTO readingRecord (userId, bookId, startDate, status) VALUES (?, ?, ?, '독서중')";
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
    </form>
    
<!-- 독서 기록 목록 -->
<h2>독서 기록 목록</h2>
<%
    if (loggedInUserId != null) {
        try {
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
            }
            String sql = "SELECT rr.recordId, rr.bookId, rr.startDate, rr.endDate, rr.status, rr.rating, rr.review, b.title, b.writer "
                       + "FROM readingRecord rr JOIN book b ON rr.bookId = b.bookId "
                       + "WHERE rr.userId = ? ORDER BY rr.status DESC, rr.startDate DESC";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loggedInUserId);
            rs = pstmt.executeQuery();

            while(rs.next()) {
                int recordId = rs.getInt("recordId");
                String bookId = rs.getString("bookId");
                String title = rs.getString("title");
                String writer = rs.getString("writer");
                Date startDate = rs.getDate("startDate");
                String status = rs.getString("status");

                out.println("<div style='margin-bottom: 10px;'>");
                
                out.println("<span style='margin-right: 10px;'>" + recordId + " / " + title + " / " + writer + " / " + status + "</span>");

                out.println("<form method='post' action='writingReview.jsp' style='display: inline;'>");
                out.println("<input type='hidden' name='recordId' value='" + recordId + "'>");
                out.println("<select name='newStatus'>");
                out.println("<option value='독서중'" + ("독서중".equals(status) ? " selected" : "") + ">독서중</option>");
                out.println("<option value='독서완료'" + ("독서완료".equals(status) ? " selected" : "") + ">독서완료</option>");
                out.println("</select>");
                out.println("<input type='submit' value='상태 변경'>");
                out.println("</form>");

                out.println("</div>");
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    }
%>

</body>
</html>
