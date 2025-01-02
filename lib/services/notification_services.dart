import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static String darwinNotificationCategoryText = 'textCategory';
  static String darwinNotificationCategoryPlain = 'plainCategory';

  static String urlLaunchActionId = 'id_1';

  /// A notification action which triggers a App navigation event
  static String navigationActionId = 'id_3';

  final List<DarwinNotificationCategory> darwinNotificationCategories = <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: darwinNotificationCategories,
    );
    var initializationSettings = InitializationSettings(
      android: androidSettings,
      iOS: initializationSettingsDarwin,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {},
    );
  }

  scheduleReminder(DateTime scheduledTime) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    print("Current time in TZDateTime format: $now");

    // Convert DateTime to TZDateTime
    final tz.TZDateTime scheduled = tz.TZDateTime.from(scheduledTime, tz.local);
    print("Scheduled time in TZDateTime format: $scheduled");

    return scheduled;
  }

  Future<void> scheduleDailyTenAMLastYearNotification({required int id, title, body, scheduledTime,DateTimeComponents? type}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      "",
      scheduleReminder(scheduledTime),
       NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id', 'daily notification channel name',
              channelDescription: 'daily notification description',
              actions: [
                AndroidNotificationAction("$id", 'Mark as Done'),
              ] ,
          ),
          iOS: const DarwinNotificationDetails()),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents:type ??  DateTimeComponents.time,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  removeNotification(id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }
}
