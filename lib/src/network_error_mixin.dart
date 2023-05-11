part of 'network_error.dart';

/// A callback with no arguments and that returns [T].
@internal
typedef EmptyCallBack<T> = T Function();

/// [NetworkError] helper mixin methods and getters.
mixin _NetworkErrorHelperMixin<T> {
  /// Returns true if the error is [NetworkError.api].
  bool get isApiError => this is _ApiError<T>;

  /// Returns true if the error is [NetworkError.cancelled].
  bool get isCancellationError => this is _RequestCancelledError<T>;

  /// Returns true if the error is [NetworkError.connection].
  bool get isConnectionError => this is _InternetConnectionError<T>;

  /// Returns true if the error is [NetworkError.format].
  bool get isFormatError => this is _NetworkFormatError<T>;

  /// Returns true if the error is [NetworkError.server].
  bool get isServerError => this is _ServerError<T>;

  /// Returns true if the error is [NetworkError.timeout].
  bool get isTimeoutError => this is _NetworkTimeoutError<T>;

  /// Returns true if the error is [NetworkError.unhandled].
  bool get isUnhandledError => this is _UnhandledError<T>;

  /// Returns a short name of the error type. In case of [NetworkError.api],
  /// when the error type [T] is an `enum`, the enum name will be returned.
  String get name {
    return switch (this) {
      _RequestCancelledError() => 'cancelled',
      _InternetConnectionError() => 'connection',
      _NetworkFormatError() => 'format',
      _ServerError() => 'server',
      _NetworkTimeoutError() => 'timeout',
      _UnhandledError() => 'unhandled',
      _ApiError(error: var error) when error is Enum => error.name,
      _ => 'api',
    };
  }

  R maybeWhen<R>({
    EmptyCallBack<R>? format,
    EmptyCallBack<R>? server,
    R Function(T error)? api,
    EmptyCallBack<R>? timeout,
    EmptyCallBack<R>? cancelled,
    EmptyCallBack<R>? connection,
    EmptyCallBack<R>? unhandled,
    required EmptyCallBack<R> orElse,
  }) {
    return switch (this) {
          _RequestCancelledError() => cancelled?.call(),
          _InternetConnectionError() => connection?.call(),
          _NetworkFormatError() => format?.call(),
          _ServerError() => server?.call(),
          _NetworkTimeoutError() => timeout?.call(),
          _UnhandledError() => unhandled?.call(),
          _ApiError(error: var error) => api?.call(error),
          _ => orElse(),
        } ??
        orElse();
  }

  R when<R>({
    required EmptyCallBack<R> format,
    required EmptyCallBack<R> server,
    required R Function(T error) api,
    required EmptyCallBack<R> timeout,
    required EmptyCallBack<R> unhandled,
    required EmptyCallBack<R> cancelled,
    required EmptyCallBack<R> connection,
  }) {
    return switch (this) {
      _RequestCancelledError() => cancelled(),
      _InternetConnectionError() => connection(),
      _NetworkFormatError() => format(),
      _ServerError() => server(),
      _NetworkTimeoutError() => timeout(),
      _UnhandledError() => unhandled(),
      _ApiError(error: var error) => api(error),
      _ => throw StateError('Unexpected error: $this'),
    };
  }

  R? whenOrNull<R>({
    EmptyCallBack<R>? format,
    EmptyCallBack<R>? server,
    R Function(T error)? api,
    EmptyCallBack<R>? timeout,
    EmptyCallBack<R>? unhandled,
    EmptyCallBack<R>? cancelled,
    EmptyCallBack<R>? connection,
  }) {
    return switch (this) {
      _RequestCancelledError() => cancelled?.call(),
      _InternetConnectionError() => connection?.call(),
      _NetworkFormatError() => format?.call(),
      _ServerError() => server?.call(),
      _NetworkTimeoutError() => timeout?.call(),
      _UnhandledError() => unhandled?.call(),
      _ApiError(error: var error) => api?.call(error),
      _ => null,
    };
  }
}
