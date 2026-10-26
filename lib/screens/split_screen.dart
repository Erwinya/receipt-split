import 'package:flutter/material.dart';
import 'package:receipt_split/models/person.dart';
import 'package:receipt_split/split_math.dart';

class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});

  @override
  State<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  final _subtotal = TextEditingController(text: '120');
  final _tax = TextEditingController(text: '10');
  final _tipPercent = TextEditingController(text: '10');
  final List<Person> _people = [Person(name: 'Alex'), Person(name: 'Sam')];
  final List<TextEditingController> _nameCtrls = [];
  final List<TextEditingController> _amountCtrls = [];

  @override
  void initState() {
    super.initState();
    _syncControllers();
  }

  void _syncControllers() {
    for (final c in [..._nameCtrls, ..._amountCtrls]) {
      c.dispose();
    }
    _nameCtrls
      ..clear()
      ..addAll(_people.map((p) => TextEditingController(text: p.name)));
    _amountCtrls
      ..clear()
      ..addAll(_people.map((p) => TextEditingController(text: p.amount == 0 ? '' : p.amount.toString())));
  }

  @override
  void dispose() {
    _subtotal.dispose();
    _tax.dispose();
    _tipPercent.dispose();
    for (final c in [..._nameCtrls, ..._amountCtrls]) {
      c.dispose();
    }
    super.dispose();
  }

  double _parse(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  Map<String, double> _compute() {
    for (var i = 0; i < _people.length; i++) {
      _people[i].name = _nameCtrls[i].text.trim().isEmpty ? 'Guest ${i + 1}' : _nameCtrls[i].text.trim();
      _people[i].amount = _parse(_amountCtrls[i]);
    }
    return computeShares(
      people: _people,
      subtotal: _parse(_subtotal),
      tax: _parse(_tax),
      tipPercent: _parse(_tipPercent),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = _compute();
    final total = result.remove('__total__') ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Receipt Split')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _subtotal,
            decoration: const InputDecoration(labelText: 'Subtotal', border: OutlineInputBorder()),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _tax,
            decoration: const InputDecoration(labelText: 'Tax', border: OutlineInputBorder()),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _tipPercent,
            decoration: const InputDecoration(labelText: 'Tip %', border: OutlineInputBorder()),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 16),
          Text('People', style: Theme.of(context).textTheme.titleMedium),
          for (var i = 0; i < _people.length; i++)
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameCtrls[i],
                        decoration: const InputDecoration(labelText: 'Name'),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 110,
                      child: TextField(
                        controller: _amountCtrls[i],
                        decoration: const InputDecoration(labelText: 'Items'),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (_) => setState(() {}),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Remove person',
                      onPressed: _people.length == 1
                          ? null
                          : () {
                              setState(() {
                                _people.removeAt(i);
                                _syncControllers();
                              });
                            },
                      icon: const Icon(Icons.delete_outline),
                    ),
                  ],
                ),
              ),
            ),
          TextButton.icon(
            onPressed: () => setState(() {
              _people.add(Person(name: 'Guest ${_people.length + 1}'));
              _syncControllers();
            }),
            icon: const Icon(Icons.person_add_alt),
            label: const Text('Add person'),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Semantics(
                liveRegion: true,
                label: 'Split results',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Total: ${total.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...result.entries.map((e) => Text('${e.key}: ${e.value.toStringAsFixed(2)}')),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
