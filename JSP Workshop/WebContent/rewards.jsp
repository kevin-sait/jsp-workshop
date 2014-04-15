<!--  
-- JSP/Servlet - Threaded Project 
-- Team - 5
-- Author:Suparna Roychoudhury
-- Date Created:15th Mar 2014
-- About the file: JSP file to show customer rewards
-->

<%	
	if (session.getAttribute("loggedin") == null)
	{
		response.sendRedirect("login.jsp");
	}
%>

<jsp:include page="header.jsp" />
<h1>My Rewards</h1>
   
<%@ page import="java.sql.*, java.io.*" %>

<%

int customerId = Integer.parseInt(session.getAttribute("CustID").toString());

try {
		//establish connection to Oracle DB
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","ictoosd","ictoosd");
		
		//prepare sql statement to fetch customer reward from DB
		PreparedStatement stmt=conn.prepareStatement("SELECT cr.rewardid \"Reward Id\", cr.rwdnumber \"Reward Number\",r.rwdname \"Reward Name\",r.rwddesc \"Reward Description\""
	          + "FROM ICTOOSD.Customers_Rewards cr, ICTOOSD.Rewards r"
	          + " WHERE cr.RewardId = r.RewardId AND cr.CustomerId =?");
		
		stmt.setInt(1, customerId); //assign parameter to sql statement
		ResultSet rs=stmt.executeQuery(); //execute query
		
		ResultSetMetaData rsmd=rs.getMetaData(); //get the metadata for the result set
		//loop through the result set and print on a table
		if (rs.next())
		{
			out.print("<table border='1'><tr>");
			for (int i=1;i<=rsmd.getColumnCount();i++)
			{
				out.print("<th>"+rsmd.getColumnLabel(i)+"</th>");
			}
			out.print("</tr><tr>");
			for (int i=1;i<=rsmd.getColumnCount();i++)
			{
				out.print("<td>"+rs.getString(i)+"</td>");
			}
			
			out.print("</tr></table>");
		}	
		else //in case no data is fetched
		{
			out.print("You have not yet collected any rewards");
		}
					
		conn.close();	//close DB connection
	
} catch (SQLException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
} catch (ClassNotFoundException e) {
	// TODO Auto-generated catch block
	e.printStackTrace();
}
%>

<jsp:include page="footer.jsp" />

