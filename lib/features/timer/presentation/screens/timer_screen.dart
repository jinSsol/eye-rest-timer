import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/eye_character.dart';
import '../../domain/timer_state.dart';
import '../providers/timer_provider.dart';
import '../widgets/rest_overlay.dart';

/// 타이머 메인 화면 - Nuny 스타일
class TimerScreen extends ConsumerWidget {
  const TimerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // 배경 (빈 상태)
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: _getEmptyBackgroundColors(isDark),
            ),
          ),
        ),
        // 프로그레스 배경 (아래에서 위로 채워짐)
        if (timerState.status == TimerStatus.running ||
            timerState.status == TimerStatus.paused)
          Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: timerState.progress.clamp(0.0, 1.0),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: _getProgressBackgroundColors(timerState.status, isDark),
                  ),
                ),
              ),
            ),
          ),
        // 휴식/대기 상태 배경
        if (timerState.status == TimerStatus.resting ||
            timerState.status == TimerStatus.idle)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: _getBackgroundColors(timerState.status, isDark),
              ),
            ),
          ),
        // 메인 컨텐츠
        SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 60), // 상단 탭바 공간
                // 상단 타이머 표시 (작은 알약 모양)
                _buildTimerPill(context, timerState, isDark),
                const Spacer(),
                // 메인 캐릭터 & 메시지
                _buildMainContent(context, timerState, ref, isDark),
                const Spacer(),
                // 하단 통계 & 버튼
                _buildBottomSection(context, timerState, ref, isDark),
                const SizedBox(height: 40),
              ],
            ),
        ),
        // 휴식 오버레이
        const RestOverlay(),
      ],
    );
  }

  // 빈 배경 (progress가 채워지기 전)
  List<Color> _getEmptyBackgroundColors(bool isDark) {
    if (isDark) {
      return [AppColors.bgDarkLight, AppColors.bgDarkDeep];
    }
    return [const Color(0xFFE8E4D9), const Color(0xFFD4CFC2)];
  }

  // 진행률에 따라 채워지는 색상
  List<Color> _getProgressBackgroundColors(TimerStatus status, bool isDark) {
    if (isDark) {
      switch (status) {
        case TimerStatus.running:
          return [AppColors.bgDarkGreenLight, AppColors.bgDarkGreen];
        case TimerStatus.paused:
          return [const Color(0xFF4A3D2A), const Color(0xFF3D3020)];
        default:
          return [AppColors.bgDarkGreenLight, AppColors.bgDarkGreen];
      }
    }
    switch (status) {
      case TimerStatus.running:
        return [AppColors.bgGreenLight, AppColors.bgGreenDark];
      case TimerStatus.paused:
        return [const Color(0xFFFFE4B5), const Color(0xFFFFD180)];
      default:
        return [AppColors.bgGreenLight, AppColors.bgGreenDark];
    }
  }

  List<Color> _getBackgroundColors(TimerStatus status, bool isDark) {
    if (isDark) {
      switch (status) {
        case TimerStatus.running:
          return [AppColors.bgDarkGreenLight, AppColors.bgDarkGreen];
        case TimerStatus.paused:
          return [AppColors.bgDarkLight, AppColors.bgDarkDeep];
        case TimerStatus.resting:
          return [const Color(0xFF4A2D3A), const Color(0xFF3D2030)];
        case TimerStatus.idle:
          return [AppColors.bgDarkGreenLight, AppColors.bgDarkGreen];
      }
    }
    switch (status) {
      case TimerStatus.running:
        return [AppColors.bgGreenLight, AppColors.bgGreenDark];
      case TimerStatus.paused:
        return [const Color(0xFFE8E4D9), const Color(0xFFD4CFC2)];
      case TimerStatus.resting:
        return [const Color(0xFFE8D4D6), const Color(0xFFD4A8AC)];
      case TimerStatus.idle:
        return [AppColors.bgGreenLight, AppColors.bgGreenDark];
    }
  }

  Widget _buildTimerPill(BuildContext context, TimerState state, bool isDark) {
    if (state.status == TimerStatus.idle) {
      return const SizedBox(height: 48);
    }

    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final bgColor = isDark ? AppColors.cardDark.withOpacity(0.9) : Colors.white.withOpacity(0.9);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
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
          Icon(
            state.status == TimerStatus.resting ? Icons.visibility : Icons.timer_outlined,
            size: 20,
            color: textColor,
          ),
          const SizedBox(width: 8),
          Text(
            state.formattedTime,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: textColor,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, TimerState state, WidgetRef ref, bool isDark) {
    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;

    return Column(
      children: [
        // 메시지
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Text(
            _getMessage(state),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: textColor,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 40),
        // 눈 캐릭터
        SimpleEyes(
          size: 80,
          isBlinking: true,
          lookDirection: state.status == TimerStatus.running ? null : 0,
        ),
        const SizedBox(height: 40),
        // 서브 메시지
        if (state.status == TimerStatus.idle) ...[
          _buildStreakBadge(state, isDark),
        ],
      ],
    );
  }

  String _getMessage(TimerState state) {
    switch (state.status) {
      case TimerStatus.idle:
        if (state.todayCount == 0) {
          return '작은 습관으로 건강 챙기기,\n지금 시작해볼까요?';
        } else {
          return '오늘 ${state.todayCount}번 쉬었어요!\n계속해볼까요?';
        }
      case TimerStatus.running:
        return _getRunningMessage(state.progress);
      case TimerStatus.paused:
        return '잠시 멈췄어요\n준비되면 다시 시작해요';
      case TimerStatus.resting:
        return '눈을 쉬는 시간이에요\n멀리 바라보세요 👀';
    }
  }

  Widget _buildStreakBadge(TimerState state, bool isDark) {
    if (state.streakDays == 0 && state.todayCount == 0) {
      return const SizedBox.shrink();
    }

    final textColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimary;
    final bgColor = isDark ? AppColors.cardDark.withOpacity(0.8) : Colors.white.withOpacity(0.8);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (state.streakDays > 0) ...[
            Icon(Icons.local_fire_department_rounded, size: 18, color: AppColors.coral),
            const SizedBox(width: 6),
            Text(
              '연속 ${state.streakDays}일 달성!',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ] else ...[
            Icon(Icons.auto_awesome_rounded, size: 18, color: AppColors.yellow),
            const SizedBox(width: 6),
            Text(
              '오늘 ${state.todayCount}회 완료',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBottomSection(BuildContext context, TimerState state, WidgetRef ref, bool isDark) {
    final timerNotifier = ref.read(timerProvider.notifier);
    final secondaryColor = isDark ? AppColors.textSecondaryDark : AppColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // 메인 버튼
          _buildMainButton(state, timerNotifier, isDark),
          // 리셋 버튼 (일시정지 상태일 때만)
          if (state.status == TimerStatus.paused) ...[
            const SizedBox(height: 12),
            TextButton(
              onPressed: timerNotifier.reset,
              child: Text(
                '처음으로',
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getRunningMessage(double progress) {
    if (progress < 0.1) {
      return '집중 시작!\n오늘도 화이팅!';
    } else if (progress < 0.25) {
      return '좋은 출발이에요!\n계속 집중해봐요';
    } else if (progress < 0.4) {
      return '잘하고 있어요!\n조금만 더 힘내요';
    } else if (progress < 0.5) {
      return '절반 가까이 왔어요!\n대단해요';
    } else if (progress < 0.6) {
      return '반 넘었어요!\n끝까지 파이팅';
    } else if (progress < 0.75) {
      return '거의 다 왔어요!\n조금만 더!';
    } else if (progress < 0.9) {
      return '마무리 단계예요!\n끝이 보여요';
    } else {
      return '거의 완료!\n곧 휴식 시간이에요';
    }
  }

  Widget _buildMainButton(TimerState state, TimerNotifier notifier, bool isDark) {
    String label;
    VoidCallback onPressed;
    Color bgColor = isDark ? AppColors.primaryLight : AppColors.buttonPrimary;

    switch (state.status) {
      case TimerStatus.idle:
        label = '시작하기';
        onPressed = notifier.start;
        break;
      case TimerStatus.running:
        label = '일시정지';
        onPressed = notifier.pause;
        bgColor = AppColors.yellow;
        break;
      case TimerStatus.paused:
        label = '계속하기';
        onPressed = notifier.resume;
        break;
      case TimerStatus.resting:
        label = '건너뛰기';
        onPressed = notifier.skipRest;
        bgColor = isDark ? Colors.white.withOpacity(0.2) : Colors.white.withOpacity(0.3);
        break;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: state.status == TimerStatus.running
              ? AppColors.textPrimary
              : Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
