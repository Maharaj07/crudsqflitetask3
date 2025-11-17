# untitled3

A Flutter app with Signup/Login (sqflite) and CRUD module.

## Getting Started

This project is a starting point for a Flutter application.

## Project folder structure

lib/
│
├── main.dart
│
├── database/
│   └── database_helper.dart
│
├── models/
│   ├── user.dart
│   └── person.dart
│
├── screens/
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── person_list_screen.dart
│   └── person_form_screen.dart
│
└── widgets/
└── custom_input_field.dart


🛠️ Features Explained 
1. User Authentication

The app provides two auth screens:

Sign Up

User enters username, email, and password.

Email is validated (format check).

Password is validated (> 6 chars).

Before creating a user, app checks if email already exists in DB.

User is saved into SQLite.

Login

User enters email & password.

App checks credentials from SQLite.

If matched → navigates to HomeScreen.

If not → shows error Snackbar.


 2. SQLite Database (sqflite)

We use sqflite package for storing:

users table, persons table.

🧩 Database Helper Explained

The class DatabaseHelper:

Creates DB if not exists.

Creates tables.

Exposes CRUD methods.

Ensures singleton (only one DB connection).

All SQLite operations are handled inside database_helper.dart.

 3. CRUD for Persons
✔ Add a person
✔ Edit a person
✔ Delete a person
✔ List all persons
✔ Search by name/email

Handled inside:

person_list_screen.dart

person_form_screen.dart


📱 Screens Overview
🔐 Login Screen

Email + Password fields

Eye toggle for password

Validates empty inputs

Calls SQLite for login

📝 Signup Screen

Username, Email, Password

Email + password validation

Checks duplicate email

Inserts user

🏠 Home Screen

Simple screen showing navigation options.

👥 Person List Screen

Fetches all persons from SQLite

Search bar

Add button

Edit & Delete actions

🧾 Person Form Screen

Add or Update a person

Validates inputs

Saves to SQLite



