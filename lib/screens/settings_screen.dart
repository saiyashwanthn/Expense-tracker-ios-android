import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/settings_provider.dart';
import '../utils/app_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  TimeOfDay? _selectedTime;

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

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });

      final timeString = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
      final settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
      await settingsProvider.updateNotificationTime(timeString);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, settingsProvider, _) {
          if (settingsProvider.isLoading && settingsProvider.settings == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = settingsProvider.settings;
          if (settings == null) {
            return const Center(child: Text('Failed to load settings'));
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Notifications Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notifications',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Enable/Disable Notifications
                      SwitchListTile(
                        title: const Text('Daily Reminder'),
                        subtitle: const Text(
                          'Get reminded to record your expenses',
                        ),
                        value: settings.notificationsEnabled,
                        onChanged: (value) {
                          settingsProvider.toggleNotifications(value);
                        },
                      ),
                      
                      const Divider(),
                      
                      // Notification Time
                      ListTile(
                        title: const Text('Reminder Time'),
                        subtitle: Text(
                          _selectedTime != null
                              ? _selectedTime!.format(context)
                              : 'Not set',
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: settings.notificationsEnabled ? _selectTime : null,
                        enabled: settings.notificationsEnabled,
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // App Info Section
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'App Information',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ListTile(
                        title: const Text('App Name'),
                        subtitle: Text(AppConfig.appName),
                      ),
                      ListTile(
                        title: const Text('Version'),
                        subtitle: const Text('1.0.0'),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Future AI Assistant Section (Placeholder)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'AI Assistant',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'Coming Soon',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Personal financial assistant powered by AI will be available in a future update.',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

