// Basic widget test to verify the app builds and boots correctly.

import 'package:flutter_test/flutter_test.dart';

import 'package:ever_salon/main.dart';

void main() {
  testWidgets('App builds and boots without errors', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    // Advance past the splash screen's 3.5s navigation timer.
    await tester.pump(const Duration(seconds: 4));
    await tester.pump();

    // No exceptions thrown means the app booted successfully.
    expect(tester.takeException(), isNull);
  });
}