# Receipt Split

Split a bill across people with per-person item amounts, shared remainder, tax, and tip.

Flutter desktop/mobile demo.

## Status

Person model and split math helpers are in place. UI and pubspec will land in follow-up commits.

## Module

```dart
import 'models/person.dart';
import 'split_math.dart';

final shares = computeShares(
  people: [Person(name: 'Alex', amount: 40), Person(name: 'Sam', amount: 30)],
  subtotal: 120,
  tax: 10,
  tipPercent: 10,
);
```

## Planned setup

```powershell
flutter create . --project-name receipt_split
flutter pub get
flutter run
```

## License

MIT
