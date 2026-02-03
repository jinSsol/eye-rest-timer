import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:eye_rest_timer/app.dart';

void main() {
  testWidgets('App starts correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: EyeRestTimerApp(),
      ),
    );

    // 앱 타이틀이 표시되는지 확인
    expect(find.text('눈 휴식 타이머'), findsOneWidget);
  });
}
