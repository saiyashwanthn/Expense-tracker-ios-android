import 'package:flutter/foundation.dart';
import '../models/user_settings.dart';
import '../services/settings_service.dart';
import '../services/notification_service.dart';

class SettingsProvider with ChangeNotifier {
  final SettingsService _settingsService = SettingsService();
  UserSettings? _settings;
  bool _isLoading = false;
  String? _error;

  UserSettings? get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadSettings() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _settings = await _settingsService.getSettings();
      if (_settings!.notificationsEnabled) {
        await NotificationService.scheduleDailyReminder(
          _settings!.notificationTime,
        );
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSettings(UserSettings newSettings) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _settings = await _settingsService.updateSettings(newSettings);
      
      // Update notification schedule if enabled
      if (_settings!.notificationsEnabled) {
        await NotificationService.scheduleDailyReminder(
          _settings!.notificationTime,
        );
      } else {
        await NotificationService.cancelDailyReminder();
      }
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNotificationTime(String time) async {
    if (_settings == null) return;

    final updatedSettings = _settings!.copyWith(notificationTime: time);
    await updateSettings(updatedSettings);
  }

  Future<void> toggleNotifications(bool enabled) async {
    if (_settings == null) return;

    final updatedSettings = _settings!.copyWith(notificationsEnabled: enabled);
    await updateSettings(updatedSettings);
  }
}

