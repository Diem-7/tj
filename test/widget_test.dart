import 'package:flutter_test/flutter_test.dart';

import 'package:tj/main.dart';

void main() {
  testWidgets('shows accounts screen', (WidgetTester tester) async {
    await tester.pumpWidget(const TradingJournalApp());

    expect(find.text('Konten'), findsOneWidget);
  });
}
