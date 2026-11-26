import 'package:flutter/material.dart';
import 'package:receipt_split/models/person.dart';
import 'package:receipt_split/models/split_result.dart';
import 'package:receipt_split/split_math.dart';

class SplitScreen extends StatefulWidget {
  const SplitScreen({super.key});

  @override
  State<SplitScreen> createState() => _SplitScreenState();
}

class _SplitScreenState extends State<SplitScreen> {
  final _formKey = GlobalKey<FormState>();
  final _subtotal = TextEditingController(text: '120');
  final _tax = TextEditingController(text: '10');
  final _tipPercent = TextEditingController(text: '10');
  final List<Person> _people = [Person(name: 'Alex'), Person(name: 'Sam')];
  final List<TextEditingController> _nameCtrls = [];
  final List<TextEditingController> _amountCtrls = [];
  SplitResult? _result;
  String? _error;

  @override
  void initState() {
    super.initState();
    _syncControllers();
    _recompute();
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

  double? _parseOptional(TextEditingController c) {
    final text = c.text.trim();
    if (text.isEmpty) return 0;
    return double.tryParse(text);
  }

  void _recompute() {
    for (var i = 0; i < _people.length; i++) {
      _people[i].name = _nameCtrls[i].text.trim().isEmpty ? 'Guest ${i + 1}' : _nameCtrls[i].text.trim();
      final amount = _parseOptional(_amountCtrls[i]);
      _people[i].amount = amount ?? 0;
    }

    final subtotal = _parseOptional(_subtotal);
    final tax = _parseOptional(_tax);
    final tip = _parseOptional(_tipPercent);
    if (subtotal == null || tax == null || tip == null) {
      setState(() {
        _result = null;
        _error = 'Enter valid numbers for money fields.';
      });
      return;
    }

    try {
      final next = computeShares(
        people: _people,
        subtotal: subtotal,
        tax: tax,
        tipPercent: tip,
      );
      setState(() {
        _result = next;
        _error = null;
      });
    } catch (err) {
      setState(() {
        _result = null;
        _error = err.toString().replaceFirst('ArgumentError: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Receipt Split')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _subtotal,
              decoration: const InputDecoration(labelText: 'Subtotal', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _recompute(),
              validator: (value) => double.tryParse((value ?? '').trim()) == null ? 'Required number' : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _tax,
              decoration: const InputDecoration(labelText: 'Tax', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _recompute(),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _tipPercent,
              decoration: const InputDecoration(labelText: 'Tip %', border: OutlineInputBorder()),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: (_) => _recompute(),
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
                          onChanged: (_) => _recompute(),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 110,
                        child: TextField(
                          controller: _amountCtrls[i],
                          decoration: const InputDecoration(labelText: 'Items'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          onChanged: (_) => _recompute(),
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
                                _recompute();
                              },
                        icon: const Icon(Icons.delete_outline),
                      ),
                    ],
                  ),
                ),
              ),
            TextButton.icon(
              onPressed: () {
                setState(() {
                  _people.add(Person(name: 'Guest ${_people.length + 1}'));
                  _syncControllers();
                });
                _recompute();
              },
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
                      if (_error != null)
                        Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error))
                      else ...[
                        Text(
                          'Total: ${_result!.total.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 8),
                        ..._result!.shares.map(
                          (share) => Text('${share.name}: ${share.amount.toStringAsFixed(2)}'),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
