# E-Commerce Backend API

A backend-focused e-commerce application built with Java and Spring Boot as a practical learning project.

The main purpose of this project is to understand backend development fundamentals and how different backend components work together to build a structured REST API application.

> **Project Status:** Version 1 - In Development

---

## Project Overview

This project provides REST APIs for an e-commerce application.

The application is divided into three main areas:

1. Products
2. Cart
3. Orders

The core focus of the project is:

* REST API development
* DTOs
* Request validation
* Exception handling
* SQL and JDBC
* JdbcTemplate
* JWT-based authentication
* Authorization
* Logging
* Pagination
* Filtering
* Sorting
* Dynamic search
* Cart management
* Order processing
* Inventory management

---

## Project Goals

The project is being developed to gain practical experience with backend development concepts such as:

* Designing REST APIs
* Working with HTTP methods
* Handling request and response data
* Using DTOs
* Validating client input
* Handling exceptions globally
* Working directly with SQL
* Using JDBC / JdbcTemplate
* Implementing authentication and authorization
* Working with JWT tokens
* Implementing pagination, filtering, and sorting
* Managing cart and order workflows
* Managing product inventory
* Logging application events and errors
* Documenting APIs using OpenAPI / Swagger

---

# Core Functional Areas

## 1. Products

The product section is publicly accessible and does not require authentication for browsing products.

Clients will be able to:

* Find products
* Search products
* Filter products
* Sort products
* Paginate products
* Perform dynamic searches
* View detailed product information

Product information includes:

* Product name
* Brand
* Category
* Model number
* Price
* Quantity
* Description
* Variants

Product APIs are designed to support common e-commerce product browsing requirements such as searching, filtering, sorting, and pagination.

---

## 2. Cart

The cart represents a user's temporary collection of products before placing an order.

### Cart Rules

* One user can have one active cart at a time.
* A cart can contain multiple cart items.
* Cart data is temporary.
* After an order is successfully placed, the active cart is disbanded.
* The same user can create or use another cart for a future order.
* A cart can show final invoice-related information for convenience.
* Applicable discounts and charges can be included in the final calculation.

The cart is not intended to represent the user's permanent order history.

---

## 3. Orders

The order section handles the process of converting a cart into a finalized order.

Order-related operations require authentication.

The order system handles:

* Cart-to-order conversion
* Address collection
* Inventory validation
* Order confirmation
* Inventory updates
* Order cancellation
* Inventory restoration after cancellation

### General Order Flow

```text
Browse Products
      ↓
Add Products to Cart
      ↓
Review Cart
      ↓
Sign In / Authenticate
      ↓
Provide Address
      ↓
Confirm Order
      ↓
Validate Inventory
      ↓
Create Order
      ↓
Update Inventory
      ↓
Disband Active Cart
```

---

# Authentication and Authorization

The application uses JWT-based authentication for protected APIs.

### Authentication Flow

```text
User Signup
     ↓
User Sign In
     ↓
Validate Credentials
     ↓
Generate JWT
     ↓
Client Receives Token
     ↓
Client Sends JWT With Protected Requests
     ↓
Server Validates Token
     ↓
Request Is Authenticated
```

JWT authentication is used to protect operations that require a logged-in user.

### Public Operations

Examples of operations that can be accessed without authentication:

* Browse products
* Search products
* Filter products
* Sort products
* Pagination
* Signup
* Sign in

### Protected Operations

Examples of operations that require authentication:

* Cart operations associated with a user
* Creating orders
* Viewing user-specific orders
* Cancelling orders
* Other user-specific operations

### Authentication vs Authorization

**Authentication** determines whether the user is properly identified.

**Authorization** determines whether the authenticated user has permission to perform a particular operation.

---

# REST API Design

The application follows REST-style API design principles.

## HTTP Methods

| Method | General Purpose                     |
| ------ | ----------------------------------- |
| GET    | Retrieve data                       |
| POST   | Create data or perform an operation |
| PUT    | Update existing data                |
| DELETE | Delete data                         |

### Request Data

Depending on the endpoint, data can be received through:

* Request body
* Query parameters
* Path variables

Example:

```text
GET /api/products
GET /api/products/{id}
GET /api/products?category=mobile
POST /api/cart/items
POST /api/orders
PUT /api/products/{id}
DELETE /api/cart/items/{id}
```

Detailed endpoint documentation is maintained using OpenAPI / Swagger.

