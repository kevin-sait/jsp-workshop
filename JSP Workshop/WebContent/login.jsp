<!--****************************************************
Application Name: Travel Expert Information System (Web)
                  (Threaded Project phase 3)
Module Name: login.jsp
Purpose of this module: 
 - provides login function
 - save and display cookies
Author : Ryuji Sasaki                            
Create Date: 14/04/2014
****************************************************-->

<jsp:include page="header.jsp" />
<h1>Login</h1>

<%-- <%@page import="login.LoginBean"%> --%>
<%@ page import="java.io.*" %>
<jsp:useBean id="loginbean" class="Login.LoginBean"></jsp:useBean>

<%!
	// private valiables
	private String message = "";
    private String userid,password;
    
    /**
     * printForm
     */
    private void printForm(JspWriter out, String userid) throws IOException
    {
    	// if err msg exist
    	if ((!message.equals(null)) && (!message.equals("")))
    	{
    		out.print("<div class='message failed'>" + message + "</div>");
    	}
    	
    	out.print("<form>");
    	out.print("<table>");
    	out.print("<tr><td>Userid:</td><td><input type='text' name='userid'  value='" + userid + "' /></td></tr>");
    	out.print("<tr><td>Password:</td><td><input type='password' name='password' /></td></tr>");
    	out.print("<tr><td></td><td><input type='submit' value='Log in' /></td></tr>");
    	out.print("</table>");
    	out.print("<form>");
    }
%>
<%
	message = "";
	// after submit
	if (request.getParameter("userid") != null)
	{
		userid = request.getParameter("userid");
		password = request.getParameter("password");

		// mandatory check
		if (userid.equals("") || password.equals("")){
			message = "UserID or Password does not have a value.";
		
		} else {
			// call login verify function
			message = loginbean.verifyLogin(userid,password,session);	
		}
	}

	// If cookie exist, get it
	String cookieNm_userid = "userid";
	Cookie cookies [] = request.getCookies ();
	Cookie myUserIdCookie = null;
	if (cookies != null){
		for (int i = 0; i < cookies.length; i++) {
			if (cookies [i].getName().equals (cookieNm_userid)){
				// User ID Cookie
				myUserIdCookie = cookies[i];				
			}
		}
	}
	
%>
    
<%
	// logout
	if (request.getParameter("logout") != null)
	{
		loginbean.logout(session);
		response.sendRedirect("index.jsp");
	}

	// initial page load
	else if (request.getParameter("userid") == null)
	{
		// get userid strings from cookie object
		String myUserId = "";
		if(myUserIdCookie != null){
			myUserId = myUserIdCookie.getValue();
		}

		printForm(out, myUserId);
	} 

	// page load after submit
	else
	{
		// Login Ok
		if (message.equals(""))
		{
			// Set cookies				
			Cookie ckUserId = new Cookie ("userid",request.getParameter("userid"));
			ckUserId.setMaxAge(365 * 24 * 60 * 60);
			response.addCookie(ckUserId);

			// move to next page
			response.sendRedirect("account.jsp");
			
		// Login Fail
		} else {
			printForm(out, "");
		}
	}
%>

<jsp:include page="footer.jsp" />

