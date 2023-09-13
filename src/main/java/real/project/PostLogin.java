package real.project;

import java.io.IOException;
import java.io.PrintWriter;

import org.json.simple.JSONObject;

import jakarta.servlet.ServletContext;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import membership.MemberDAO;
import membership.MemberDTO;

//로그인 페이지에서 폼값이 전송될때의 요청명 매핑
@WebServlet("/realproject/PostLogin.do")
public class PostLogin extends HttpServlet {

	private static final long serialVersionUID = 1L;

	//로그인은 post 방식을 사용하므로 doPost() 오버라이딩
	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) 
			throws ServletException, IOException {
		
		//폼값 받기
		String id = req.getParameter("user_id");
		String pw = req.getParameter("user_pw");
		
		//서블릿이 직접 요청을 받으므로 application 내장객체는 아래 메서드를 통해 얻어와야 한다.
		ServletContext application = this.getServletContext();
		//DAO객체 생성 및 회원인증
		MemberDAO dao = new MemberDAO(application);
		MemberDTO dto = dao.getMemberDTO(id, pw);
		/*
		Java에서 JSON 데이터를 생성하기 위한 확장 라이브러리 json-simple.jar를 프로젝트에 설치한 후 아래 객체를 생성
		JSON은 객체와 배열로 구분되는 객체인 경우 JSONObject 객체를 사용하고 배열의 경우 JSONArray 객체를 사용한다.
		*/
		JSONObject json = new JSONObject();
		
		//회원인증에 성공한 경우에는 성공메세지를 JSON으로 생성한다.
		if (dto.getName() != null) {
			//JSON 객체는 Map 컬렉션과 사용법이 동일하다.
			json.put("result", 1);
			json.put("message", dto.getName() + "님, 로그인 성공입니다.");
			
			//JSON 객체에 저장할 값은 아래와 같이 HTML 태그도 가능하다.
			String html = "";
				html += "<table class='table table-bordered' style='width:300px;'>";
				html += "  <tr>";
				html += "    <td>" + dto.getName() + " 회원님, 반갑습니다.</td>";
				html += "  </tr>";
				html +="</table>";
				
				json.put("html", html);
		}
		else {
			//회원인증에 실패한 경우
			json.put("result", 0);
			json.put("message", "로그인 실패입니다.");
		}
		
		dao.close();
		
		//앞에서 생성한 JSON 객체를 String으로 변환
		String jsonStr = json.toJSONString();
		//서블릿에서 JSON을 직접 출력하기 위해 컨텐츠 타입을 설정
		resp.setContentType("text/html;charset=UTF-8");
		PrintWriter writer = resp.getWriter();
		
		//JSON을 출력
		writer.println(jsonStr);
		writer.close();
	}
}























