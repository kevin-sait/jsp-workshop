<!-- Author: Porkodi Thiagarajan
WorkShop:CPRG220  JSP/Servlets
Created Date: April- 06-2014
Updated Date: April-14-14
Version: 1.2
Description: This is a Jsp/Servlet form, Can be used by customer to view and update their information -->  

<%@page   import="java.util.regex.*" %>

<%	
	if (session.getAttribute("loggedin") == null)
	{
		response.sendRedirect("login.jsp");
	}
%>

<jsp:include page="header.jsp" />
<h1>My Account</h1> 
   
<%!
   Connection con;
   Statement stmt;
   String updateQuery; 

   String errorMsg     ="";
   boolean validData = true;
	  
   String customerid   ="";
   String custFname    ="";
   String custLaname   ="";
   String custAddress  ="";
   String custCity     ="";
   String custProv     ="";
   String custPostal   ="";
   String custCountry  ="";
   String custHomePhone="";
   String custBusPhone ="";
   String custEmail    ="";
%>
   
<%@page   import="java.io.IOException"%>
<%@page   import="java.io.PrintWriter"%>
<%@page   import="java.io.*"%>
<%@page   import="java.sql.*" %>

<%   
	 String EMAIL_PATTERN = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@"
												+ "[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$";
	/* Get the customer id */
	String customerid = (String)session.getAttribute("CustID");

	/* Connecting to the database   */  
	try
	{
		Class.forName("com.mysql.jdbc.Driver");
		con = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ictoosd", "ictoosd");
		stmt = con.createStatement();
		
	} catch (SQLException e) {
		e.printStackTrace();
	} catch (ClassNotFoundException e) {
		e.printStackTrace();
	}
%>

<%
	/* Handle update requests */
	if (request.getParameter("update") != null)
	{
		
	   errorMsg     ="";
	   validData = true;
	   
		/* get the parameters being display  when  update button is clicked */
	      
		customerid = request.getParameter("customerid1");
		custFname    =request.getParameter("custFname").trim();
		custLaname   =request.getParameter("custLaname").trim();
		custAddress  =request.getParameter("custAddress").trim();
		custCity     =request.getParameter("custCity").trim();
		custProv     =request.getParameter("custProv").trim();
		custPostal   =request.getParameter("custPostal").trim();
		custCountry  =request.getParameter("custCountry").trim();
		custHomePhone=request.getParameter("custHomePhone").trim();
		custBusPhone =request.getParameter("custBusPhone").trim();
		custEmail    =request.getParameter("custEmail").trim(); 
		       
		if (custFname.length() == 0  )
		{
			errorMsg+="<br>Please enter first name";
			 validData = false;  
		 }
		if (custLaname.length() == 0  )
		{
			errorMsg+="<br>Please enter last name";
			 validData = false;  
		 }
		if (custAddress.length() == 0  )
		{
			errorMsg+="<br>Please enter address";
			 validData = false;  
		 }
		  //  Customer home phone number validation //
		 if (custHomePhone.length()!= 0  )
		 {
			 
			 Pattern patternPhone = Pattern.compile("\\d{3}\\d{3}\\d{4}");
			    Matcher matcherPhone = patternPhone.matcher(custHomePhone);
				 
								 
			    if ((!matcherPhone.matches())) 
			    {
			    	errorMsg+="<br>Please enter 10 digit number only";    	 
			    	  
			    	validData = false;  
			    }		
			 
			
		 } 
		 else
		 {
			 errorMsg+="<br>Please enter home phone number";
			 validData = false;  
		 }
		  
		 if (custBusPhone.length()!= 0  )
		 {
			 
			 Pattern patternPhone1 = Pattern.compile("\\d{3}\\d{3}\\d{4}");
			    Matcher matcherPhone1 = patternPhone1.matcher(custBusPhone);
				 
								 
			    if ((!matcherPhone1.matches())) 
			    {
			    	errorMsg+="<br>Please enter 10 digit number only";    	 
			    	  
			    	validData = false;  
			    }		
			 
			
		 } 
		 else
		 {
			 errorMsg+="<br>Please enter business phone number";
			 validData = false;  
		 }
		
		 if(custPostal.length() == 0)
		 {
			 errorMsg+="<br>Please enter postal code";
		 }
		 else if (custPostal.length()!=7)
		 {
			 validData = false;   
			 errorMsg+="<br>Please check your postal code"; //This is postal code validate
		 } 		 
		 else 
		 {
			 char cArray[] = custPostal.toCharArray();
			 if (cArray[3]!=' ')
			 {
				 validData = false;   
				 errorMsg+="<br>Invalid Postal Code"; //Eg. Postal canada postal code T3k 3j5
			 }
			 int alpha[] = {0,2,5};
			 int num[] = {1,4,6};
			 for ( int i=0; i<alpha.length; i++)
			 {
				if (cArray[alpha[i]]< 'A'|| cArray[alpha[i]] >'Z') 
				{
					 validData = false;   
					 errorMsg+="<br>Invalid Postal Code";
				 break;
				}
				
			 }
			 for ( int i=0; i<num.length; i++)
			 {
				if (cArray[num[i]]< '0'|| cArray[num[i]] >'9') 
				{
					validData = false;   
					 errorMsg+="<br>Invalid Postal code";
				 break;
				}
				
			 }
		 }
		
		 if (custEmail.length() == 0  )
		 {
				errorMsg+="<br>Please enter email id";
				 validData = false;  
		 }
		 else
		 {
			 Pattern patternEmail = java.util.regex.Pattern.compile(EMAIL_PATTERN);
			    Matcher matcherEmail = patternEmail.matcher(custEmail);
			 
			      if(!matcherEmail.matches())
			      {
			    	  errorMsg+="<br>Please enter valid email id";
					  validData = false;  
			      }
			      
			      
		 }
		 if (validData)
		 {
			updateQuery = "update Customers set ";
			updateQuery += " CustFirstName     =  '" + custFname     + "',";
			updateQuery += " custLastName      =  '" + custLaname    + "',";
			updateQuery += " custAddress       =  '" + custAddress   + "',";
			updateQuery += " custCity          =  '" + custCity      + "',";
			updateQuery += " custProv          =  '" + custProv      + "',";
			updateQuery += " custPostal        =  '" + custPostal    + "',";
			updateQuery += " custCountry       =  '" + custCountry   + "',";
			updateQuery += " custHomePhone     =  '" + custHomePhone + "',";
			updateQuery += " custBusPhone      =  '" + custBusPhone  + "',";
			updateQuery += " custEmail         =  '" + custEmail     + "'";
			updateQuery += " where customerid=" + customerid;
			
			try
			{
				int c = stmt.executeUpdate(updateQuery);
				stmt.executeQuery("commit");
			   response.sendRedirect("account.jsp?success=true");
			} 
			catch (SQLException e)
			{
				validData = false;   
			 	errorMsg = "Unknown SQL error!";
				e.printStackTrace();
			}
		 }
		 else 
		 {
			// Strip the first break from the error message.
		 	errorMsg = errorMsg.substring(4);
		 }
 	}		
