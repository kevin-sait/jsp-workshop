/*
* JSP/Servlet - Threaded Project 
* Team - 5
* Author:Suparna Roychoudhury
* Date Created:15th Mar 2014
* About the file: Servlet to show customer package booking details
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
 * Servlet implementation class GetCustomerPkgBookings
 */
@WebServlet("/GetCustomerPkgBookings")
public class GetCustomerPkgBookings extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public GetCustomerPkgBookings() {
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
		
			//prepare sql statement to fetch customer package booking data from DB
			PreparedStatement stmt=con1.prepareStatement("SELECT to_char(b.BookingDate,'dd/mm/yyyy') \"Date of Booking\",b.BookingNo \"Booking No.\","
            + "b.TravelerCount \"No. of Travlers\",p.PackageId \"Package Id\", p.PkgName \"Package Name\" ,to_char(PkgbasePrice,'$9,999.99') \"Price\""
            + "FROM ICTOOSD.Bookings b, ICTOOSD.Packages p"
            + " WHERE b.PackageId = p.PackageId AND b.BookingId =? ");
			stmt.setString(1, bookingId);//assign parameter to sql statement
			ResultSet rs=stmt.executeQuery();//execute query
			ResultSetMetaData rsmd=rs.getMetaData();//get the metadata for the result set
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
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
	}

}
