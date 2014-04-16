/*****************************************************
Application Name: Travel Expert Information System (Web)
                  (Threaded Project phase 3)
Module Name: LoginBean.java
Purpose of this module: 
 - connect database, get users table data for authentication
 - if authentication is OK, set customer id session
 - if authentication failed, returns err message
Author : Ryuji Sasaki                            
Create Date: 14/04/2014
*****************************************************/
package Login;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.http.HttpSession;

/**
 * LoginBean class
 */
public class LoginBean {
	
	/**
	 * logout
	 */
	public void logout(HttpSession session){
		session.removeAttribute("CustID");
		session.removeAttribute("loggedin");
		session.removeAttribute("userid");
	}

	/**
	 * verifyLogin
	 */
	public String verifyLogin(String userid,String password, HttpSession session){
	
	String message = "";
	
	try
	   {
      
	      // creates DB connection
	      Class.forName("oracle.jdbc.driver.OracleDriver");
	   	  Connection conn = DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe", "ictoosd", "ictoosd");
	   	  
	   	  // select SQL
		  String sql = "select customerid from Users where ";
		  sql += "userid = ? and password = ? ";
		  
		  // create preparedstatement 
		  PreparedStatement stmt = conn.prepareStatement(sql);
		  
		  // set parameters
		  stmt.setString(1, userid);
		  stmt.setString(2, password);
		  
		  // executes SQL
		  ResultSet rs = stmt.executeQuery();
		  
		  // Login failed
	      if (!rs.next())
	      {
	    	  message = "UserId or Password are incorrect";
	    	  
	    	// Login succeed
	      } else {
	    	  updateSession(session,rs.getString("customerid").toString(),userid);
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
	
	/**
	 * updateSession
	 */
	private void updateSession(HttpSession session, String custId, String userid)
	{
		session.setAttribute("CustID", custId);
		session.setAttribute("loggedin", "true");
		session.setAttribute("userid", userid);
	}
	
}
