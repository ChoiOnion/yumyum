<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="main.css">
    <title>도서검색</title>
</head>
<body>
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

    <!-- 검색 결과 처리 및 표시 -->
    <%-- 검색 결과 부분을 여기에 배치 --%>
    <%
        String searchType = request.getParameter("searchType");
        String searchQuery = request.getParameter("searchQuery");
        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
        String dbID = "root";
        String dbPassword = "1234";
        String driverName = "com.mysql.jdbc.Driver";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

            boolean hasResults = false;

            if(searchType != null && searchQuery != null && !searchQuery.trim().isEmpty()) {
                String safeSearchType = "";
                switch (searchType) {
                    case "title":
                        safeSearchType = "title";
                        break;
                    case "writter":
                        safeSearchType = "writer";
                        break;
                    case "genre":
                        safeSearchType = "genre";
                        break;
                    default:
                        safeSearchType = "title"; // 기본값 혹은 오류 처리
                }

                String sql = "SELECT * FROM book WHERE " + safeSearchType + " LIKE ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setString(1, "%" + searchQuery + "%");
                rs = pstmt.executeQuery();

                while(rs.next()) {
                    hasResults = true;
                    out.println("<p>책 ID: " + rs.getInt("bookId") + "</p>");
                    out.println("<p>제목: " + rs.getString("title") + "</p>");
                    out.println("<p>글쓴이: " + rs.getString("writer") + "</p>");
                    out.println("<p>장르: " + rs.getString("genre") + "</p>");
                    out.println("<p>별점: " + rs.getDouble("starScore") + "</p>");
                    out.println("<p>서평: " + rs.getString("review") + "</p>");
                }

                if (!hasResults) {
                    out.println("<p>검색 결과가 없습니다.</p>");
                }
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            // 커넥션 닫기를 여기서 하지 않음
        }
    %>

    <!-- 인기 순위 표시 -->
    <%-- 인기 순위 부분을 여기에 배치 --%>
    <%
        Statement stmt = null;
        ResultSet rankRs = null;

        try {
            if (conn == null || conn.isClosed()) {
                conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
            }
            stmt = conn.createStatement();

            // 인기 순위 쿼리 항상 실행
            String rankSql = "SELECT * FROM book ORDER BY starScore DESC LIMIT 3";
            rankRs = stmt.executeQuery(rankSql);

            out.println("<h2>인기 순위</h2>");
            int rank = 1;
            while(rankRs.next()) {
                out.println("<p>" + rank + "위: " + rankRs.getString("title") + " - " + rankRs.getString("writer") + ", 별점: " + rankRs.getDouble("starScore") + "</p>");
                rank++;
            }
        } catch(Exception e) {
            e.printStackTrace();
        } finally {
            if (rankRs != null) try { rankRs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    %>
</body>
</html>
