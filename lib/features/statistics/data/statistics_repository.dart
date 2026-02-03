import 'package:hive/hive.dart';
import '../domain/statistics_model.dart';

/// 통계 저장소
class StatisticsRepository {
  static const String _boxName = 'daily_records';
  Box<DailyRecord>? _box;

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DailyRecordAdapter());
    }
    _box = await Hive.openBox<DailyRecord>(_boxName);
  }

  String _dateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 오늘 기록 가져오기
  DailyRecord? getTodayRecord() {
    final key = _dateKey(DateTime.now());
    return _box?.get(key);
  }

  /// 오늘 휴식 횟수 가져오기
  int getTodayCount() {
    return getTodayRecord()?.restCount ?? 0;
  }

  /// 휴식 횟수 증가
  Future<void> incrementTodayCount() async {
    final today = DateTime.now();
    final key = _dateKey(today);
    final current = _box?.get(key);

    if (current != null) {
      final updated = current.copyWith(restCount: current.restCount + 1);
      await _box?.put(key, updated);
    } else {
      final newRecord = DailyRecord(
        date: DateTime(today.year, today.month, today.day),
        restCount: 1,
      );
      await _box?.put(key, newRecord);
    }
  }

  /// 주간 데이터 가져오기 (최근 7일)
  List<DailyRecord> getWeeklyData() {
    final records = <DailyRecord>[];
    final today = DateTime.now();

    for (int i = 6; i >= 0; i--) {
      final date = today.subtract(Duration(days: i));
      final key = _dateKey(date);
      final record = _box?.get(key);
      if (record != null) {
        records.add(record);
      } else {
        records.add(DailyRecord(
          date: DateTime(date.year, date.month, date.day),
          restCount: 0,
        ));
      }
    }

    return records;
  }

  /// 연속 일수 계산
  int calculateStreak() {
    int streak = 0;
    final today = DateTime.now();

    for (int i = 0; i < 365; i++) {
      final date = today.subtract(Duration(days: i));
      final key = _dateKey(date);
      final record = _box?.get(key);

      if (record != null && record.restCount > 0) {
        streak++;
      } else if (i > 0) {
        break;
      }
    }

    return streak;
  }

  /// 총 휴식 횟수
  int getTotalCount() {
    int total = 0;
    _box?.values.forEach((record) {
      total += record.restCount;
    });
    return total;
  }

  /// 최장 연속 기록
  int getLongestStreak() {
    if (_box == null || _box!.isEmpty) return 0;

    final records = _box!.values.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    int longest = 0;
    int current = 0;
    DateTime? prevDate;

    for (final record in records) {
      if (record.restCount > 0) {
        if (prevDate == null ||
            record.date.difference(prevDate).inDays == 1) {
          current++;
        } else {
          current = 1;
        }
        if (current > longest) longest = current;
        prevDate = record.date;
      } else {
        current = 0;
        prevDate = null;
      }
    }

    return longest;
  }
}
