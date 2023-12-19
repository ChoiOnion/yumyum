<%@page import="java.io.Console"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@page import="java.io.PrintWriter"%>    
<%@ page import="user.User"%>
<%@ page import="user.UserDAO"%>
<% request.setCharacterEncoding("UTF-8");%>

<jsp:useBean id="user" class="user.User" scope="page"></jsp:useBean>
<jsp:setProperty property="id" name="user"/>
<jsp:setProperty property="pwd" name="user"/>
<jsp:setProperty property="name" name="user"/>
<jsp:setProperty property="mail" name="user"/>
<jsp:setProperty property="phoneNum" name="user"/>
<jsp:setProperty property="gender" name="user"/>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>yumyum</title>

</head>
<body>
    <% 
        if(user.getId() == null || user.getPwd() == null || user.getName() == null || user.getMail() == null || user.getGender() == null || user.getPhoneNum() == null){
            PrintWriter script = response.getWriter();
            script.println("<script>");
            script.println("alert('입력이 안 된 사항이 있습니다.')");
            script.println("history.back()");
            script.println("</script>");
        } else {
            UserDAO userDAO = new UserDAO();
            int result = userDAO.join(user);
            if(result == -1){
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('이미 존재하는 아이디입니다.')");
                script.println("history.back()");
                script.println("</script>");
            } else if(result == -2){
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('DB오류가 발생했습니다')");
                script.println("history.back()");
                script.println("</script>");
            } else {
                session.setAttribute("id", user.getId());
                String id = user.getId();
                PrintWriter script = response.getWriter();
                script.println("<script>");
                script.println("alert('회원가입이 완료되었습니다.')");
                script.println("location.href='main.jsp'");
                script.println("</script>");
            }
        }
    %>

</body>
</html>
