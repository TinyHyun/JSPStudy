<%@page import="model1.board.BoardDTO"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Map"%>
<%@page import="model1.board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
//DAO객체 생성을 통해 DB에 연결한다.
BoardDAO dao = new BoardDAO(application);

//검색어가 있는 경우 클라이언트가 선택한 필드명과 검색어를 저장할 Map컬렉션을 생성한다.
Map<String, Object> param = new HashMap<String, Object>();

/*
검색 폼에서 입력한 검색어와 필드명을 파라미터로 받아온다.
해당 <form> 태그의 전송방식은 get, action 속성이 없는 상태이므로 현재 페이지로 폼값이 전송된다.
*/
String searchField = request.getParameter("searchField");
String searchWord = request.getParameter("searchWord");

if (searchWord != null) {
	/*
	클라이언트가 입력한 검색어가 있는 경우에만 Map컬렉션에 컬럼명과 검색어를 추가한다
	해당 값은 DB처리를 위한 Model 객체로 전달된다.
	*/
	param.put("searchField", searchField);
	param.put("searchWord", searchWord);
}

//Map컬렉션을 인수로 게시물의 갯수를 카운트한다.
int totalCount = dao.selectCount(param);

//목록에 출력할 게시물을 인출하여 반환받는다.
List<BoardDTO> boardLists = dao.selectList(param);

//모든 인출이 끝나면 DB자원 해제
dao.close();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 공통링크 -->
    <jsp:include page="../Common/Link.jsp" />  

    <h2>목록 보기(List)</h2>
    
    <!-- 검색폼 -->
    <form method="get"> <!-- action속성(폼값이 전송될 위치)이 없으면 현재페이지(자기자신의 페이지)로 간다. -->
	    <table border="1" width="90%">
	    <tr>
	        <td align="center">
	            <select name="searchField"> 
	                <option value="title">제목</option> 
	                <option value="content">내용</option>
	            </select>
	            
	            <input type="text" name="searchWord" />
	            <input type="submit" value="검색하기" />
	        </td>
	    </tr>   
	    </table>
    </form>
    
    <table border="1" width="90%">
        <tr>
            <th width="10%">번호</th>
            <th width="50%">제목</th>
            <th width="15%">작성자</th>
            <th width="10%">조회수</th>
            <th width="15%">작성일</th>
        </tr>
<%
//컬렉션에 입력된 데이터가 없는지 확인한다.
if (boardLists.isEmpty()) {
%>
        <tr>
            <td colspan="5" align="center">등록된 게시물이 없습니다^^*</td>
        </tr>
<%
}
else {
	//출력할 게시물이 있는 경우에는 확장 for문으로 List컬렉션에 저장된 레코드의 갯수만큼 반복하여 출력한다.
	int virtualNum = 0;
	
	for (BoardDTO dto : boardLists) {
		
		//현재 출력할 게시물의 갯수에 따라 번호가 달라지게 되므로 totalCount를 사용하여 가상번호를 부여한다.
		virtualNum = totalCount--;
%>
        <tr align="center">
            <td><%= virtualNum %></td>  
            <td align="left">
            	<a href="View.jsp?num=<%= dto.getNum() %>"><%= dto.getTitle() %></a>
            </td>
            <td align="center"><%= dto.getId() %></td>           
            <td align="center"><%= dto.getVisitcount() %></td>   
            <td align="center"><%= dto.getPostdate() %></td>    
        </tr>
<%
	}
}
%>
    </table>
   
    <table border="1" width="90%">
        <tr align="right">
            <td>
            	<button type="button" onclick="location.href='Write.jsp';">글쓰기</button>
            </td>
        </tr>
    </table>
</body>
</html>