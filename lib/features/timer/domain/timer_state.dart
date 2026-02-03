import 'package:flutter/foundation.dart';

/// 타이머 상태 enum
enum TimerStatus {
  idle,     // 대기 상태
  running,  // 실행 중
  paused,   // 일시정지
  resting,  // 휴식 중
}

/// 타이머 상태 모델
@immutable
class TimerState {
  final TimerStatus status;
  final int remainingSeconds;
  final int totalWorkSeconds;
  final int totalRestSeconds;
  final int todayCount;
  final int streakDays;

  const TimerState({
    this.status = TimerStatus.idle,
    this.remainingSeconds = 1200, // 20분 = 1200초
    this.totalWorkSeconds = 1200,
    this.totalRestSeconds = 20,
    this.todayCount = 0,
    this.streakDays = 0,
  });

  /// 진행률 계산 (0.0 ~ 1.0)
  double get progress {
    if (status == TimerStatus.resting) {
      return 1.0 - (remainingSeconds / totalRestSeconds);
    }
    return 1.0 - (remainingSeconds / totalWorkSeconds);
  }

  /// 남은 시간 포맷팅 (MM:SS)
  String get formattedTime {
    final minutes = remainingSeconds ~/ 60;
    final seconds = remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  TimerState copyWith({
    TimerStatus? status,
    int? remainingSeconds,
    int? totalWorkSeconds,
    int? totalRestSeconds,
    int? todayCount,
    int? streakDays,
  }) {
    return TimerState(
      status: status ?? this.status,
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      totalWorkSeconds: totalWorkSeconds ?? this.totalWorkSeconds,
      totalRestSeconds: totalRestSeconds ?? this.totalRestSeconds,
      todayCount: todayCount ?? this.todayCount,
      streakDays: streakDays ?? this.streakDays,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimerState &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          remainingSeconds == other.remainingSeconds &&
          totalWorkSeconds == other.totalWorkSeconds &&
          totalRestSeconds == other.totalRestSeconds &&
          todayCount == other.todayCount &&
          streakDays == other.streakDays;

  @override
  int get hashCode =>
      status.hashCode ^
      remainingSeconds.hashCode ^
      totalWorkSeconds.hashCode ^
      totalRestSeconds.hashCode ^
      todayCount.hashCode ^
      streakDays.hashCode;
}
