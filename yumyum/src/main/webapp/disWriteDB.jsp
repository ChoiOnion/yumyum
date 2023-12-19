<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Date"%>
<%@ page import="java.util.concurrent.atomic.AtomicInteger" %>
<%request.setCharacterEncoding("UTF-8");%>
<%
    String title = request.getParameter("title");
    String text = request.getParameter("text");
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    String loggedInUserId = (String) session.getAttribute("id");
    if (loggedInUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        return;
    }

    try {
        // 자동으로 증가하는 변수를 저장할 AtomicInteger 객체 생성(글 번호)
        AtomicInteger autoIncrement1 = (AtomicInteger) application.getAttribute("autoIncrement");

        if (autoIncrement1 == null) {
        	autoIncrement1 = new AtomicInteger(0);
            application.setAttribute("autoIncrement", autoIncrement1);
        }

        int nextValue = autoIncrement1.getAndIncrement();
        application.setAttribute("autoIncrement", autoIncrement1);

        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
        String dbID = "root";
        String dbPassword = "1234";
        String driverName = "com.mysql.jdbc.Driver";
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        String sql = "INSERT INTO discussion (num, title, id, date, text, isDelete) VALUES (?, ?, ?, ?, ?, ?)";
        pstmt = conn.prepareStatement(sql);
        pstmt.setInt(1, nextValue);
        pstmt.setString(2, title);
        pstmt.setString(3, loggedInUserId); 
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
    location.href="discussionBoard.jsp";
</script>