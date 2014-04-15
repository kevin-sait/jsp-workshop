/*
* JSP/Servlet - Threaded Project 
* Team - 5
* Author:Suparna Roychoudhury
* Date Created:15th Mar 2014
* About the file: Servlet to show customer product booking details
*/

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class GetCustomerPdtBookings
 */
@WebServlet("/GetCustomerPdtBookings")
public class GetCustomerPdtBookings extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetCustomerPdtBookings() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doStuff(request,response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
	}
	protected void doStuff(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		String bookingId=request.getParameter("bookingId");
		
		PrintWriter out=response.getWriter();
		
		try {
			
			//establish connection to Oracle DB
			Class.forName("oracle.jdbc.driver.OracleDriver");
			Connection con1 = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","ictoosd","ictoosd");
		
			//prepare sql statement to fetch customer product booking data from DB
			PreparedStatement stmt1=con1.prepareStatement("SELECT to_char(b.BookingDate,'dd/mm/yyyy') \"Date of Booking\", b.BookingNo \"Booking No.\" ," 
		            +"p.ProdName \"Product Name\" ,bd.Description \"Description\" "
		            +"FROM ICTOOSD.Customers c, ICTOOSD.Bookings b, ICTOOSD.BookingDetails bd, ICTOOSD.Products_Suppliers ps, ICTOOSD.Products p "
		            +"WHERE c.CustomerId = b.CustomerId "
		            +"AND b.BookingId = bd.BookingId "
		            +"AND bd.ProductSupplierId = ps.ProductSupplierId "
		            +"AND ps.ProductId = p.ProductId AND b.BookingId = ?");
					stmt1.setString(1, bookingId);//assign parameter to sql statement
					ResultSet rs1=stmt1.executeQuery();//execute query
					ResultSetMetaData rsmd1=rs1.getMetaData();//get the metadata for the result set
					
			//loop through the result set and print on a table
			if (rs1.next())
			{
				out.print("<table border='1'><tr>");
				for (int i=1;i<=rsmd1.getColumnCount();i++)
				{
					out.print("<th>"+rsmd1.getColumnLabel(i)+"</th>");
				}
				out.print("</tr><tr>");
				for (int i=1;i<=rsmd1.getColumnCount();i++)
				{
					out.print("<td>"+rs1.getString(i)+"</td>");
				}
				
				out.print("</tr></table>");
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}
}
