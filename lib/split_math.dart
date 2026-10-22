import 'models/person.dart';

/// Compute per-person shares from assigned item amounts plus shared remainder/tax/tip.
Map<String, double> computeShares({
  required List<Person> people,
  required double subtotal,
  required double tax,
  required double tipPercent,
}) {
  final tip = subtotal * (tipPercent / 100.0);
  final total = subtotal + tax + tip;
  if (people.isEmpty) {
    return {'__total__': total};
  }

  final assigned = people.fold<double>(0, (sum, p) => sum + p.amount);
  final remainder = (subtotal - assigned).clamp(0, subtotal).toDouble();
  final even = (remainder + tax + tip) / people.length;

  final shares = <String, double>{};
  for (final person in people) {
    shares[person.name] = person.amount + even;
  }
  shares['__total__'] = total;
  return shares;
}
