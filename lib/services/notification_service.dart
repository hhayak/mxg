import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:mxg/models/reminder.dart';

class NotificationService {
  final GlobalKey<NavigatorState> navigatorKey;
  final String remindersChannel = 'reminders';

  NotificationService(this.navigatorKey) {
    init();
  }

  Future<void> init() async {
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
            channelKey: remindersChannel,
            channelName: 'Reminders',
            channelDescription: 'Notification channel for reminders',
            defaultColor: Colors.teal,
            ledColor: Colors.teal,
          )
        ]);
  }

  Future<void> setReminder(Reminder reminder) async {
    var isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) {
      var result =
          await AwesomeNotifications().requestPermissionToSendNotifications();
      if (!result) {
        return;
      }
    }
    var localTimeZone =
        await AwesomeNotifications().getLocalTimeZoneIdentifier();
    AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: 0,
        channelKey: remindersChannel,
        title: 'Weight Measurement Reminder',
        body: 'Keep your weight tracking updated!',
      ),
      schedule: NotificationCalendar(
        weekday: reminder.frequency == Frequency.weekly ? reminder.weekday : null,
        hour: reminder.time.hour,
        minute: reminder.time.minute,
        second: 0,
        millisecond: 0,
        timeZone: localTimeZone,
        repeats: true,
      ),
    );
  }

  Future<void> disableReminder(Reminder reminder) async {
    return AwesomeNotifications().cancelSchedule(reminder.id);
  }

  void showSnackMessage(String message) {
    ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(SnackBar(
      content: Text(message),
    ));
  }
}
