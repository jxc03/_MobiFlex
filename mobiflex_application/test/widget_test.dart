import 'dart:async';
import 'package:mobiflex_application/domain/auth/auth_failure.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobiflex_application/data/repositories/auth_repository.dart';
import 'package:mobiflex_application/screens/login_screen.dart';

// Keeps requests pending so each test controls when they finish.
class _FakeAuthRepository implements AuthRepository {
  final pendingResult = Completer<void>();
  int signInCalls = 0;

  @override
  Future<void> signIn({required String email, required String password}) {
    signInCalls++;
    return pendingResult.future;
  }
}

void main() {
  testWidgets('Empty fields prevent a sign-in request', (tester) async {
    final repository = _FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(authRepository: repository)),
    );

    await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
    await tester.pump();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(repository.signInCalls, 0);
  });

  testWidgets('Login shows loading and recovers after failure', (tester) async {
    final repository = _FakeAuthRepository();

    await tester.pumpWidget(
      MaterialApp(home: LoginScreen(authRepository: repository)),
    );

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'test@example.com',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'test-password');

    await tester.tap(find.widgetWithText(FilledButton, 'Log in'));
    await tester.pump();

    expect(repository.signInCalls, 1);
    expect(find.text('Logging in...'), findsOneWidget);

    final loadingButton = tester.widget<FilledButton>(
      find.byType(FilledButton),
    );
    expect(loadingButton.onPressed, isNull);

    // Simulate a failed request without contacting Firebase.
    repository.pendingResult.completeError(AuthFailure.invalidCredentials);

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(
      find.text('Unable to log in. Check your email and password.'),
      findsOneWidget,
    );

    final readyButton = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(readyButton.onPressed, isNotNull);
    expect(find.widgetWithText(FilledButton, 'Log in'), findsOneWidget);
  });
}
