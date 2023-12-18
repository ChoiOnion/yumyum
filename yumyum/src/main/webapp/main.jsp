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

    <% 
    String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
    String dbID = "root";
    String dbPassword = "1234";
    Connection conn = null;
    try {
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        // 인기 순위 표시
        Statement stmt = conn.createStatement();
        String rankSql = "SELECT b.bookId, b.title, b.writer, AVG(r.starScore) as avgScore " +
                "FROM book b LEFT JOIN record r ON b.bookId = r.bookId " +
                "GROUP BY b.bookId, b.title, b.writer " +
                "ORDER BY avgScore DESC LIMIT 3";

        ResultSet rankRs = stmt.executeQuery(rankSql);

        out.println("<h2>인기 순위</h2>");
        if (!rankRs.isBeforeFirst()) {
            out.println("<p>등록된 평가가 없습니다.</p>"); // "No evaluations registered."
        } else {
            int rank = 1;
            while(rankRs.next()) {
                out.println("<p>" + rank + "위: " + rankRs.getString("title") + " - " + rankRs.getString("writer") + ", 평균 별점: " + String.format("%.1f", rankRs.getDouble("avgScore")) + "</p>");
                rank++;
            }
        }

        if (rankRs != null) try { rankRs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
    } catch(Exception e) {
        e.printStackTrace();
    }
%>

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
<form method="get">
<div class="records-container">
<%
    String searchType = request.getParameter("searchType");
    String searchQuery = request.getParameter("searchQuery");
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        if(searchType != null && searchQuery != null && !searchQuery.trim().isEmpty()) {
            String safeSearchType = "";
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
                default:
                    safeSearchType = "title";
            }

            // Updated SQL Query
            String sql = "SELECT b.bookId, b.title, b.writer, b.genre, AVG(r.starScore) as avgScore " +
                         "FROM book b LEFT JOIN record r ON b.bookId = r.bookId " +
                         "WHERE " + safeSearchType + " LIKE ? " +
                         "GROUP BY b.bookId, b.title, b.writer, b.genre";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, "%" + searchQuery + "%");
            rs = pstmt.executeQuery();
            int counter = 1;
            while(rs.next()) {
            	out.println("<div class='record-item'>");
            	out.println(counter + ".");
                out.println("<p>책 ID: " + rs.getInt("bookId") + "</p>");
                out.println("<p>제목: " + rs.getString("title") + "</p>");
                out.println("<p>글쓴이: " + rs.getString("writer") + "</p>");
                out.println("<p>장르: " + rs.getString("genre") + "</p>");
                out.println("<p>평균 별점: " + String.format("%.1f", rs.getDouble("avgScore")) + "</p>");
                out.println("</div>");
                counter++;
            }

        }
    } catch(Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
</div>
</form>
</body>
</html>
