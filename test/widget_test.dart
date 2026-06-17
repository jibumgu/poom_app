import 'package:flutter_test/flutter_test.dart';

import 'package:poom_app/main.dart';

void main() {
  testWidgets('Poom app renders intro, auth, and home', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const PoomApp());

    expect(find.text('품'), findsOneWidget);

    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    expect(find.text('품 시작하기'), findsOneWidget);
    await tester.tap(find.text('지금은 둘러보기'));
    await tester.pumpAndSettle();

    expect(find.text('오늘 필요한 연결'), findsOneWidget);
  });
}
