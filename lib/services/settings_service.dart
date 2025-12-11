import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_settings.dart';
import '../utils/app_config.dart';

class SettingsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<String?> getCurrentUserId() async {
    final user = _supabase.auth.currentUser;
    return user?.id;
  }

  Future<UserSettings> getSettings() async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');

    try {
      final response = await _supabase
          .from('user_settings')
          .select()
          .eq('user_id', userId)
          .single();

      return UserSettings.fromJson(response);
    } catch (e) {
      // If settings don't exist, create default settings
      return await createDefaultSettings();
    }
  }

  Future<UserSettings> createDefaultSettings() async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');

    final defaultSettings = UserSettings(
      userId: userId,
      notificationTime: AppConfig.defaultNotificationTime,
      notificationsEnabled: true,
      currency: 'USD',
    );

    final response = await _supabase
        .from('user_settings')
        .insert(defaultSettings.toJson())
        .select()
        .single();

    return UserSettings.fromJson(response);
  }

  Future<UserSettings> updateSettings(UserSettings settings) async {
    final userId = await getCurrentUserId();
    if (userId == null) throw Exception('User not authenticated');

    final response = await _supabase
        .from('user_settings')
        .update(settings.copyWith(updatedAt: DateTime.now()).toJson())
        .eq('user_id', userId)
        .select()
        .single();

    return UserSettings.fromJson(response);
  }
}

