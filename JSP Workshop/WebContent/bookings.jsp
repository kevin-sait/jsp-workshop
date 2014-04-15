<!--  
-- JSP/Servlet - Threaded Project 
-- Team - 5
-- Author:Suparna Roychoudhury
-- Date Created:15th Mar 2014
-- About the file: JSP file to show customer booking details
-->

<%	
	if (session.getAttribute("loggedin") == null)
	{
		response.sendRedirect("login.jsp");
	}
%>

<jsp:include page="header.jsp" />
   
<%@ page import="java.sql.*, java.io.*" %>
<%

int customerId = Integer.parseInt(session.getAttribute("CustID").toString());

StringBuffer pkgList=new StringBuffer(); //variable to store list of packages booked
StringBuffer pdtList=new StringBuffer();//variable to store list of products booked

try {
		//establish connection to Oracle DB
		Class.forName("oracle.jdbc.driver.OracleDriver");
		Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","ictoosd","ictoosd");
		
		pkgList.append("<h1>My Packages</h1>");
		//prepare sql statement to fetch customer package bookings from DB
		PreparedStatement stmt=conn.prepareStatement("SELECT b.bookingId, to_char(b.BookingDate,'dd/mm/yyyy'), p.PkgName "
	          + "FROM ICTOOSD.Bookings b, ICTOOSD.Packages p"
	          + " WHERE b.PackageId = p.PackageId AND b.CustomerId =? ORDER BY b.BookingDate desc");
		
		stmt.setInt(1, customerId); //assign parameter to sql statement
		ResultSet rs=stmt.executeQuery();//execute query
		//loop through the result set and print the drop down list
		if(rs.next())
		{
			pkgList.append("<div class='bookings'><select name='bookingId' onchange='getPackageBooking(this.value)'>");
			pkgList.append("<option value=''>Select a package to view details</option>");
			
			while (rs.next())
			{
				pkgList.append("<option value='"+rs.getString(1)+"'>"+rs.getString(3)+": Booked on: "+rs.getString(2)+"</option>");
			}
			pkgList.append("</select></div>");
		
		}		
		else//in case no data is fetched
		{
			pkgList.append("You have not booked any packages");
		}
				
		pdtList.append("<h1>My Products</h1>");
		//prepare sql statement to fetch customer product bookings from DB	
		PreparedStatement stmt1=conn.prepareStatement("SELECT b.BookingId,to_char(b.BookingDate,'dd/mm/yyyy'),p.ProdName "
	          +"FROM ICTOOSD.Customers c, ICTOOSD.Bookings b, ICTOOSD.BookingDetails bd, ICTOOSD.Products_Suppliers ps, ICTOOSD.Products p "
	          +"WHERE c.CustomerId = b.CustomerId "
	          +"AND b.BookingId = bd.BookingId "
	          +"AND bd.ProductSupplierId = ps.ProductSupplierId "
	          +"AND ps.ProductId = p.ProductId AND b.CustomerId = ? ORDER BY b.BookingDate desc");
		
		stmt1.setInt(1, customerId);//assign parameter to sql statement
		ResultSet rs1=stmt1.executeQuery();//execute query
		//loop thorugh the result set and print the drop down list
		if(rs1.next())
		{
			pdtList.append("<div class='bookings'><select name='bookingId' onchange='getProductBooking(this.value)'>");
			pdtList.append("<option value=''>Select a product to view details</option>");
			
			while (rs1.next())
			{
				pdtList.append("<option value='"+rs1.getString(1)+"'>"+rs1.getString(3)+": Booked on: "+rs1.getString(2)+"</option>");
			}
			pdtList.append("</select></div>");	
		}		
		else//in case no data is fetched
		{
			pdtList.append("You have not booked any products");
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

<script type="text/javascript">
	
	//AJAX scripts to submit only a part of the form to server
	var req1;
	var req2;
	//javascript functions to call servlet onchage of dropdown list
	function getPackageBooking(bookingId)
	{
		var url="GetCustomerPkgBookings?bookingId="+bookingId;
		req1=new XMLHttpRequest();
		req1.onreadystatechange=stateChanged;
		req1.open("GET",url);
		req1.send(null);
	}
	
	function stateChanged()
	{
		if (req1.readyState==4)
		{
			document.getElementById("div1").innerHTML=req1.responseText;
		}
	}
	//javascript functions to call servlet onchage of dropdown list
	function getProductBooking(bookingId)
	{
		var url="GetCustomerPdtBookings?bookingId="+bookingId;
		req2=new XMLHttpRequest();
		req2.onreadystatechange=stateChanged1;
		req2.open("GET",url);
		req2.send(null);
	}
	
	function stateChanged1()
	{
		if (req2.readyState==4)
		{
			document.getElementById("div2").innerHTML=req2.responseText;
		}
	}
	
	function doPrint() { window.print(); }
	
</script>

<% out.print(pkgList); %>
<div class='booking-details' id='div1'></div>
<% out.print(pdtList); %>
<div class='booking-details' id='div2'></div>

<div class='bookings'>
	<input name='print' type='button' id='print' value='Print Booking Details' onclick='doPrint()'/>
</div>

<jsp:include page="footer.jsp" />

