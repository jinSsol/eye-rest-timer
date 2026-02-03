import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/settings_repository.dart';
import '../../domain/settings_model.dart';
import '../../../timer/presentation/providers/timer_provider.dart';

/// 설정 저장소 Provider
final settingsRepositoryProvider = Provider((ref) => SettingsRepository());

/// 설정 상태 Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsModel>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repository, ref);
});

/// 설정 StateNotifier
class SettingsNotifier extends StateNotifier<SettingsModel> {
  final SettingsRepository _repository;
  final Ref _ref;

  SettingsNotifier(this._repository, this._ref) : super(const SettingsModel()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = await _repository.loadSettings();
    // 초기 로드 시 타이머에도 설정 적용
    _ref.read(timerProvider.notifier).setWorkDuration(state.workDurationMinutes);
    _ref.read(timerProvider.notifier).setRestDuration(state.restDurationSeconds);
  }

  Future<void> setWorkDuration(int minutes) async {
    state = state.copyWith(workDurationMinutes: minutes);
    await _repository.saveSettings(state);
    // 타이머에도 반영
    _ref.read(timerProvider.notifier).setWorkDuration(minutes);
  }

  Future<void> setRestDuration(int seconds) async {
    state = state.copyWith(restDurationSeconds: seconds);
    await _repository.saveSettings(state);
    // 타이머에도 반영
    _ref.read(timerProvider.notifier).setRestDuration(seconds);
  }

  Future<void> setSoundEnabled(bool enabled) async {
    state = state.copyWith(soundEnabled: enabled);
    await _repository.saveSettings(state);
  }

  Future<void> setVibrationEnabled(bool enabled) async {
    state = state.copyWith(vibrationEnabled: enabled);
    await _repository.saveSettings(state);
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    state = state.copyWith(themeMode: mode);
    await _repository.saveSettings(state);
  }
}
