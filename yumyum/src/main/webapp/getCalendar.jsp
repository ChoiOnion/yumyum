<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.sql.Date" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="org.json.simple.JSONArray" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.json.simple.JSONObject" %>
<% request.setCharacterEncoding("UTF-8"); %>

<%
    String DRIVER = "com.mysql.jdbc.Driver";
    String DBURL = "jdbc:mysql://localhost:3306/nyamnyam";
    String DBID = "root";
    String DBPW = "1234";

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        // DB 연결
        Class.forName(DRIVER);
        con = DriverManager.getConnection(DBURL, DBID, DBPW);

        // URL로부터 id 파라미터 받아오기
        String idParam = request.getParameter("id");

        // SQL 쿼리
        String sql = "SELECT record.id, book.title, record.startDate, record.endDate FROM record, book WHERE id = ? AND book.bookId = record.bookId";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, idParam);

        // 쿼리 실행
        rs = pstmt.executeQuery();

        List<JSONObject> eventsList = new ArrayList<>();

        while (rs.next()) {
        	String id = rs.getString("id");
            String bookId = rs.getString("title");
            Timestamp startDateTimestamp = rs.getTimestamp("startDate");
            Timestamp endDateTimestamp = rs.getTimestamp("endDate");

            // startDate, endDate를 Date 객체로 변환
            Date startDate = new Date(startDateTimestamp.getTime()+ (24 * 60 * 60 * 1000));
            Date endDate = new Date(endDateTimestamp.getTime()+ (24 * 60 * 60 * 1000));

            // 날짜를 ISO 8601 형식으로 변환
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
            sdf.setTimeZone(TimeZone.getTimeZone("UTC"));

            // JSON 객체 생성하여 리스트에 추가
            JSONObject event = new JSONObject();
            event.put("title", bookId);
            event.put("start", sdf.format(startDate));
            event.put("end", sdf.format(endDate));

            eventsList.add(event);
        }

        // Convert the list to JSON array
        JSONArray jsonArray = new JSONArray();
        jsonArray.addAll(eventsList);

        // Set content type to application/json
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // JSON array를 응답으로 보내기
        out.print(jsonArray.toJSONString());

    } catch (ClassNotFoundException | SQLException e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
            if (con != null) con.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>