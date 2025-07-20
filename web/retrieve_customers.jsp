<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Query Result</title>
</head>
<body>
	<%@page import="com.jobshop.handlers.DataHandler"%>
	<%@page import="java.sql.ResultSet"%>
	<%@page import="java.sql.Array"%>
	<%
	// The handler is the one in charge of establishing the connection.
	DataHandler handler = new DataHandler();
	// Get the attribute values passed from the input form.
	String rangeFrom = request.getParameter("start_range");
	String rangeTo = request.getParameter("end_range");

	if (start_range.equals("") || end_range.equals("")) {
		response.sendRedirect("Pedakolimi_Ramya_Sruthi_IP_Task7_retrieve_customers_form.jsp");
	} else {
		int duration_from = Integer.parseInt(rangeFrom);
		int duration_to = Integer.parseInt(rangeTo); // Now perform the query with the data from the form.
		final ResultSet customers = handler.retrieveCustomers(duration_from, duration_to);
	%>
	<!-- The table for displaying all the movie records -->
	<table cellspacing="2" cellpadding="2" border="1">
		<tr>
			<!-- The table headers row -->
			<td align="center">
				<h4>Customer Name</h4>
			</td>
			<td align="center">
				<h4>Customer Address</h4>
			</td>
			<td align="center">
				<h4>Category</h4>
			</td>
		</tr>
		<%
		while (customers.next()) { 
			final String customer_name = customers.getString("customer_name");
			final String customer_address = customers.getString("customer_address");
			final String category = customers.getString("category");
			out.println("<tr>"); // Start printing out the new table row
			out.println( 
			"<td align=\"center\">" + customer_name + "<td align=\"center\">" + customer_address + "<td align=\"center\">" + category
					+ "</td>");
			out.println("</tr>");
		}
		}
		%>
	
</body>
</html>