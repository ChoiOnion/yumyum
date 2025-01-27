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
        Class.forName(DRIVER);
        con = DriverManager.getConnection(DBURL, DBID, DBPW);

		String loggedInUserId = (String) session.getAttribute("id");
    	if (loggedInUserId == null) {
        	out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        	return;
    }

        String sql = "SELECT record.id, book.title, record.startDate, record.endDate FROM record, book WHERE id = ? AND book.bookId = record.bookId";
        pstmt = con.prepareStatement(sql);
        pstmt.setString(1, loggedInUserId);

        //
        rs = pstmt.executeQuery();

        List<JSONObject> eventsList = new ArrayList<>();

        while (rs.next()) {
        	String id = rs.getString("id");
            String bookId = rs.getString("title");
            Timestamp startDateTimestamp = rs.getTimestamp("startDate");
            Timestamp endDateTimestamp = rs.getTimestamp("endDate");
            
            if(endDateTimestamp!=null){
            	// 
                Date startDate = new Date(startDateTimestamp.getTime()+ (24 * 60 * 60 * 1000));
                Date endDate = new Date(endDateTimestamp.getTime()+ (24 * 60 * 60 * 1000));

                // 
                SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
                sdf.setTimeZone(TimeZone.getTimeZone("UTC"));

                // 
                JSONObject event = new JSONObject();
                event.put("title", bookId);
                event.put("start", sdf.format(startDate));
                event.put("end", sdf.format(endDate));

                eventsList.add(event);
            }
        }


        JSONArray jsonArray = new JSONArray();
        jsonArray.addAll(eventsList);


        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");


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