<jsp:include page="header.jsp" />
<h1>Login</h1>

<%-- <%@page import="login.LoginBean"%> --%>
<%@ page import="java.io.*" %>
<jsp:useBean id="loginbean" class="Login.LoginBean"></jsp:useBean>

<%!
	private String message = "";
    private String userid,password;
    
    private void printForm(JspWriter out) throws IOException
    {
    	
    	if (!message.equals(null))
    	{
    		out.print("<div class='message failed'>" + message + "</div>");
    		
    	}
    	
    	out.print("<form>");
    	out.print("<table>");
    	out.print("<tr><td>Userid:</td><td><input type='text' name='userid' /></td></tr>");
    	out.print("<tr><td>Password:</td><td><input type='password' name='password' /></td></tr>");
    	out.print("<tr><td></td><td><input type='submit' value='Log in' /></td></tr>");
    	out.print("</table>");
    	out.print("<form>");
   	
    }
    
%>
<%
	message = "";
	if (request.getParameter("userid") != null)
	{
		userid = request.getParameter("userid");
		password = request.getParameter("password");
		if (userid.equals("") || password.equals("")){
			message = "UserID or Password does not have a value.";
		
		}
		else
		{
			message = loginbean.verifyLogin(userid,password,session);	
		}
	}
%>
    
<%
	if (request.getParameter("logout") != null)
	{
		loginbean.logout(session);
		response.sendRedirect("index.jsp");
	}
	else if (request.getParameter("userid") == null)
	{
		printForm(out);
	} 
	else
	{
		if (message.equals(""))
		{
			//String jspname = (String)session.getAttribute("jspname");
			response.sendRedirect("account.jsp");
		} else {
			printForm(out);
		}
	}
%>

<jsp:include page="footer.jsp" />

