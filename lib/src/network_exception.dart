/// A marker interface implemented by all network exceptions.
abstract class NetworkException implements Exception {}

/// {@template network_exception}
/// A network exception that should never happen but happened anyway because of
/// a wrong assumptions/usages of a network service or a network error.
///
/// It should be reported using a crash reporting tool if it occurs in
/// production to fix it ASAP as it is intentionally unhandled programmatically,
/// and it is not expected to happen.
///
/// Extending [Error] class allows to automatically have a stack trace in the
/// first time the error is thrown by a `throw` expression.
/// {@endtemplate}
class UnexpectedNetworkError extends Error implements NetworkException {
  /// Message describing the error.
  final Object? message;

  /// {@macro network_exception}
  UnexpectedNetworkError([this.message]);

  @override
  String toString() {
    if (message != null) return Error.safeToString(message);
    return 'Unexpected error.';
  }
}
