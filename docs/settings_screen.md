# Settings Screen Documentation

## Overview
The Settings Screen allows users to configure app preferences, particularly notification settings for daily expense reminders. It also displays app information and includes a placeholder for future AI Assistant features.

## Location
`lib/screens/settings_screen.dart`

## Functionality

### Settings Sections

#### 1. Notifications Section
- **Daily Reminder Toggle**: Enable/disable daily expense reminders
- **Reminder Time Picker**: Select time for daily notification (default: 8:00 PM)
- **Time Format**: 24-hour format stored as "HH:mm" string

#### 2. App Information Section
- **App Name**: Display app name
- **Version**: Current app version

#### 3. AI Assistant Section (Placeholder)
- **Status**: "Coming Soon" badge
- **Description**: Information about future AI feature
- **Purpose**: Reserve space for AI chatbot integration

## State Management

### Providers Used
- `SettingsProvider`: Manages user settings and notification scheduling

### Data Loading
On screen initialization:
1. Loads settings via `SettingsProvider.loadSettings()`
2. Parses notification time string to `TimeOfDay`
3. Displays current settings values

### Settings Updates
- **Notification Toggle**: Updates via `toggleNotifications()`
- **Time Change**: Updates via `updateNotificationTime()`
- Both trigger notification service updates

## Code Flow

### Initialization
```dart
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadSettings();
  });
}

void _loadSettings() {
  final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
  settingsProvider.loadSettings().then((_) {
    if (settingsProvider.settings != null) {
      // Parse time string to TimeOfDay
      final timeParts = settingsProvider.settings!.notificationTime.split(':');
      setState(() {
        _selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      });
    }
  });
}
```

### Time Selection
```dart
Future<void> _selectTime() async {
  final picked = await showTimePicker(
    context: context,
    initialTime: _selectedTime ?? TimeOfDay.now(),
  );

  if (picked != null) {
    setState(() {
      _selectedTime = picked;
    });

    // Convert TimeOfDay to "HH:mm" string
    final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    
    // Update settings
    final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    await settingsProvider.updateNotificationTime(timeString);
  }
}
```

### Notification Toggle
```dart
SwitchListTile(
  value: settings.notificationsEnabled,
  onChanged: (value) {
    settingsProvider.toggleNotifications(value);
  },
)
```

## Notification Service Integration

### When Settings Change
1. **Enable Notifications**: Schedules daily reminder at selected time
2. **Disable Notifications**: Cancels existing daily reminder
3. **Change Time**: Cancels old reminder, schedules new one

### Notification Scheduling
- Handled by `NotificationService.scheduleDailyReminder()`
- Uses `flutter_local_notifications` package
- Repeats daily at specified time
- Works even when app is closed

## UI Components

### Settings Cards
- Material Design cards with padding
- Section headers with bold text
- Clear visual separation between sections

### Switch List Tile
- Material switch for notification toggle
- Title and subtitle for clarity
- Immediate visual feedback

### Time Picker
- Material time picker dialog
- 12-hour or 24-hour format (system dependent)
- List tile with trailing arrow icon
- Disabled when notifications are off

### App Info List Tiles
- Read-only information display
- Consistent styling with other settings

### AI Assistant Placeholder
- Card with "Coming Soon" badge
- Descriptive text about future feature
- Visual indication of planned enhancement

## Data Flow

### Loading Settings
```
SettingsProvider.loadSettings()
  → SettingsService.getSettings()
    → Supabase query
      → UserSettings model
        → Update provider state
          → UI rebuilds with settings
```

### Updating Notification Time
```
User selects time
  → TimeOfDay converted to "HH:mm" string
    → SettingsProvider.updateNotificationTime()
      → SettingsService.updateSettings()
        → Supabase update
          → NotificationService.scheduleDailyReminder()
            → Local notification scheduled
```

### Toggling Notifications
```
User toggles switch
  → SettingsProvider.toggleNotifications()
    → SettingsService.updateSettings()
      → Supabase update
        → If enabled: schedule notification
        → If disabled: cancel notification
```

## Default Values
- **Notification Time**: "20:00" (8:00 PM)
- **Notifications Enabled**: true
- **Currency**: "USD"

## Error Handling
- Loading states shown with `CircularProgressIndicator`
- Error states handled by provider
- Settings validation at service level
- Graceful fallback to defaults if settings don't exist

## Future Enhancements

### Additional Settings
- Currency selection
- Date format preferences
- Theme selection (light/dark)
- Language selection
- Export data format
- Backup frequency
- Data retention policy

### Notification Settings
- Multiple reminder times
- Custom reminder messages
- Reminder frequency (daily/weekly)
- Quiet hours
- Sound selection

### Privacy & Security
- Biometric authentication
- PIN/password protection
- Data encryption options
- Cloud sync preferences

### AI Assistant Integration
- Enable/disable AI features
- AI personality settings
- Conversation history
- Privacy settings for AI data

## Integration Points

### Notification Service
- `NotificationService.scheduleDailyReminder()`
- `NotificationService.cancelDailyReminder()`

### Settings Service
- `SettingsService.getSettings()`
- `SettingsService.updateSettings()`
- `SettingsService.createDefaultSettings()`

### Settings Provider
- `SettingsProvider.loadSettings()`
- `SettingsProvider.updateSettings()`
- `SettingsProvider.updateNotificationTime()`
- `SettingsProvider.toggleNotifications()`

