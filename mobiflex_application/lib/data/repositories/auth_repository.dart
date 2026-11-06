/// Defines the authentication actions available to the app.
///
/// Screens depend on this contract so authentication can be
/// replaced with a fake implementation during testing.
abstract interface class AuthRepository {
  /// Signs in with the supplied email and password.
  ///
  /// Completes when sign-in succeeds, or throws if it fails.
  Future<void> signIn({required String email, required String password});
}