%>
    
<%           		
	//Get customer information from Database if there wasn't an update error.
	if (validData)
	{
		try
		{
		    PreparedStatement stmt = con.prepareStatement("select * from Customers  where customerid=" + customerid);
		    ResultSet rs           = stmt.executeQuery();
			ResultSetMetaData rsmd = rs.getMetaData();
		    	
			 if (rs.next())
		     {
		        for (int i=1; i<=rsmd.getColumnCount(); i++)
		        {
		      	   custFname     = rs.getString(2);
		    	   custLaname    = rs.getString(3);
		    	   custAddress   = rs.getString(4);
		    	   custCity      = rs.getString(5);
		    	   custProv      = rs.getString(6);
		    	   custPostal    = rs.getString(7);
		    	   custCountry   = rs.getString(8);
		    	   custHomePhone = rs.getString(9);
		    	   custBusPhone  = rs.getString(10);
		    	   custEmail     = rs.getString(11);                       
		        }
		     }
			 
		} catch (SQLException e) {
			e.printStackTrace();
		} finally {
				con.close();	//close DB connection
		}
	}

	// Print a message, if necessary.
	if (!validData) {
		out.print("<div class='message failed'>" + errorMsg + "</div>");
	} else if (request.getParameter("success") != null) {
		out.print("<div class='message success'>Your account was updated!</div>");
	}

  // Display the user data in a form.
  out.print("<form method = 'post' action='account.jsp?update=true'>");
  out.print("<input type='hidden' name='customerid1' value='"+customerid+"' />"); // display with  customerid1 in table
	  
  out.print("<table><tr><td>*First Name:</td>"+"<td><input type='text' name='custFname' value='" +custFname + "'></td></tr>");  
  out.print("<tr><td>*Last Name:</td>"+"<td><input type='text' name='custLaname' value='" +custLaname + "'></td></tr>");
  out.print("<tr><td>*Address:</td>"+"<td><input type='text' name='custAddress' value='" +custAddress + "'></td></tr>");
  out.print("<tr><td>City:</td>"+"<td><input type='text' name='custCity' value='" +custCity + "'></td></tr>");
  out.print("<tr><td>Province:</td>"+"<td><input type='text' name='custProv' value='" +custProv + "'></td></tr>");
  out.print("<tr><td>*Postal Code:</td>"+"<td><input type='text' name='custPostal' value='" +custPostal + "'></td></tr>");
  out.print("<tr><td>Country:</td>"+"<td><input type='text' name='custCountry' value='" +custCountry + "'></td></tr>");
  out.print("<tr><td>*Home Phone:</td>"+"<td><input type='text' name='custHomePhone' value='" +custHomePhone + "'></td></tr>"); 
  out.print("<tr><td>*Business Phone:</td>"+"<td><input type='text' name='custBusPhone' value='" +custBusPhone  + "'></td></tr>");
  out.print("<tr><td>*Email:</td>"+"<td><input type='text' name='custEmail' value='" +custEmail + "'></td></tr></table>"); 
  out.print("<h4 style=color:green>* mandatory fields</h4>");
  out.print("<div class='account'><input type='submit' value='Save Updates'></div>"); 
  
  out.print("</form>");
      
%>    

<jsp:include page="footer.jsp" />
