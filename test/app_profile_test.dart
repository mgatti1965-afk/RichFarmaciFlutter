import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/app/flags_providers.dart';
import 'package:richfarmaci/app/profile_controller.dart';
import 'package:richfarmaci/app/providers.dart';
import 'package:richfarmaci/app/state_providers.dart';

import 'app_helpers.dart';

void main() {
  late TestEnv env;
  late ProfileController profiles;

  setUp(() async {
    env = await TestEnv.create();
    profiles = env.container.read(profileControllerProvider);
  });

  tearDown(() => env.dispose());

  test('senza profili: initialize dice che mancano i dati', () async {
    expect(await profiles.initialize(), isFalse);
    expect(env.container.read(activeProfileIdProvider), isNull);
    expect(env.container.read(isConfiguredProvider), isFalse);
  });

  test('saveSettings crea il profilo e lo rende attivo, con dati puliti',
      () async {
    final p = await profiles.saveSettings(validSettings());
    await env.settle();

    expect(p.pazienteNome, 'Mario');
    expect(p.pazienteCf, 'RSSMRA40A01H501Z');
    expect(p.medicoTelefono, '+393331');
    expect(env.container.read(activeProfileIdProvider), p.id);
    expect(env.settings.activeProfileId, p.id);
    expect(env.container.read(isConfiguredProvider), isTrue);
    expect(env.container.read(canSendProvider), isTrue);
  });

  test('saveSettings aggiorna il profilo attivo senza crearne un altro',
      () async {
    final first = await profiles.saveSettings(validSettings());
    final second = await profiles
        .saveSettings(validSettings().copyWith(medicoNome: 'Dott. Verdi'));
    await env.settle();

    expect(second.id, first.id);
    final all = await env.container.read(profileRepositoryProvider).getAll();
    expect(all.length, 1);
    expect(all.single.medicoNome, 'Dott. Verdi');
  });

  test('profilo incompleto: si salva ma non si puo\' inviare', () async {
    await profiles.saveSettings(validSettings().copyWith(medicoTelefono: ''));
    await env.settle();
    expect(env.container.read(isConfiguredProvider), isTrue);
    expect(env.container.read(canSendProvider), isFalse);
  });

  test('codice fiscale speciale: aggiunge i 7 farmaci una sola volta',
      () async {
    final p = await profiles.saveSettings(validSettings(cf: 'cll rnn40m59 l957v'));
    final repo = env.container.read(medicationRepositoryProvider);
    expect((await repo.getByProfile(p.id)).length, 7);

    await profiles.saveSettings(validSettings(cf: 'CLLRNN40M59L957V'));
    expect((await repo.getByProfile(p.id)).length, 7);
  });

  test('codice fiscale normale: nessun farmaco di esempio', () async {
    final p = await profiles.saveSettings(validSettings());
    final repo = env.container.read(medicationRepositoryProvider);
    expect(await repo.getByProfile(p.id), isEmpty);
  });

  test('cancellare il profilo attivo passa al primo rimasto', () async {
    final a = await profiles.saveSettings(validSettings());
    await profiles.startNewProfile();
    final b = await profiles.saveSettings(validSettings());
    expect(env.container.read(activeProfileIdProvider), b.id);

    expect(await profiles.deleteProfile(b.id), isTrue);
    expect(env.container.read(activeProfileIdProvider), a.id);

    expect(await profiles.deleteProfile(a.id), isFalse);
    expect(env.container.read(activeProfileIdProvider), isNull);
  });

  test('initialize tiene il profilo attivo salvato se esiste ancora',
      () async {
    await profiles.saveSettings(validSettings());
    await profiles.startNewProfile();
    final b = await profiles.saveSettings(validSettings());

    expect(await profiles.initialize(), isTrue);
    expect(env.container.read(activeProfileIdProvider), b.id);
  });

  test('initialize con profilo salvato inesistente sceglie un profilo valido',
      () async {
    final a = await profiles.saveSettings(validSettings());
    await env.container.read(activeProfileIdProvider.notifier).select('fantasma');

    expect(await profiles.initialize(), isTrue);
    expect(env.container.read(activeProfileIdProvider), a.id);
  });

  test('azzera tutto: dati, preferenze e promemoria', () async {
    await profiles.saveSettings(validSettings());
    await env.container.read(onboardingShownProvider.notifier).set(true);

    await profiles.resetEverything();
    await env.settle();

    expect(await env.container.read(profileRepositoryProvider).getAll(),
        isEmpty);
    expect(env.settings.activeProfileId, isNull);
    expect(env.settings.onboardingShown, isFalse);
    expect(env.container.read(activeProfileIdProvider), isNull);
    expect(env.scheduler.cancelAllCount, 1);
  });
}
