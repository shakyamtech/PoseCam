import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repositories/settings_repository.dart';
import 'service_providers.dart';

/// Riverpod StateNotifier managing active ThemeMode (Light, Dark, System).
class ThemeNotifier extends StateNotifier<ThemeMode> {
  final SettingsRepository _repository;

  ThemeNotifier(this._repository) : super(_repository.getThemeMode());

  Future<void> setThemeMode(ThemeMode mode) async {
    state = mode;
    await _repository.saveThemeMode(mode);
  }

  Future<void> toggleTheme() async {
    if (state == ThemeMode.dark) {
      await setThemeMode(ThemeMode.light);
    } else {
      await setThemeMode(ThemeMode.dark);
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return ThemeNotifier(repository);
});
