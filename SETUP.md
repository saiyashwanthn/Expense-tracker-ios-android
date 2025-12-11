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

## How to Run on Emulators

### Prerequisites for Emulators

#### iOS Simulator (macOS only)
- Xcode installed from Mac App Store
- Xcode Command Line Tools: `xcode-select --install`
- iOS Simulator (comes with Xcode)

#### Android Emulator
- Android Studio installed
- Android SDK installed
- At least one Android Virtual Device (AVD) created

---

## iOS Simulator Setup and Running

### Step 1: Install Xcode (if not already installed)
1. Open **Mac App Store**
2. Search for "Xcode"
3. Click **Get** or **Install** (large download, ~10GB+)
4. Wait for installation to complete
5. Open Xcode and accept license agreements

### Step 2: Install Command Line Tools
```bash
xcode-select --install
```
Follow the prompts to install.

### Step 3: Verify Flutter iOS Setup
```bash
flutter doctor
```
Check that iOS toolchain shows no issues. If there are issues, run:
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

### Step 4: List Available iOS Simulators
```bash
flutter emulators
```
Or use:
```bash
xcrun simctl list devices
```

### Step 5: Launch iOS Simulator
**Option A: Launch from Flutter**
```bash
flutter emulators --launch apple_ios_simulator
```

**Option B: Launch from Xcode**
1. Open **Xcode**
2. Go to **Xcode** > **Open Developer Tool** > **Simulator**
3. Choose device: **File** > **Open Simulator** > Select iOS version and device

**Option C: Launch specific simulator**
```bash
open -a Simulator
```

### Step 6: Verify Simulator is Running
```bash
flutter devices
```
You should see something like:
```
iPhone 15 Pro (mobile) • 12345678-1234-1234-1234-123456789ABC • ios • com.apple.CoreSimulator.SimRuntime.iOS-17-0
```

### Step 7: Run the App on iOS Simulator
```bash
# Make sure you're in the project directory
cd Expense-tracker-ios-android

# Run the app
flutter run -d ios
```

Or if you have multiple devices:
```bash
flutter run -d <device-id>
```

### Step 8: First Build (Takes Longer)
- First build may take 5-10 minutes
- Subsequent builds are much faster
- You'll see "Running Gradle task 'assembleDebug'..." for Android or "Building iOS app..." for iOS

---

## Android Emulator Setup and Running

