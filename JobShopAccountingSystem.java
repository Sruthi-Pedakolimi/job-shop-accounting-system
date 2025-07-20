import java.sql.Connection;
import java.util.Scanner;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.time.format.DateTimeFormatter;
import java.io.*;
import java.math.BigDecimal;
import java.sql.CallableStatement;

public class JobShopAccountingSystem {
	// Database credentials
	 	final static String HOSTNAME = "peda0001-sql-server.database.windows.net";
	    final static String DBNAME = "cs-dsa-4513-sql-db";
	    final static String USERNAME = "peda0001";
	    final static String PASSWORD = "XXXXX@2023";
	    // Database connection string
	    final static String URL = String.format("jdbc:sqlserver://%s:1433;database=%s;user=%s;"
	    		+ "password=%s;encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;"
	    		+ "loginTimeout=30;",
	    		HOSTNAME, DBNAME, USERNAME, PASSWORD);
		// Query templates
		final static String QUERY_TEMPLATE_1 = "EXEC addCustomerDetails @customer_name = ?, @customer_address = ?, @category = ?;";
		final static String QUERY_TEMPLATE_2 = "EXEC addDepartmentDetails @department_number = ?, @department_data = ?;";
		final static String QUERY_TEMPLATE_3 = "EXEC addNewProcess @process_id = ?, @process_data=?, @paint_type=?,@painting_method=?,@fit_type=?,"
				+ "@cutting_type=?, @machine_type=?, @department_number=?, @process_type=?;";
		final static String QUERY_TEMPLATE_4 = "EXEC addNewAssembly @assembly_id = ?, @date_ordered = ?,  @assembly_details = ?, @customer_name = ?, @process_id = ?;";
		final static String QUERY_TEMPLATE_5 = "EXEC addAccountDetailsAndProcess @account_type=?,@account_number = ?, @cost_details=?,@date_established = ?, "
				+ "@process_id=?, @assembly_id=?,@department_number=?;";
		final static String QUERY_TEMPLATE_6 = "EXEC addJobDetails @job_number = ?, @assembly_id = ?, @process_id=?, "
				+ "@job_commenced_date=?, @job_type=?,@machine_type_used=?,@material_used=?, @color=?, @volume=?;";
		final static String QUERY_TEMPLATE_7 = "EXEC updateJobDetails @job_number=?, @job_completed_date=?,"
				+ " @amount_of_time_machine_used=?, @labor_time=?";
		final static String QUERY_TEMPLATE_8 = "EXEC updateCostDetails @transaction_number = ?, @sup_cost = ?, @account_number=?;";
		final static String QUERY_TEMPLATE_9 = "EXEC getTotalCostIncurred @assembly_id=?, @total_cost=?;";
		final static String QUERY_TEMPLATE_10 = "EXEC GetTotalLaborTimeInDepartment @department_number=?, @job_completed_date=?, @total_labor_time=? ;";
		final static String QUERY_TEMPLATE_11 = "EXEC getProcessDepartmentDetails @assembly_id=?";
		final static String QUERY_TEMPLATE_12 = "EXEC getCustomersForCategories @range_start=?, @range_end=?;";
		final static String QUERY_TEMPLATE_13 = "EXEC deleteCutJobs @job_number_start=?, @job_number_end=?;";
		final static String QUERY_TEMPLATE_14 = "EXEC ChangeColorPaintJob @paint_job_number=?, @color=?;";
		final static String QUERY_TEMPLATE_16 = "EXEC getCustomerData @start_range=?, @end_range=?;";

		final static DateTimeFormatter dtf = DateTimeFormatter.ofPattern("MM-dd-yyyy");

