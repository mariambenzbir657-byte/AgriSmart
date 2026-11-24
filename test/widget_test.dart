
import 'package:flutter_test/flutter_test.dart';
import 'package:agrismart/main.dart';

void main() {
  testWidgets('AgriSmart app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const AgriSmartApp());

    expect(find.byType(AgriSmartApp), findsOneWidget);
  });
}
