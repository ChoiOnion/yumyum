<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.net.URLDecoder" %>
<%
String id = request.getParameter("id");

    Connection conn = null;
    ResultSet rs = null;
    ResultSet rs2 = null;
    ResultSet rs3 = null;
    PreparedStatement pstmt = null;
    PreparedStatement pstmt2 = null;
    PreparedStatement pstmt3 = null;

    try {
        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
        String dbID = "root";
        String dbPassword = "1234";
        String driverName = "com.mysql.jdbc.Driver";
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        // SQL 쿼리 실행
        String sql = "SELECT COUNT(bookID) AS oneBookCount FROM record WHERE MONTH(endDate) = MONTH(CURRENT_DATE) AND id = ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, id);
        rs = pstmt.executeQuery();

        String sql2 = "SELECT COUNT(bookID) AS twoBookCount FROM record WHERE MONTH(endDate) = (MONTH(CURRENT_DATE)-1) AND id = ?";
        pstmt2 = conn.prepareStatement(sql2);
        pstmt2.setString(1, id);
        rs2 = pstmt2.executeQuery();

        String sql3 = "SELECT COUNT(bookID) AS threeBookCount FROM record WHERE MONTH(endDate) = (MONTH(CURRENT_DATE)-2) AND id = ?";
        pstmt3 = conn.prepareStatement(sql3);
        pstmt3.setString(1, id);
        rs3 = pstmt3.executeQuery();


        // 결과를 저장할 변수
        int oneBookCount = 0;
        int twoBookCount = 0;
        int threeBookCount = 0;

     // 결과를 변수에 저장
        if (rs.next()) {
            oneBookCount = rs.getInt("oneBookCount");
        }

        // rs2에 대해서도 동일하게 적용
        if (rs2.next()) {
            twoBookCount = rs2.getInt("twoBookCount");
        }

        // rs3에 대해서도 동일하게 적용
        if (rs3.next()) {
            threeBookCount = rs3.getInt("threeBookCount");
        }
        response.getWriter().println(oneBookCount);
        response.getWriter().println(twoBookCount);
        response.getWriter().println(threeBookCount);

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) rs.close();
        if (rs2 != null) rs2.close();
        if (rs3 != null) rs3.close();
        if (pstmt != null) pstmt.close();
        if (pstmt2 != null) pstmt2.close();
        if (pstmt3 != null) pstmt3.close();
        if (conn != null) conn.close();
    }
%>