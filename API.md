# API Endpoints for Flutter Project

This document outlines the API endpoints used by the Flutter application.

## 1. User Authentication API

### Login
*   **URL:** `/api/auth/login`
*   **Method:** `POST`
*   **Description:** Authenticates a user and returns an authentication token.
*   **Parameters (Request Body):**
    *   `username` (string): The user's username.
    *   `password` (string): The user's password.
*   **Success Response:**
    *   **Code:** `200 OK`
    *   **Content:** `{ "token": "jwt_token_string", "userId": "user_id" }`
*   **Error Response:**
    *   **Code:** `401 Unauthorized`
    *   **Content:** `{ "message": "Invalid credentials" }`

## 2. User Profile API

### Get User Profile
*   **URL:** `/api/profile/{userId}`
*   **Method:** `GET`
*   **Description:** Retrieves the profile information for a specific user.
*   **Parameters (Path):**
    *   `userId` (string): The ID of the user.
*   **Success Response:**
    *   **Code:** `200 OK`
    *   **Content:** `{ "name": "User Name", "nickname": "User Nickname" }`
*   **Error Response:**
    *   **Code:** `404 Not Found`
    *   **Content:** `{ "message": "User not found" }`

### Update User Profile
*   **URL:** `/api/profile/{userId}`
*   **Method:** `PUT`
*   **Description:** Updates the profile information for a specific user.
*   **Parameters (Path):**
    *   `userId` (string): The ID of the user.
*   **Parameters (Request Body):**
    *   `name` (string, optional): The new name for the user.
    *   `nickname` (string, optional): The new nickname for the user.
*   **Success Response:**
    *   **Code:** `200 OK`
    *   **Content:** `{ "message": "Profile updated successfully" }`
*   **Error Responses:**
    *   **Code:** `400 Bad Request`
    *   **Content:** `{ "message": "Invalid input data" }`
    *   **Code:** `404 Not Found`
    *   **Content:** `{ "message": "User not found" }`

## 3. Product Catalog API

### Get All Products
*   **URL:** `/api/products`
*   **Method:** `GET`
*   **Description:** Fetches a list of all available products.
*   **Success Response:**
    *   **Code:** `200 OK`
    *   **Content:** `[ { "id": "prod1", "name": "Product A", "price": 10.00 }, ... ]`

### Get Product Details
*   **URL:** `/api/products/{productId}`
*   **Method:** `GET`
*   **Description:** Retrieves details for a specific product.
*   **Parameters (Path):**
    *   `productId` (string): The ID of the product.
*   **Success Response:**
    *   **Code:** `200 OK`
    *   **Content:** `{ "id": "prod1", "name": "Product A", "description": "...", "price": 10.00 }`
*   **Error Response:**
    *   **Code:** `404 Not Found`
    *   **Content:** `{ "message": "Product not found" }`

## 4. Order Processing API

### Create New Order
*   **URL:** `/api/orders`
*   **Method:** `POST`
*   **Description:** Creates a new order.
*   **Parameters (Request Body):**
    *   `userId` (string): The ID of the user placing the order.
    *   `items` (array of objects): List of items in the order. Each object: `{ "productId": "string", "quantity": "integer" }`
*   **Success Response:**
    *   **Code:** `201 Created`
    *   **Content:** `{ "orderId": "order123", "status": "pending" }`
*   **Error Response:**
    *   **Code:** `400 Bad Request`
    *   **Content:** `{ "message": "Invalid order data" }`

### Get Order Details
*   **URL:** `/api/orders/{orderId}`
*   **Method:** `GET`
*   **Description:** Retrieves details for a specific order.
*   **Parameters (Path):**
    *   `orderId` (string): The ID of the order.
*   **Success Response:**
    *   **Code:** `200 OK`
    *   **Content:** `{ "orderId": "order123", "userId": "user_id", "items": [...], "status": "completed", "total": 50.00 }`
*   **Error Response:**
    *   **Code:** `404 Not Found`
    *   **Content:** `{ "message": "Order not found" }`
