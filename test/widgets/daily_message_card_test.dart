import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:your_app/widgets/daily_message_card.dart';

void main() {
  testWidgets('DailyMessageCard shows loading state', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => AppState(MockContentService()),
          child: DailyMessageCard(),
        ),
      ),
    );

    // Assert
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('DailyMessageCard shows message content', (WidgetTester tester) async {
    // Arrange
    final testMessage = 'Test message content';
    final appState = AppState(MockContentService())..setTestMessage(testMessage);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider.value(
          value: appState,
          child: DailyMessageCard(),
        ),
      ),
    );

    // Assert
    expect(find.text(testMessage), findsOneWidget);
  });
}
