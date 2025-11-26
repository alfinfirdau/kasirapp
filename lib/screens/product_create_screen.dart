import 'package:flutter/material.dart';

class ProductCreateScreen extends StatelessWidget {
  const ProductCreateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Buat Produk Baru')),
      body: const Center(child: Text('Form untuk membuat produk baru')),
    );
  }
}
