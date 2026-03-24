import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';
import '../models/sensor_reading.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();
  static final AudioPlayer _audioPlayer = AudioPlayer();

  // We track the last alert level so we don't spam the user with
  // push notifications every 2 seconds if the risk stays "MEDIUM"
  static RiskLevel _lastAlertLevel = RiskLevel.LOW;

  static Future<void> initialize() async {
    // Setting up the default Android icon (using the default flutter launcher icon)
    const AndroidInitializationSettings androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings = InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(settings: initSettings);
  }

  static Future<void> triggerRiskAlert(RiskLevel newLevel) async {
    // Only trigger a new push notification if the risk level has ESCALATED or changed
    if (newLevel == _lastAlertLevel) return;

    _lastAlertLevel = newLevel;

    if (newLevel == RiskLevel.HIGH) {
      // 1. Play loud 3-beep alarm
      try {
         await _audioPlayer.play(AssetSource('sounds/alert_beep.mp3'));
      } catch (e) {
         print("Audio file missing: $e");
      }

      // 2. Heavy Vibration Pattern (Wait 0ms, Vibrate 500ms, Wait 200ms, Vibrate 500ms)
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(pattern: [0, 500, 200, 500]);
      }

      // 3. System Push Notification
      _showSystemNotification(
        '⚠️ HIGH RISK DETECTED!',
        'Immediate action required. Landslide risk levels are critical.',
        Importance.max,
      );

    } else if (newLevel == RiskLevel.MEDIUM) {
      // 1. Softer notification sound
      try {
         await _audioPlayer.play(AssetSource('sounds/notification.mp3'));
      } catch (e) {
         print("Audio file missing: $e");
      }

      // 2. Single short vibration
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate(duration: 200);
      }

      // 3. System Push Notification
      _showSystemNotification(
        'MEDIUM RISK',
        'Moderate ground movement detected. Continue monitoring.',
        Importance.high,
      );
    }
  }

  static Future<void> _showSystemNotification(String title, String body, Importance importance) async {
    AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'terraguard_alerts', // Channel ID
      'Risk Alerts',       // Channel Name
      channelDescription: 'Notifications for landslide risk levels',
      importance: importance,
      priority: Priority.high,
      color: const Color(0xFFD32F2F), // Red color for the notification icon
    );

    NotificationDetails details = NotificationDetails(android: androidDetails);

    // Show the notification instantly
    await _notificationsPlugin.show(
      id: DateTime.now().millisecond,
      title: title,
      body: body,
      notificationDetails: details,
    );
  }
}