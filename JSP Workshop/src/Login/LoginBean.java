package Login;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.http.HttpSession;

public class LoginBean {
	
	public void logout(HttpSession session){
		session.removeAttribute("CustID");
		session.removeAttribute("loggedin");
	}

	public String verifyLogin(String userid,String password, HttpSession session){
	
	String message = "";
	
	try
	   {
//	      Class.forName("com.mysql.jdbc.Driver");
//	      Connection conn = DriverManager.getConnection("jdbc:mysql://localhost/TravelExperts", "root", "");
//	      //PreparedStatement stmt = conn.prepareStatement("select password from Users where userid=?");
//	      PreparedStatement stmt = conn.prepareStatement("select password from Users where userid=? and password=?");
//	      stmt.setString(1, userid);
//	      stmt.setString(2, password);
//	      ResultSet rs = stmt.executeQuery();
	      
	      // creates DB connection
	      Class.forName("oracle.jdbc.driver.OracleDriver");
	   	  Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ictoosd", "ictoosd");
	   	  
		  String sql = "select customerid from Users where ";
		  sql += "userid = ? and password = ? ";
		  PreparedStatement stmt = conn.prepareStatement(sql);
		  stmt.setString(1, userid);
		  stmt.setString(2, password);
		  // executes SQL
		  ResultSet rs = stmt.executeQuery();
			  
	      if (!rs.next())
	      {
	    	  message = "UserId or Password are incorrect";
	      } else {
	    	  updateSession(session,rs.getString("customerid").toString());
	    	  //updateSession(session);
	      }
 	      
	   }
	   catch(ClassNotFoundException e)
	   {
		   e.printStackTrace();
		   message=e.getMessage();
	   }
	   catch(SQLException e)
	   {
		   e.printStackTrace();
		   message=e.getMessage();
	   }
	
	return message;
	
	}
		
	private void updateSession(HttpSession session, String custId)
	{
		session.setAttribute("CustID", custId);
		session.setAttribute("loggedin", "true");
	}
	
}
