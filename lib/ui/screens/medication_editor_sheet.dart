import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/medication_controller.dart';
import '../../data/models/enums.dart';
import '../../data/models/medication.dart';
import '../../domain/notification_scheduler.dart';
import '../theme/app_theme.dart';
import '../widgets/confirmation_dialog.dart';

/// Schermata/Foglio per aggiungere o modificare un farmaco.
/// Ottimizzato per utenti anziani: controlli grandi, etichette esplicite,
/// selettori chiari per orari e ripetizioni.
class MedicationEditorSheet extends ConsumerStatefulWidget {
  const MedicationEditorSheet({
    super.key,
    this.medication,
  });

  final Medication? medication;

  bool get isEditing => medication != null;

  @override
  ConsumerState<MedicationEditorSheet> createState() =>
      _MedicationEditorSheetState();
}

class _MedicationEditorSheetState extends ConsumerState<MedicationEditorSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _noteController;

  late int _scatole;
  late bool _notificaAttiva;
  late List<String> _orari;
  late int _frequenzaValore;
  late FrequencyUnit _frequenzaTipo;
  late bool _inPausa;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final med = widget.medication;
    _nameController = TextEditingController(text: med?.nome ?? '');
    _noteController = TextEditingController(text: med?.note ?? '');
    _scatole = med?.scatole ?? 1;
    _notificaAttiva = med?.notificaAttiva ?? false;
    _orari = med != null ? List<String>.from(med.orari) : ['08:00'];
    if (_orari.isEmpty) _orari = ['08:00'];
    _frequenzaValore = med?.frequenzaValore ?? 0;
    _frequenzaTipo = med?.frequenzaTipo ?? FrequencyUnit.ore;
    _inPausa = med?.inPausa ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _addOrEditTime([int? index]) async {
    final current = index != null && index < _orari.length
        ? NotificationScheduler.parseTime(_orari[index])
        : null;

    final initialTime = TimeOfDay(
      hour: current?.hour ?? 8,
      minute: current?.minute ?? 0,
    );

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
      helpText: 'SCEGLI L\'ORARIO DEL PROMEMORIA',
      cancelText: 'ANNULLA',
      confirmText: 'CONFERMA',
    );

    if (picked == null) return;

    final formatted =
        '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';

    setState(() {
      if (index != null && index < _orari.length) {
        _orari[index] = formatted;
      } else {
        if (!_orari.contains(formatted)) {
          _orari.add(formatted);
          _orari.sort();
        }
      }
    });
  }

  void _removeTime(int index) {
    if (_orari.length <= 1) return;
    setState(() => _orari.removeAt(index));
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inserisci il nome del farmaco.'),
          backgroundColor: AppColors.redDanger,
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    final controller = ref.read(medicationControllerProvider);
    final orarioJoined = _orari.join(', ');

    try {
      if (widget.isEditing) {
        final updated = widget.medication!.copyWith(
          nome: name,
          scatole: _scatole,
          note: _noteController.text.trim(),
          notificaAttiva: _notificaAttiva,
          orarioNotifica: orarioJoined,
          frequenzaValore: _frequenzaValore,
          frequenzaTipo: _frequenzaTipo,
          inPausa: _inPausa,
        );
        await controller.update(updated);
      } else {
        await controller.add(
          nome: name,
          scatole: _scatole,
          note: _noteController.text.trim(),
          notificaAttiva: _notificaAttiva,
          orarioNotifica: orarioJoined,
          frequenzaValore: _frequenzaValore,
          frequenzaTipo: _frequenzaTipo,
        );
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.isEditing
                  ? 'Farmaco "$name" aggiornato!'
                  : 'Farmaco "$name" aggiunto alla rubrica!',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: AppColors.greenPrimary,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _handleDelete() async {
    if (widget.medication == null) return;
    final confirm = await showConfirmDeleteDialog(
      context: context,
      title: 'Elimina Farmaco',
      message:
          'Sei sicuro di voler eliminare "${widget.medication!.nome}" dalla tua lista?',
    );

    if (confirm && mounted) {
      await ref.read(medicationControllerProvider).delete(widget.medication!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Farmaco "${widget.medication!.nome}" eliminato.',
              style: const TextStyle(fontSize: 16),
            ),
            backgroundColor: AppColors.slate900,
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.isEditing ? 'Modifica Farmaco' : 'Aggiungi Farmaco',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        leading: TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Annulla', style: TextStyle(fontSize: 16)),
        ),
        leadingWidth: 80,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Nome Farmaco
              const Text(
                'NOME DEL FARMACO *',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                textCapitalization: TextCapitalization.words,
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                decoration: const InputDecoration(
                  hintText: 'Es: Cardioaspirina, Metformina...',
                ),
              ),

              const SizedBox(height: 24),

              // Quantità Scatole
              const Text(
                'NUMERO SCATOLE ABITUALI',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: _scatole > 0
                        ? () => setState(() => _scatole--)
                        : null,
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(60, 60),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('−', style: TextStyle(fontSize: 28)),
                  ),
                  Container(
                    width: 80,
                    alignment: Alignment.center,
                    child: Text(
                      '$_scatole',
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: AppColors.slate900,
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () => setState(() => _scatole++),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(60, 60),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text('+', style: TextStyle(fontSize: 28)),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    _scatole == 1 ? 'scatola' : 'scatole',
                    style: const TextStyle(fontSize: 18, color: AppColors.slate600),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Note o Dosaggio
              const Text(
                'NOTE / DOSAGGIO (OPZIONALE)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.slate900,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _noteController,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(fontSize: 18),
                decoration: const InputDecoration(
                  hintText: 'Es: 100 mg dopo pranzo',
                ),
              ),

              const SizedBox(height: 28),

              // Sezione Notifiche e Promemoria
              Card(
                color: _notificaAttiva ? AppColors.greenLightBg : AppColors.white,
                shape: RoundedCornerShape(16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SwitchListTile(
                        value: _notificaAttiva,
                        onChanged: (val) => setState(() => _notificaAttiva = val),
                        title: const Text(
                          'Promemoria Notifica',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slate900,
                          ),
                        ),
                        subtitle: Text(
                          _notificaAttiva
                              ? 'L\'app ti avviserà all\'orario stabilito'
                              : 'Nessun promemoria impostato',
                          style: const TextStyle(fontSize: 15, color: AppColors.slate600),
                        ),
                        activeColor: AppColors.greenPrimary,
                        contentPadding: EdgeInsets.zero,
                      ),
                      if (_notificaAttiva) ...[
                        const Divider(height: 24),
                        const Text(
                          'ORARI DEL PROMEMORIA',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: [
                            for (int i = 0; i < _orari.length; i++)
                              InputChip(
                                label: Text(
                                  _orari[i],
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onDeleted: _orari.length > 1
                                    ? () => _removeTime(i)
                                    : null,
                                onPressed: () => _addOrEditTime(i),
                                deleteIconColor: AppColors.redDanger,
                                backgroundColor: AppColors.white,
                              ),
                            ActionChip(
                              avatar: const Icon(Icons.add, size: 20),
                              label: const Text('Aggiungi orario',
                                  style: TextStyle(fontSize: 16)),
                              onPressed: () => _addOrEditTime(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'RIPETIZIONE',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slate900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: DropdownButtonFormField<int>(
                                value: _frequenzaValore,
                                decoration: const InputDecoration(
                                  labelText: 'Ogni',
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                ),
                                items: const [
                                  DropdownMenuItem(value: 0, child: Text('Nessuna')),
                                  DropdownMenuItem(value: 1, child: Text('1')),
                                  DropdownMenuItem(value: 2, child: Text('2')),
                                  DropdownMenuItem(value: 4, child: Text('4')),
                                  DropdownMenuItem(value: 6, child: Text('6')),
                                  DropdownMenuItem(value: 8, child: Text('8')),
                                  DropdownMenuItem(value: 12, child: Text('12')),
                                  DropdownMenuItem(value: 24, child: Text('24')),
                                ],
                                onChanged: (val) =>
                                    setState(() => _frequenzaValore = val ?? 0),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: DropdownButtonFormField<FrequencyUnit>(
                                value: _frequenzaTipo,
                                decoration: const InputDecoration(
                                  labelText: 'Unità',
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12, vertical: 12),
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: FrequencyUnit.ore,
                                    child: Text('Ore'),
                                  ),
                                  DropdownMenuItem(
                                    value: FrequencyUnit.giorni,
                                    child: Text('Giorni'),
                                  ),
                                ],
                                onChanged: (val) => setState(() =>
                                    _frequenzaTipo = val ?? FrequencyUnit.ore),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Farmaco in pausa
              if (widget.isEditing)
                Card(
                  color: _inPausa ? AppColors.sandAlertBg : AppColors.white,
                  shape: RoundedCornerShape(16),
                  child: SwitchListTile(
                    value: _inPausa,
                    onChanged: (val) => setState(() => _inPausa = val),
                    title: Text(
                      _inPausa ? 'Farmaco in PAUSA' : 'Farmaco ATTIVO',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: _inPausa ? AppColors.orangeAlert : AppColors.slate900,
                      ),
                    ),
                    subtitle: const Text(
                      'I farmaci in pausa non vengono inclusi nelle richieste e i loro promemoria sono sospesi.',
                      style: TextStyle(fontSize: 15, color: AppColors.slate600),
                    ),
                    activeColor: AppColors.orangeAlert,
                  ),
                ),

              const SizedBox(height: 32),

              // Pulsante Salva
              ElevatedButton(
                onPressed: _isSaving ? null : _handleSave,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 58),
                  backgroundColor: AppColors.greenPrimary,
                ),
                child: _isSaving
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : Text(
                        widget.isEditing ? 'SALVA MODIFICHE' : 'AGGIUNGI FARMACO',
                        style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                      ),
              ),

              if (widget.isEditing) ...[
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: _handleDelete,
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 56),
                    foregroundColor: AppColors.redDanger,
                    side: const BorderSide(color: AppColors.redDanger, width: 2),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_outline, color: AppColors.redDanger),
                      SizedBox(width: 8),
                      Text(
                        'ELIMINA QUESTO FARMACO',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.redDanger,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

