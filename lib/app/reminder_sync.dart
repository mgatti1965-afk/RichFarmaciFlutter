import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/medication.dart';
import '../data/models/profile.dart';
import '../domain/notification_scheduler.dart';
import 'providers.dart';

/// Tiene allineati i promemoria con i dati: un promemoria e' attivo solo
/// se il profilo ha le notifiche attive, il farmaco ha il promemoria
/// acceso e non e' in pausa (regola di NotificationScheduler.shouldReschedule).
class ReminderSync {
  ReminderSync(this._ref);

  final Ref _ref;

  Future<void> syncMedication(Medication med, Profile profile) async {
    final scheduler = _ref.read(reminderSchedulerProvider);
    final active = NotificationScheduler.shouldReschedule(
      med,
      profileNotificationsOn: profile.notificheAttive,
    );
    if (active) {
      await scheduler.schedule(med, profile.descrizioneNotifica);
    } else {
      await scheduler.cancel(med);
    }
  }

  Future<void> syncProfile(String profileId) async {
    final profile = await _ref.read(profileRepositoryProvider).getById(profileId);
    if (profile == null) return;
    final meds =
        await _ref.read(medicationRepositoryProvider).getByProfile(profileId);
    for (final med in meds) {
      await syncMedication(med, profile);
    }
  }

  /// Annulla tutto e riprogramma ogni profilo (dopo un ripristino).
  Future<void> syncAll() async {
    await _ref.read(reminderSchedulerProvider).cancelAll();
    final profiles = await _ref.read(profileRepositoryProvider).getAll();
    for (final profile in profiles) {
      await syncProfile(profile.id);
    }
  }

  /// Annulla i promemoria di tutti i farmaci del profilo.
  Future<void> cancelProfile(String profileId) async {
    final scheduler = _ref.read(reminderSchedulerProvider);
    final meds =
        await _ref.read(medicationRepositoryProvider).getByProfile(profileId);
    for (final med in meds) {
      await scheduler.cancel(med);
    }
  }
}

final reminderSyncProvider = Provider<ReminderSync>((ref) => ReminderSync(ref));
