class UserSettings {
  final String userId;
  final String notificationTime; // Format: "HH:mm"
  final bool notificationsEnabled;
  final String currency; // e.g., "USD", "INR"
  final DateTime? updatedAt;

  UserSettings({
    required this.userId,
    required this.notificationTime,
    this.notificationsEnabled = true,
    this.currency = 'USD',
    this.updatedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'notification_time': notificationTime,
      'notifications_enabled': notificationsEnabled,
      'currency': currency,
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'] as String,
      notificationTime: json['notification_time'] as String,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      currency: json['currency'] as String? ?? 'USD',
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  UserSettings copyWith({
    String? userId,
    String? notificationTime,
    bool? notificationsEnabled,
    String? currency,
    DateTime? updatedAt,
  }) {
    return UserSettings(
      userId: userId ?? this.userId,
      notificationTime: notificationTime ?? this.notificationTime,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      currency: currency ?? this.currency,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

