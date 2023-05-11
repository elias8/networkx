import 'package:meta/meta.dart';

import 'network_exception.dart';

part 'network_error_mixin.dart';

/// A network error that doesn't contain an API error.
typedef EmptyNetworkError = NetworkError<void>;

/// Generic network exception.
///
/// Helps us to propagate network exceptions from a remote source layer to any
/// layer above. By using [ NetworkError.api ] we can pass any custom
/// error [T] such as a validation error returned from a server.
@immutable
sealed class NetworkError<T>
    with _NetworkErrorHelperMixin<T>
    implements NetworkException {
  /// It occurs when a request is successfully made to a server and an error is
  /// returned from the server. For example, 404 (not found) response.
  ///
  /// In general, this exception is for client side errors with status 4xx.
  /// Checkout https://en.wikipedia.org/wiki/List_of_HTTP_status_codes#4xx_client_errors
  /// for more info.
  const factory NetworkError.api(T error) = _ApiError<T>;

  /// It occurs when a request is cancelled.
  const factory NetworkError.cancelled() = _RequestCancelledError<T>;

  /// It occurs when there is no internet connection.
  const factory NetworkError.connection() = _InternetConnectionError<T>;

  /// It occurs when [FormatException] or [TypeError] is thrown while decoding
  /// an API response.
  const factory NetworkError.format() = _NetworkFormatError<T>;

  /// It occurs when a server error (a response with a status code of >= 500)
  /// is returned from the server.
  const factory NetworkError.server() = _ServerError<T>;

  /// It occurs when opening, sending, or receiving data from/to an server is
  /// timeout.
  const factory NetworkError.timeout() = _NetworkTimeoutError<T>;

  /// It occurs when a network error is not handled properly.
  const factory NetworkError.unhandled() = _UnhandledError<T>;

  /// We don't want any other class to extend this class.
  const NetworkError._();

  // coverage:ignore-start
  @override
  int get hashCode => 0;

  // coverage:ignore-end

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkError<T> && runtimeType == other.runtimeType;

  @override
  String toString() {
    if (this is _ApiError<T>) {
      final error = (this as _ApiError<T>).error;
      return '$runtimeType($error)';
    }
    return '$runtimeType()';
  }
}

class _ApiError<T> extends NetworkError<T> {
  final T error;

  const _ApiError(this.error) : super._();

  @override
  int get hashCode => error.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ApiError<T> &&
          runtimeType == other.runtimeType &&
          error == other.error;
}

class _InternetConnectionError<T> extends NetworkError<T> {
  const _InternetConnectionError() : super._();
}

class _NetworkFormatError<T> extends NetworkError<T> {
  const _NetworkFormatError() : super._();
}

class _NetworkTimeoutError<T> extends NetworkError<T> {
  const _NetworkTimeoutError() : super._();
}

class _RequestCancelledError<T> extends NetworkError<T> {
  const _RequestCancelledError() : super._();
}

class _ServerError<T> extends NetworkError<T> {
  const _ServerError() : super._();
}

/// It occurs when a network error is not handled properly.
class _UnhandledError<T> extends NetworkError<T> {
  const _UnhandledError() : super._();
}

/// Extensions that are applied specifically on [EmptyNetworkError].
extension EmptyNetworkErrorX on EmptyNetworkError {
  /// Casts current exception's type from `void` to type [R].
  ///
  /// Since we are using `void` type on the current exception its guaranteed
  /// that we won't have a [NetworkError.api].
  NetworkError<R> cast<R extends Object>() {
    return switch (this) {
      _RequestCancelledError() => _RequestCancelledError<R>(),
      _InternetConnectionError() => _InternetConnectionError<R>(),
      _NetworkFormatError() => _NetworkFormatError<R>(),
      _ServerError() => _ServerError<R>(),
      _NetworkTimeoutError() => _NetworkTimeoutError<R>(),
      _UnhandledError() => _UnhandledError<R>(),
      _ApiError() => throw StateError('Should not be called'),
    };
  }
}

/// Extensions that are applied specifically on a non-empty [NetworkError]s.
extension NetworkErrorError<T extends Object> on NetworkError<T> {
  /// Casts current exception's type from [T] to type [R].
  ///
  /// Since we are using type [T] on the current exception we expect to have a
  /// [NetworkError.api]. So for this reason, we should provide function
  /// that converts the api error from type [T] to [R].
  NetworkError<R> cast<R extends Object>(R Function(T error) convert) {
    return switch (this) {
      _RequestCancelledError() => _RequestCancelledError<R>(),
      _InternetConnectionError() => _InternetConnectionError<R>(),
      _NetworkFormatError() => _NetworkFormatError<R>(),
      _ServerError() => _ServerError<R>(),
      _NetworkTimeoutError() => _NetworkTimeoutError<R>(),
      _UnhandledError() => _UnhandledError<R>(),
      _ApiError<T>(error: final error) when error is R => _ApiError<R>(error),
      _ApiError<T>(error: final error) => _ApiError<R>(convert(error)),
    };
  }

  /// Returns `true` when the error is an [NetworkError.api] and the error
  /// matches by using the [matcher] callback.
  bool match(bool Function(T error) matcher) {
    return switch (this) {
      _ApiError<T>(error: final error) => matcher(error),
      _ => false
    };
  }
}
