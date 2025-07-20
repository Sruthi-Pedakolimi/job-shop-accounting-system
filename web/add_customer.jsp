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
	String customer_name = request.getParameter("customer_name");
	String customer_address = request.getParameter("customer_address");
	String categoryString = request.getParameter("category");

	if (customer_name.equals("") || customer_address.equals("") || categoryString.equals("")) {
		response.sendRedirect("Pedakolimi_Ramya_Sruthi_IP_Task7_add_customer_form.jsp");
	} else {
		int category = Integer.parseInt(categoryString);
		// Now perform the query with the data from the form.
		boolean success = handler.addCustomer(customer_name, customer_address, category);
		if (!success) { // Something went wrong
	%>
	<h2>Insertion Problem</h2>
	<%
} else { 
%>
	<h2>The Customer Data Entered:</h2>
	<ul>
		<li>Customer Name: <%=customer_name%></li>
		<li>Customer Address: <%=customer_address%></li>
		<li>Category: <%=categoryString%></li>
	</ul>
	<h2>Was successfully inserted.</h2>
	<a href="Pedakolimi_Ramya_Sruthi_IP_Task7_get_all_customers.jsp">See all Customers.</a>
	<%
}
}
%>
</body>
</html>