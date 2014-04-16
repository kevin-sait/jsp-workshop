<html>
<head>
<title>Travel Experts</title>
<link href="tecss.css" rel="stylesheet" type="text/css">
<script type='text/javascript' src='regionswap.js'></script>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
</head>

<body>

<header>

	<div id="menu1">
		<a href="index.jsp">Travel Experts</a>
	</div>
	<div id="menu2">
	<%
		if (session.getAttribute("loggedin") == null)
		{
			out.print("<a href=\"register.jsp\">Register</a>");
			out.print("<a href=\"login.jsp\">Login</a>");
		}
		else
		{
			out.print("<a href=\"rewards.jsp\">Rewards</a>");
			out.print("<a href=\"bookings.jsp\">Bookings</a>");
			out.print("<a href=\"account.jsp\">Account</a>");
			out.print("<a href=\"login.jsp?logout=true\">Logout</a>");
		}
	%>
	</div>

<div id="banner">
<img src="images/image1.jpg"  id="slide" width="800" height="400">

<script type="text/javascript">

var step = 1;
function slideit()
{	
	document.getElementById("slide").setAttribute("src", "images/image"+step+".jpg")
	
	if (step<5)
	step++;
	else
	step=1;	
	
	setTimeout("slideit()",2000);
	
}
slideit()

 </script>
</div>

</header>

