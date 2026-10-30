import '../data/models/medication.dart';

/// Programma e annulla i promemoria veri sul telefono (Fase 5).
/// Per ora l'app usa [NoopReminderScheduler], che non fa nulla: i
/// controller chiamano gia' questa interfaccia, cosi' in Fase 5 basta
/// sostituire l'implementazione.
abstract class ReminderScheduler {
  /// Programma il prossimo promemoria del farmaco.
  Future<void> schedule(Medication med, String description);

  /// Annulla i promemoria del farmaco.
  Future<void> cancel(Medication med);

  /// Annulla tutti i promemoria.
  Future<void> cancelAll();

  /// Chiede all'utente il permesso di mostrare notifiche. Restituisce
  /// vero se concesso. Va chiamata dopo aver spiegato perche' serve.
  Future<bool> requestPermissions();

  /// Mostra subito una notifica di prova.
  Future<void> showTestNotification();
}

class NoopReminderScheduler implements ReminderScheduler {
  const NoopReminderScheduler();

  @override
  Future<void> schedule(Medication med, String description) async {}

  @override
  Future<void> cancel(Medication med) async {}

  @override
  Future<void> cancelAll() async {}

  @override
  Future<bool> requestPermissions() async => true;

  @override
  Future<void> showTestNotification() async {}
}
