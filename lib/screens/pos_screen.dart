import 'package:flutter/material.dart';

class POSScreen extends StatelessWidget {
  const POSScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('POS (Kasir)')),
      body: const Center(child: Text('Interface untuk point of sale')),
    );
  }
}
