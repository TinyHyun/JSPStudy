<%@page import="common.Person"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<%
	//3가지 객체를 request 영역에 저장한다.
	request.setAttribute("personObj", new Person("홍길동", 33));
	request.setAttribute("StringObj", "나는 문자열");
	request.setAttribute("integerObj", new Integer(99));
	%>
	<!--
	액션태그를 통해 포워드한다.
	이때 2개의 정수를 파라미터로 전달한다.
	-->
	<jsp:forward page="ObjectResult.jsp">
		<jsp:param value="10" name="firstNum"/>
		<jsp:param value="20" name="secondNum"/>
	</jsp:forward>
	
	<%
	//d위 액션 태그를 JSP코드로 표현하면 아래와 같이 기술할 수 있다.
	/* request.getRequestDispatcher("ObjectResult.jsp?firstNum=10&secondNum=20").forward(request, response); */
	%>
</body>
</html>