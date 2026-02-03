import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/eye_character.dart';
import '../../domain/timer_state.dart';
import '../providers/timer_provider.dart';

/// 휴식 오버레이 위젯 - Nuny 스타일
class RestOverlay extends ConsumerWidget {
  const RestOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timerState = ref.watch(timerProvider);
    final timerNotifier = ref.read(timerProvider.notifier);

    if (timerState.status != TimerStatus.resting) {
      return const SizedBox.shrink();
    }

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF8B9A7D),
              Color(0xFF6B7A5D),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // 상단 탭바 공간 확보
              const SizedBox(height: 50),
              // 상단 컨트롤
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // 사운드 버튼
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.volume_up_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                    // 타이머 표시
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.visibility,
                            color: Colors.white,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '00:${timerState.remainingSeconds.toString().padLeft(2, '0')}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFeatures: [FontFeature.tabularFigures()],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // 닫기 버튼
                    GestureDetector(
                      onTap: timerNotifier.skipRest,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // 눈 캐릭터 (방향 표시)
              _buildEyesWithDirection(timerState.remainingSeconds),
              const SizedBox(height: 40),
              // 안내 메시지
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  _getGuideMessage(timerState.remainingSeconds),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
              ),
              const Spacer(),
              // 하단 버튼
              Padding(
                padding: const EdgeInsets.all(24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: timerNotifier.skipRest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.2),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      '건너뛰기',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEyesWithDirection(int remainingSeconds) {
    // 5초마다 방향 변경
    double lookDirection;
    if (remainingSeconds > 15) {
      lookDirection = -0.8; // 왼쪽
    } else if (remainingSeconds > 10) {
      lookDirection = 0.8; // 오른쪽
    } else if (remainingSeconds > 5) {
      lookDirection = -0.8; // 왼쪽
    } else {
      lookDirection = 0.8; // 오른쪽
    }

    return Column(
      children: [
        // 방향 화살표
        if (remainingSeconds > 3)
          Icon(
            lookDirection < 0 ? Icons.arrow_back : Icons.arrow_forward,
            size: 48,
            color: Colors.white.withOpacity(0.6),
          ),
        const SizedBox(height: 30),
        // 눈
        SimpleEyes(
          size: 90,
          isBlinking: false,
          lookDirection: lookDirection,
        ),
      ],
    );
  }

  String _getGuideMessage(int seconds) {
    if (seconds > 15) {
      return '왼쪽을 바라보세요 👈';
    } else if (seconds > 10) {
      return '오른쪽을 바라보세요 👉';
    } else if (seconds > 5) {
      return '다시 왼쪽으로 👈';
    } else {
      return '거의 다 됐어요! 조금만 더 👀';
    }
  }
}
