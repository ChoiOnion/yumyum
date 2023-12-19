<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<%request.setCharacterEncoding("UTF-8");%>
<%
    String numParam = request.getParameter("num");
String loggedInUserId = (String) session.getAttribute("id");
if (loggedInUserId == null) {
out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
return;
}

if (numParam != null) {
    try {
        int num = Integer.parseInt(numParam);

        Connection conn = null;
        PreparedStatement pstmtParticipantCheck = null;
        PreparedStatement pstmtMeeting = null;
        PreparedStatement pstmtParticipantInsert = null;

        try {
            String dbURL = "jdbc:mysql://localhost:3306/nyamnyam";
            String dbID = "root";
            String dbPassword = "1234";
            String driverName = "com.mysql.jdbc.Driver";
            Class.forName(driverName);
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

            //id 유니크 체크
            String checkParticipantQuery = "SELECT id FROM participant WHERE num = ? AND id = ?";
            pstmtParticipantCheck = conn.prepareStatement(checkParticipantQuery);
            pstmtParticipantCheck.setInt(1, num);
            pstmtParticipantCheck.setString(2, loggedInUserId);
            ResultSet rs = pstmtParticipantCheck.executeQuery();

            if (rs.next()) {
                out.println("이미 참여한 모임입니다.");
            } else {
                //참여자 수 업데이트
                String updateMeetingQuery = "UPDATE meeting SET participant = participant + 1 WHERE participant < headcount AND num = ?";
                pstmtMeeting = conn.prepareStatement(updateMeetingQuery);
                pstmtMeeting.setInt(1, num);
                int rowCountMeeting = pstmtMeeting.executeUpdate();

                if (rowCountMeeting > 0) {
                    //참여 테이블에 참여 정보 추가
                    String insertParticipantQuery = "INSERT INTO participant (num, id) VALUES (?, ?)";
                    pstmtParticipantInsert = conn.prepareStatement(insertParticipantQuery);
                    pstmtParticipantInsert.setInt(1, num);
                    pstmtParticipantInsert.setString(2, loggedInUserId); 
                    pstmtParticipantInsert.executeUpdate();
                    out.println("참여가 완료되었습니다.");
                } else {
                    out.println("인원이 꽉 차서 참여할 수 없습니다.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (pstmtParticipantCheck != null) pstmtParticipantCheck.close();
            if (pstmtMeeting != null) pstmtMeeting.close();
            if (pstmtParticipantInsert != null) pstmtParticipantInsert.close();
            if (conn != null) conn.close();
        }
    } catch (NumberFormatException e) {
        out.println("올바르지 않은 게시글 번호입니다.");
    }
} else {
    out.println("게시글 번호를 지정해주세요.");
}
%>