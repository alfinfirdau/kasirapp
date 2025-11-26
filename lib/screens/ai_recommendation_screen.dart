import 'package:flutter/material.dart';

class AIRecommendationScreen extends StatelessWidget {
  const AIRecommendationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rekomendasi AI')),
      body: const Center(
        child: Text('Rekomendasi dari AI akan ditampilkan di sini'),
      ),
    );
  }
}
