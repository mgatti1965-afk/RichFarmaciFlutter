import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'providers.dart';

/// Preferenze semplici dell'app, lette dalle preferenze salvate e
/// aggiornate in tempo reale (onboarding, disclaimer, contatore donazioni).

class OnboardingShownNotifier extends Notifier<bool> {
  @override
  bool build() => ref.watch(settingsStoreProvider).onboardingShown;

  Future<void> set(bool value) async {
    await ref.read(settingsStoreProvider).setOnboardingShown(value);
    state = value;
  }

  void reload() => state = ref.read(settingsStoreProvider).onboardingShown;
}

final onboardingShownProvider =
    NotifierProvider<OnboardingShownNotifier, bool>(OnboardingShownNotifier.new);

class DisclaimerAcceptedNotifier extends Notifier<bool> {
  @override
  bool build() => ref.watch(settingsStoreProvider).disclaimerAccepted;

  Future<void> set(bool value) async {
    await ref.read(settingsStoreProvider).setDisclaimerAccepted(value);
    state = value;
  }

  void reload() => state = ref.read(settingsStoreProvider).disclaimerAccepted;
}

final disclaimerAcceptedProvider =
    NotifierProvider<DisclaimerAcceptedNotifier, bool>(
  DisclaimerAcceptedNotifier.new,
);

class DonationCountNotifier extends Notifier<int> {
  @override
  int build() => ref.watch(settingsStoreProvider).donationCount;

  Future<void> increment() async {
    final store = ref.read(settingsStoreProvider);
    await store.incrementDonationCount();
    state = store.donationCount;
  }

  void reload() => state = ref.read(settingsStoreProvider).donationCount;
}

final donationCountProvider =
    NotifierProvider<DonationCountNotifier, int>(DonationCountNotifier.new);

/// Rilegge tutte le preferenze (dopo un ripristino o un azzeramento).
void reloadAllFlags(Ref ref) {
  ref.read(onboardingShownProvider.notifier).reload();
  ref.read(disclaimerAcceptedProvider.notifier).reload();
  ref.read(donationCountProvider.notifier).reload();
}
