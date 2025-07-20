<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Retrieval of  Customers</title>
</head>
<body>
	<h2>Given the Customer Range get all the Customers</h2>
	<!--
Form for collecting user input for the new movie_night record.
Upon form submission, add_customer.jsp file will be invoked.
-->
	<form action="retrieve_customers.jsp">
		<!-- The form organized in an HTML table for better clarity. -->
		<table border=1>
			<tr>
				<th colspan="2">Enter the Details of Category Range:</th>
			</tr>
			<tr>
				<td>Ranges From:</td>
				<td><div style="text-align: center;">
						<input type=text name=min_cat>
					</div></td>
			</tr>
			<tr>
				<td>Ranges To:</td>
				<td><div style="text-align: center;">
						<input type=text name=max_cat>
					</div></td>
			</tr>
			<tr>
				<td><div style="text-align: center;">
						<input type=reset value=Clear>
					</div></td>
				<td><div style="text-align: center;">
						<input type=submit value=search>
					</div></td>
			</tr>
		</table>
	</form>
</body>
</html>