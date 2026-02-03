import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/timer_state.dart';
import '../../../statistics/presentation/providers/statistics_provider.dart';

/// 타이머 상태 관리 Provider
final timerProvider = StateNotifierProvider<TimerNotifier, TimerState>((ref) {
  return TimerNotifier(ref);
});

/// 타이머 StateNotifier
class TimerNotifier extends StateNotifier<TimerState> {
  Timer? _timer;
  final Ref _ref;

  TimerNotifier(this._ref) : super(const TimerState());

  /// 타이머 시작
  void start() {
    if (state.status == TimerStatus.running) return;

    state = state.copyWith(
      status: TimerStatus.running,
      remainingSeconds: state.status == TimerStatus.paused
          ? state.remainingSeconds
          : state.totalWorkSeconds,
    );
    _startTimer();
  }

  /// 타이머 일시정지
  void pause() {
    if (state.status != TimerStatus.running) return;
    _timer?.cancel();
    state = state.copyWith(status: TimerStatus.paused);
  }

  /// 타이머 재개
  void resume() {
    if (state.status != TimerStatus.paused) return;
    state = state.copyWith(status: TimerStatus.running);
    _startTimer();
  }

  /// 타이머 리셋
  void reset() {
    _timer?.cancel();
    state = state.copyWith(
      status: TimerStatus.idle,
      remainingSeconds: state.totalWorkSeconds,
    );
  }

  /// 휴식 건너뛰기
  void skipRest() {
    if (state.status != TimerStatus.resting) return;
    _completeRest(skipped: true);
  }

  /// 작업 시간 설정
  void setWorkDuration(int minutes) {
    final seconds = minutes * 60;
    state = state.copyWith(
      totalWorkSeconds: seconds,
      remainingSeconds: state.status == TimerStatus.idle ? seconds : state.remainingSeconds,
    );
  }

  /// 휴식 시간 설정
  void setRestDuration(int seconds) {
    state = state.copyWith(totalRestSeconds: seconds);
  }

  /// 오늘 횟수 및 연속일 설정 (통계에서 로드)
  void setStats({required int todayCount, required int streakDays}) {
    state = state.copyWith(
      todayCount: todayCount,
      streakDays: streakDays,
    );
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    if (state.remainingSeconds > 0) {
      state = state.copyWith(remainingSeconds: state.remainingSeconds - 1);
    } else {
      _timer?.cancel();
      if (state.status == TimerStatus.running) {
        _startRest();
      } else if (state.status == TimerStatus.resting) {
        _completeRest();
      }
    }
  }

  void _startRest() {
    state = state.copyWith(
      status: TimerStatus.resting,
      remainingSeconds: state.totalRestSeconds,
    );
    _startTimer();
  }

  void _completeRest({bool skipped = false}) {
    _timer?.cancel();

    // 통계 업데이트 (건너뛰지 않은 경우에만)
    if (!skipped) {
      _ref.read(statisticsProvider.notifier).incrementTodayCount();
    }

    final newCount = skipped ? state.todayCount : state.todayCount + 1;
    state = state.copyWith(
      status: TimerStatus.idle,
      remainingSeconds: state.totalWorkSeconds,
      todayCount: newCount,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
