import 'package:flutter/material.dart';

class ReceiptSplitApp extends StatelessWidget {
  const ReceiptSplitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Receipt Split',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3D5A80)),
        useMaterial3: true,
      ),
      // SplitScreen lands in a follow-up commit.
      home: Scaffold(
        appBar: AppBar(title: const Text('Receipt Split')),
        body: const Center(
          child: Text('Split UI lands in a follow-up commit.'),
        ),
      ),
    );
  }
}
