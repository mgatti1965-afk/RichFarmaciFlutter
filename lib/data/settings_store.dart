import 'package:shared_preferences/shared_preferences.dart';

/// Preferenze globali dell'app (equivalente delle SharedPreferences
/// "richfarmaci_prefs" di Kotlin, senza i dati del profilo che ora stanno
/// nel database).
class SettingsStore {
  SettingsStore(this._prefs);

  final SharedPreferences _prefs;

  static const _activeProfileKey = 'active_profile_id';
  static const _donationKey = 'donation_count';
  static const _onboardingKey = 'onboarding_shown';
  static const _disclaimerKey = 'disclaimer_accepted';

  static Future<SettingsStore> open() async =>
      SettingsStore(await SharedPreferences.getInstance());

  String? get activeProfileId => _prefs.getString(_activeProfileKey);

  Future<void> setActiveProfileId(String? id) => id == null
      ? _prefs.remove(_activeProfileKey)
      : _prefs.setString(_activeProfileKey, id);

  int get donationCount => _prefs.getInt(_donationKey) ?? 0;

  Future<void> incrementDonationCount() =>
      _prefs.setInt(_donationKey, donationCount + 1);

  /// Imposta il contatore (usato dal ripristino del backup).
  Future<void> clearDonationAndSet(int value) =>
      _prefs.setInt(_donationKey, value < 0 ? 0 : value);

  bool get onboardingShown => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingShown(bool value) =>
      _prefs.setBool(_onboardingKey, value);

  bool get disclaimerAccepted => _prefs.getBool(_disclaimerKey) ?? false;

  Future<void> setDisclaimerAccepted(bool value) =>
      _prefs.setBool(_disclaimerKey, value);

  /// Cancella tutte le preferenze (usato da "azzera tutto").
  Future<void> clear() => _prefs.clear();
}
