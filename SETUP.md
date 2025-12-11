# Setup Guide

## Quick Start

### 1. Prerequisites
- Flutter SDK 3.0.0 or higher
- Dart SDK
- Supabase account (free tier available)
- iOS Simulator / Android Emulator or physical device

### 2. Clone and Install
```bash
# Clone the repository
git clone <repository-url>
cd Expense-tracker-ios-android

# Install dependencies
flutter pub get
```

### 3. Supabase Setup

#### Step 1: Create Supabase Project
1. Go to [supabase.com](https://supabase.com)
2. Sign up or log in
3. Click "New Project"
4. Fill in project details:
   - Name: Expense Tracker
   - Database Password: (choose a strong password)
   - Region: (choose closest to you)
5. Wait for project to be created (2-3 minutes)

#### Step 2: Set Up Database Schema
1. In Supabase Dashboard, go to **SQL Editor**
2. Click **New Query**
3. Copy the entire contents of `database/schema.sql`
4. Paste into SQL Editor
5. Click **Run** (or press Cmd/Ctrl + Enter)
6. Verify tables are created by checking **Table Editor**

#### Step 3: Get API Credentials
1. In Supabase Dashboard, go to **Project Settings** (gear icon)
2. Click **API** in the sidebar
3. Copy the following:
   - **Project URL** (under "Project URL")
   - **anon public** key (under "Project API keys")

#### Step 4: Configure App
1. Copy `lib/utils/app_config.example.dart` to `lib/utils/app_config.dart`:
   ```bash
   cp lib/utils/app_config.example.dart lib/utils/app_config.dart
   ```
2. Open `lib/utils/app_config.dart`
3. Replace placeholders:
   ```dart
   static const String supabaseUrl = 'https://your-project.supabase.co';
   static const String supabaseAnonKey = 'your-anon-key-here';
   ```

### 4. Configure Authentication (Optional but Recommended)

#### Enable Email Authentication
1. In Supabase Dashboard, go to **Authentication** > **Providers**
2. Enable **Email** provider
3. Configure email templates if desired

#### For Testing (Development Only)
You can use Supabase's built-in test users or create accounts through the app.

### 5. Run the Application

#### iOS
```bash
flutter run -d ios
```

#### Android
```bash
flutter run -d android
```

#### Specific Device
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device-id>
```

### 6. First Launch
1. The app will initialize default categories automatically
2. You'll need to authenticate (if authentication is enabled)
3. Start adding expenses!

## Troubleshooting

### Common Issues

#### 1. Supabase Connection Error
- **Problem**: "Failed to connect to Supabase"
- **Solution**: 
  - Verify URL and key in `app_config.dart`
  - Check internet connection
  - Verify Supabase project is active

#### 2. Database Errors
- **Problem**: "Table does not exist" or RLS errors
- **Solution**: 
  - Run `database/schema.sql` again in Supabase SQL Editor
  - Check that RLS policies are created
  - Verify user is authenticated

#### 3. Notification Not Working
- **Problem**: Daily reminders not appearing
- **Solution**:
  - Check notification permissions in device settings
  - Verify notification time is set in Settings screen
  - For iOS: Ensure notifications are enabled in app settings

#### 4. Build Errors
- **Problem**: Flutter build fails
- **Solution**:
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```

#### 5. iOS Specific Issues
- **Problem**: CocoaPods errors
- **Solution**:
  ```bash
  cd ios
  pod deintegrate
  pod install
  cd ..
  flutter run
  ```

## Development Tips

### Hot Reload
- Press `r` in terminal to hot reload
- Press `R` to hot restart
- Press `q` to quit

### Debugging
- Use `print()` statements for debugging
- Flutter DevTools: `flutter pub global activate devtools` then `flutter pub global run devtools`

### Testing on Physical Devices

#### iOS
1. Connect iPhone via USB
2. Trust computer on iPhone
3. Open Xcode and sign with Apple ID
4. Run: `flutter run -d ios`

#### Android
1. Enable USB Debugging on Android device
2. Connect via USB
3. Run: `flutter run -d android`

## Next Steps

1. **Customize Categories**: Add your own expense categories
2. **Set Reminder Time**: Configure daily notification time in Settings
3. **Start Tracking**: Add your first expense!
4. **Explore Analytics**: View spending patterns and insights

## Support

For issues or questions:
1. Check the documentation in `docs/` folder
2. Review `README.md` for feature overview
3. Check Supabase documentation for backend issues