---

# DTOs

DTOs (Data Transfer Objects) are used to control the data transferred between the client and the backend.

DTOs help separate API request and response structures from internal database structures.

### General Request Flow

```text
Client Request
      ↓
Request DTO
      ↓
Validation
      ↓
Business Logic
      ↓
Database
```

DTOs are used to:

* Control incoming data
* Control outgoing data
* Avoid exposing unnecessary internal fields
* Apply request validation
* Keep API structures independent of database structures 

---

# Validation

Request validation is used to ensure that client-provided data satisfies the required rules before business logic is executed.

Validation may include:

* Required fields
* Email format
* Password requirements
* Product information
* Quantity validation
* Address information
* Request-specific business rules

Invalid requests should be rejected with an appropriate HTTP response.

---

# Exception Handling

The application uses centralized exception handling for REST APIs.

The main mechanisms include:

* `@RestControllerAdvice`
* `@ExceptionHandler`
* Custom exceptions

Examples of errors handled by the application:

* Resource not found
* Invalid request
* Validation errors
* Authentication errors
* Authorization errors
* Insufficient inventory
* Invalid business operations
* Database-related errors
* Unexpected server errors

Centralized exception handling keeps error responses consistent across the application.

---

# HTTP Status Codes

The API uses HTTP status codes to communicate the result of requests.

| Status Code | Meaning                                  |
| ----------- | ---------------------------------------- |
| 200         | Request successful                       |
| 201         | Resource created                         |
| 204         | Request successful with no response body |
| 400         | Bad request                              |
| 401         | Authentication required or failed        |
| 403         | Access forbidden                         |
| 404         | Resource not found                       |
| 409         | Conflict                                 |
| 500         | Internal server error                    |

The exact status code depends on the result and type of operation.

---

# Logging

Logging is used to monitor application behavior and help with debugging.

Logging may be used for:

* Application startup
* Request processing
* Authentication events
* Important business operations
* Order processing
* Inventory operations
* Exceptions
* Database errors
* Debugging information

Sensitive information must not be logged.

The application should never log:

* Passwords
* JWT secrets
* Database passwords
* API keys
* Other sensitive credentials

---

# Database

The application uses PostgreSQL as the relational database.

The project focuses on understanding SQL and database operations directly rather than depending only on ORM abstractions.

### Database Concepts Covered

* Tables
* Primary keys
* Foreign keys
* Constraints
* Relationships
* Joins
* Queries
* Inserts
* Updates
* Deletes
* Transactions
* Indexes
* Inventory updates

### Main Database Areas

The database contains tables for areas such as:

* Accounts
* Profiles
* Addresses
* Products
* Carts
* Cart Items
* Orders
* Order Items
* Sales

The application uses JDBC / JdbcTemplate for database interaction.

---

# Inventory Management

Inventory is handled as part of the order workflow.

Before an order is finalized, the application validates whether sufficient stock is available.

Example:

```text
Available Quantity = 10
Requested Quantity = 3

Remaining Quantity = 7
```

The order process should prevent an order from being finalized when sufficient inventory is not available.

When an eligible order is canceled, the corresponding inventory can be restored.

---

# Cart and Order Relationship

The cart is temporary, while an order represents a finalized purchase request.

```text
Cart
 ↓
Review
 ↓
Order Confirmation
 ↓
Inventory Validation
 ↓
Order Creation
 ↓
Inventory Update
 ↓
Cart Disbanded
```

The order retains the information required for the order history even after the active cart is disbanded.

---

# Payment

Version 1 does not process real-money payments.

The project focuses on:

* Product management
* Cart management
* Order processing
* Inventory management
* Authentication
* Authorization
* Backend fundamentals

Payment gateway integration and payment transaction handling are planned for a future version.

> Database transactions and real-money payment transactions are different concepts. The absence of payment processing in Version 1 does not mean database transaction management cannot be used.

---

# Project Structure

```text
src/
└── main/
    └── java/
        └── com.test.e com/
            ├── admin/
            ├── user/
            └── globalExceptions/
```

The project structure may evolve as the application grows.

---

# Technology Stack

## Backend

* Java
* Spring Boot
* Spring Web
* Spring JDBC
* JdbcTemplate
* Spring Validation
* Spring Security
* JWT Authentication

## Database

* PostgreSQL
* SQL
* JDBC

## Build Tool

* Maven

## Development Tools

