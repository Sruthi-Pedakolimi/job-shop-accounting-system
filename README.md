# 📘 Job Shop Accounting System

A web-based database application built using **Java**, **JSP**, and **SQL Server** to manage customers, departments, jobs, and accounting processes in a job shop manufacturing environment.

## 🛠️ Tech Stack

- **Java (JDK 8+)**
- **JSP / HTML**
- **Microsoft SQL Server**
- **JDBC**
- **Apache Tomcat** (recommended for deployment)
- Developed using **Eclipse IDE**

## 📦 Features

- Add, update, and retrieve **customer** records
- Record and manage **departments**, **processes**, **assemblies**, and **jobs**
- Execute **stored procedures** for complex logic (e.g., cost tracking, labor time)
- **Import** and **export** customer data using CSV files
- HTML & JSP-based UI for form input and data display

## 🚀 Getting Started

### 1. Clone the Repository

```bash
git clone https://github.com/your-username/job-shop-accounting-system.git
```

### 2. Set Up SQL Server

- Run `sql/create_tables.sql` to create the necessary tables
- Run `sql/stored_procedures.sql` to set up stored procedures

### 3. Configure Database in Java

In `DataHandler.java`, update the credentials:

```java
final static String USERNAME = "your_username";
final static String PASSWORD = "your_password";
final static String DBNAME = "your_database_name";
```

### 4. Deploy on Tomcat

- Place the project in your Tomcat `webapps` folder
- Access pages like:
  - `/web/register_customer_form.html`
  - `/web/get_all_customers.jsp`

## 📁 Project Structure

```
job-shop-accounting-system/
├── src/com/jobshop/handlers/DataHandler.java
├── web/
│   ├── register_customer_form.html
│   ├── add_customer.jsp
│   ├── get_all_customers.jsp
│   ├── retrieve_customers_form.html
│   └── retrieve_customers.jsp
├── sql/
│   ├── create_tables.sql
│   └── stored_procedures.sql
├── .gitignore
├── .project (Eclipse)
└── README.md
```

## 📸 Screenshots

Please refer the report

## 🙋‍♀️ Author

**Ramya Sruthi Pedakolimi**
