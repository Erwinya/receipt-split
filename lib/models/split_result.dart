class PersonShare {
  const PersonShare({required this.name, required this.cents});

  final String name;
  final int cents;

  double get amount => cents / 100.0;
}

class SplitResult {
  const SplitResult({
    required this.shares,
    required this.totalCents,
  });

  final List<PersonShare> shares;
  final int totalCents;

  double get total => totalCents / 100.0;
}
