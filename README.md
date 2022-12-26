Custom network error types for easy error handling.

## Getting started

Install the latest version from pub.dev.

```yaml
dependencies:
  networkx: ^0.1.0
```

## Usage

```dart
import 'package:networkx/networkx.dart';

void main() {
  const networkError = NetworkError.api(ApiValidationError.emailAlreadyExists);

  // `maybeWhen`
  networkError.maybeWhen(
    api: (error) {
      if (error == ApiValidationError.emailAlreadyExists) {
        print('Email already exists.');
      } else if (error == ApiValidationError.phoneNumberAlreadyExists) {
        print('Phone number already exists.');
      }
    },
    orElse: () => print('Something went wrong.'),
  );

  // `match`
  if (networkError.match((error) => error.isEmailAlreadyExists)) {
    print('Email already exists');
  }

  // `cast`
  final signUpError = networkError.cast(SignUpError.fromApiError);

  // `name`
  print(signUpError.name);
}

enum ApiValidationError {
  emailAlreadyExists,
  phoneNumberAlreadyExists;

  bool get isEmailAlreadyExists => this == emailAlreadyExists;

  bool get isPhoneNumberAlreadyExists => this == phoneNumberAlreadyExists;
}

enum SignUpError {
  emailAlreadyExists,
  phoneNumberAlreadyExists,
  otherValidationError;

  factory SignUpError.fromApiError(ApiValidationError error) {
    if (error.isEmailAlreadyExists) {
      return SignUpError.emailAlreadyExists;
    } else if (error.isPhoneNumberAlreadyExists) {
      return SignUpError.phoneNumberAlreadyExists;
    } else {
      return SignUpError.otherValidationError;
    }
  }
}

```
---

You can use it with any HTTP client library. For example, [here](https://gist.github.com/elias8/2d5c44e1337178e2efa37210534272b5), you can find an extension to the [Dio](https://pub.dev/packages/dio) library, so you don't have to write it from scratch. Or you can see an example project [here](https://github.com/elias8/last_fm) for more detail and usage.

## Maintainers

- [Elias Andualem](https://github.com/elias8)


