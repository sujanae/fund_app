# Overview

This is a mobile application built using Flutter that allows users to create, view, and donate to fundraising campaigns. The app is powered by Supabase for backend services and PostgreSQL for database management. It features secure authentication, real-time updates, and user-friendly interfaces.

## Features

- User Authentication: Sign up and log in securely.
- Campaign Management: Create, edit, and delete campaigns.
- Donations: Support campaigns with a simple donation process.
- Progress Tracking: View campaign funding progress in real-time.

## Tech Stack

- Frontend: Flutter
- Backend: Supabase
- Database: PostgreSQL
- Version Control: Git

## Installation

    
### Prerequisites

- Flutter SDK.
- A Supabase account.

### Steps

- Clone this repository:
    ```git clone https://github.com/yourusername/fund_app.git```
-  Navigate to the project directory:
    ```cd fund_app```
- Install dependencies:
    ```flutter pub get```
- Set up your Supabase backend and update the API keys in the lib/constants.dart file:
    ```const String supabaseUrl = "your-supabase-url";
    const String supabaseKey = "your-supabase-key";```
- Run the app:
    ```flutter run```







