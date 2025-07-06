# Flutter API Usage Documentation

This document clarifies how HTTP requests are utilized within this Flutter application, differentiating between screens that make actual API calls and those that handle data locally.

## Understanding HTTP Requests in this Application

In a Flutter application, HTTP requests are used to communicate with external backend services. This involves sending data to a server (e.g., user credentials for login) and receiving data from it (e.g., user profile information, product lists).

### Pages Using HTTP Requests:

1.  **Login Screen (`login_screen.dart`)**
    *   **Purpose:** Authenticates a user against a backend service.
    *   **HTTP Method:** `POST`
    *   **Endpoint (Simulated):** `https://jsonplaceholder.typicode.com/posts`
    *   **Explanation:** While the login logic (checking username/password) is currently simulated locally within the app for demonstration purposes, an actual HTTP POST request is made to a dummy endpoint (`jsonplaceholder.typicode.com`). This allows you to observe network traffic in your development tools when attempting to log in, even though the response from the dummy endpoint doesn't dictate the login success.
    *   **Simulated Responses:**
        *   **Success (username: `user`, password: `password`):** Behaves as if a `200 OK` was received from a real authentication API.
        *   **Failure (other credentials):** Behaves as if a `401 Unauthorized` was received from a real authentication API.

2.  **Network Test Screen (`network_test_screen.dart`)**
    *   **Purpose:** Demonstrates a direct HTTP GET request to a public API.
    *   **HTTP Method:** `GET`
    *   **Endpoint:** `https://jsonplaceholder.typicode.com/posts/1`
    *   **Explanation:** This screen makes a genuine HTTP GET request to `jsonplaceholder.typicode.com`. This is a real network call, and you will see the request and its response in your network inspection tools.
    *   **Expected Responses:**
        *   `200 OK`: Successful retrieval of data.
        *   `404 Not Found`: If the resource is unavailable.

### Pages Not Using Direct HTTP Requests:

1.  **Profile Screen (`profile_screen.dart`)**
    *   **Purpose:** Displays and allows editing of user profile information (name, nickname).
    *   **Data Handling:** This screen primarily uses **local storage** (`shared_preferences` package) to persist the user's name and nickname across app launches. When you update your profile, the changes are saved directly to the device's local storage, not to a remote server via HTTP.
    *   **Explanation:** Since data is handled locally, you will **not** observe any network traffic originating from this screen's save or load operations. The `shared_preferences` package provides a simple key-value store for lightweight data persistence.

## Conclusion

This application uses HTTP requests for features that require interaction with external services (like login simulation and network testing). For user preferences and other non-critical data, local storage mechanisms are employed, which do not generate network traffic.