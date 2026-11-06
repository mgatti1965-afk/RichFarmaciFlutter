import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/backup_controller.dart';
import '../../app/medication_controller.dart';
import '../../app/profile_controller.dart';
import '../../app/providers.dart';
import '../../app/state_providers.dart';
import '../../app/web_mode.dart';
import '../../data/models/enums.dart';
import '../../data/models/medication.dart';
import '../../data/models/patient_settings.dart';
import '../../domain/settings_rules.dart';
import '../../services/archive_file_service.dart';
import '../theme/app_theme.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/web_mode_banner.dart';
import 'medication_editor_sheet.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _pazienteNome;
  late TextEditingController _pazienteCf;
  late TextEditingController _medicoNome;
  late TextEditingController _medicoTelefono;
  late TextEditingController _medicoEmail;
  late TextEditingController _secondoIndirizzo;
  late TextEditingController _messaggioTesta;
  late TextEditingController _messaggioCoda;
  late TextEditingController _descrizioneNotifica;

  late SendChannel _tipoInvio;
  late bool _notificheAttive;

  bool _isSaving = false;
  bool _isInitialized = false;
  bool _webReminderTelemetryTracked = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _loadActiveProfile();
      _isInitialized = true;
    }
  }

  void _loadActiveProfile() {
    final profile = ref.read(activeProfileProvider);
    final settings = profile?.toSettings() ?? const PatientSettings();

    _pazienteNome = TextEditingController(text: settings.pazienteNome);
    _pazienteCf = TextEditingController(text: settings.pazienteCf);
    _medicoNome = TextEditingController(text: settings.medicoNome);
    _medicoTelefono = TextEditingController(text: settings.medicoTelefono);
    _medicoEmail = TextEditingController(text: settings.medicoEmail);
    _secondoIndirizzo = TextEditingController(text: settings.secondoIndirizzo);
    _messaggioTesta = TextEditingController(text: settings.messaggioTesta);
    _messaggioCoda = TextEditingController(text: settings.messaggioCoda);
    _descrizioneNotifica = TextEditingController(text: settings.descrizioneNotifica);

    _tipoInvio = settings.tipoInvio;
    _notificheAttive = settings.notificheAttive;
  }

  @override
  void dispose() {
    _pazienteNome.dispose();
    _pazienteCf.dispose();
    _medicoNome.dispose();
    _medicoTelefono.dispose();
    _medicoEmail.dispose();
    _secondoIndirizzo.dispose();
    _messaggioTesta.dispose();
    _messaggioCoda.dispose();
    _descrizioneNotifica.dispose();
    super.dispose();
  }

  PatientSettings _buildCurrentSettings() {
    return PatientSettings(
      pazienteNome: _pazienteNome.text,
      pazienteCf: _pazienteCf.text,
      medicoNome: _medicoNome.text,
      medicoTelefono: _medicoTelefono.text,
      medicoEmail: _medicoEmail.text,
      secondoIndirizzo: _secondoIndirizzo.text,
      messaggioTesta: _messaggioTesta.text,
      messaggioCoda: _messaggioCoda.text,
      tipoInvio: _tipoInvio,
      notificheAttive: _notificheAttive,
      descrizioneNotifica: _descrizioneNotifica.text,
    );
  }

  Future<void> _saveSettings() async {
    final settings = _buildCurrentSettings();
    if (!SettingsRules.isComplete(settings)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Compila Nome Paziente, Codice Fiscale, Medico e il recapito del canale scelto (Telefono o Email).',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: AppColors.redDanger,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      await ref.read(profileControllerProvider).saveSettings(settings);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impostazioni salvate con successo!', style: TextStyle(fontSize: 16)),
            backgroundColor: AppColors.greenPrimary,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _addNewProfile() async {
    final nameController = TextEditingController();
    final created = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nuovo Paziente'),
        content: TextField(
          controller: nameController,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(labelText: 'Nome e Cognome'),
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annulla'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Crea'),
          ),
        ],
      ),
    );

    if (created == true && nameController.text.trim().isNotEmpty) {
      await ref.read(profileControllerProvider).startNewProfile();
      setState(() {
        _pazienteNome.text = nameController.text.trim();
        _pazienteCf.text = '';
      });
    }
  }

  Future<void> _deleteCurrentProfile() async {
    final active = ref.read(activeProfileProvider);
    if (active == null) return;

    final confirm = await showConfirmDeleteDialog(
      context: context,
      title: 'Elimina Profilo',
      message:
          'Sei sicuro di voler eliminare il profilo di "${active.pazienteNome}"? Verranno rimossi anche tutti i suoi farmaci e lo storico.',
    );

    if (confirm && mounted) {
      final hasProfiles =
          await ref.read(profileControllerProvider).deleteProfile(active.id);
      if (mounted) {
        if (!hasProfiles) {
          _loadActiveProfile();
          setState(() {});
        } else {
          Navigator.of(context).pop();
        }
      }
    }
  }

  Future<void> _exportBackup() async {
    final isWebMode = ref.read(isWebModeProvider);
    try {
      final outcome = await ref.read(backupControllerProvider).exportToFile();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              outcome == ArchiveShareOutcome.completed
                  ? 'Archivio esportato con successo!'
                  : 'Esportazione completata.',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: AppColors.greenPrimary,
          ),
        );
      }
    } catch (_) {
      if (isWebMode) {
        ref.read(telemetryProvider).track('export_failed_web');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Operazione non riuscita, riprova.',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: AppColors.redDanger,
          ),
        );
      }
    }
  }

  Future<void> _importBackup() async {
    final isWebMode = ref.read(isWebModeProvider);
    try {
      final result = await ref.read(backupControllerProvider).importFromFile();
      if (result != null && mounted) {
        _loadActiveProfile();
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ripristinati con successo: ${result.profiles} profili e ${result.medications} farmaci.',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: AppColors.greenPrimary,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } catch (_) {
      if (isWebMode) {
        ref.read(telemetryProvider).track('backup_failed_web');
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Operazione non riuscita, riprova.',
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: AppColors.redDanger,
          ),
        );
      }
    }
  }

  void _showWebReminderInfo() {
    ref.read(telemetryProvider).track('web_reminder_action_blocked', params: {
      'source': 'settings_reminder_section',
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Funzione disponibile nelle versioni native Android e iOS nativa.',
          style: TextStyle(fontSize: 16),
        ),
        backgroundColor: AppColors.orangeAlert,
      ),
    );
  }

  void _openMedicationEditor([Medication? med]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MedicationEditorSheet(medication: med),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profiles = ref.watch(profilesProvider).value ?? [];
    final activeId = ref.watch(activeProfileIdProvider);
    final medicationsAsync = ref.watch(medicationsProvider);
    final meds = medicationsAsync.value ?? [];
    final isWebMode = ref.watch(isWebModeProvider);

    if (isWebMode && !_webReminderTelemetryTracked) {
      _webReminderTelemetryTracked = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(telemetryProvider).track('web_reminder_section_opened', params: {
          'screen': 'settings',
        });
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Impostazioni & Profilo',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(20.0),
            children: [
              if (isWebMode) const WebModeBanner(),

              // 1. Gestione Profilo Paziente
              Card(
                color: AppColors.blueInputBg,
                shape: RoundedCornerShape(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PROFILO ATTIVO',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.slate900,
                            ),
                          ),
                          TextButton.icon(
                            onPressed: _addNewProfile,
                            icon: const Icon(Icons.person_add, size: 20),
                            label: const Text('Nuovo', style: TextStyle(fontSize: 16)),
                          ),
                        ],
                      ),
                      if (profiles.isNotEmpty)
                        DropdownButtonFormField<String>(
                          initialValue: activeId,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          ),
                          items: [
                            for (final p in profiles)
                              DropdownMenuItem(
                                value: p.id,
                                child: Text(
                                  p.pazienteNome.isEmpty ? 'Senza nome' : p.pazienteNome,
                                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                          onChanged: (id) async {
                            if (id != null) {
                              await ref.read(profileControllerProvider).selectProfile(id);
                              _loadActiveProfile();
                              setState(() {});
                            }
                          },
                        ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // 2. Dati Paziente
              const Text(
                'DATI DEL PAZIENTE',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.slate900),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _pazienteNome,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Nome e Cognome Paziente *',
                  hintText: 'Es: Mario Rossi',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _pazienteCf,
                textCapitalization: TextCapitalization.characters,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Codice Fiscale *',
                  hintText: '16 caratteri alfanumerici',
                ),
              ),

              const SizedBox(height: 28),

              // 3. Dati Medico Curante
              const Text(
                'DATI DEL MEDICO CURANTE',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.slate900),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _medicoNome,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Nome del Medico *',
                  hintText: 'Es: Dott. Bianchi',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _medicoTelefono,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  labelText: 'Telefono Medico (per WhatsApp o SMS)',
                  hintText: 'Es: 3331234567',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _medicoEmail,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  labelText: 'Email Medico (per Email)',
                  hintText: 'Es: dottore@email.it',
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _secondoIndirizzo,
                style: const TextStyle(fontSize: 16),
                decoration: const InputDecoration(
                  labelText: 'Indirizzo Studio (Opzionale)',
                  hintText: 'Es: Via Roma 1, Ambulatorio 3',
                ),
              ),

              const SizedBox(height: 28),

              // 4. Canale di Invio
              const Text(
                'CANALE DI INVIO PREFERITO',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.slate900),
              ),
              const SizedBox(height: 10),
              SegmentedButton<SendChannel>(
                segments: const [
                  ButtonSegment(value: SendChannel.whatsapp, label: Text('WhatsApp'), icon: Icon(Icons.chat)),
                  ButtonSegment(value: SendChannel.sms, label: Text('SMS'), icon: Icon(Icons.sms)),
                  ButtonSegment(value: SendChannel.email, label: Text('Email'), icon: Icon(Icons.email)),
                ],
                selected: {_tipoInvio},
                onSelectionChanged: (set) => setState(() => _tipoInvio = set.first),
              ),

              const SizedBox(height: 28),

              // 5. Notifiche & Promemoria
              Card(
                color: _notificheAttive ? AppColors.greenLightBg : AppColors.white,
                shape: RoundedCornerShape(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: _notificheAttive,
                        onChanged: isWebMode
                            ? null
                            : (val) => setState(() => _notificheAttive = val),
                        title: const Text(
                          'Promemoria Notifiche',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        subtitle: const Text(
                          'Abilita gli avvisi dei promemoria farmaci per questo paziente.',
                          style: TextStyle(fontSize: 15),
                        ),
                        activeThumbColor: AppColors.greenPrimary,
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (isWebMode) ...[
                        const SizedBox(height: 8),
                        const Text(
                          'Funzione disponibile nelle versioni native Android e iOS nativa.',
                          style: TextStyle(
                            fontSize: 14,
                            color: AppColors.slate600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: OutlinedButton.icon(
                            onPressed: _showWebReminderInfo,
                            icon: const Icon(Icons.info_outline),
                            label: const Text('Dettagli disponibilita'),
                          ),
                        ),
                      ],
                      if (_notificheAttive) ...[
                        const SizedBox(height: 10),
                        TextField(
                          controller: _descrizioneNotifica,
                          enabled: !isWebMode,
                          style: const TextStyle(fontSize: 16),
                          decoration: const InputDecoration(
                            labelText: 'Testo promemoria',
                            hintText: 'È ora di prendere il farmaco',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // Pulsante Salva Impostazioni
              ElevatedButton(
                onPressed: _isSaving ? null : _saveSettings,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 58),
                  backgroundColor: AppColors.greenPrimary,
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : const Text(
                        'SALVA IMPOSTAZIONI',
                        style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
              ),

              const SizedBox(height: 36),
              const Divider(color: AppColors.grayBorder, thickness: 1.5),
              const SizedBox(height: 16),

              // 6. Gestore Rubrica Farmaci (come nella versione Kotlin)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'RUBRICA DEI FARMACI',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slate900,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Farmaci abituali per questo paziente',
                          style: TextStyle(fontSize: 14, color: AppColors.slate600),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _openMedicationEditor(),
                    icon: const Icon(Icons.add, size: 20),
                    label: const Text('AGGIUNGI', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.greenPrimary,
                      foregroundColor: AppColors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              if (meds.isEmpty)
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grayBorder),
                  ),
                  child: const Center(
                    child: Text(
                      'Nessun farmaco salvato per questo paziente.\nTocca "AGGIUNGI" per inserire un medicinale.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 15, color: AppColors.slate600, height: 1.4),
                    ),
                  ),
                )
              else
                for (final med in meds)
                  Card(
                    color: med.inPausa ? AppColors.sandAlertBg.withValues(alpha: 0.4) : AppColors.white,
                    shape: RoundedCornerShape(
                      12,
                      side: BorderSide(
                        color: med.inPausa ? AppColors.orangeAlert : AppColors.grayBorder,
                        width: med.inPausa ? 1.5 : 1,
                      ),
                    ),
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => _openMedicationEditor(med),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          med.nome,
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: med.inPausa ? AppColors.slate600 : AppColors.slate900,
                                            decoration: med.inPausa ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                      ),
                                      if (med.inPausa)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.orangeAlert,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: const Text(
                                            'IN PAUSA',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: AppColors.white,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                  if (med.note.isNotEmpty) ...[
                                    const SizedBox(height: 2),
                                    Text(
                                      med.note,
                                      style: const TextStyle(fontSize: 14, color: AppColors.slate600),
                                    ),
                                  ],
                                  const SizedBox(height: 2),
                                  Text(
                                    '${med.scatole} ${med.scatole == 1 ? "scatola" : "scatole"} abituali',
                                    style: const TextStyle(fontSize: 14, color: AppColors.slate600),
                                  ),
                                  if (med.notificaAttiva) ...[
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.notifications_active, size: 15, color: AppColors.greenPrimary),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Ore ${med.orarioNotifica}',
                                          style: const TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.greenPrimary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          // Bottone Pausa/Attiva
                          OutlinedButton(
                            onPressed: () => ref.read(medicationControllerProvider).toggleStandby(med),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: const Size(64, 38),
                              side: BorderSide(
                                color: med.inPausa ? AppColors.greenPrimary : AppColors.slate600,
                              ),
                            ),
                            child: Text(
                              med.inPausa ? 'Riattiva' : 'Pausa',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: med.inPausa ? AppColors.greenPrimary : AppColors.slate600,
                              ),
                            ),
                          ),
                          // Bottone Modifica
                          IconButton(
                            onPressed: () => _openMedicationEditor(med),
                            icon: const Icon(Icons.edit_outlined, size: 22, color: AppColors.slate600),
                            tooltip: 'Modifica farmaco',
                          ),
                          // Bottone Elimina
                          IconButton(
                            onPressed: () async {
                              final confirm = await showConfirmDeleteDialog(
                                context: context,
                                title: 'Elimina Farmaco',
                                message: 'Sei sicuro di voler eliminare "${med.nome}"?',
                              );
                              if (confirm && mounted) {
                                await ref.read(medicationControllerProvider).delete(med);
                              }
                            },
                            icon: const Icon(Icons.delete_outline, size: 22, color: AppColors.redDanger),
                            tooltip: 'Elimina farmaco',
                          ),
                        ],
                      ),
                    ),
                  ),

              const SizedBox(height: 36),
              const Divider(color: AppColors.grayBorder, thickness: 1.5),
              const SizedBox(height: 16),

              // 7. Backup e Ripristino Dati
              const Text(
                'ARCHIVIO & COPIA DI SICUREZZA',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.slate900),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _exportBackup,
                      icon: const Icon(Icons.share, size: 20),
                      label: const Text('Esporta'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _importBackup,
                      icon: const Icon(Icons.file_upload_outlined, size: 20),
                      label: const Text('Importa'),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              // 8. Zona Gestione Profilo (solo se multipli)
              if (profiles.length > 1) ...[
                OutlinedButton.icon(
                  onPressed: _deleteCurrentProfile,
                  icon: const Icon(Icons.person_remove, color: AppColors.redDanger),
                  label: const Text(
                    'Elimina Questo Profilo',
                    style: TextStyle(color: AppColors.redDanger),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.redDanger, width: 2),
                  ),
                ),
                const SizedBox(height: 14),
              ],

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
