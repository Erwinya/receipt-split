# Receipt Split

Split a bill across people with per-person item amounts, shared remainder, tax, and tip.

Flutter desktop/mobile demo.

## Status

Split math helpers, pubspec, and app shell (`main` / `app`) are in place. Split screen UI will land in a follow-up commit.

## Setup

```powershell
flutter pub get
flutter run
```

## Module

```dart
import 'package:receipt_split/models/person.dart';
import 'package:receipt_split/split_math.dart';

final shares = computeShares(
  people: [Person(name: 'Alex', amount: 40), Person(name: 'Sam', amount: 30)],
  subtotal: 120,
  tax: 10,
  tipPercent: 10,
);
```

## License

MIT
