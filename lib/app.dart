import 'package:flutter/material.dart';
import 'package:receipt_split/screens/split_screen.dart';

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
      home: const SplitScreen(),
    );
  }
}