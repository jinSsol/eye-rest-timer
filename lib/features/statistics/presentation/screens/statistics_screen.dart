import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_config.dart';
import '../providers/statistics_provider.dart';

/// 통계 화면 - Nuny 스타일
class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  BannerAd? _bannerAd;
  bool _isBannerAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadBannerAd();
  }

  void _loadBannerAd() {
    final adUnitId = Platform.isAndroid
        ? AppConfig.androidBannerAdId
        : AppConfig.iosBannerAdId;

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _isBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('Banner ad failed to load: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = ref.watch(statisticsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark
              ? [AppColors.bgDarkLight, AppColors.bgDarkDeep]
              : [const Color(0xFFFFF9E6), const Color(0xFFF5E6A3)],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50), // 상단 탭바 공간

              // 오늘 카드
              _buildTodayCard(stats, isDark),
              const SizedBox(height: 16),

              // 통계 카드들 (3개 가로 배치)
              Row(
                children: [
                  Expanded(
                    child: _buildMiniStatCard(
                      icon: Icons.local_fire_department_rounded,
                      iconColor: AppColors.coral,
                      title: '연속',
                      value: '${stats.streakDays}',
                      unit: '일',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMiniStatCard(
                      icon: Icons.emoji_events_rounded,
                      iconColor: AppColors.yellow,
                      title: '최고',
                      value: '${stats.longestStreak}',
                      unit: '일',
                      isDark: isDark,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildMiniStatCard(
                      icon: Icons.visibility_rounded,
                      iconColor: AppColors.blue,
                      title: '총',
                      value: '${stats.totalCount}',
                      unit: '회',
                      isDark: isDark,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 주간 그래프
              _buildWeeklyChart(context, stats, isDark),
              const SizedBox(height: 20),

              // 배너 광고
              _buildAdBanner(isDark),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodayCard(StatisticsState stats, bool isDark) {
    String message;
    IconData messageIcon;
    if (stats.todayCount == 0) {
      message = '오늘 첫 휴식을 시작해보세요!';
      messageIcon = Icons.eco_rounded;
    } else if (stats.todayCount < 5) {
      message = '좋은 시작이에요! 계속 가봐요';
      messageIcon = Icons.fitness_center_rounded;
    } else {
      message = '오늘 눈 건강 챔피언!';
      messageIcon = Icons.celebration_rounded;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // 왼쪽: 오늘 휴식 횟수
          Expanded(
            child: Row(
              children: [
                Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.yellow),
                const SizedBox(width: 8),
                Text(
                  '오늘 휴식',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  '${stats.todayCount}',
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primary,
                  ),
                ),
                const Text(
                  '회',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          // 오른쪽: 메시지
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? AppColors.bgDarkGreen : AppColors.bgGreenLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(messageIcon, size: 14, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  message,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: iconColor,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.grey[400] : Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, StatisticsState stats, bool isDark) {
    final maxCount = stats.weeklyData.isEmpty
        ? 1
        : stats.weeklyData.map((e) => e.restCount).reduce((a, b) => a > b ? a : b);
    final effectiveMax = maxCount == 0 ? 1 : maxCount;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                '이번 주',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: stats.weeklyData.asMap().entries.map((entry) {
                final index = entry.key;
                final record = entry.value;
                final height = (record.restCount / effectiveMax) * 80;
                final isToday = index == stats.weeklyData.length - 1;
                final dayFormat = DateFormat('E', 'ko');
                final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${record.restCount}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: isToday ? AppColors.primary : secondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: 32,
                      height: height.clamp(8.0, 80.0),
                      decoration: BoxDecoration(
                        color: isToday ? AppColors.primary : (isDark ? AppColors.bgDarkGreen : AppColors.bgGreenLight),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dayFormat.format(record.date),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                        color: isToday ? AppColors.primary : secondaryColor,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdBanner(bool isDark) {
    if (_isBannerAdLoaded && _bannerAd != null) {
      return Container(
        height: 60,
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.hardEdge,
        child: AdWidget(ad: _bannerAd!),
      );
    }

    // 광고 로딩 중 플레이스홀더
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }
}
