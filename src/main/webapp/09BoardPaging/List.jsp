<%@page import="utils.BoardPage"%>
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

int totalCount = dao.selectCount(param); //게시물 수 확인

///////////////////////////////////////////////////////////////////////////////////////////////////////////

/* #paging 관련 코드 추가 start# */

/*
web.xml에 설정한 컨텍스트 초기화 파라미터를 읽어온다.
초기화 파라미터는 String으로 저장되므로 산술연산을 위해 int형으로 변환해야한다.
*/
int pageSize = Integer.parseInt(application.getInitParameter("POSTS_PER_PAGE"));
int blockPage = Integer.parseInt(application.getInitParameter("PAGES_PER_BLOCK"));

/*
전체 페이지수를 계산한다.
(전체 게시물의 갯수 / 페이지당 출력 할 게시물의 갯수) => 결과값의 올림처리(ceil)
가령 게시물의 갯수가 51개라면 나눴을 때 결과가 5.1이 된다.
이때 무조건 올림처리하면 6페이지로 설정하게 된다.
만약 totalCount를 double형으로 변환하지 않으면 정수의 결과가 나오게 되므로 5페이지가 된다.
이 부분을 주의해야한다.
*/
int totalPage = (int)Math.ceil((double)totalCount / pageSize);

/*
목록에 처음 진입했을 때는 페이지 관련 파라미터가 없는 상태이므로 무조건 1page로 지정한다.
만약 파라미터 pageNum이 있다면 request 내장객체를 통해 받아온 후 페이지 번호로 지정한다.

List.jsp => 이와 같이 파라미터가 없는 상태일때는 null
List.jsp?pageNum= => 이와 같이 파라미터는 있는 값이 없을 때는 빈값으로 체크된다.
					 따라서 아래 if문은 2개의 조건으로 구성해야한다.
*/
int pageNum = 1;
String pageTemp = request.getParameter("pageNum");
if (pageTemp != null && !pageTemp.equals("")) {
	pageNum = Integer.parseInt(pageTemp);
}

/*
게시물의 구간을 계산한다.
각 페이지의 시작번호와 종료번호를 현재 페이지 번호와 페이지 사이즈를 통해 계산한 후
DAO로 전달하기 위해 Map컬렉션에 추가한다.
*/
int start = (pageNum - 1) * pageSize + 1;
int end = pageNum * pageSize;
param.put("start", start);
param.put("end", end);

/* #paging 관련 코드 추가 end# */

///////////////////////////////////////////////////////////////////////////////////////////////////////////

List<BoardDTO> boardLists = dao.selectListPage(param); //게시물 목록 받기

dao.close(); //DB 닫기
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<!-- 공통링크 -->
    <jsp:include page="../Common/Link.jsp" />  <!-- 공통 링크 -->

    <h2>목록 보기(List) - 현재 페이지: <%= pageNum %> (전체: <%= totalPage %>)</h2>
    
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
	int countNum = 0;
	
	for (BoardDTO dto : boardLists) {
		
		//현재 출력할 게시물의 갯수에 따라 번호가 달라지게 되므로 totalCount를 사용하여 가상번호를 부여한다.
		//virtualNum = totalCount--; //전체 게시물 수에서 시작해 1씩감소
		
		virtualNum = totalCount - (((pageNum - 1) * pageSize) + countNum++);
%>
        <tr align="center">
            <td><%= virtualNum %></td>  <!-- 게시물 번호 -->
            <td align="left"> <!-- 제목(+ 하이퍼링크) -->
            	<a href="View.jsp?num=<%= dto.getNum() %>"><%= dto.getTitle() %></a>
            </td>
            <td align="center"><%= dto.getId() %></td>          <!-- 작성자 아이디 --> 
            <td align="center"><%= dto.getVisitcount() %></td>  <!-- 조회수 -->
            <td align="center"><%= dto.getPostdate() %></td>    <!-- 작성일 -->
        </tr>
<%
	}
}
%>
    </table>
   
   	<!-- 목록 하단의 글쓰기 버튼-->
    <table border="1" width="90%">
        <tr align="center">
        	<!-- 페이징 처리 -->
        	<td>
        		<%--= BoardPage.pagingStr(totalCount, pageSize, blockPage, pageNum, request.getRequestURI()) --%>
        		<%= BoardPage.pagingImg(totalCount, pageSize, blockPage, pageNum, request.getRequestURI()) %>
        	</td>
        	
        	<!-- 글쓰기 버튼 -->
            <td>
            	<button type="button" onclick="location.href='Write.jsp';">글쓰기</button>
            </td>
        </tr>
    </table>
</body>
</html>