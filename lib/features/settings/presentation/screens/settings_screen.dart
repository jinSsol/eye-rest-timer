import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_config.dart';
import '../../../onboarding/presentation/screens/onboarding_screen.dart';
import '../providers/settings_provider.dart';

/// 설정 화면 - 심플 스타일
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      color: isDark ? AppColors.backgroundDark : Colors.grey[100],
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),

              // 시간 설정 섹션
              _buildSectionTitle(Icons.schedule_rounded, '시간', isDark),
              const SizedBox(height: 12),
              _buildCard([
                _buildSliderItem(
                  title: '집중 시간',
                  value: settings.workDurationMinutes,
                  unit: '분',
                  min: AppConfig.minWorkMinutes,
                  max: AppConfig.maxWorkMinutes,
                  onChanged: (v) => settingsNotifier.setWorkDuration(v.toInt()),
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _buildSliderItem(
                  title: '휴식 시간',
                  value: settings.restDurationSeconds,
                  unit: '초',
                  min: AppConfig.minRestSeconds,
                  max: AppConfig.maxRestSeconds,
                  onChanged: (v) => settingsNotifier.setRestDuration(v.toInt()),
                  isDark: isDark,
                ),
              ], isDark),
              const SizedBox(height: 24),

              // 알림 섹션
              _buildSectionTitle(Icons.notifications_rounded, '알림', isDark),
              const SizedBox(height: 12),
              _buildCard([
                _buildToggleItem(
                  title: '소리',
                  value: settings.soundEnabled,
                  onChanged: settingsNotifier.setSoundEnabled,
                  isDark: isDark,
                ),
                _buildDivider(isDark),
                _buildToggleItem(
                  title: '진동',
                  value: settings.vibrationEnabled,
                  onChanged: settingsNotifier.setVibrationEnabled,
                  isDark: isDark,
                ),
              ], isDark),
              const SizedBox(height: 24),

              // 테마 섹션
              _buildSectionTitle(Icons.palette_rounded, '테마', isDark),
              const SizedBox(height: 12),
              _buildThemeSelector(settings.themeMode, settingsNotifier.setThemeMode, isDark),
              const SizedBox(height: 24),

              // 도움말 섹션
              _buildSectionTitle(Icons.help_outline_rounded, '도움말', isDark),
              const SizedBox(height: 12),
              _buildHelpButton(context, isDark),
              const SizedBox(height: 24),

              // 광고 배너
              Container(
                height: 60,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    '광고 배너 영역',
                    style: TextStyle(
                      color: isDark ? AppColors.textSecondaryDark : Colors.grey[400],
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(IconData icon, String title, bool isDark) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(List<Widget> children, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      indent: 16,
      endIndent: 16,
      color: isDark ? Colors.white.withOpacity(0.1) : Colors.grey[200],
    );
  }

  Widget _buildSliderItem({
    required String title,
    required int value,
    required String unit,
    required int min,
    required int max,
    required Function(double) onChanged,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '$value$unit',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: isDark ? Colors.white.withOpacity(0.2) : Colors.grey[200],
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withOpacity(0.1),
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
            ),
            child: Slider(
              value: value.toDouble(),
              min: min.toDouble(),
              max: max.toDouble(),
              divisions: max - min,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleItem({
    required String title,
    required bool value,
    required Function(bool) onChanged,
    required bool isDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeSelector(ThemeMode currentMode, Function(ThemeMode) onChanged, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _buildThemeOption(
            icon: Icons.phone_android_rounded,
            label: '시스템',
            isSelected: currentMode == ThemeMode.system,
            onTap: () => onChanged(ThemeMode.system),
            isDark: isDark,
          ),
          _buildThemeOption(
            icon: Icons.light_mode_rounded,
            label: '라이트',
            isSelected: currentMode == ThemeMode.light,
            onTap: () => onChanged(ThemeMode.light),
            isDark: isDark,
          ),
          _buildThemeOption(
            icon: Icons.dark_mode_rounded,
            label: '다크',
            isSelected: currentMode == ThemeMode.dark,
            onTap: () => onChanged(ThemeMode.dark),
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildThemeOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    final unselectedColor = isDark ? Colors.grey[400] : Colors.grey[500];

    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? Colors.white : unselectedColor,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : unselectedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHelpButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(isFromSettings: true),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDark ? AppColors.bgDarkGreen : AppColors.bgGreenLight,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.menu_book_rounded,
                size: 20,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '사용법 보기',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '20-20-20 규칙과 앱 사용법을 확인해요',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? Colors.grey[600] : Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}
