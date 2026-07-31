import 'package:flutter/material.dart';
import '../core/services/storage_service.dart';
import '../core/constants/app_constants.dart';

abstract class SettingsRepository {
  Future<void> saveThemeMode(ThemeMode mode);
  ThemeMode getThemeMode();
}

class SettingsRepositoryImpl implements SettingsRepository {
  final StorageService _storageService;

  SettingsRepositoryImpl(this._storageService);

  @override
  Future<void> saveThemeMode(ThemeMode mode) async {
    await _storageService.setString(AppConstants.keyThemeMode, mode.name);
  }

  @override
  ThemeMode getThemeMode() {
    final modeName = _storageService.getString(AppConstants.keyThemeMode);
    if (modeName == null) return ThemeMode.system;
    return ThemeMode.values.firstWhere(
      (e) => e.name == modeName,
      orElse: () => ThemeMode.system,
    );
  }
}
