<%@ page language="java" contentType="application/json; charset=UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="com.google.gson.Gson" %>

<%
    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;

    try {
        // 데이터베이스 연결 정보 설정
        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
        String dbID = "root";
        String dbPassword = "1234";
        String driverName = "com.mysql.jdbc.Driver";
        Class.forName(driverName);

        // 데이터베이스 연결
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        // SQL 쿼리 실행
        // bookID 는 다른 곳에서 받아오도록 하는걸로
        String sql = "SELECT startDate, endDate, bookId FROM record";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(sql);

        // 기존 데이터 목록 생성
        List<String> existingDataList = new ArrayList<>();

        while (rs.next()) {
            String startDate = rs.getString("startDate");
            String endDate = rs.getString("endDate");
            String bookId = rs.getString("bookId");

            // 여기서는 단순히 문자열로 묶어서 리스트에 추가하는 예제입니다.
            existingDataList.add("Start Date: " + startDate + ", End Date: " + endDate + ", Book Name: " + bookId);
        }

        // 새로운 데이터를 파라미터에서 받아와서 추가
        String newStartDate = request.getParameter("newStartDate");
        String newEndDate = request.getParameter("newEndDate");
        String newBookName = request.getParameter("newBookName");

        if (newStartDate != null && newEndDate != null && newBookName != null) {
            existingDataList.add("Start Date: " + newStartDate + ", End Date: " + newEndDate + ", Book Name: " + newBookName);
        }

        // JSON 데이터 생성
        Gson gson = new Gson();
        String jsonData = gson.toJson(existingDataList);

        // 클라이언트에게 JSON 응답 전송
        response.setContentType("application/json");
        response.getWriter().write(jsonData);

    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        // 리소스 해제
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>