* IntelliJ IDEA
* Git
* GitHub
* Postman

## API Documentation

* OpenAPI
* Swagger

## Planned / Additional Features

* Email service
* Email verification
* OTP verification
* OAuth 2.0
* Automated testing
* Payment gateway integration

---

# Configuration

Sensitive configuration values are stored using environment variables instead of committing credentials to the repository.

Example configuration:

```properties
spring.datasource.url=${DB_URL}
spring.datasource.username=${DB_USERNAME}
spring.datasource.password=${DB_PASSWORD}

jwt.secret=${JWT_SECRET}
```

Actual database credentials, JWT secrets, API keys, and other sensitive values should not be committed to GitHub.

The project's local `application.properties` file containing sensitive configuration should remain excluded from version control when appropriate.

---

# Running the Project

## Prerequisites

Make sure the following are installed:

* Java
* Maven
* PostgreSQL
* Git

## Clone the Repository

```bash
git clone <repository-url>
```

Move into the project directory:

```bash
cd E-com
```

## Configure Environment Variables

Configure the required environment variables on the local machine.

Example:

```text
DB_URL
DB_USERNAME
DB_PASSWORD
JWT_SECRET
```

The actual values depend on the local development environment.

## Run With Maven Wrapper

### Windows

```bash
mvnw.cmd spring-boot:run
```

### Linux / macOS

```bash
./mvnw spring-boot:run 
```

---

# API Documentation

The API is documented using OpenAPI / Swagger.

Swagger documentation provides information about:

* Available endpoints
* HTTP methods
* Request parameters
* Path variables
* Request bodies
* Response bodies
* HTTP status codes
* Authentication requirements
* Request and response schemas

When the application is running locally, the Swagger UI can typically be accessed at:

```text
http://localhost:8080/swagger-ui/index.html
```

The exact URL may depend on the project's configuration.

---

# API Testing

The APIs can be tested using tools such as Postman and Swagger UI.

Testing includes:

* Product APIs
* Search
* Filtering
* Sorting
* Pagination
* Cart operations
* Authentication
* JWT-protected requests
* Authorization
* Order creation
* Order cancellation
* Validation errors
* Exception handling
* HTTP status codes
* Inventory scenarios

---

# Version Roadmap

## Version 1

### Product Features

* [ ] Product APIs
* [ ] Product search
* [ ] Filtering
* [ ] Sorting
* [ ] Pagination
* [ ] Dynamic search
* [ ] Product details

### Cart Features

* [ ] Create active cart
* [ ] Add cart items
* [ ] Update cart items
* [ ] Remove cart items
* [ ] Cart calculations
* [ ] Discounts and charges

### Order Features

* [ ] Cart-to-order conversion
* [ ] Address handling
* [ ] Inventory validation
* [ ] Order creation
* [ ] Inventory update
* [ ] Order cancellation
* [ ] Inventory restoration

### Backend Fundamentals

* [ ] REST APIs
* [ ] DTOs
* [ ] Validation
* [ ] Custom exceptions
* [ ] Global exception handling
* [ ] SQL
* [ ] JDBC / JdbcTemplate
* [ ] JWT authentication
* [ ] Authorization
* [ ] Logging
* [ ] API documentation
* [ ] API testing

### Additional Version 1 Features

* [ ] Email service
* [ ] Email verification
* [ ] OTP verification
* [ ] OAuth 2.0

---

# Version 2

Planned improvements include:

* Payment gateway integration
* Real payment transaction handling
* Improved payment and order states
* Advanced security
* Performance improvements
* Automated testing
* Production-oriented improvements
* Additional backend services

---

# Project Purpose

This project is primarily a practical Java and Spring Boot backend learning project.

The goal is to understand how the different components of a backend application work together.

A simplified request flow is:

```text
Client
  ↓
REST Controller
  ↓
Request DTO
  ↓
Validation
  ↓
Business Logic
  ↓
JdbcTemplate
  ↓
SQL
  ↓
PostgresSQL
  ↓
Response
```

For protected requests:

```text
Client
  ↓
JWT
  ↓
Authentication
  ↓
Authorization
  ↓
REST Controller
  ↓
Validation
  ↓
Business Logic
  ↓
Database
  ↓
Response
```

The project is being developed incrementally so that each backend concept can be understood and implemented practically.

---

# Author

**DAKSH**

Java / Spring Boot Backend Learning Project
