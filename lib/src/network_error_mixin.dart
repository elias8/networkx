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
    if (isApiError) {
      final error = (this as _ApiError<T>).error;
      if (error is Enum) return error.name;
      return 'api';
    } else if (isCancellationError) {
      return 'cancelled';
    } else if (isConnectionError) {
      return 'connection';
    } else if (isFormatError) {
      return 'format';
    } else if (isServerError) {
      return 'server';
    } else if (isUnhandledError) {
      return 'unhandled';
    } else if (isTimeoutError) {
      return 'timeout';
    } else {
      throw FallThroughError();
    }
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
    if (this is _ApiError<T> && api != null) {
      final error = (this as _ApiError<T>).error;
      return api(error);
    } else if (this is _RequestCancelledError<T> && cancelled != null) {
      return cancelled();
    } else if (this is _InternetConnectionError<T> && connection != null) {
      return connection();
    } else if (this is _NetworkFormatError<T> && format != null) {
      return format();
    } else if (this is _ServerError<T> && server != null) {
      return server();
    } else if (this is _NetworkTimeoutError<T> && timeout != null) {
      return timeout();
    } else if (this is _UnhandledError<T> && unhandled != null) {
      return unhandled();
    } else {
      return orElse();
    }
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
    if (this is _ApiError<T>) {
      final error = (this as _ApiError<T>).error;
      return api(error);
    } else if (this is _RequestCancelledError<T>) {
      return cancelled();
    } else if (this is _InternetConnectionError<T>) {
      return connection();
    } else if (this is _NetworkFormatError<T>) {
      return format();
    } else if (this is _ServerError<T>) {
      return server();
    } else if (this is _NetworkTimeoutError<T>) {
      return timeout();
    } else if (this is _UnhandledError<T>) {
      return unhandled();
    } else {
      // coverage:ignore-start
      throw FallThroughError();
      // coverage:ignore-end
    }
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
    if (this is _ApiError<T> && api != null) {
      final error = (this as _ApiError<T>).error;
      return api(error);
    } else if (this is _RequestCancelledError<T> && cancelled != null) {
      return cancelled();
    } else if (this is _InternetConnectionError<T> && connection != null) {
      return connection();
    } else if (this is _NetworkFormatError<T> && format != null) {
      return format();
    } else if (this is _ServerError<T> && server != null) {
      return server();
    } else if (this is _NetworkTimeoutError<T> && timeout != null) {
      return timeout();
    } else if (this is _UnhandledError<T> && unhandled != null) {
      return unhandled();
    } else {
      return null;
    }
  }
}
