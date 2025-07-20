	package com.jobshop.handlers;

	import java.sql.Connection;
	import java.sql.DriverManager;
	import java.sql.PreparedStatement;
	import java.sql.ResultSet;
	import java.sql.SQLException;

	public class DataHandler {
		private Connection conn;
		final static String HOSTNAME = "peda0001.database.windows.net";
		final static String DBNAME = "cs-dsa-4513-sql-db";
		final static String USERNAME = "peda0001";
		final static String PASSWORD = "XXXXX@2021";
		// Database connection string
		final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;",
				HOSTNAME, DBNAME, USERNAME, PASSWORD);
		
		// Initialize and save the database connection
		private void getDBConnection() throws SQLException {
			if (conn != null) {
				return;
			}
			this.conn = DriverManager.getConnection(URL);
		}
		
		// Return the result of selecting everything from the customer table
		public ResultSet getAllCustomers() throws SQLException {
			getDBConnection();
			final String sqlQuery = "SELECT * FROM customers;";
			final PreparedStatement stmt = conn.prepareStatement(sqlQuery);
			return stmt.executeQuery();
		}
		// Inserts a record into the customer table with the given attribute values
		public boolean addCustomer(
			String customer_name, String customer_address, int category) throws SQLException {
			getDBConnection(); // Prepare the database connection
			// Prepare the SQL statement
			final String sqlQuery =
					"INSERT INTO customers " +
							"(customer_name, customer_address, category) " +
							"VALUES " +
							"(?, ?, ?)";
			final PreparedStatement stmt = conn.prepareStatement(sqlQuery);
			// Replace the '?' in the above statement with the given attribute values
			stmt.setString(1, customer_name);
			stmt.setString(2, customer_address);
			stmt.setInt(3, category);
			// Execute the query, if only one record is updated, then we indicate success by returning true
			return stmt.executeUpdate() == 1;
		}
		// Return the result of selecting everything from the customer table in the given range
		public ResultSet retrieveCustomers(int start_range, int end_range) throws SQLException {
			getDBConnection();
			final String sqlQuery = "SELECT * FROM customers WHERE category BETWEEN '" + start_range + "' and '" + end_range + "'";;
			final PreparedStatement stmt = conn.prepareStatement(sqlQuery);
			return stmt.executeQuery();
		}
	}
