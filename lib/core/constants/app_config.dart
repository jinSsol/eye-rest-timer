/// 앱 설정 상수
class AppConfig {
  AppConfig._();

  // Timer defaults
  static const int defaultWorkMinutes = 20;
  static const int defaultRestSeconds = 20;
  static const int minWorkMinutes = 10;
  static const int maxWorkMinutes = 60;
  static const int minRestSeconds = 10;
  static const int maxRestSeconds = 60;

  // AdMob IDs (실제)
  static const String androidBannerAdId = 'ca-app-pub-6739796437725652/9757000004';
  static const String iosBannerAdId = 'ca-app-pub-3940256099942544/2934735716'; // iOS는 나중에 교체
  static const String androidInterstitialAdId = 'ca-app-pub-3940256099942544/1033173712';
  static const String iosInterstitialAdId = 'ca-app-pub-3940256099942544/4411468910';

  // Ad frequency
  static const int interstitialAdFrequency = 3; // 3회 휴식마다 전면 광고

  // Animation
  static const int timerAnimationDuration = 300;
}
