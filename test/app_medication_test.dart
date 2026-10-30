import 'package:flutter_test/flutter_test.dart';
import 'package:richfarmaci/app/medication_controller.dart';
import 'package:richfarmaci/app/profile_controller.dart';
import 'package:richfarmaci/app/providers.dart';
import 'package:richfarmaci/app/state_providers.dart';
import 'package:richfarmaci/data/models/enums.dart';

import 'app_helpers.dart';

void main() {
  late TestEnv env;
  late MedicationController meds;
  late String profileId;

  setUp(() async {
    env = await TestEnv.create();
    meds = env.container.read(medicationControllerProvider);
    final p = await env.container
        .read(profileControllerProvider)
        .saveSettings(validSettings(notifiche: true));
    profileId = p.id;
    await env.settle();
  });

  tearDown(() => env.dispose());

  test('senza profilo attivo non aggiunge nulla', () async {
    await env.container.read(activeProfileIdProvider.notifier).select(null);
    expect(await meds.add(nome: 'X'), isNull);
  });

  test('nome vuoto: non aggiunge nulla', () async {
    expect(await meds.add(nome: '   '), isNull);
    expect(await env.container.read(medicationRepositoryProvider).getAll(),
        isEmpty);
  });

  test('aggiunge con nome e note puliti, quantita\' minima 0', () async {
    final m = await meds.add(nome: '  Aspirina ', scatole: -3, note: ' dopo cena ');
    expect(m!.nome, 'Aspirina');
    expect(m.note, 'dopo cena');
    expect(m.scatole, 0);
    expect(m.profileId, profileId);
    expect(m.frequenzaValore, 0);
    expect(m.frequenzaTipo, FrequencyUnit.ore);
  });

  test('promemoria: programmato solo se farmaco e profilo lo vogliono',
      () async {
    final senza = await meds.add(nome: 'A');
    expect(env.scheduler.scheduled, isNot(contains(senza!.id)));
    expect(env.scheduler.cancelled, contains(senza.id));

    final con = await meds.add(nome: 'B', notificaAttiva: true);
    expect(env.scheduler.scheduled, contains(con!.id));
  });

  test('pausa: annulla il promemoria e toglie il farmaco dalla richiesta',
      () async {
    final m = (await meds.add(nome: 'A', scatole: 2, notificaAttiva: true))!;
    await env.settle();
    env.container.read(requestSelectionProvider.notifier).toggle(m);
    expect(env.container.read(requestSelectionProvider).isSelected(m.id), isTrue);

    final paused = await meds.toggleStandby(m);
    expect(paused.inPausa, isTrue);
    expect(env.scheduler.cancelled, contains(m.id));
    expect(env.container.read(requestSelectionProvider).isSelected(m.id), isFalse);

    env.scheduler.scheduled.clear();
    final resumed = await meds.toggleStandby(paused);
    expect(resumed.inPausa, isFalse);
    expect(env.scheduler.scheduled, contains(m.id));
  });

  test('modifica: salva e riallinea il promemoria', () async {
    final m = (await meds.add(nome: 'A'))!;
    env.scheduler.scheduled.clear();
    await meds.update(m.copyWith(nome: 'A2', notificaAttiva: true));

    final saved = await env.container.read(medicationRepositoryProvider).getByProfile(profileId);
    expect(saved.single.nome, 'A2');
    expect(env.scheduler.scheduled, contains(m.id));
  });

  test('elimina: annulla il promemoria e toglie dalla selezione', () async {
    final m = (await meds.add(nome: 'A', notificaAttiva: true))!;
    await env.settle();
    env.container.read(requestSelectionProvider.notifier).toggle(m);

    await meds.delete(m);
    expect(env.scheduler.cancelled, contains(m.id));
    expect(await env.container.read(medicationRepositoryProvider).getAll(), isEmpty);
    expect(env.container.read(requestSelectionProvider).isEmpty, isTrue);
  });

  test('la selezione si svuota cambiando profilo', () async {
    final m = (await meds.add(nome: 'A'))!;
    env.container.read(requestSelectionProvider.notifier).toggle(m);
    expect(env.container.read(requestSelectionProvider).isEmpty, isFalse);

    final profiles = env.container.read(profileControllerProvider);
    await profiles.startNewProfile();
    await env.settle();
    expect(env.container.read(requestSelectionProvider).isEmpty, isTrue);
  });
}
