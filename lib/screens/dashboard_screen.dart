import 'package:flutter/material.dart';
import 'product_list_screen.dart';
import 'product_create_screen.dart';
import 'pos_screen.dart';
import 'transaction_history_screen.dart';
import 'ai_recommendation_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Daftar Produk'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductListScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Buat Produk Baru'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ProductCreateScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('POS (Kasir)'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const POSScreen()),
              );
            },
          ),
          ListTile(
            title: const Text('Riwayat Transaksi'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionHistoryScreen(),
                ),
              );
            },
          ),
          ListTile(
            title: const Text('Rekomendasi AI'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AIRecommendationScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
