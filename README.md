# Digital Home Library

A modern, desktop-based library management system built with Qt 6 (C++/QML) and PostgreSQL. Keep track of your personal book collection, including books you've loaned out to friends or borrowed from others.

## Features

*   **Manage Collection**: Add books with Title and Author.
*   **Track Status**: Mark books as "SHELF" (owned), "LOANED" (lent to someone), or "BORROWED" (from someone).
*   **Contact Tracking**: Automatically capture contact name and number for loaned or borrowed items.
*   **Material Design**: Clean and modern UI using Qt Quick Controls 2 Material style.
*   **Persistent Storage**: All data is stored securely in a local PostgreSQL database.

## Prerequisites

*   **Qt 6.8+** (with Qt Quick, Qt SQL, and Qt Quick Controls 2 modules)
*   **PostgreSQL** (Local server running)
*   **C++ Compiler** (GCC, Clang, or MSVC)
*   **CMake**

## Setup

### 1. Database Configuration

1.  Ensure your PostgreSQL server is running.
2.  Create a database (default configured is `mwanatech_db`).
3.  The application will automatically create the necessary `books` table on the first run if it doesn't exist.
4.  **Important**: If your credentials differ, update `DatabaseManager.cpp` with your local database credentials:
    ```cpp
    m_db.setDatabaseName("mwanatech_db");
    m_db.setUserName("your_username");
    m_db.setPassword("your_password");
    ```

### 2. Build the Application

```bash
mkdir build
cd build
cmake ..
cmake --build .
```

### 3. Run

```bash
./appMwanatech
```

## Project Structure

*   **Main.qml**: The user interface defined in Qt Quick.
*   **LibraryModel.cpp/h**: C++ data model bridging the UI and the database.
*   **DatabaseManager.cpp/h**: Handles PostgreSQL connection and queries.
*   **qtquickcontrols2.conf**: Configuration for the Material Design theme.