		// User input prompt
		final static String PROMPT =
				"\nPlease select one of the options below: \n" +
						"(1) Enter a new customer \n" +
						"(2) Enter a new department \n" +
						"(3) Enter a new process-id and its department together with its type and information \n" +
						"\trelevant to the type\n" +
						"(4) Enter a new assembly with its customer-name, assembly-details, assembly-id, \n" +
						"\tand dateordered and associate it with one or more processes\n" +
						"(5) Create a new account and associate it with the process, assembly, or department \n" +
						"\tto which it is applicable\n" +
						"(6) Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced\n" +
						"(7) At the completion of a job, enter the date it completed and the information \n" +
						"\trelevant to the type of job \n" +
						"(8) Enter a transaction-no and its sup-cost and update all the costs (details) of the \n" +
						"\taffected accounts by adding sup-cost to their current values of details \n" +
						"(9) Retrieve the total cost incurred on an assembly-id \n" +
						"(10) Retrieve the total labor time within a department for jobs completed in the \n" +
						"\tdepartment during a given date\n" +
						"(11) Retrieve the processes through which a given assembly-id has passed so far \n" +
						"\t(in datecommenced order) and the department responsible for each process\n"+
						"(12) Retrieve the customers (in name order) whose category is in a given range\n" +
						"(13) Delete all cut-jobs whose job-no is in a given range\n" +
						"(14) Change the color of a given paint job\n" +
						"(15) Import: enter new customers from a data file until the file is empty \n" +
						"(\tthe user must be asked to enter the input file name). \n" +
						"(16) Export: Retrieve the customers (in name order) whose category is in a given range \n" + "\tand output them to a data file instead of screen (the user must be asked to enter the output file name).\n" +
						"(17) Quit\n";

