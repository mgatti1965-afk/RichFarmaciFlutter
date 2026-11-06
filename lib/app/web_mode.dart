import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Vero quando l'app gira nel browser.
final isWebModeProvider = Provider<bool>((ref) => kIsWeb);
