import 'dart:typed_data';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../data/models/medication.dart';
import '../domain/reminder_plan.dart';
import 'reminder_scheduler.dart';

/// Promemoria veri sul telefono (Android e iOS), con flutter_local_notifications.
///
/// Non si puo' provare con i test automatici: serve un telefono o un
/// emulatore. La logica di cosa programmare e' in [ReminderPlanner], che
/// invece e' coperta dai test.
class LocalReminderScheduler implements ReminderScheduler {
  LocalReminderScheduler({
    FlutterLocalNotificationsPlugin? plugin,
    DateTime Function()? clock,
  })  : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
        _clock = clock ?? DateTime.now;

  final FlutterLocalNotificationsPlugin _plugin;
  final DateTime Function() _clock;

  static const String channelId = 'medication_reminders';

  bool _ready = false;

  /// Falso se non si e' riusciti a leggere il fuso orario del telefono:
  /// in quel caso niente ripetizioni giornaliere (che dipendono dal fuso)
  /// ma solo promemoria singoli, il cui istante resta corretto.
  bool _zoneKnown = false;

  /// Prepara notifiche e fuso orario. Si chiama da sola alla prima
  /// operazione, ma conviene chiamarla all'avvio dell'app.
  Future<void> init() async {
    if (_ready) return;
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
      _zoneKnown = true;
    } on Exception {
      _zoneKnown = false;
    }
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // I permessi si chiedono dopo, con una spiegazione: vedi
        // requestPermissions().
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
    _ready = true;
  }

  @override
  Future<void> schedule(Medication med, String description) async {
    await init();
    await _cancelIds(med.id);
    final plan = ReminderPlanner.plan(med, _clock());
    if (plan.isEmpty) return;

    final mode = await _scheduleMode();
    final details = _details();
    for (final reminder in plan) {
      await _plugin.zonedSchedule(
        id: reminder.id,
        scheduledDate: tz.TZDateTime.from(reminder.when, tz.local),
        notificationDetails: details,
        androidScheduleMode: mode,
        title: med.nome,
        body: description,
        payload: med.id,
        matchDateTimeComponents: (reminder.repeatsDaily && _zoneKnown)
            ? DateTimeComponents.time
            : null,
      );
    }
  }

  @override
  Future<void> cancel(Medication med) async {
    await init();
    await _cancelIds(med.id);
  }

  @override
  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAllPendingNotifications();
  }

  @override
  Future<bool> requestPermissions() async {
    await init();
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      final granted = await android.requestNotificationsPermission() ?? true;
      final canExact = await android.canScheduleExactNotifications() ?? false;
      if (!canExact) await android.requestExactAlarmsPermission();
      return granted;
    }
    final ios = _plugin.resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  @override
  Future<void> showTestNotification() async {
    await init();
    await _plugin.show(
      id: 1,
      title: 'RichFarmaci - Prova notifica',
      body: 'Le notifiche funzionano! Sentirai questo suono per i tuoi farmaci.',
      notificationDetails: _details(),
    );
  }

  Future<void> _cancelIds(String medicationId) async {
    for (final id in ReminderPlanner.allIds(medicationId)) {
      await _plugin.cancel(id: id);
    }
  }

  /// Orario esatto se il telefono lo consente, altrimenti approssimato.
  Future<AndroidScheduleMode> _scheduleMode() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return AndroidScheduleMode.exactAllowWhileIdle;
    final canExact = await android.canScheduleExactNotifications() ?? false;
    return canExact
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
  }

  NotificationDetails _details() => NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          'Promemoria Farmaci',
          channelDescription: "Notifiche per l'assunzione dei farmaci",
          importance: Importance.max,
          priority: Priority.high,
          category: AndroidNotificationCategory.reminder,
          enableVibration: true,
          // Stessa vibrazione dell'app Kotlin.
          vibrationPattern: Int64List.fromList([0, 500, 200, 500, 200, 500]),
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );
}
