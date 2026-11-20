import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobiflex_application/screens/login_screen.dart';

void main() {
  testWidgets('Login can show and hide a typed password', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

    final field = find.widgetWithText(TextField, 'Password');
    TextField passwordField() => tester.widget<TextField>(field);

    await tester.enterText(field, 'example123');
    expect(passwordField().obscureText, isTrue);

    await tester.tap(find.byTooltip('Show password'));
    await tester.pump();
    expect(passwordField().obscureText, isFalse);

    await tester.tap(find.byTooltip('Hide password'));
    await tester.pump();
    expect(passwordField().obscureText, isTrue);
    expect(passwordField().controller?.text, 'example123');
  });

  testWidgets('Empty login shows both required field messages', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

  await tester.tap(find.text('Log in'));
  await tester.pump();

  expect(find.text('Enter your email'), findsOneWidget);
  expect(find.text('Enter your password'), findsOneWidget);
});
}
