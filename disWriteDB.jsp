<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.concurrent.atomic.AtomicInteger" %>

<%
    String title = request.getParameter("title");
    String text = request.getParameter("text");

    Connection conn = null;
    PreparedStatement pstmt = null;

    try {
        // 자동으로 증가하는 변수를 저장할 AtomicInteger 객체 생성
        AtomicInteger autoIncrement = (AtomicInteger) application.getAttribute("autoIncrement");

        // 만약에 객체가 없다면 초기값으로 설정
        if (autoIncrement == null) {
            autoIncrement = new AtomicInteger(1);
            application.setAttribute("autoIncrement", autoIncrement);
        }

        // 다음 증가된 값을 얻어오고, application에 저장
        int nextValue = autoIncrement.getAndIncrement();
        application.setAttribute("autoIncrement", autoIncrement);

        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
        String dbID = "root";
        String dbPassword = "Puppy0423!";
        String driverName = "com.mysql.jdbc.Driver";
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        String sql = "INSERT INTO discussion (num, title, id, date, text, isDelete) VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, nextValue);
        pstmt.setString(2, title);
        pstmt.setString(3, "han"); 
        pstmt.setString(4, new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
        pstmt.setString(5, text);
        pstmt.setInt(6, 0);
        pstmt.executeUpdate();
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (pstmt != null) pstmt.close();
        if (conn != null) conn.close();
    }
%>

<script>
    alert("글이 작성되었습니다.");
    location.href="discussionBoard.html";
</script>