# Receipt Split

Split a bill across people with per-person item amounts, shared remainder, tax, and tip.

Flutter desktop/mobile demo.

## Status

Complete: cent-accurate split math, form validation, accessible live results, unit tests, and CI.

Unassigned subtotal remainder is split evenly with tax and tip across all people. Duplicate names stay as separate shares. Assigned item totals cannot exceed the subtotal.

## Setup

```powershell
flutter pub get
flutter run
```

## Test

```powershell
flutter analyze
flutter test
```

## Module

```dart
import 'package:receipt_split/models/person.dart';
import 'package:receipt_split/split_math.dart';

final result = computeShares(
  people: [Person(name: 'Alex', amount: 40), Person(name: 'Sam', amount: 30)],
  subtotal: 100,
  tax: 10,
  tipPercent: 10,
);
print(result.total); // 120.00
print(result.shares.map((s) => '${s.name}: ${s.amount}'));
```

## License

MIT
