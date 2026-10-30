import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/data/settings_store.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('valori iniziali come nell\'app Kotlin', () async {
    final s = await SettingsStore.open();
    expect(s.activeProfileId, isNull);
    expect(s.donationCount, 0);
    expect(s.onboardingShown, isFalse);
    expect(s.disclaimerAccepted, isFalse);
  });

  test('profilo attivo: imposta e rimuove', () async {
    final s = await SettingsStore.open();
    await s.setActiveProfileId('p1');
    expect(s.activeProfileId, 'p1');
    await s.setActiveProfileId(null);
    expect(s.activeProfileId, isNull);
  });

  test('contatore donazioni', () async {
    final s = await SettingsStore.open();
    await s.incrementDonationCount();
    await s.incrementDonationCount();
    expect(s.donationCount, 2);
    await s.clearDonationAndSet(-5);
    expect(s.donationCount, 0);
  });

  test('onboarding e disclaimer', () async {
    final s = await SettingsStore.open();
    await s.setOnboardingShown(true);
    await s.setDisclaimerAccepted(true);
    expect(s.onboardingShown, isTrue);
    expect(s.disclaimerAccepted, isTrue);
  });

  test('clear azzera tutto', () async {
    final s = await SettingsStore.open();
    await s.setActiveProfileId('p');
    await s.incrementDonationCount();
    await s.clear();
    expect(s.activeProfileId, isNull);
    expect(s.donationCount, 0);
  });
}
