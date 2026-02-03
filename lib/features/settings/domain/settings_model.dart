import 'package:flutter/material.dart';

/// 설정 모델
class SettingsModel {
  final int workDurationMinutes;
  final int restDurationSeconds;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final ThemeMode themeMode;

  const SettingsModel({
    this.workDurationMinutes = 20,
    this.restDurationSeconds = 20,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.themeMode = ThemeMode.system,
  });

  SettingsModel copyWith({
    int? workDurationMinutes,
    int? restDurationSeconds,
    bool? soundEnabled,
    bool? vibrationEnabled,
    ThemeMode? themeMode,
  }) {
    return SettingsModel(
      workDurationMinutes: workDurationMinutes ?? this.workDurationMinutes,
      restDurationSeconds: restDurationSeconds ?? this.restDurationSeconds,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      themeMode: themeMode ?? this.themeMode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'workDurationMinutes': workDurationMinutes,
      'restDurationSeconds': restDurationSeconds,
      'soundEnabled': soundEnabled,
      'vibrationEnabled': vibrationEnabled,
      'themeMode': themeMode.index,
    };
  }

  factory SettingsModel.fromJson(Map<String, dynamic> json) {
    return SettingsModel(
      workDurationMinutes: json['workDurationMinutes'] ?? 20,
      restDurationSeconds: json['restDurationSeconds'] ?? 20,
      soundEnabled: json['soundEnabled'] ?? true,
      vibrationEnabled: json['vibrationEnabled'] ?? true,
      themeMode: ThemeMode.values[json['themeMode'] ?? 0],
    );
  }
}
