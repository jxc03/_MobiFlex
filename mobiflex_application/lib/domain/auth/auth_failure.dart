/// Authentication failures that the app understands.
enum AuthFailure implements Exception {
  /// The supplied email and password could not authenticate the user.
  invalidCredentials,

  /// Requests have temporarily been limited.
  tooManyRequests,

  /// The authentication service could not be reached.
  network,

  /// The requested authentication method is unavailable.
  unavailable,

  /// An authentication error without a specific mapping.
  unknown,
}
