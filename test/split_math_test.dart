import 'package:flutter_test/flutter_test.dart';
import 'package:receipt_split/models/person.dart';
import 'package:receipt_split/split_math.dart';

void main() {
  test('person defaults', () {
    final p = Person(name: 'Alex');
    expect(p.amount, 0);
  });

  test('computeShares splits remainder tax and tip evenly', () {
    final shares = computeShares(
      people: [
        Person(name: 'Alex', amount: 40),
        Person(name: 'Sam', amount: 30),
      ],
      subtotal: 100,
      tax: 10,
      tipPercent: 10,
    );
    expect(shares['__total__'], closeTo(120, 0.001));
    // remainder 30 + tax 10 + tip 10 = 50 shared -> 25 each
    expect(shares['Alex'], closeTo(65, 0.001));
    expect(shares['Sam'], closeTo(55, 0.001));
  });
}
