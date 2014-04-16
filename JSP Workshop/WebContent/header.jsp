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
		<%
			if (session.getAttribute("userid") != null) {
				out.print("<div id='welcome'>Hi, " + session.getAttribute("userid") + "!</div>");
			}
		%>
	</div>
	<div id="menu2">
	<%
		if (session.getAttribute("loggedin") == null)
		{
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

	<div id="banner"></div>

</header>

