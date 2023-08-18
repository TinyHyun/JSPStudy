<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<html>
<head><title>내장 객체 - request</title></head>
<body>
<%
request.setCharacterEncoding("UTF-8"); // => post방식으로 전송된 한글이 깨지는 현상을 해결한다.

/*
getParameter()
: input태그의 text, radio 타입처럼 하나의 값이 전송되는 경우에 사용한다.
 입력값이 문자, 숫자에 상관없이 String타입으로 저장된다.

getParameterValues()
: checkbox 혹은 <select> 태그의 multiple 속성을 부여하여 2개 이상의 값이 전송되는 경우에 사용한다.
 받은 값은 String 타입의 배열로 저장된다.
*/
String id = request.getParameter("id");
String sex = request.getParameter("sex");
//관심사항은 checkbox이므로 2개 이상 선택이 가능하다. 따라서 배열로 폼값을 받는다.
String[] favo = request.getParameterValues("favo");
String favoStr = "";

if (favo != null) {
	//배열은 크기가 있으므로 length를 통해 아래와 같이 반복할 수 있다.
	for (int i=0 ; i<favo.length ; i++) { //체크박스는 체크한 것만 서버로 전송된다.
		favoStr += favo[i] + " "; 
	}
}

/*
<textarea> 태그는 2줄 이상 입력가능하므로 엔터를 추가하는 경우 \r\n으로 저장된다.
따라서 웹브라우저에 출력할때에는 <br>태그로 변경해야한다.
*/
String intro = request.getParameter("intro").replace("\r\n", "<br>");
%>
<ul>
	<li>아이디: <%= id %></li>
	<li>성별: <%= sex %></li>
	<li>관심사항: <%= favoStr %></li>
	<li>자기소개: <%= intro %></li>
</ul>
</body>
</html>