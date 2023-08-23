<%@page import="utils.JSFunction"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>

<%
if (session.getAttribute("UserId") == null) {
	JSFunction.alertLocation("로그인 후 이용해주세요.", "../06Session/LoginForm.jsp", out);
	
	return;
}
%>    