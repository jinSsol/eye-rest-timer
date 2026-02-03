import 'package:hive/hive.dart';

part 'statistics_model.g.dart';

/// 일일 기록 모델
@HiveType(typeId: 0)
class DailyRecord extends HiveObject {
  @HiveField(0)
  final DateTime date;

  @HiveField(1)
  final int restCount;

  DailyRecord({
    required this.date,
    required this.restCount,
  });

  DailyRecord copyWith({
    DateTime? date,
    int? restCount,
  }) {
    return DailyRecord(
      date: date ?? this.date,
      restCount: restCount ?? this.restCount,
    );
  }
}
