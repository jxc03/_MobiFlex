import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/auth/auth_failure.dart';
import 'auth_repository.dart';

/// Performs authentication actions using Firebase.
class FirebaseAuthRepository implements AuthRepository {
  /// Uses the supplied Firebase client, or the default app's client.
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      // Translate backend codes so screens depend on app-level failures.
      final failure = switch (error.code) {
        'invalid-credential' ||
        'wrong-password' ||
        'user-not-found' ||
        'invalid-email' => AuthFailure.invalidCredentials,
        'too-many-requests' => AuthFailure.tooManyRequests,
        'network-request-failed' => AuthFailure.network,
        'operation-not-allowed' => AuthFailure.unavailable,
        _ => AuthFailure.unknown,
      };

      throw failure;
    }
  }
}
