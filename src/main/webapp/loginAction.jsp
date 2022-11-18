<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "vo.*"%>
<%@ page import = "java.sql.*"%>
<%@ page import="java.net.URLEncoder" %>
<%
	// 1) controller
	// session 유효성 검증 코드 후 필요하다면 redirect!
	if(session.getAttribute("loginEmp") != null){
		// 로그인이 된 상태
		response.sendRedirect(request.getContextPath()+"/empList.jsp");
		return;
	}
	// request 유효성 검증
	request.setCharacterEncoding("UTF-8");
	
	int empNo = Integer.parseInt(request.getParameter("empNo"));
	String firstName = request.getParameter("firstName");
	String lastName = request.getParameter("lastName");
	
	// VO setter 호출
	Employee employee = new Employee();
	employee.setEmpNo(empNo);
	employee.setFirstName(firstName);
	employee.setLastName(lastName);
	
	// 2) model
	String driver	= "org.mariadb.jdbc.Driver";
	String dbUrl	= "jdbc:mariadb://localhost:3306/employees";
	String dbUser	= "root";
	String dbPw		= "java1234";
	
	Class.forName(driver); // 외부 드라이브 로딩
	Connection conn = DriverManager.getConnection(dbUrl, dbUser, dbPw);
	/*
		SELECT emp_no empNo, last_name lastName
		FROM employee
		WHERE emp_no =? AND first_name =? AND last_name=?
	*/
	String sql = "SELECT emp_no empNo, birth_date birthDate, first_name firstName, last_name lastName, gender, hire_date hireDate FROM employees WHERE emp_no =? AND first_name =? AND last_name=?";
	PreparedStatement stmt = conn.prepareStatement(sql);
	// getter 사용
	stmt.setInt(1, employee.getEmpNo());
	stmt.setString(2, employee.getFirstName());
	stmt.setString(3, employee.getLastName());
	
	ResultSet rs = stmt.executeQuery();
	
	String targetUrl = "/loginForm.jsp";
	
	if(rs.next()) {
		// 로그인 성공
		System.out.println("success");
		Employee loginEmp = new Employee();
		loginEmp.setEmpNo(rs.getInt("empNo"));
		loginEmp.setBirthDate(rs.getString("birthDate"));
		loginEmp.setFirstName(rs.getString("firstName"));
		loginEmp.setLastName(rs.getString("lastName"));
		loginEmp.setGender(rs.getString("gender"));
		loginEmp.setHireDate(rs.getString("hireDate"));
		// 로그인 성공했다는 값을 저장 -> session
		session.setAttribute("loginEmp", loginEmp); // 키 : "loginEmp", 값 : Object object = loginEmp; 
		targetUrl = "/empList.jsp";
	}
	rs.close();
	stmt.close();
	conn.close();
	response.sendRedirect(request.getContextPath()+targetUrl);
	// 3) view
%>