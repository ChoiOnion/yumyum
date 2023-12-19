<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String id = null;
    if (session.getAttribute("id") != null) {
        id = (String) session.getAttribute("id");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>냠냠북클럽</title>
    <style>
    @font-face {
        font-family: 'Cafe24Ssurround';
        src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2105_2@1.0/Cafe24Ssurround.woff') format('woff');
        font-weight: normal;
        font-style: normal;
    }
    body {
        font-family: 'Cafe24Ssurround', serif;
        color: #8B4513; /* Dark warm font color */
    }
    header {
    
        background-color: #F4A460; /* Sandy brown */
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        gap: 4px;
        padding: 5px 0;
    }
    .header-top {
        width: 100%;
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: row;
    }
    .heading {
        font-size: 48px;
        margin: 0;
        color: #6B4423; /* Darker brown */
    }
    header img {
        max-height: 80px;
    }
    .menu {
        max-width: 1200px;
        margin: 20px 0;
        display: flex;
        justify-content: center;
    }
    .menu ul {
        list-style: none;
        padding: 0;
        display: flex;
        justify-content: center;
    }
    .lists li {
        margin-right: 20px;
        color: #8B4513; /* Consistent dark warm font color */
    }
    .lists li:last-child {
        margin-right: 0;
    }
    .lists a {
        font-size: 18px;
        text-decoration: none;
        color: #D2691E; /* Chocolate color */
        transition: color 0.3s ease;
    }
    .lists a:hover {
        color: #DEB887; /* Burlywood color on hover */
    }
    .log {
        font-size: 18px;
        margin-top: 20px;
        align-self: flex-end;
    }
    .dropdown_menu {
        display: none;
        position: absolute;
        background-color: #fb9d7896;  /* Light Salmon color */
        min-width: 160px;
        z-index: 1;
    }
    .dropdown_menu a {
        color: #FFF5EE; /* SeaShell color */
        padding: 12px 16px;
        text-decoration: none;
        display: block;
    }
    .dropdown_main:hover .dropdown_menu {
        display: block;
    }
    </style>
</head>
<body>
<header>
    <div class="header-top">
        <h1 class="heading">냠냠 북클럽</h1>
        <img src="https://github.com/Manmandarin/abc/blob/main/%EB%A1%9C%EA%B3%A0.png?raw=true" alt="냠냠 북클럽 로고">
    </div>

    <div class="menu">
        <ul class="lists">
            <li><a href="main.jsp">도서 검색</a></li>
            <li><a href="discussionBoard.jsp">독서 토론 게시판</a></li>
            <li><a href="meetingBoard.jsp">독서 모임 게시판</a></li>
            <li class="dropdown_main">
                <a href="readingRecords.jsp">독서 기록 페이지</a>
                <div class="dropdown_menu">
                    <a href="readingRecords.jsp">독서 목록</a>
                    <a href="readingReview.jsp">별점 및 서평</a>
                    <a href="readingCalendar.jsp">캘린더</a>
                    <a href="readingStats.jsp">통계</a>
                </div>
            </li>
        </ul>
    </div>
    <div class="log">
        <% if (id != null) { %>
        <a href="logoutAction.jsp">Log Out</a>
        <% } %>
    </div>
</header>
</body>
</html>
