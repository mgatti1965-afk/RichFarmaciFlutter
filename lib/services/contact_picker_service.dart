import 'package:flutter/foundation.dart';
import 'package:flutter_contacts/flutter_contacts.dart';

/// Dati essenziali di un contatto importato dalla rubrica per il medico curante.
class PickedDoctorContact {
  const PickedDoctorContact({
    required this.name,
    this.phone,
    this.email,
    this.address,
  });

  final String name;
  final String? phone;
  final String? email;
  final String? address;
}

/// Eccezione lanciata quando l'utente nega l'accesso alla rubrica.
class ContactPermissionDeniedException implements Exception {
  const ContactPermissionDeniedException({this.permanentlyDenied = false});

  final bool permanentlyDenied;
}

/// Apre la rubrica di sistema e restituisce il contatto scelto.
/// E' un'interfaccia cosi' i test possono usare una versione finta.
abstract class ContactPickerService {
  Future<PickedDoctorContact?> pickContact();
}

class DeviceContactPickerService implements ContactPickerService {
  const DeviceContactPickerService();

  @override
  Future<PickedDoctorContact?> pickContact() async {
    if (kIsWeb) {
      throw UnsupportedError('Rubrica non disponibile nella versione Web.');
    }

    final hasPermission =
        await FlutterContacts.permissions.has(PermissionType.read);
    if (!hasPermission) {
      final status =
          await FlutterContacts.permissions.request(PermissionType.read);
      if (status == PermissionStatus.permanentlyDenied ||
          status == PermissionStatus.restricted) {
        throw const ContactPermissionDeniedException(permanentlyDenied: true);
      }
      if (status != PermissionStatus.granted &&
          status != PermissionStatus.limited) {
        throw const ContactPermissionDeniedException();
      }
    }

    final contact = await FlutterContacts.native.showPicker(
      properties: {
        ContactProperty.name,
        ContactProperty.phone,
        ContactProperty.email,
        ContactProperty.address,
      },
    );
    if (contact == null) return null;

    return PickedDoctorContact(
      name: _extractName(contact),
      phone: _extractPhone(contact),
      email: _extractEmail(contact),
      address: _extractAddress(contact),
    );
  }

  static String _extractName(Contact contact) {
    final display = contact.displayName?.trim() ?? '';
    if (display.isNotEmpty) return display;

    final n = contact.name;
    if (n == null) return '';
    return [n.prefix, n.first, n.middle, n.last, n.suffix]
        .whereType<String>()
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .join(' ');
  }

  static String? _extractPhone(Contact contact) {
    final nonEmpty = contact.phones
        .where((p) => p.number.trim().isNotEmpty)
        .toList();
    if (nonEmpty.isEmpty) return null;
    final primary = nonEmpty.where((p) => p.isPrimary == true).firstOrNull;
    return (primary ?? nonEmpty.first).number.trim();
  }

  static String? _extractEmail(Contact contact) {
    final nonEmpty = contact.emails
        .where((e) => e.address.trim().isNotEmpty)
        .toList();
    if (nonEmpty.isEmpty) return null;
    final primary = nonEmpty.where((e) => e.isPrimary == true).firstOrNull;
    return (primary ?? nonEmpty.first).address.trim();
  }

  static String? _extractAddress(Contact contact) {
    for (final addr in contact.addresses) {
      final formatted = addr.formatted?.trim() ?? '';
      if (formatted.isNotEmpty) {
        return formatted.replaceAll(RegExp(r'\s*\n+\s*'), ', ');
      }
      final parts = [
        addr.street,
        addr.postalCode,
        addr.city,
        addr.state,
        addr.country,
      ]
          .whereType<String>()
          .map((s) => s.trim())
          .where((s) => s.isNotEmpty)
          .toList();
      if (parts.isNotEmpty) {
        return parts.join(', ');
      }
    }
    return null;
  }
}
