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
        // DB ì°ê²°
        Class.forName(DRIVER);
        con = DriverManager.getConnection(DBURL, DBID, DBPW);

        // URLë¡ë¶í° id íë¼ë¯¸í° ë°ìì¤ê¸°
		    String loggedInUserId = (String) session.getAttribute("id");
    if (loggedInUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        return;
    }

        // SQL ì¿¼ë¦¬
        String sql = "SELECT record.id, book.title, record.startDate, record.endDate FROM record, book WHERE id = ? AND book.bookId = record.bookId";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, loggedInUserId);

        // ì¿¼ë¦¬ ì¤í
        rs = pstmt.executeQuery();

        List<JSONObject> eventsList = new ArrayList<>();

        while (rs.next()) {
        	String id = rs.getString("id");
            String bookId = rs.getString("title");
            Timestamp startDateTimestamp = rs.getTimestamp("startDate");
            Timestamp endDateTimestamp = rs.getTimestamp("endDate");
            
            if(endDateTimestamp!=null){
            	// startDate, endDateë¥¼ Date ê°ì²´ë¡ ë³í
                Date startDate = new Date(startDateTimestamp.getTime()+ (24 * 60 * 60 * 1000));
                Date endDate = new Date(endDateTimestamp.getTime()+ (24 * 60 * 60 * 1000));

                // ë ì§ë¥¼ ISO 8601 íìì¼ë¡ ë³í
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                sdf.setTimeZone(TimeZone.getTimeZone("UTC"));

                // JSON ê°ì²´ ìì±íì¬ ë¦¬ì¤í¸ì ì¶ê°
                JSONObject event = new JSONObject();
                event.put("title", bookId);
                event.put("start", sdf.format(startDate));
                event.put("end", sdf.format(endDate));

                eventsList.add(event);
            }
        }

        // Convert the list to JSON array
        JSONArray jsonArray = new JSONArray();
        jsonArray.addAll(eventsList);

        // Set content type to application/json
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        // JSON arrayë¥¼ ìëµì¼ë¡ ë³´ë´ê¸°
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