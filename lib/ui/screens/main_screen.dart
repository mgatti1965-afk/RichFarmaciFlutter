import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/flags_providers.dart';
import '../../app/profile_controller.dart';
import '../../app/request_controller.dart';
import '../../app/state_providers.dart';
import '../../data/models/medication.dart';
import '../../data/models/sent_request.dart';
import '../../domain/request_selection.dart';
import '../theme/app_theme.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/help_dialog.dart';
import '../widgets/pharmacy_cross.dart';
import 'disclaimer_dialog.dart';
import 'medication_editor_sheet.dart';
import 'onboarding_dialog.dart';
import 'quick_message_dialog.dart';
import 'settings_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _openHelp() {
    final type = _tabController.index == 0 ? 'richiesta' : 'cronologia';
    showDialog(
      context: context,
      builder: (_) => HelpDialog(
        type: type,
        onDismiss: () => Navigator.of(context).pop(),
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

  void _openQuickMessage() {
    showDialog(
      context: context,
      builder: (_) => QuickMessageDialog(
        onSend: (customText) async {
          final requestCtrl = ref.read(requestControllerProvider);
          final message = await requestCtrl.buildQuickMessage(customText);
          if (message == null) return;
          final opened = await requestCtrl.openSendApp(message);
          if (opened) {
            await requestCtrl.recordSent(message);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Messaggio veloce inviato!', style: TextStyle(fontSize: 16)),
                  backgroundColor: AppColors.greenPrimary,
                ),
              );
            }
          } else {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Impossibile aprire l\'applicazione per l\'invio.', style: TextStyle(fontSize: 16)),
                  backgroundColor: AppColors.redDanger,
                ),
              );
            }
          }
        },
      ),
    );
  }

  Future<void> _sendRequest() async {
    final canSend = ref.read(canSendProvider);
    if (!canSend) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Completa prima i dati del paziente e del medico nelle Impostazioni.',
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: AppColors.redDanger,
          action: SnackBarAction(
            label: 'IMPOSTAZIONI',
            textColor: AppColors.white,
            onPressed: _openSettings,
          ),
        ),
      );
      return;
    }

    final sent = await ref.read(requestControllerProvider).sendRequest();
    if (sent != null && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Richiesta inviata e registrata nello storico!', style: TextStyle(fontSize: 16)),
          backgroundColor: AppColors.greenPrimary,
          duration: Duration(seconds: 4),
        ),
      );
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Impossibile aprire l\'app di invio o richiesta annullata.', style: TextStyle(fontSize: 16)),
          backgroundColor: AppColors.orangeAlert,
        ),
      );
    }
  }

  void _viewRequestDetails(SentRequest request) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Dettaglio Messaggio Inviato'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Data: ${_formatDate(request.sentAt)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.grayBackground,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.grayBorder),
                ),
                child: Text(
                  request.testoCompleto,
                  style: const TextStyle(fontSize: 16, height: 1.4),
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Chiudi'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteRequest(SentRequest request) async {
    final confirm = await showConfirmDeleteDialog(
      context: context,
      title: 'Elimina Richiesta',
      message: 'Vuoi eliminare questa voce dallo storico delle richieste?',
    );

    if (confirm && mounted) {
      await ref.read(requestControllerProvider).deleteHistoryItem(request.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final disclaimerAccepted = ref.watch(disclaimerAcceptedProvider);
    final onboardingShown = ref.watch(onboardingShownProvider);

    // Se il disclaimer non è stato accettato, mostra il dialog
    if (!disclaimerAccepted) {
      return Scaffold(
        body: Center(
          child: DisclaimerDialog(
            onAccept: () => ref.read(disclaimerAcceptedProvider.notifier).set(true),
          ),
        ),
      );
    }

    // Se l'onboarding non è stato visualizzato, mostra l'onboarding
    if (!onboardingShown) {
      return Scaffold(
        body: Center(
          child: OnboardingDialog(
            onDismiss: () => ref.read(onboardingShownProvider.notifier).set(true),
          ),
        ),
      );
    }

    final activeProfile = ref.watch(activeProfileProvider);
    final profiles = ref.watch(profilesProvider).value ?? [];
    final selection = ref.watch(requestSelectionProvider);
    final medicationsAsync = ref.watch(medicationsProvider);
    final historyAsync = ref.watch(historyProvider);

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Row(
          children: [
            const PharmacyCross(size: 32),
            const SizedBox(width: 12),
            const Text(
              'RichFarmaci',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: AppColors.slate900,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: _openHelp,
            icon: const Icon(Icons.help_outline, size: 28),
            tooltip: 'Aiuto',
          ),
          IconButton(
            onPressed: _openSettings,
            icon: const Icon(Icons.settings, size: 28),
            tooltip: 'Impostazioni',
          ),
          const SizedBox(width: 8),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              // Selettore Profilo Paziente
              InkWell(
                onTap: _openSettings,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.blueInputBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.grayBorder),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.person, color: AppColors.greenPrimary, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          activeProfile?.pazienteNome.isNotEmpty == true
                              ? 'Paziente: ${activeProfile!.pazienteNome}'
                              : (profiles.isEmpty ? 'Nessun paziente configurato' : 'Seleziona paziente'),
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: AppColors.slate900,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const Icon(Icons.arrow_drop_down, color: AppColors.slate600),
                    ],
                  ),
                ),
              ),

              // TabBar
              TabBar(
                controller: _tabController,
                indicatorColor: AppColors.greenPrimary,
                indicatorWeight: 3,
                labelColor: AppColors.greenPrimary,
                unselectedLabelColor: AppColors.slate600,
                labelStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                tabs: const [
                  Tab(icon: Icon(Icons.edit_note), text: 'Richiesta'),
                  Tab(icon: Icon(Icons.history), text: 'Cronologia'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // TAB 1: Richiesta Farmaci
          _buildRequestTab(
            medicationsAsync: medicationsAsync,
            selection: selection,
            activeProfilePresent: activeProfile != null,
          ),

          // TAB 2: Cronologia Richieste
          _buildHistoryTab(historyAsync: historyAsync),
        ],
      ),
      bottomNavigationBar: _tabController.index == 0
          ? null // Gestito direttamente nel tab per visibilità animata
          : null,
    );
  }

  Widget _buildRequestTab({
    required AsyncValue<List<Medication>> medicationsAsync,
    required RequestSelection selection,
    required bool activeProfilePresent,
  }) {
    return medicationsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Errore: $e')),
      data: (meds) {
        if (!activeProfilePresent) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.person_outline, size: 64, color: AppColors.slate600),
                  const SizedBox(height: 16),
                  const Text(
                    'Nessun paziente configurato.',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _openSettings,
                    icon: const Icon(Icons.settings),
                    label: const Text('CONFIGURA ORA'),
                  ),
                ],
              ),
            ),
          );
        }

        final activeMeds = meds.where((m) => !m.inPausa).toList();
        final selectedCount = selection.count;

        return Column(
          children: [
            Expanded(
              child: activeMeds.isEmpty
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.medication_outlined, size: 64, color: AppColors.slate600),
                            const SizedBox(height: 16),
                            const Text(
                              'Nessun farmaco attivo presente.',
                              style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Aggiungi i tuoi farmaci abituali per poterli richiedere rapidamente.',
                              style: TextStyle(fontSize: 16, color: AppColors.slate600),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton.icon(
                              onPressed: () => _openMedicationEditor(),
                              icon: const Icon(Icons.add),
                              label: const Text('AGGIUNGI FARMACO'),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
                      itemCount: activeMeds.length,
                      itemBuilder: (context, index) {
                        final med = activeMeds[index];
                        final isSelected = selection.isSelected(med.id);
                        final qty = selection.quantity(med.id);

                        return Card(
                          color: isSelected ? AppColors.greenLightBg : AppColors.white,
                          shape: RoundedCornerShape(
                            14,
                            side: BorderSide(
                              color: isSelected ? AppColors.greenPrimary : AppColors.grayBorder,
                              width: isSelected ? 2.5 : 1,
                            ),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(14),
                            onTap: () {
                              ref.read(requestSelectionProvider.notifier).toggle(med);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Checkbox grande
                                  Checkbox(
                                    value: isSelected,
                                    activeColor: AppColors.greenPrimary,
                                    onChanged: (_) {
                                      ref.read(requestSelectionProvider.notifier).toggle(med);
                                    },
                                  ),
                                  const SizedBox(width: 8),
                                  // Dettaglio Farmaco
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          med.nome,
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.slate900,
                                          ),
                                        ),
                                        if (med.note.isNotEmpty) ...[
                                          const SizedBox(height: 4),
                                          Text(
                                            med.note,
                                            style: const TextStyle(
                                              fontSize: 15,
                                              color: AppColors.slate600,
                                            ),
                                          ),
                                        ],
                                        if (med.notificaAttiva) ...[
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.notifications_active,
                                                  size: 16, color: AppColors.greenPrimary),
                                              const SizedBox(width: 4),
                                              Text(
                                                'Promemoria: ${med.orarioNotifica}',
                                                style: const TextStyle(
                                                  fontSize: 14,
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
                                  // Modifica
                                  IconButton(
                                    icon: const Icon(Icons.edit_outlined, color: AppColors.slate600),
                                    onPressed: () => _openMedicationEditor(med),
                                    tooltip: 'Modifica farmaco',
                                  ),
                                  // Stepper Quantità (se selezionato)
                                  if (isSelected) ...[
                                    const SizedBox(width: 6),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: qty > 1
                                              ? () => ref
                                                  .read(requestSelectionProvider.notifier)
                                                  .setQuantity(med.id, qty - 1)
                                              : () => ref
                                                  .read(requestSelectionProvider.notifier)
                                                  .deselect(med),
                                          icon: const Icon(Icons.remove_circle_outline, size: 28),
                                          color: AppColors.slate900,
                                        ),
                                        Text(
                                          '$qty',
                                          style: const TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => ref
                                              .read(requestSelectionProvider.notifier)
                                              .setQuantity(med.id, qty + 1),
                                          icon: const Icon(Icons.add_circle_outline, size: 28),
                                          color: AppColors.greenPrimary,
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),

            // Barra Inferiore Azioni
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                child: selectedCount > 0
                    ? ElevatedButton.icon(
                        onPressed: _sendRequest,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 60),
                          backgroundColor: AppColors.greenPrimary,
                        ),
                        icon: const Icon(Icons.send, size: 24),
                        label: Text(
                          'INVIA RICHIESTA AL MEDICO ($selectedCount)',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      )
                    : Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: _openQuickMessage,
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: const Text('Messaggio Veloce', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _openMedicationEditor(),
                              icon: const Icon(Icons.add),
                              label: const Text('Nuovo Farmaco', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHistoryTab({
    required AsyncValue<List<SentRequest>> historyAsync,
  }) {
    return historyAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Errore: $e')),
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history, size: 64, color: AppColors.slate600),
                  SizedBox(height: 16),
                  Text(
                    'Nessuna richiesta inviata finora.',
                    style: TextStyle(fontSize: 18, color: AppColors.slate600),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];

            return Card(
              shape: RoundedCornerShape(14),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          _formatDate(req.sentAt),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.greenPrimary,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, color: AppColors.redDanger),
                          onPressed: () => _deleteRequest(req),
                          tooltip: 'Elimina richiesta',
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Paziente: ${req.pazienteNome}',
                      style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Medico: ${req.medicoNome}',
                      style: const TextStyle(fontSize: 15, color: AppColors.slate600),
                    ),
                    const SizedBox(height: 10),
                    if (req.farmaci.isNotEmpty) ...[
                      const Text(
                        'Farmaci richiesti:',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 4),
                      for (final f in req.farmaci)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            '• ${f.nome}: ${f.scatole} ${f.scatole == 1 ? "scatola" : "scatole"}',
                            style: const TextStyle(fontSize: 15, color: AppColors.slate900),
                          ),
                        ),
                    ],
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => _viewRequestDetails(req),
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: const Text('Visualizza testo completo', style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}

String _formatDate(DateTime dt) {
  const months = ['gen', 'feb', 'mar', 'apr', 'mag', 'giu', 'lug', 'ago', 'set', 'ott', 'nov', 'dic'];
  final m = months[dt.month - 1];
  final hh = dt.hour.toString().padLeft(2, '0');
  final mm = dt.minute.toString().padLeft(2, '0');
  return '${dt.day} $m ${dt.year}, $hh:$mm';
}