### Step 1: Install Android Studio
1. Download from [developer.android.com/studio](https://developer.android.com/studio)
2. Install Android Studio
3. Open Android Studio and complete setup wizard
4. Install Android SDK (recommended: Android 11+)

### Step 2: Create Android Virtual Device (AVD)
1. Open **Android Studio**
2. Click **More Actions** > **Virtual Device Manager** (or **Tools** > **Device Manager**)
3. Click **Create Device**
4. Select device (e.g., **Pixel 5**)
5. Click **Next**
6. Select system image (e.g., **Android 13 (Tiramisu)**)
   - If not downloaded, click **Download** next to the system image
7. Click **Next**
8. Review configuration and click **Finish**

### Step 3: Verify Flutter Android Setup
```bash
flutter doctor
```
Ensure Android toolchain shows no critical issues.

### Step 4: Accept Android Licenses (if needed)
```bash
flutter doctor --android-licenses
```
Press `y` to accept all licenses.

### Step 5: List Available Android Emulators
```bash
flutter emulators
```
You should see your created AVD listed.

### Step 6: Launch Android Emulator
**Option A: Launch from Flutter**
```bash
flutter emulators --launch <emulator-id>
```

**Option B: Launch from Android Studio**
1. Open **Android Studio**
2. Go to **Tools** > **Device Manager**
3. Click **Play** button next to your AVD

**Option C: Launch from Command Line**
```bash
emulator -avd <avd-name>
```

### Step 7: Verify Emulator is Running
```bash
flutter devices
```
You should see something like:
```
sdk gphone64 arm64 (mobile) • emulator-5554 • android-arm64 • Android 13 (API 33)
```

### Step 8: Run the App on Android Emulator
```bash
# Make sure you're in the project directory
cd Expense-tracker-ios-android

# Run the app
flutter run -d android
```

Or specify device:
```bash
flutter run -d emulator-5554
```

---

## Step-by-Step Testing Guide

### Pre-Testing Checklist
- [ ] Supabase project created and configured
- [ ] Database schema executed in Supabase SQL Editor
- [ ] `app_config.dart` updated with Supabase credentials
- [ ] Emulator/simulator is running
- [ ] App builds successfully

### Test 1: App Launch and Initial Setup
1. **Launch the app** on emulator
2. **Expected**: App opens to Home Screen
3. **Check**: Default categories should be initialized automatically
4. **Verify**: No error messages appear
5. **Result**: ✅ App launches successfully

### Test 2: Add Expense
1. **Tap** the **"Add Expense"** floating action button (FAB)
2. **Select** a category from dropdown (e.g., "Groceries")
3. **Enter** amount: `25.50`
4. **Enter** description: `Weekly groceries`
5. **Select** date (default is today)
6. **Tap** "Add Expense" button
7. **Expected**: 
   - Success message appears
   - Returns to Home Screen
   - New expense appears in list
8. **Result**: ✅ Expense added successfully

### Test 3: View Expense List
1. **Navigate** to Home Screen (if not already there)
2. **Verify**: Added expense appears in list
3. **Check**: Expense shows:
   - Category name
   - Description
   - Date
   - Amount (in red)
4. **Test**: Pull down to refresh
5. **Result**: ✅ Expenses display correctly

### Test 4: Edit Expense
1. **Tap** on an expense card
2. **Expected**: Opens Edit Expense screen with pre-filled data
3. **Change** amount to `30.00`
4. **Change** description to `Updated groceries`
5. **Tap** "Update Expense" button
6. **Expected**: 
   - Success message
   - Returns to Home Screen
   - Expense shows updated values
7. **Result**: ✅ Expense edited successfully

### Test 5: Delete Expense
1. **Tap** on an expense card
2. **Tap** delete icon (trash) in app bar
3. **Confirm** deletion in dialog
4. **Expected**: 
   - Success message
   - Returns to Home Screen
   - Expense removed from list
5. **Result**: ✅ Expense deleted successfully

### Test 6: Create Custom Category
1. **Navigate** to Categories screen (via drawer menu)
2. **Tap** floating action button (+)
3. **Enter** category name: `Coffee`
4. **Select** icon: ☕
5. **Select** color: Orange
6. **Tap** "Add Category" button
7. **Expected**: 
   - Success message
   - New category appears in list
8. **Result**: ✅ Custom category created

### Test 7: Use Custom Category
1. **Go back** to Home Screen
2. **Add** new expense
3. **Select** your custom "Coffee" category
4. **Enter** amount and description
5. **Save** expense
6. **Verify**: Expense appears with Coffee category
7. **Result**: ✅ Custom category works correctly

### Test 8: View Analytics
1. **Navigate** to Analytics screen (via drawer or app bar icon)
2. **Expected**: 
   - Shows current month's total expenses
   - Pie chart displays (if expenses exist)
   - Category breakdown list shows
3. **Test**: Change date range
   - Tap calendar icon
   - Select different date range
   - Verify data updates
4. **Test**: Filter by category
   - Select category from dropdown
   - Verify filtered results
5. **Result**: ✅ Analytics display correctly

### Test 9: Configure Settings
1. **Navigate** to Settings screen (via drawer)
2. **Toggle** "Daily Reminder" switch ON
3. **Tap** "Reminder Time"
4. **Select** time (e.g., 9:00 PM)
5. **Expected**: 
   - Time updates
   - Notification scheduled (check device notifications)
6. **Toggle** switch OFF
7. **Expected**: Notifications disabled
8. **Result**: ✅ Settings work correctly

### Test 10: Notification Test (Advanced)
1. **Set** notification time to 1-2 minutes from now
2. **Enable** notifications in Settings
3. **Minimize** app or lock emulator
4. **Wait** for notification time
5. **Expected**: Notification appears at scheduled time
6. **Note**: 
   - iOS: May need to grant notification permissions
   - Android: Usually works automatically
7. **Result**: ✅ Notifications work correctly

### Test 11: Date Range Filtering
1. **Go to** Analytics screen
2. **Add** expenses with different dates:
   - One from last week
   - One from today
3. **Set** date range to "Last 7 days"
4. **Verify**: Only expenses in range appear
5. **Change** to "This Month"
6. **Verify**: All monthly expenses appear
7. **Result**: ✅ Date filtering works correctly

### Test 12: Empty States
1. **Delete** all expenses
2. **Check** Home Screen: Shows "No expenses yet" message
3. **Check** Analytics Screen: Shows "No expenses in this period"
4. **Add** expense back
5. **Verify**: Empty states disappear
6. **Result**: ✅ Empty states display correctly

### Test 13: Form Validation
1. **Try** to add expense without amount
2. **Expected**: Error message "Please enter an amount"
3. **Try** to add expense with invalid amount (e.g., "abc")
4. **Expected**: Error message "Please enter a valid number"
5. **Try** to add expense with negative amount
6. **Expected**: Error message "Amount must be greater than 0"
7. **Try** to add expense without category
8. **Expected**: Error message "Please select a category"
9. **Result**: ✅ Validation works correctly

### Test 14: Pull to Refresh
1. **Go to** Home Screen
2. **Pull down** on expense list
3. **Expected**: 
   - Loading indicator appears
   - List refreshes
   - Latest data loads
4. **Repeat** on Categories screen
5. **Result**: ✅ Pull to refresh works correctly

### Test 15: Navigation
1. **Test** all navigation paths:
   - Home → Categories (via drawer)
   - Home → Analytics (via drawer and app bar)
   - Home → Settings (via drawer)
   - Categories → Add Category (via FAB)
   - Analytics → Home (back button)
2. **Verify**: All navigation works smoothly
3. **Result**: ✅ Navigation works correctly

---

## Troubleshooting Emulator Issues

### iOS Simulator Issues

#### Simulator Won't Launch
```bash
# Kill all simulator processes
killall Simulator

# Reset simulator
xcrun simctl shutdown all
xcrun simctl erase all

# Try launching again
open -a Simulator
```

#### App Won't Install on Simulator
```bash
# Clean build
flutter clean
flutter pub get

# Rebuild
flutter run -d ios
```

#### CocoaPods Issues
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter run -d ios
```

### Android Emulator Issues

#### Emulator Won't Start
1. Check if HAXM/Virtualization is enabled in BIOS
2. Ensure enough RAM allocated (recommended: 2GB+)
3. Try cold boot: **Actions** > **Cold Boot Now**

#### App Won't Install
```bash
# Clean build
flutter clean
flutter pub get

# Rebuild
flutter run -d android
```

#### ADB Issues
```bash
# Kill ADB server
adb kill-server

# Start ADB server
adb start-server

# List devices
adb devices
```

#### Emulator Too Slow
1. Increase RAM allocation in AVD settings
2. Enable hardware acceleration
3. Use x86/x86_64 system images instead of ARM

---

## Quick Reference Commands

### Check Available Devices
```bash
flutter devices
```

### List Emulators
```bash
flutter emulators
```

### Launch Emulator
```bash
# iOS
flutter emulators --launch apple_ios_simulator

# Android
flutter emulators --launch <emulator-id>
```

### Run App
```bash
# iOS
flutter run -d ios

# Android
flutter run -d android

# Specific device
flutter run -d <device-id>
```

### Hot Reload/Restart
- Press `r` in terminal: Hot reload
- Press `R` in terminal: Hot restart
- Press `q` in terminal: Quit app

### Check Flutter Setup
```bash
flutter doctor
flutter doctor -v  # Detailed version
```

---

## Performance Tips

1. **First Build**: Takes 5-10 minutes, be patient
2. **Subsequent Builds**: Much faster (30 seconds - 2 minutes)
3. **Hot Reload**: Use for UI changes (instant)
4. **Hot Restart**: Use for logic changes (5-10 seconds)
5. **Clean Build**: Run `flutter clean` if experiencing issues

---

## Next Steps After Testing

1. ✅ All tests passing? Great! App is ready for use
2. 🔧 Found issues? Check Troubleshooting section
3. 📱 Want to test on physical device? See "Testing on Physical Devices" section above
4. 🚀 Ready to deploy? Check Flutter deployment documentation