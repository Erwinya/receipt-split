import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_split/models/person.dart';
import 'package:receipt_split/split_math.dart';

void main() {
  test('person defaults', () {
    final p = Person(name: 'Alex');
    expect(p.amount, 0);
  });

  test('computeShares splits remainder tax and tip evenly', () {
    final result = computeShares(
      people: [
        Person(name: 'Alex', amount: 40),
        Person(name: 'Sam', amount: 30),
      ],
      subtotal: 100,
      tax: 10,
      tipPercent: 10,
    );
    expect(result.total, closeTo(120, 0.001));
    // remainder 30 + tax 10 + tip 10 = 50 shared -> 25 each
    expect(result.shares[0].amount, closeTo(65, 0.001));
    expect(result.shares[1].amount, closeTo(55, 0.001));
    expect(
      result.shares.fold<int>(0, (sum, s) => sum + s.cents),
      result.totalCents,
    );
  });

  test('duplicate names stay as separate shares', () {
    final result = computeShares(
      people: [
        Person(name: 'Alex', amount: 10),
        Person(name: 'Alex', amount: 20),
      ],
      subtotal: 30,
      tax: 0,
      tipPercent: 0,
    );
    expect(result.shares, hasLength(2));
    expect(result.shares.every((s) => s.name == 'Alex'), isTrue);
  });

  test('rejects over-assignment negatives and empty names', () {
    expect(
      () => computeShares(
        people: [Person(name: 'Alex', amount: 40)],
        subtotal: 30,
        tax: 0,
        tipPercent: 0,
      ),
      throwsArgumentError,
    );
    expect(
      () => computeShares(
        people: [Person(name: 'Alex', amount: -1)],
        subtotal: 10,
        tax: 0,
        tipPercent: 0,
      ),
      throwsArgumentError,
    );
    expect(
      () => computeShares(
        people: [Person(name: '  ')],
        subtotal: 10,
        tax: 0,
        tipPercent: 0,
      ),
      throwsArgumentError,
    );
  });

  test('odd cent totals reconcile exactly', () {
    final result = computeShares(
      people: [
        Person(name: 'A', amount: 0),
        Person(name: 'B', amount: 0),
        Person(name: 'C', amount: 0),
      ],
      subtotal: 10,
      tax: 0.01,
      tipPercent: 0,
    );
    expect(result.shares.fold<int>(0, (sum, s) => sum + s.cents), result.totalCents);
  });
}