		public static void main(String[] args) throws SQLException, IOException {
			System.out.println("WELCOME TO JOB-SHOP ACCOUNTING SYSTEM !");
			final Scanner sc = new Scanner(System.in);

			String option = "";

			while (!option.equals("17")) {
				System.out.println(PROMPT);
				System.out.println("Enter your option : ");
				option = sc.next();

				switch (option) {
				case "1":
					System.out.println("Enter customer name:");
					sc.nextLine();
					final String customer_name = sc.nextLine();
					System.out.println("Enter customer address:");
					
					final String customer_address = sc.nextLine();
					


					System.out.println("Enter category:");
					final int category = sc.nextInt();
					System.out.println("Connecting to the database...");

					try (final Connection connection = DriverManager.getConnection(URL)) {
						try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_1)) {
							statement.setString(1, customer_name);
							statement.setString(2, customer_address);
							statement.setInt(3, category);
							statement.execute();
						}
					}
					break;
				case "2":
					System.out.println("Enter Department number:");
					final int department_number = sc.nextInt();

					System.out.println("Enter Department data:");
					sc.nextLine();
					final String department_data = sc.nextLine();
					System.out.println("Connecting to the database...");

					try (final Connection connection = DriverManager.getConnection(URL)) {
						try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_2)) {
							statement.setInt(1, department_number);
							statement.setString(2, department_data);
							statement.execute();
						}
					}
					break;

				case "3":

					System.out.println("Enter the Process ID:");
					final int process_id = sc.nextInt();

					System.out.println("Enter the Department Number:");
					final int department_number3 = sc.nextInt();
					
					System.out.println("Enter the Process Data:");
					sc.nextLine();

					final String process_data = sc.nextLine();
					
					
					System.out.println("Please enter the process_type (cut/paint/fit) to insert");
					final String process_type = sc.nextLine();
					String cutting_type = "";
					String machine_type = "";
					String paint_type = "";
					String painting_method = "";
					String fit_type = "";
					
					if(process_type.equals("paint")) {
						
						System.out.println("Enter the paint type:");
						paint_type = sc.nextLine();

						System.out.println("Enter the painting method:");
						painting_method = sc.nextLine();
								
					}
					
					else if (process_type.equals("cut")) {
						
						System.out.println("cutting type:");
						cutting_type = sc.nextLine();


						System.out.println("Enter the machine type:");
						machine_type = sc.nextLine();
					}
					else if (process_type.equals("fit")) {
						
						System.out.println("Enter the fit type:");
						fit_type = sc.nextLine();
					}
					System.out.println("Connecting to the database...");

					try (final Connection connection = DriverManager.getConnection(URL)) {
						System.out.println("Dispatching the query...");
						try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_3)) {
							statement.setInt(1, process_id);
							statement.setString(2, process_data);
							statement.setString(3, paint_type);
							statement.setString(4, painting_method);
							statement.setString(5, fit_type);
							statement.setString(6, cutting_type);
							statement.setString(7, machine_type);
							statement.setInt(8, department_number3);
							statement.setString(9, process_type);
							statement.execute();
						}	
					}
					break;
					
					case "4":
						System.out.println("Enter the new assembly id:");
						final int assembly_id = sc.nextInt();
							
						System.out.println("Enter the date ordered (MM-dd-yyyy):");
						sc.nextLine();
						final String date_ordered = sc.nextLine();
			

						System.out.println("Enter Assembly Details:");
						final String assembly_details = sc.nextLine();

						
						System.out.println("Enter Customer Name");
						final String customer_name1 = sc.nextLine();

						System.out.println("Enter Existing process id");
						final String process_ids = sc.nextLine();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_4)) {
								statement.setInt(1, assembly_id);					        
								statement.setString(2, date_ordered);
								statement.setString(3, assembly_details);
								statement.setString(4, customer_name1);
								statement.setString(5, process_ids);
								statement.execute();
							}
						}
						break;

					case "5":
						
						
						System.out.println("Enter new account number:");
						final int account_number = sc.nextInt();
						

						System.out.println("Enter the Date Established:");
						sc.nextLine();
						final String date_established = sc.nextLine();
						
						
						System.out.println("Enter the account type (process, assembly, department) case-sensitive:");
						final String account_type = sc.nextLine();
						
						
					
							
						int process_id3 = 0;
						int assembly_id5 = 0;
						int department_number2 = 0;
						if(account_type.equals("process")) {
							
							System.out.println("Enter existing process id:");
							process_id3 = sc.nextInt();
						}
						
						else if (account_type.equals("assembly")) {
							System.out.println("Enter existing assembly id:");
							assembly_id5 = sc.nextInt();
						}
						
						else if (account_type.equals("department")) {

							System.out.println("Enter existing department number:");
							department_number2 = sc.nextInt();
						}
						
						System.out.println("cost details:");
						final float cost_details = sc.nextFloat();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_5)) {
								statement.setString(1, account_type);
								statement.setInt(2, account_number);
								statement.setFloat(3, cost_details);
								statement.setString(4, date_established);
								statement.setInt(5, process_id3);
								statement.setInt(6, assembly_id5);
								statement.setInt(7, department_number2);
							
								statement.execute();
							}
						}
						break;
						
					case "6":
						System.out.println("Enter new job number:");
						final int job_number = sc.nextInt();
						System.out.println("Enter job commenced date:");
						sc.nextLine();
						final String job_commenced_date = sc.nextLine();
						

						System.out.println("Enter Existing assembly id:");
						final int assembly_id6 = sc.nextInt();
						System.out.println("process id:");
						final int process_id6 = sc.nextInt();
						System.out.println("Enter job type (paint, fit, cut) case-sensitive:");
						final String job_type = sc.next();
						String machine_type_used = "";
						String material_used = "";
						String color = "";
						String volume = "";
						if(job_type.equals("cut")) {
							System.out.println("Enter machine type used:");
							sc.nextLine();
							machine_type_used = sc.nextLine();
							
							System.out.println("Enter material used:");
							material_used = sc.nextLine();
						}
						else if(job_type.equals("paint")) {
							System.out.println("Enter color:");
							sc.nextLine();
							color = sc.nextLine();
							System.out.println("Enter volume:");
							volume = sc.nextLine();
						}
						System.out.println("Connecting to the database...");
						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_6)) {
								statement.setInt(1, job_number);
								statement.setInt(2, assembly_id6);
								statement.setInt(3, process_id6);
								statement.setString(4, job_commenced_date);
								statement.setString(5, job_type);
								statement.setString(6, machine_type_used);
								statement.setString(7, material_used);
								statement.setString(8, color);
								statement.setString(9, volume);
								statement.execute();
							}
						}
						break;
					case "7":

						System.out.println("Enter the job number");
						final int job_number7 = sc.nextInt();
						
						System.out.println("Enter job competion date:");
						sc.nextLine();
						final String job_completed_date = sc.nextLine();
						
						System.out.println("Enter Labour Time:");
						final float labor_time = sc.nextFloat();
						
			
						System.out.println("Enter Time Machine Used:");
						final float amount_of_time_machine_used = sc.nextFloat();
			
						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_7)) {
								cs.setInt(1, job_number7);
								cs.setString(2, job_completed_date);
								cs.setFloat(3, amount_of_time_machine_used);
								cs.setFloat(4, labor_time);
								// Execute the stored procedure
						        cs.execute();
							}
						}
						break;
					case "8":

						System.out.println("Enter Transaction Number:");
						final int transaction_number = sc.nextInt();

						System.out.println("Enter the sup cost:");
						final float sup_cost = sc.nextFloat();
						
						System.out.println("Enter the Account Number:");
						final int account_number8 = sc.nextInt();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_8)) {
								statement.setInt(1, transaction_number);
								statement.setFloat(2, sup_cost);
								statement.setInt(3, account_number8);
								statement.execute();
							}
						}
						break;
					case "9":

						System.out.println("Enter assembly id:");
						final int assembly_id9 = sc.nextInt();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_9)) {

								cs.setInt(1, assembly_id9);
								cs.registerOutParameter(2, Types.DECIMAL);
						        cs.execute();

						        BigDecimal totalCost = cs.getBigDecimal(2);
						        System.out.println("Final Total Cost: " + totalCost);
							}
						}
						break;
					case "10":

						System.out.println("Please Enter Department Number:");
						final int department_number10 = sc.nextInt();
						
						System.out.println("Please Enter Job completed date:");
						sc.nextLine();
						final String date_job_completed = sc.nextLine();
						

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_10);
							cs.setInt(1, department_number10);
							cs.setString(2, date_job_completed);
							cs.registerOutParameter(3, Types.DECIMAL);
					        cs.execute();
					        BigDecimal totalCost = cs.getBigDecimal(3);
					        System.out.println("Total cost: " + totalCost);
						}
						break;
					case "11":

						System.out.println("Please Enter the assembly id:");
						final int assembly_id11 = sc.nextInt();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_11);
							cs.setInt(1, assembly_id11);
							System.out.println("Dispatching the query...");
							ResultSet resultSet = cs.executeQuery();
							System.out.println("Done.");
							System.out.println("\nProcess for assembly-id: " + assembly_id11 +
									", and its departement number; Sorted by date commenced.");
							System.out.println("processID | deptNo");
							while (resultSet.next()) {
								System.out.println(String.format("%s | %s ",
										resultSet.getString(1),
										resultSet.getString(2)));
							}
						}
						break;
					case "12":

						System.out.println("Enter the Start Range of Category:");
						final int range_start = sc.nextInt();

						System.out.println("Enter the End Range of category:");
						final int range_end = sc.nextInt();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_12);) {
								cs.setInt(1, range_start);
								cs.setInt(2, range_end);
								System.out.println("Dispatching the query...");
								ResultSet resultSet = cs.executeQuery();
								System.out.println("Done.");
								System.out.println("\nJobs from start date " + range_start +
										" completed on: " + range_end);
								System.out.println("customer name");
								while (resultSet.next()) {
									System.out.println(String.format("%s",
											resultSet.getString(1)));

								}
							}
						}
						break;
					case "13":
						
						System.out.println("Enter Job Number Start Value:");
						final int job_number_start = sc.nextInt();

						System.out.println("Enter Job Number End Value:");
						final int job_number_end = sc.nextInt();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_13)) {
								statement.setInt(1, job_number_start);
								statement.setInt(2, job_number_end);
								statement.executeUpdate();
							}
						}
						break;
					case "14":

						System.out.println("job number:");
						final int job_number14 = sc.nextInt();

						System.out.println("color:");
						final String color1 = sc.next();

						System.out.println("Connecting to the database...");

						try (final Connection connection = DriverManager.getConnection(URL)) {
							try (final PreparedStatement statement = connection.prepareStatement(QUERY_TEMPLATE_14)) {
								statement.setInt(1, job_number14);
								statement.setString(2, color1);
								int rows = statement.executeUpdate();
								System.out.println(rows);
							}
						}
						break;
					case "15":
						System.out.println("Please enter name of CSV file with customer data");
						String filename = sc.next();
						String query = readCSV(filename);
						// Database connection
						try (final Connection connection = DriverManager.getConnection(URL)) {
							PreparedStatement ps = connection.prepareCall(query);
							System.out.println("Dispatching the query...");
							final int inserted_rows = ps.executeUpdate();
							System.out.println(String.format("rows inserted." + inserted_rows));
						}
						break;
					case "16":
						System.out.println("Please enter start range of category number");
						int start_range = sc.nextInt();
						System.out.println("Please enter end range of category number");
						int end_range = sc.nextInt();

						System.out.println("Enter the file name:");
						sc.nextLine();
						String filename16 = sc.nextLine();
						try (final Connection connection = DriverManager.getConnection(URL)) {
						    try (CallableStatement cs = connection.prepareCall(QUERY_TEMPLATE_16)) {
						        cs.setInt(1, start_range);
						        cs.setInt(2, end_range);

						        // Run the stored procedure and store values in resultSet
						        System.out.println("Dispatching the query...");
						        try (ResultSet resultSet = cs.executeQuery()) {
						            try (FileWriter myWriter = new FileWriter(filename16 + ".csv")) {
						                myWriter.write("customer_name,customer_address,category\n");

						                // Unpack the tuples returned by the database and write them to the file
						                while (resultSet.next()) {
						                    myWriter.write(String.format("%s,%s,%s\n",
						                            resultSet.getString(1),
						                            resultSet.getString(2),
						                            resultSet.getString(3)));
						                }
						            } catch (IOException e) {
						                System.out.println("File Name Error");
						                e.printStackTrace();
						            }
						        }
						    }
						}

						System.out.println(filename16 + ".csv");
						break;
					case "17":
						System.out.println("Quitting the Job Shop Accounting Database");
						break;
					default:
						System.out.println("Wrong Option");
						break;
					}
				}

				sc.close();
			}


		// Reading CSV file
		public static String readCSV(String filename) throws IOException, SQLException {
		    StringBuilder insertStatement = new StringBuilder("INSERT INTO customers VALUES ");
		    // Input reading
		    try (BufferedReader input = new BufferedReader(new FileReader(filename))) {
		        String line;
		        int iterCount = 0; // keep track of iterations
		        final int FIRST_ITER = 0;
		        // Iterate through each 'row' of the csv
		        while ((line = input.readLine()) != null) {
		            // First iteration
		            if (iterCount != FIRST_ITER) {
		                insertStatement.append(", ");
		            } else {
		                ++iterCount;
		            }
		            // Split the line into values based on comma
		            String[] values = line.split(",");
		            // insertion
		            insertStatement.append("('")
		                    .append(values[0].trim()) 
		                    .append("', '")
		                    .append(values[1].trim()) 
		                    .append("', ")
		                    .append(values[2].trim()) 
		                    .append(")");

		        }
		    } 
		    return insertStatement.toString();
		}
}
