import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/constants/app_colors.dart';
import 'features/settings/presentation/providers/settings_provider.dart';
import 'features/timer/presentation/screens/timer_screen.dart';
import 'features/statistics/presentation/screens/statistics_screen.dart';
import 'features/settings/presentation/screens/settings_screen.dart';
import 'features/onboarding/presentation/screens/onboarding_screen.dart';
import 'features/onboarding/data/onboarding_repository.dart';

/// 현재 선택된 화면 인덱스
final currentScreenProvider = StateProvider<int>((ref) => 0);

/// 메인 앱 위젯
class EyeRestTimerApp extends ConsumerWidget {
  const EyeRestTimerApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return MaterialApp(
      title: '삼이공',
      debugShowCheckedModeBanner: false,
      theme: _buildLightTheme(),
      darkTheme: _buildDarkTheme(),
      themeMode: settings.themeMode,
      home: const MainScreen(),
    );
  }

  static const String _fontFamily = 'Cafe24Ssurround';

  ThemeData _buildLightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: AppColors.bgGreenLight,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.accent,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: AppColors.textPrimary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.buttonPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  ThemeData _buildDarkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: _fontFamily,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primaryLight,
        secondary: AppColors.accent,
        surface: AppColors.surfaceDark,
        onPrimary: AppColors.backgroundDark,
        onSurface: AppColors.textPrimaryDark,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: AppColors.backgroundDark,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/// 메인 화면 (상단 탭바)
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  bool _isLoading = true;
  bool _showOnboarding = false;
  final OnboardingRepository _onboardingRepo = OnboardingRepository();

  @override
  void initState() {
    super.initState();
    _checkOnboarding();
  }

  Future<void> _checkOnboarding() async {
    final isCompleted = await _onboardingRepo.isOnboardingCompleted();
    setState(() {
      _showOnboarding = !isCompleted;
      _isLoading = false;
    });
  }

  void _completeOnboarding() async {
    await _onboardingRepo.setOnboardingCompleted();
    setState(() {
      _showOnboarding = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_showOnboarding) {
      return OnboardingScreen(
        onComplete: _completeOnboarding,
      );
    }

    final currentIndex = ref.watch(currentScreenProvider);

    return Scaffold(
      body: Stack(
        children: [
          // 화면 내용
          IndexedStack(
            index: currentIndex,
            children: const [
              TimerScreen(),
              StatisticsScreen(),
              SettingsScreen(),
            ],
          ),
          // 상단 탭바
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            left: 0,
            right: 0,
            child: Center(
              child: _TopTabBar(
                currentIndex: currentIndex,
                onTabChanged: (index) {
                  ref.read(currentScreenProvider.notifier).state = index;
                },
                isDark: Theme.of(context).brightness == Brightness.dark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 상단 탭바 위젯
class _TopTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;
  final bool isDark;

  const _TopTabBar({
    required this.currentIndex,
    required this.onTabChanged,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark.withOpacity(0.9) : Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _TabItem(
            icon: Icons.timer_outlined,
            label: '타이머',
            isSelected: currentIndex == 0,
            onTap: () => onTabChanged(0),
            isDark: isDark,
          ),
          _TabItem(
            icon: Icons.bar_chart_rounded,
            label: '기록',
            isSelected: currentIndex == 1,
            onTap: () => onTabChanged(1),
            isDark: isDark,
          ),
          _TabItem(
            icon: Icons.settings_outlined,
            label: '설정',
            isSelected: currentIndex == 2,
            onTap: () => onTabChanged(2),
            isDark: isDark,
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _TabItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final unselectedColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.buttonPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : unselectedColor,
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
