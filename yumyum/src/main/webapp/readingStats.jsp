<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8" />
    <title>통계</title>
    <link rel="stylesheet" href="main.css">
    <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
  </head>
  <body>
      <% 
    String loggedInUserId = (String) session.getAttribute("id");
    if (loggedInUserId == null) {
        out.println("<script>alert('로그인이 필요합니다.'); location.href='login.jsp';</script>");
        return;
    }
    %>
    <button id="mainButton" style=align:left;>메인</button><br>
    
    <h2>지난 세 달의 읽은 권 수를 알려드려요</h2><br>
    
    <p id="main" style="width: 900px;height:500px; margin: 0 auto;"></p>
    <script>
        var bookCount;

        function loadStats() {
            var xmlhttp = new XMLHttpRequest();
            xmlhttp.onreadystatechange = function() {
                 if (xmlhttp.readyState == 4 && xmlhttp.status == 200) {
                    var responseData = xmlhttp.responseText.split('\n');
                    var oneBookCount = responseData[0];
                    var twoBookCount = responseData[1];
                    var threeBookCount = responseData[2];


                    let myChart = echarts.init(document.getElementById('main'))

                    let option = {
                      
                      legend: {
                        data: ['권'],
                        top: 20,
                      },
                      xAxis: {
                        data: ['저저번달', '저번달', '이번달'],
                      },
                      yAxis: {},
                      series: [
                        {                       
                          type: 'bar',
                          data: [{value: threeBookCount, itemStyle:{color: '#FFCC99'},}, 
                          		{value: twoBookCount, itemStyle:{color: '#FFA64C'},},
                          		{value: oneBookCount, itemStyle:{color: '#FF7E00'},}],                               
                        },
                      ],
                    }

                    myChart.setOption(option)
                }
            };
            
            xmlhttp.open("GET", "getStats.jsp?id=<%=loggedInUserId%>", true);
            xmlhttp.send();
        }

        window.onload = function() {
            loadStats();
            var mainButton = document.getElementById('mainButton');
            if (mainButton) {
                mainButton.addEventListener('click', function() {
                    window.location.href = 'main.jsp';
                });
            }
        };
    </script>
  </body>
</html>
