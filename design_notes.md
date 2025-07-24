# Design Notes

## 1. Architectural Overview

### 1.1 Frontend (Flutter)
The Flutter app follows a **Model‑View‑Controller** (MVC) pattern for clarity and separation of concerns:

- **Model**
  - Defines data structures for `Expense`, `User`.
  - Parses JSON responses and serializes objects when sending requests.

- **View**
  - Composed of clean, reusable widgets organized in `screens/` (e.g., `HomeScreen`, `AddExpenseScreen`, `SummaryScreen`).
  - Uses Flutter’s built‑in theming to maintain consistent UI/UX.
  - Includes chart widgets (bar/pie) to visualize expense summaries.

- **Controller**
  - Resides in `providers/` directory.
  - Handles user input, invokes API calls (via `DioService`), and notifies Views when data changes.
  - Coordinates with local storage (shared_preferences) for offline support.

# Backend Design Notes

## 1. Architectural Overview

### 1.1 Controllers

The Controllers handle incoming HTTP requests, parse and validate inputs, invoke services, and send responses.

* **Location:** `src/controllers/`

* **Routes & Handlers:**
  * `POST /auth/signup` → `signUp`
  * `POST /auth/signin` → `signIn`
  * `GET /expenses/` → `getExpenses`
  * `POST /expenses/` → `addExpense`
  * `DELETE /expenses/` → `deleteExpense`

* **Responsibilities:**
  * Extract and sanitize request data
  * Call corresponding Service methods
  * Return JSON or stream CSV

### 1.2 Services

The Services layer encapsulates business logic and data access.

* **Location:** `src/services/`

* **Modules:**

  * `expenseService`
    * `createExpense(data)`

* **Responsibilities:**
  * Implement core business rules
  * Interact with the data store (JSON, MongoDB, or PostgreSQL)

### 1.3 Validation

Input validation ensures only correct data reaches Controllers.

* **Location:** `src/validation/`
* **Tool:** Joi or similar schema-validator
* **Schemas:**
  * `authSchema` (for POST /auth)
  * `expenseSchema` (for POST /expenses)

### 1.4 Middlewares

Middlewares provide cross-cutting concerns.

* **Location:** `src/middlewares/`
* **Key Middlewares:**

  * `authMiddleware` (JWT or OTP verification)
  * `errorHandler` (centralized error formatting)
  * `requestLogger` (logs method, path, status, duration)

### 2.0 Error Handling & Edge Cases

* **No Data:** Respond with `204 No Content`.
* **Invalid Params:** Validation middleware returns `400 Bad Request`.
* **Streaming Errors:** Caught by `errorHandler`, returns `500 Internal Server Error` with code `export_error`.

---
