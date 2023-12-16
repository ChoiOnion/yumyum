<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String userId = null;
    if (session.getAttribute("userId") != null) {
        userId = (String) session.getAttribute("userId");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>냠냠북클럽</title>
    <style>
        /* 헤더 스타일 */
        header {
            background-color: #ff916f92; /* 배경색 */
            padding: 10px 0; /* 위아래 여백 */
            box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1); /* 그림자 효과 */
            display: flex;
            flex-direction: column; /* 세로 정렬을 위해 컬럼 방향으로 설정 */
            align-items: center; /* 가운데 정렬 */
        }

        .menu {
            max-width: 1200px; /* 최대 너비 설정 */
            margin: 20px 0; /* 위아래 여백 */
        }

        .menu ul {
            list-style: none; /* 리스트 스타일 제거 */
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center; /* 가운데 정렬 */
        }

        .lists li {
            margin-right: 20px; /* 리스트 아이템 간 여백 */
        }

        .lists li:last-child {
            margin-right: 0; /* 마지막 아이템의 여백 제거 */
        }

        .lists a {
            font-size: 18px; /* 메뉴 폰트 크기 */
            text-decoration: none; /* 밑줄 제거 */
            color: #d67d55; /* 글자색 */
            transition: color 0.3s ease; /* 색상 전환 애니메이션 */
        }

        .lists a:hover {
            color: #ff5722; /* 호버 시 색상 변경 */
        }

        .log {
            font-size: 18px; /* 로그인/로그아웃 폰트 크기 */
            margin-top: 20px; /* 위 여백 추가 */
            align-self: flex-end; /* 오른쪽 정렬 */
        }
        
        /* 드롭다운 메뉴 스타일 */
        .dropdown_menu {
            display: none;
            position: absolute;
            background-color: #ff916f92; /* 배경색 변경 */
            min-width: 160px;
            z-index: 1;
        }

        .dropdown_menu a {
            color: white;
            padding: 12px 16px;
            text-decoration: none;
            display: block;
        }

        /* 마우스 갖다대면 하위 메뉴 표시 */
        .dropdown_main:hover .dropdown_menu {
            display: block;
        }
    </style>
</head>
<body>
<header>
    <h1 class="h1">냠냠북클럽</h1>
    <div class="menu">
        <ul class="lists">
            <li><a href="main.jsp">도서 검색</a></li>
            <li><a href="discussionBoard.html">독서 토론 게시판</a></li>
            <li><a href="bookClubBoard.html">독서 모임 게시판</a></li>
            <li class="dropdown_main">
                <a href="readingRecords.html">독서 기록 페이지</a>
                <div class="dropdown_menu">
                    <a href="readingList.html">목록</a>
                    <a href="recordReading.html">기록</a>
                    <a href="readingCalendar.html">캘린더</a>
                    <a href="readingStats.html">통계</a>
                </div>
            </li>
        </ul>
    </div>
    <div class="log">
        <% if (userId != null) { %>
        <a href="logoutAction.jsp">Log Out</a>
        <% } %>
    </div>
</header>
</body>
</html>
