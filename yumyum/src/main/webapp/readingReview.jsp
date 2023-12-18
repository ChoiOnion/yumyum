<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*"%>
<% request.setCharacterEncoding("UTF-8"); %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>서평 목록</title>
    <style>
        #reviewsContainer {
            display: flex;
            align-items: flex-start;
        }
        #reviewsList {
            flex: 1;
            margin-right: 20px;
            background-color: #f0f0f0; /* 왼쪽 박스 배경색 */
            padding: 20px; /* 내용과의 간격을 위한 패딩 */
        }
        #reviewDetails {
            flex: 1;
            background-color: #e0e0e0; /* 오른쪽 박스 배경색 */
            padding: 20px; /* 내용과의 간격을 위한 패딩 */
        }
        .review {
            cursor: pointer;
            margin-bottom: 20px;
        }
    </style>
<script>

	// URL 파라미터 값을 가져오는 함수
	function getParameterByName(name, url) {
  		if (!url) url = window.location.href;
  		name = name.replace(/[\[\]]/g, "\\$&");
  		var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
      		results = regex.exec(url);
  		if (!results) return null;
  		if (!results[2]) return '';
  		return decodeURIComponent(results[2].replace(/\+/g, " "));
	}
	
	window.onload = function() {       
        // 수정된 부분: 버튼 클릭 시 메인 페이지로 이동하도록 처리
        var mainButton = document.getElementById('mainButton');
        if (mainButton) {
            mainButton.addEventListener('click', function() {
                var idParam = getParameterByName('id');
                window.location.href = 'main.jsp?id=' + idParam;
            });
        }
    };
	
    function confirmDelete(bookId) {
        var confirmed = confirm("이 서평을 삭제하시겠습니까?");
        if (confirmed) {
            window.location.href = "deleteReview.jsp?bookId=" + bookId;
        }
    }

    function showReviewDetails(review) {
        var reviewDetailsDiv = document.getElementById('reviewDetails');
        if (review) {
            reviewDetailsDiv.innerHTML = "<h2>서평 상세 내용</h2>" + review + "<br><button onclick='closeReviewDetails()'>닫기</button>";
        } else {
            reviewDetailsDiv.innerHTML = "<h2>서평 상세 내용</h2>"; 
        }
    }

    function closeReviewDetails() {
        var reviewDetailsDiv = document.getElementById('reviewDetails');
        reviewDetailsDiv.innerHTML = "<h2>서평 상세 내용</h2>"; 
    }
</script>
</head>
<body>
	<button id="mainButton">메인</button><br>
    <%
    String loggedInUserId = (String) session.getAttribute("id");
    if (loggedInUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        return;
    }

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        String dbURL = "jdbc:mysql://localhost:3306/nyamnyam?useUnicode=true&characterEncoding=UTF-8";
        String dbID = "root";
        String dbPassword = "1234";
        String driverName = "com.mysql.jdbc.Driver";
        Class.forName(driverName);
        conn = DriverManager.getConnection(dbURL, dbID, dbPassword);

        String sql = "SELECT r.bookId, b.title, r.review, r.starScore FROM record r JOIN book b ON r.bookId = b.bookId WHERE r.id = ? AND r.review IS NOT NULL";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, loggedInUserId);
        rs = pstmt.executeQuery();

        out.println("<div id='reviewsContainer'>");
        out.println("<div id='reviewsList'>");
        out.println("<h1>내 서평 목록</h1>");
        while (rs.next()) {
            String bookId = rs.getString("bookId");
            String title = rs.getString("title");
            String review = rs.getString("review");
            float starScore = rs.getFloat("starScore");

            String displayReview = review.length() > 10 ? review.substring(0, 10) + "...더보기" : review;

            out.println("<div class='review' onclick='showReviewDetails(\"" + review.replaceAll("\"", "&quot;") + "\");'>");
            out.println("<h3>" + title + "</h3>");
            out.println("<p>별점: " + starScore + "/5</p>");
            out.println("<p>서평: " + displayReview + "</p>");
            out.println("<a href='editReview.jsp?bookId=" + bookId + "'>수정</a> | ");
            out.println("<a href='#' onclick='event.stopPropagation(); confirmDelete(\"" + bookId + "\");'>삭제</a>");
            out.println("</div>");
        }
        out.println("</div>");

        out.println("<div id='reviewDetails'><h2>서평 상세 내용</h2></div>");
        out.println("</div>");
    } catch(Exception e) {
        out.println("<p>오류가 발생했습니다: " + e.getMessage() + "</p>");
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
    %>
</body>
</html>
