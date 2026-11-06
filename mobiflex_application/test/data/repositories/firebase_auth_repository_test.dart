import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobiflex_application/data/repositories/firebase_auth_repository.dart';
import 'package:mobiflex_application/domain/auth/auth_failure.dart';

// Simulates a Firebase client that fails with a chosen error code.
class _FailingFirebaseAuth extends Fake implements FirebaseAuth {
  _FailingFirebaseAuth(this.errorCode);

  final String errorCode;

  @override
  Future<UserCredential> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    throw FirebaseAuthException(code: errorCode);
  }
}

void main() {
  const cases = <String, AuthFailure>{
    'invalid-credential': AuthFailure.invalidCredentials,
    'wrong-password': AuthFailure.invalidCredentials,
    'user-not-found': AuthFailure.invalidCredentials,
    'invalid-email': AuthFailure.invalidCredentials,
    'too-many-requests': AuthFailure.tooManyRequests,
    'network-request-failed': AuthFailure.network,
    'operation-not-allowed': AuthFailure.unavailable,
    'unexpected-error-code': AuthFailure.unknown,
  };

  for (final entry in cases.entries) {
    test('${entry.key} becomes ${entry.value.name}', () async {
      final firebaseClient = _FailingFirebaseAuth(entry.key);

      // Exercise the real repository with a controlled Firebase client.
      final repository = FirebaseAuthRepository(firebaseAuth: firebaseClient);

      await expectLater(
        repository.signIn(email: 'test@example.com', password: 'test-password'),
        throwsA(same(entry.value)),
      );
    });
  }
}
