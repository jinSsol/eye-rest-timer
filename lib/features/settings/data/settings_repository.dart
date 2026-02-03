import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/settings_model.dart';

/// 설정 저장소
class SettingsRepository {
  static const String _key = 'settings';

  Future<SettingsModel> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_key);
    if (jsonString == null) {
      return const SettingsModel();
    }
    try {
      final json = jsonDecode(jsonString) as Map<String, dynamic>;
      return SettingsModel.fromJson(json);
    } catch (e) {
      return const SettingsModel();
    }
  }

  Future<void> saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(settings.toJson());
    await prefs.setString(_key, jsonString);
  }
}
