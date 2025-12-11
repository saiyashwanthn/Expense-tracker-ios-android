# Expense Tracker Mobile Application

A comprehensive Flutter-based expense tracking application for iOS and Android that allows users to manually track their expenses with customizable categories, visual analytics, and daily reminder notifications.

## Features

- ✅ **Manual Expense Entry**: Add expenses anytime with amount, description, category, and date
- ✅ **Customizable Categories**: Create and manage your own expense categories with custom icons and colors
- ✅ **Daily Reminders**: Configurable daily notifications to remind users to record expenses
- ✅ **Visual Analytics**: Interactive charts and infographics showing spending patterns by category
- ✅ **Date Range Filtering**: Analyze expenses for specific time periods
- ✅ **Category Filtering**: Filter expenses and analytics by category
- ✅ **Supabase Backend**: Secure cloud database with Row Level Security (RLS)
- 🔜 **AI Assistant**: Architecture prepared for future AI chatbot integration

## Technology Stack

- **Frontend**: Flutter (Dart)
- **Backend**: Supabase (PostgreSQL + Authentication + Real-time)
- **State Management**: Provider
- **Charts**: fl_chart
- **Notifications**: flutter_local_notifications
- **Date/Time**: intl

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   ├── expense.dart
│   ├── category.dart
│   └── user_settings.dart
├── services/                 # Business logic & API calls
│   ├── expense_service.dart
│   ├── category_service.dart
│   ├── settings_service.dart
│   └── notification_service.dart
├── providers/                # State management
│   ├── expense_provider.dart
│   ├── category_provider.dart
│   └── settings_provider.dart
├── screens/                  # UI screens
│   ├── home_screen.dart
│   ├── add_edit_expense_screen.dart
│   ├── categories_screen.dart
│   ├── add_edit_category_screen.dart
│   ├── analytics_screen.dart
│   └── settings_screen.dart
└── utils/
    └── app_config.dart       # Configuration constants
```

## Setup Instructions

### Prerequisites

- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Supabase account
- iOS Simulator / Android Emulator or physical device

### 1. Clone the Repository

```bash
git clone <repository-url>
cd Expense-tracker-ios-android
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Set Up Supabase

1. Create a new project at [supabase.com](https://supabase.com)
2. Go to SQL Editor and run the SQL script from `database/schema.sql`
3. Copy your Supabase URL and Anon Key from Project Settings > API
4. Update `lib/utils/app_config.dart` with your Supabase credentials:

```dart
static const String supabaseUrl = 'YOUR_SUPABASE_URL';
static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
```

### 4. Configure Authentication

The app uses Supabase Authentication. You'll need to:
- Enable Email authentication in Supabase Dashboard
- Configure OAuth providers if needed (optional)

### 5. Run the Application

```bash
flutter run
```

## Database Schema

The application uses three main tables:

1. **categories**: Stores expense categories (default and custom)
2. **expenses**: Stores individual expense records
3. **user_settings**: Stores user preferences (notification time, currency, etc.)

All tables have Row Level Security (RLS) enabled to ensure users can only access their own data.

## Default Categories

The app initializes with these default categories:
- 🛒 Groceries
- 🍔 Online Food
- 💡 Mandatory Bills
- 💳 Credit Card Bills
- 🚗 Transportation
- 🎬 Entertainment
- 🏥 Healthcare
- 📦 Other

Users can add, edit, or delete custom categories (default categories cannot be deleted).

## Future Enhancements

### AI Assistant Integration (Planned)

The application architecture is designed to accommodate a future AI chatbot feature:

- **Location**: `lib/services/ai_service.dart` (to be created)
- **Provider**: `lib/providers/ai_provider.dart` (to be created)
- **Screen**: `lib/screens/ai_chat_screen.dart` (to be created)
- **Integration Points**: 
  - Home screen drawer already has placeholder
  - Settings screen has "Coming Soon" section
  - Can be integrated as a floating action button or dedicated tab

The AI assistant will function as a personal financial advisor, providing:
- Expense insights and recommendations
- Budget suggestions
- Spending pattern analysis
- Personalized financial tips
- Conversational expense entry

## Documentation

Detailed documentation for each screen is available in the `docs/` directory:
- [Home Screen Documentation](docs/home_screen.md)
- [Add/Edit Expense Screen Documentation](docs/add_edit_expense_screen.md)
- [Categories Screen Documentation](docs/categories_screen.md)
- [Analytics Screen Documentation](docs/analytics_screen.md)
- [Settings Screen Documentation](docs/settings_screen.md)

## Contributing

This is a personal project, but suggestions and improvements are welcome!

## License

See LICENSE file for details.

