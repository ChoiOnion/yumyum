<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset='utf-8' />
    <title>캘린더</title>
    <link rel="stylesheet" href="main.css">
    <script src="https://code.jquery.com/jquery-3.6.4.min.js"></script>
    <script src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.8/index.global.min.js'></script>

    <style>
        #calendar {
            width: 80vw;
            height: 80vh;
            margin: 0 auto;
        }
         
    </style>
</head>

<body>
<%
	String loggedInUserId = (String) session.getAttribute("id");
	if (loggedInUserId == null) {
		out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
		return;
	}
%>
    <p id='calendar'></p>
    <button id="mainButton" >메인</button>
    <script>
        
        // window.onload에 함수 참조를 할당
        window.onload = function () {
            loadPosts();
            
            var mainButton = document.getElementById('mainButton');
            if (mainButton) {
                mainButton.addEventListener('click', function() {
                    window.location.href = 'main.jsp';
                });
            }
        };

        $(function () {
            var request = $.ajax({
                url: "getCalendar.jsp?id=<%=loggedInUserId%>", 
                method: "GET",
                dataType: "json"
            });

            request.done(function (data) {
                console.log(data);

                var calendarEl = document.getElementById('calendar');

                var calendar = new FullCalendar.Calendar(calendarEl, {
					eventColor : 'orange', 
                    initialView: 'dayGridMonth',
                    headerToolbar: {
                        left: 'prevYear,prev,next,nextYear',
                        center: 'title',
                        right: 'today dayGridMonth'
                    },
                    events: data,
                    displayEventTime: false
                });

                calendar.render();
            });

            request.fail(function (jqXHR, textStatus) {
                alert("Request failed: " + textStatus);
            });
        });

        function loadPosts() {
			
			
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function () {
                if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                }
            };
            xmlhttp.open("GET", "getCalendar.jsp?id=<%=loggedInUserId%>", true); 
            xmlhttp.send();
        }
    </script>
</body>

</html>