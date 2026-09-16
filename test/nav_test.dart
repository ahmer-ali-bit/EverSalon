import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ever_salon/screen/auth/auth%20screens/login_screen.dart';

void main() {
  testWidgets('login screen taps Login -> MainScreen without error', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
  });
}
