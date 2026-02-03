import 'package:shared_preferences/shared_preferences.dart';

/// 온보딩 상태 관리 Repository
class OnboardingRepository {
  static const String _keyOnboardingCompleted = 'onboarding_completed';

  /// 온보딩 완료 여부 확인
  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// 온보딩 완료 처리
  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingCompleted, true);
  }

  /// 온보딩 초기화 (테스트용)
  Future<void> resetOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyOnboardingCompleted);
  }
}
