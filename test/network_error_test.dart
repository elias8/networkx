import 'package:networkx/networkx.dart';
import 'package:test/test.dart';

void main() {
  group('$NetworkError', () {
    test('should return true when type matches', () {
      expect(const NetworkError<int>.cancelled().isCancellationError, isTrue);
      expect(const NetworkError<int>.connection().isConnectionError, isTrue);
      expect(const NetworkError<int>.api(0).isApiError, isTrue);
      expect(const NetworkError<int>.server().isServerError, isTrue);
      expect(const NetworkError<int>.timeout().isTimeoutError, isTrue);
      expect(const NetworkError<int>.format().isFormatError, isTrue);
      expect(const NetworkError<int>.unhandled().isUnhandledError, isTrue);
    });

    test('should toString return correct result', () {
      expect(
        const NetworkError<int>.cancelled().toString(),
        '_RequestCancelledError<int>()',
      );
      expect(
        const NetworkError<String>.connection().toString(),
        '_InternetConnectionError<String>()',
      );
      expect(
        const NetworkError.api('message').toString(),
        '_ApiError<String>(message)',
      );
      expect(
        const NetworkError<int>.server().toString(),
        '_ServerError<int>()',
      );
      expect(
        const NetworkError<int>.timeout().toString(),
        '_NetworkTimeoutError<int>()',
      );
      expect(
        const NetworkError<int>.format().toString(),
        '_NetworkFormatError<int>()',
      );
      expect(
        const NetworkError<int>.unhandled().toString(),
        '_UnhandledError<int>()',
      );
    });

    test('should == operator return true when only two errors have equal value',
        () {
      expect(
        const NetworkError<int>.cancelled(),
        equals(const NetworkError<int>.cancelled()),
      );
      expect(
        const NetworkError<int>.cancelled(),
        isNot(equals(const NetworkError<int>.connection())),
      );
      expect(
        const NetworkError.api('message'),
        isNot(equals(const NetworkError<String>.connection())),
      );
      expect(
        const NetworkError.api('message'),
        isNot(equals(const NetworkError.api('other'))),
      );
      expect(
        const NetworkError.api('message'),
        equals(const NetworkError.api('message')),
      );
      expect(
        // ignore: prefer_const_constructors
        NetworkError.api('message'),
        // ignore: prefer_const_constructors
        equals(NetworkError.api('message')),
      );
      expect(
        const NetworkError.api('message').hashCode,
        'message'.hashCode,
      );
      expect(const NetworkError<int>.unhandled().hashCode, 0);
    });

    test('should name return correct value', () {
      expect(const NetworkError.api('').name, 'api');
      expect(const NetworkError.api(_SomeEnum.first).name, 'first');
      expect(const NetworkError.api(_SomeEnum.some).name, 'some');
      expect(const NetworkError<int>.cancelled().name, 'cancelled');
      expect(const NetworkError<int>.connection().name, 'connection');
      expect(const NetworkError<int>.format().name, 'format');
      expect(const NetworkError<int>.server().name, 'server');
      expect(const NetworkError<int>.timeout().name, 'timeout');
      expect(const NetworkError<int>.unhandled().name, 'unhandled');
    });

    group('maybeWhen', () {
      test('should return correct value from the callback', () {
        int value() => 100;
        int orElse() => 1000;

        expect(
          const NetworkError.api('100')
              .maybeWhen(api: (_) => 100, orElse: orElse),
          100,
        );
        expect(
          const NetworkError<int>.cancelled()
              .maybeWhen(cancelled: value, orElse: orElse),
          100,
        );
        expect(
          const NetworkError<int>.connection()
              .maybeWhen(connection: value, orElse: orElse),
          100,
        );
        expect(
          const NetworkError<int>.format()
              .maybeWhen(format: value, orElse: orElse),
          100,
        );
        expect(
          const NetworkError<int>.server()
              .maybeWhen(server: value, orElse: orElse),
          100,
        );
        expect(
          const NetworkError<int>.timeout()
              .maybeWhen(timeout: value, orElse: orElse),
          100,
        );
        expect(
          const NetworkError<int>.timeout().maybeWhen(orElse: orElse),
          1000,
        );
        expect(
          const NetworkError<int>.unhandled()
              .maybeWhen(unhandled: value, orElse: orElse),
          100,
        );
      });
    });

    group('when', () {
      test('should return correct value from the callback', () {
        int callback() => 100;
        int apiCallback(int value) => 2 * value;

        expect(
          const NetworkError.api(100).when(
            api: apiCallback,
            format: callback,
            server: callback,
            timeout: callback,
            cancelled: callback,
            connection: callback,
            unhandled: callback,
          ),
          200,
        );
        expect(
          const NetworkError<int>.cancelled().when(
            api: apiCallback,
            format: callback,
            server: callback,
            timeout: callback,
            cancelled: callback,
            connection: callback,
            unhandled: callback,
          ),
          100,
        );
        expect(
          const NetworkError<int>.connection().when(
            api: apiCallback,
            format: callback,
            server: callback,
            timeout: callback,
            cancelled: callback,
            connection: callback,
            unhandled: callback,
          ),
          100,
        );
        expect(
          const NetworkError<int>.format().when(
            api: apiCallback,
            format: callback,
            server: callback,
            timeout: callback,
            cancelled: callback,
            connection: callback,
            unhandled: callback,
          ),
          100,
        );
        expect(
          const NetworkError<int>.server().when(
            api: apiCallback,
            format: callback,
            server: callback,
            timeout: callback,
            cancelled: callback,
            connection: callback,
            unhandled: callback,
          ),
          100,
        );
        expect(
          const NetworkError<int>.timeout().when(
            api: apiCallback,
            format: callback,
            server: callback,
            timeout: callback,
            cancelled: callback,
            connection: callback,
            unhandled: callback,
          ),
          100,
        );
        expect(
          const NetworkError<int>.unhandled().when(
            api: apiCallback,
            format: callback,
            server: callback,
            timeout: callback,
            cancelled: callback,
            connection: callback,
            unhandled: callback,
          ),
          100,
        );
      });
    });

    group('whenOrNull', () {
      test('should return correct value from the  callback', () {
        int value() => 100;

        expect(const NetworkError.api('100').whenOrNull(api: (_) => 100), 100);
        expect(
          const NetworkError<int>.cancelled().whenOrNull(cancelled: value),
          100,
        );
        expect(
          const NetworkError<int>.connection().whenOrNull(connection: value),
          100,
        );
        expect(const NetworkError<int>.format().whenOrNull(format: value), 100);
        expect(const NetworkError<int>.server().whenOrNull(server: value), 100);
        expect(
          const NetworkError<int>.timeout().whenOrNull(timeout: value),
          100,
        );
        expect(const NetworkError<int>.timeout().whenOrNull<int>(), isNull);
        expect(
          const NetworkError<int>.unhandled().whenOrNull<int>(unhandled: value),
          100,
        );
        expect(const NetworkError<int>.unhandled().whenOrNull<int>(), isNull);
      });
    });

    group('cast void', () {
      test('should convert to correct type', () {
        expect(
          // ignore: void_checks
          () => const NetworkError<void>.api(0).cast<int>(),
          throwsA(isA<FallThroughError>()),
        );
        expect(
          const NetworkError<void>.cancelled().cast<int>(),
          const NetworkError<int>.cancelled(),
        );
        expect(
          const NetworkError<void>.cancelled().cast<int>(),
          const NetworkError<int>.cancelled(),
        );
        expect(
          const NetworkError<void>.connection().cast<int>(),
          const NetworkError<int>.connection(),
        );
        expect(
          const NetworkError<void>.format().cast<int>(),
          const NetworkError<int>.format(),
        );
        expect(
          const NetworkError<void>.server().cast<int>(),
          const NetworkError<int>.server(),
        );
        expect(
          const NetworkError<void>.timeout().cast<int>(),
          const NetworkError<int>.timeout(),
        );
        expect(
          const NetworkError<void>.unhandled().cast<int>(),
          const NetworkError<int>.unhandled(),
        );
      });
    });

    group('cast object', () {
      test('should convert to correct type', () {
        int convert(String val) => val.length;
        expect(
          const NetworkError<String>.api('four').cast<int>(convert),
          const NetworkError<int>.api(4),
        );
        expect(
          const NetworkError<String>.cancelled().cast<int>(convert),
          const NetworkError<int>.cancelled(),
        );
        expect(
          const NetworkError<String>.connection().cast<int>(convert),
          const NetworkError<int>.connection(),
        );
        expect(
          const NetworkError<String>.format().cast<int>(convert),
          const NetworkError<int>.format(),
        );
        expect(
          const NetworkError<String>.server().cast<int>(convert),
          const NetworkError<int>.server(),
        );
        expect(
          const NetworkError<String>.timeout().cast<int>(convert),
          const NetworkError<int>.timeout(),
        );
        expect(
          const NetworkError<String>.unhandled().cast<int>(convert),
          const NetworkError<int>.unhandled(),
        );
      });
    });

    group('match', () {
      test('should return the result of a matcher when type is an api error',
          () {
        expect(
          const NetworkError.api(2).match((error) => error.isEven),
          isTrue,
        );
        expect(
          const NetworkError.api(2).match((error) => error.isOdd),
          isFalse,
        );
        expect(
          const NetworkError<int>.server().match((error) => error.isEven),
          isFalse,
        );
        expect(
          const NetworkError<int>.server().match((error) => error.isOdd),
          isFalse,
        );
        expect(
          const NetworkError<int>.unhandled().match((error) => error.isOdd),
          isFalse,
        );
      });
    });
  });
}

enum _SomeEnum { first, some }
