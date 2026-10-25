# Receipt Split

Split a bill across people with per-person item amounts, shared remainder, tax, and tip.

Flutter desktop/mobile demo.

## Status

Split UI, math helpers, lint config, and unit tests are in place. Final polish lands next.

Unassigned subtotal remainder is split evenly with tax and tip across all people.

## Setup

```powershell
flutter pub get
flutter run
```

## Test

```powershell
flutter test
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
