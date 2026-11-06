import 'package:firebase_auth/firebase_auth.dart';

import 'auth_repository.dart';

/// Performs authentication actions using Firebase.
class FirebaseAuthRepository implements AuthRepository {
  /// Uses the supplied Firebase client, or the default app's client.
  FirebaseAuthRepository({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;

  @override
  Future<void> signIn({required String email, required String password}) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }
}
