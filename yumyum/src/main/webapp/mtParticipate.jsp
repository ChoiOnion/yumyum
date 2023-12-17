<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>

<%
    String numParam = request.getParameter("num");

    if (numParam != null) {
        try {
            int num = Integer.parseInt(numParam);

            Connection conn = null;
            PreparedStatement pstmt = null;

            try {
                String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
                String dbID = "root";
                String dbPassword = "Puppy0423!";
                String driverName = "com.mysql.jdbc.Driver";
                Class.forName(driverName);
                conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

                String updateQuery = "UPDATE meeting SET participant = participant + 1 WHERE participant < headcount AND num = ?";
                pstmt = conn.prepareStatement(updateQuery);
                pstmt.setInt(1, num);
                int rowCount = pstmt.executeUpdate();

                if (rowCount > 0) {
                    out.println("참여가 완료되었습니다.");
                } else {
                    out.println("인원이 꽉 차서 참여할 수 없습니다.");
                }
            } catch (Exception e) {
                e.printStackTrace();
            } finally {
                if (pstmt != null) pstmt.close();
                if (conn != null) conn.close();
            }
        } catch (NumberFormatException e) {
            out.println("올바르지 않은 게시글 번호입니다.");
        }
    } else {
        out.println("게시글 번호를 지정해주세요.");
    }
%>
