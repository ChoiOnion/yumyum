<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@page import="java.io.PrintWriter"%>    
<%@ page import="user.User"%>
<%@ page import="user.UserDAO"%>
<% request.setCharacterEncoding("UTF-8");%>

<jsp:useBean id="user" class="user.User" scope="page"></jsp:useBean>
<jsp:setProperty property="id" name="user"/>
<jsp:setProperty property="pwd" name="user"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    
    <title>도서 검색</title>
</head>
<body>
    <% 
        String id = null;
        if(session.getAttribute("id") != null){
            id = (String) session.getAttribute("id");
        }
        
        if(id != null){
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('이미 로그인이 되어있습니다')");
            script.println("location.href='main.jsp'");
            script.println("</script>");
        }
    
        UserDAO userDAO = new UserDAO();
        int result = userDAO.login(user.getId(), user.getPwd());
        
        if(result == 1){
            session.setAttribute("id", user.getId());
            id = user.getId();
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('로그인이 완료되었습니다.')");
            script.println("location.href='main.jsp?id="+id+"'");
            script.println("</script>");
        }
        else if(result == 0){
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('비밀번호가 틀립니다.')");
            script.println("history.back()");
            script.println("</script>");
        }
        else if(result == -1){
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('존재하지 않는 아이디입니다.')");
            script.println("history.back()");
            script.println("</script>");
        }
        else if(result == -2){
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('DB 오류가 발생했습니다')");
            script.println("history.back()");
            script.println("</script>");
        }
    %>
</body>
</html>
