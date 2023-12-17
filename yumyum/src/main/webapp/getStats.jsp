<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    
    Statement stmt2 = null;
    ResultSet rs2 = null;
    
    Statement stmt3 = null;
    ResultSet rs3 = null;

    try {
        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
        String dbID = "root";
        String dbPassword = "1234";
        String driverName = "com.mysql.jdbc.Driver";
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        // SQL 쿼리 실행
        String sql = "SELECT COUNT(bookID) AS oneBookCount FROM record WHERE MONTH(endDate) = MONTH(CURRENT_DATE)";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        String sql2 = "SELECT COUNT(bookID) AS twoBookCount FROM record WHERE MONTH(endDate) = (MONTH(CURRENT_DATE)-1)";
        stmt2 = conn.createStatement();
        rs2 = stmt2.executeQuery(sql2);

        String sql3 = "SELECT COUNT(bookID) AS threeBookCount FROM record WHERE MONTH(endDate) = (MONTH(CURRENT_DATE)-2)";
        stmt3 = conn.createStatement();
        rs3 = stmt3.executeQuery(sql3);

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
        if (stmt != null) stmt.close();
        if (stmt2 != null) stmt2.close();
        if (stmt3 != null) stmt3.close();
        if (conn != null) conn.close();
    }
%>