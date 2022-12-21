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
  final signError = networkError.cast(SignUpError.fromApiError);

  // `name`
  print(signError.name);
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

## Maintainers

- [Elias Andualem](https://github.com/elias8)


