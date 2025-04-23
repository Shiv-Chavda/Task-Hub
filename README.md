# Task Hub

A Flutter task management application that uses Supabase for authentication and data storage.

## Features

- User authentication (signup, login, logout)
- Task management (create, read, update, delete)
- Light/dark theme switching
- Responsive design


## Requirements

- Flutter 3.0.0 or higher
- Dart 2.17.0 or higher
- A Supabase account
- Git

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/yourusername/task_hub.git
cd task_hub
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Set up Environment Variables

Create a `.env` file in the root of your project with the following content:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 4. Run the App

```bash
flutter run
```

## Supabase Setup

### 1. Create a Supabase Project

1. Sign up for a Supabase account at [supabase.com](https://supabase.com)
2. Create a new project and note down the URL and anon key
3. Add these credentials to your `.env` file

### 2. Set up the Database Schema

1. Navigate to the SQL Editor in your Supabase dashboard
2. Run the following SQL commands to create the necessary tables:

```sql
-- Create a table for users
CREATE TABLE IF NOT EXISTS profiles (
  id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
  username TEXT UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create a table for tasks
CREATE TABLE IF NOT EXISTS tasks (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  is_completed BOOLEAN DEFAULT FALSE,
  due_date TIMESTAMP WITH TIME ZONE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Set up RLS (Row Level Security)
ALTER TABLE tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Users can view their own tasks" ON tasks
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can create their own tasks" ON tasks
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own tasks" ON tasks
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own tasks" ON tasks
  FOR DELETE USING (auth.uid() = user_id);
```

### 3. Set up Authentication

1. Go to Authentication > Settings in your Supabase dashboard
2. Configure the authentication providers you want to use (Email, Google, etc.)
3. For email authentication, you can enable "Confirm email" if you want users to verify their email

## Hot Reload vs Hot Restart

Flutter provides two powerful features for development: Hot Reload and Hot Restart. Understanding the difference between them can improve your development workflow.

### Hot Reload (⚡️)

Hot Reload quickly updates the UI without losing the current state of your app. When you press the hot reload button or use the shortcut `r` in the terminal:

- Injects updated source code into the running Dart VM
- Updates the widget tree
- Preserves the app state (variables, navigation stack, etc.)
- Takes less time (typically under a second)

**Best for:** UI changes, adding new widgets, modifying widget parameters

**Limitations:**
- Cannot handle changes to initialization code
- Does not reset state variables
- Might not work for changes in class hierarchy or static fields

### Hot Restart (🔄)

Hot Restart completely resets the application state and rebuilds it from scratch. When you press the hot restart button or use the shortcut `R` in the terminal:

- Recompiles the Dart code and restarts the Dart VM
- Loses all state information
- Takes more time than Hot Reload
- Applies all code changes completely

**Best for:** Changes to initialization code, state logic, or when Hot Reload doesn't work correctly

**When to use:**
- After changing class hierarchies
- When modifying static field initializers
- When changing the `main()` function
- When changing dependencies in `pubspec.yaml`

## Troubleshooting

### Common Issues

1. **Supabase Connection Error**
   - Check if your `.env` file contains the correct Supabase URL and anon key
   - Ensure you have an active internet connection

2. **Flutter Build Errors**
   - Try running `flutter clean` followed by `flutter pub get`
   - Check for dependency conflicts in `pubspec.yaml`

3. **Hot Reload Not Working**
   - Try Hot Restart instead
   - Check terminal for error messages
   - Restart the Flutter development server

## License

[Add your license information here]
