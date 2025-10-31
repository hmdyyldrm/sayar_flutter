import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'notification_service.dart';

class AlarmService {
  static Future<void> init() async {
    await AndroidAlarmManager.initialize();
  }

  static Future<void> setDailyAlarm({
    required int id,
    required DateTime time,
    required String title,
    bool cancel = false,
  }) async {
    if (cancel) {
      await AndroidAlarmManager.cancel(id);
      return;
    }

    await AndroidAlarmManager.periodic(
      const Duration(days: 1),
      id,
      _alarmCallback,
      startAt: time,
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
      params: {'id': id, 'title': title},
    );
  }

  // Alarm tetiklenince çağrılır
  static void _alarmCallback(int id, Map<String, dynamic> params) async {
    final String title = params['title'] ?? 'Zikir Hatırlatması';
    await NotificationService.showNotification(
      id: id,
      title: title,
      body: 'Saymak için dokunun...',
    );
  }
}
