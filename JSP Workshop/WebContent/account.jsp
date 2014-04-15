<!-- Author: Porkodi Thiagarajan
WorkShop:CPRG220  JSP/Servlets
Created Date: April- 06-2014
Version: 1.0
Description: This is a Jsp/Servlet form, Can be used by customer to view and update their information -->  

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
		/* get the parameters being display  when  update button is clicked */
	      
		customerid = request.getParameter("customerid1");
		custFname    =request.getParameter("custFname");
		custLaname   =request.getParameter("custLaname");
		custAddress  =request.getParameter("custAddress");
		custCity     =request.getParameter("custCity");
		custProv     =request.getParameter("custProv");
		custPostal   =request.getParameter("custPostal");
		custCountry  =request.getParameter("custCountry");
		custHomePhone=request.getParameter("custHomePhone");
		custBusPhone =request.getParameter("custBusPhone");
		custEmail    =request.getParameter("custEmail"); 
		       
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
		} 
		catch (SQLException e)
		{
			e.printStackTrace();
		}
		
		out.print("<div class='message success'>Your account was updated!</div>");
 	}		
%>
    
<%           		
 	//Get customer information from Database
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
    	
 
/* 2nd form start here. */

  out.print("<form method = 'post' action='account.jsp?update=true'>");
  out.print("<input type='hidden' name='customerid1' value='"+customerid+"' />"); // display with  customerid1 in table
	  
 /* after select customer id  then display customer details */
 
  out.print("<table><tr><td>First Name:</td>"+"<td><input type='text' name='custFname' value='" +custFname + "'></td></tr>");  
  out.print("<tr><td>Last Name:</td>"+"<td><input type='text' name='custLaname' value='" +custLaname + "'></td></tr>");
  out.print("<tr><td>Address:</td>"+"<td><input type='text' name='custAddress' value='" +custAddress + "'></td></tr>");
  out.print("<tr><td>City:</td>"+"<td><input type='text' name='custCity' value='" +custCity + "'></td></tr>");
  out.print("<tr><td>Province:</td>"+"<td><input type='text' name='custProv' value='" +custProv + "'></td></tr>");
  out.print("<tr><td>Postal Code:</td>"+"<td><input type='text' name='custPostal' value='" +custPostal + "'></td></tr>");
  out.print("<tr><td>Country:</td>"+"<td><input type='text' name='custCountry' value='" +custCountry + "'></td></tr>");
  out.print("<tr><td>Home Phone:</td>"+"<td><input type='text' name='custHomePhone' value='" +custHomePhone + "'></td></tr>"); 
  out.print("<tr><td>Business Phone:</td>"+"<td><input type='text' name='custBusPhone' value='" +custBusPhone  + "'></td></tr>");
  out.print("<tr><td>Email:</td>"+"<td><input type='text' name='custEmail' value='" +custEmail + "'></td></tr></table>"); 
    
  out.print("<div class='account'><input type='submit' value='Save Updates'></div>"); 
  out.print("</form>"); //2nd form closed 
      
      %>    

<jsp:include page="footer.jsp" />
