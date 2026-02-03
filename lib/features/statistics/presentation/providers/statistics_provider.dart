import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/statistics_repository.dart';
import '../../domain/statistics_model.dart';

/// 통계 저장소 Provider
final statisticsRepositoryProvider = Provider((ref) => StatisticsRepository());

/// 통계 상태
class StatisticsState {
  final int todayCount;
  final int streakDays;
  final int totalCount;
  final int longestStreak;
  final List<DailyRecord> weeklyData;

  const StatisticsState({
    this.todayCount = 0,
    this.streakDays = 0,
    this.totalCount = 0,
    this.longestStreak = 0,
    this.weeklyData = const [],
  });

  StatisticsState copyWith({
    int? todayCount,
    int? streakDays,
    int? totalCount,
    int? longestStreak,
    List<DailyRecord>? weeklyData,
  }) {
    return StatisticsState(
      todayCount: todayCount ?? this.todayCount,
      streakDays: streakDays ?? this.streakDays,
      totalCount: totalCount ?? this.totalCount,
      longestStreak: longestStreak ?? this.longestStreak,
      weeklyData: weeklyData ?? this.weeklyData,
    );
  }
}

/// 통계 Provider
final statisticsProvider = StateNotifierProvider<StatisticsNotifier, StatisticsState>((ref) {
  final repository = ref.watch(statisticsRepositoryProvider);
  return StatisticsNotifier(repository);
});

/// 통계 StateNotifier
class StatisticsNotifier extends StateNotifier<StatisticsState> {
  final StatisticsRepository _repository;

  StatisticsNotifier(this._repository) : super(const StatisticsState()) {
    _init();
  }

  Future<void> _init() async {
    await _repository.init();
    refresh();
  }

  void refresh() {
    state = StatisticsState(
      todayCount: _repository.getTodayCount(),
      streakDays: _repository.calculateStreak(),
      totalCount: _repository.getTotalCount(),
      longestStreak: _repository.getLongestStreak(),
      weeklyData: _repository.getWeeklyData(),
    );
  }

  Future<void> incrementTodayCount() async {
    await _repository.incrementTodayCount();
    refresh();
  }
}
