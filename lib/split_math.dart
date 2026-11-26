import 'models/person.dart';
import 'models/split_result.dart';

int toCents(double value) {
  if (value.isNaN || value.isInfinite) {
    throw ArgumentError('money values must be finite');
  }
  return (value * 100).round();
}

/// Compute per-person shares from assigned item amounts plus shared remainder/tax/tip.
/// Uses integer cents and preserves duplicate display names as separate shares.
SplitResult computeShares({
  required List<Person> people,
  required double subtotal,
  required double tax,
  required double tipPercent,
}) {
  if (subtotal < 0 || tax < 0 || tipPercent < 0) {
    throw ArgumentError('subtotal, tax, and tipPercent must be >= 0');
  }

  final subtotalCents = toCents(subtotal);
  final taxCents = toCents(tax);
  final tipCents = toCents(subtotal * (tipPercent / 100.0));
  final totalCents = subtotalCents + taxCents + tipCents;

  if (people.isEmpty) {
    return SplitResult(shares: const [], totalCents: totalCents);
  }

  for (final person in people) {
    if (person.name.trim().isEmpty) {
      throw ArgumentError('person names must be non-empty');
    }
    if (person.amount < 0) {
      throw ArgumentError('assigned amounts must be >= 0');
    }
  }

  final assignedCents = people.fold<int>(0, (sum, p) => sum + toCents(p.amount));
  if (assignedCents > subtotalCents) {
    throw ArgumentError('assigned item amounts exceed subtotal');
  }

  final remainderCents = subtotalCents - assignedCents;
  final sharedCents = remainderCents + taxCents + tipCents;
  final baseEven = sharedCents ~/ people.length;
  var leftover = sharedCents % people.length;

  final shares = <PersonShare>[];
  for (var i = 0; i < people.length; i++) {
    final extra = leftover > 0 ? 1 : 0;
    if (leftover > 0) leftover -= 1;
    final cents = toCents(people[i].amount) + baseEven + extra;
    shares.add(PersonShare(name: people[i].name, cents: cents));
  }

  final sumShares = shares.fold<int>(0, (sum, s) => sum + s.cents);
  if (sumShares != totalCents) {
    throw StateError('share cents ($sumShares) must equal total ($totalCents)');
  }

  return SplitResult(shares: shares, totalCents: totalCents);
}

/// Legacy map view for older UI code. Duplicate names get a numeric suffix.
@Deprecated('Use computeShares SplitResult instead')
Map<String, double> computeSharesMap({
  required List<Person> people,
  required double subtotal,
  required double tax,
  required double tipPercent,
}) {
  final result = computeShares(
    people: people,
    subtotal: subtotal,
    tax: tax,
    tipPercent: tipPercent,
  );
  final map = <String, double>{};
  final seen = <String, int>{};
  for (final share in result.shares) {
    final count = seen.update(share.name, (v) => v + 1, ifAbsent: () => 1);
    final key = count == 1 ? share.name : '${share.name} ($count)';
    map[key] = share.amount;
  }
  map['__total__'] = result.total;
  return map;
}
