import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/transaction.dart';

class AIRecommendationScreen extends StatefulWidget {
  const AIRecommendationScreen({super.key});

  @override
  State<AIRecommendationScreen> createState() => _AIRecommendationScreenState();
}

class _AIRecommendationScreenState extends State<AIRecommendationScreen> {
  List<Product> _recommendations = [];
  String _selectedCategory = 'Semua';

  @override
  void initState() {
    super.initState();
    _generateRecommendations();
  }

  void _generateRecommendations() {
    final products = ProductData.getDummyProducts();
    final transactions = TransactionData.getDummyTransactions();

    // Hitung frekuensi penjualan produk
    Map<String, int> productSales = {};
    for (var transaction in transactions) {
      for (var item in transaction.items) {
        productSales[item.productId] =
            (productSales[item.productId] ?? 0) + item.quantity;
      }
    }

    // Urutkan produk berdasarkan penjualan
    List<Product> sortedProducts = List.from(products);
    sortedProducts.sort((a, b) {
      int salesA = productSales[a.id] ?? 0;
      int salesB = productSales[b.id] ?? 0;
      return salesB.compareTo(salesA); // Descending
    });

    // Filter berdasarkan kategori
    if (_selectedCategory != 'Semua') {
      sortedProducts = sortedProducts
          .where((product) => product.category == _selectedCategory)
          .toList();
    }

    // Ambil top 10 rekomendasi
    _recommendations = sortedProducts.take(10).toList();
  }

  void _onCategoryChanged(String category) {
    setState(() {
      _selectedCategory = category;
      _generateRecommendations();
    });
  }

  List<Map<String, dynamic>> _getRecommendationTypes() {
    final products = ProductData.getDummyProducts();
    final transactions = TransactionData.getDummyTransactions();

    // Hitung total penjualan per produk
    Map<String, int> productSales = {};
    for (var transaction in transactions) {
      for (var item in transaction.items) {
        productSales[item.productId] =
            (productSales[item.productId] ?? 0) + item.quantity;
      }
    }

    // Produk terlaris
    final bestSelling =
        products.where((p) => (productSales[p.id] ?? 0) > 0).toList()..sort(
          (a, b) =>
              (productSales[b.id] ?? 0).compareTo(productSales[a.id] ?? 0),
        );

    // Produk stok rendah
    final lowStock =
        products.where((p) => p.stock < 10 && p.isAvailable).toList()
          ..sort((a, b) => a.stock.compareTo(b.stock));

    // Produk populer berdasarkan kategori
    final popularByCategory =
        products
            .where(
              (p) => p.category == 'Makanan' && (productSales[p.id] ?? 0) > 0,
            )
            .toList()
          ..sort(
            (a, b) =>
                (productSales[b.id] ?? 0).compareTo(productSales[a.id] ?? 0),
          );

    return [
      {
        'title': 'Produk Terlaris',
        'subtitle': 'Berdasarkan jumlah penjualan',
        'icon': Icons.trending_up,
        'color': Colors.green,
        'products': bestSelling.take(3).toList(),
      },
      {
        'title': 'Stok Rendah',
        'subtitle': 'Perlu restock segera',
        'icon': Icons.warning,
        'color': Colors.orange,
        'products': lowStock.take(3).toList(),
      },
      {
        'title': 'Makanan Populer',
        'subtitle': 'Rekomendasi makanan',
        'icon': Icons.restaurant,
        'color': Colors.red,
        'products': popularByCategory.take(3).toList(),
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final recommendationTypes = _getRecommendationTypes();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekomendasi AI'),
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
              Theme.of(context).colorScheme.surface,
            ],
          ),
        ),
        child: Column(
          children: [
            // Category filter
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                children: ProductData.getCategories().map((category) {
                  final isSelected = _selectedCategory == category;
                  return Container(
                    margin: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(category),
                      selected: isSelected,
                      onSelected: (selected) {
                        if (selected) {
                          _onCategoryChanged(category);
                        }
                      },
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      selectedColor: Theme.of(
                        context,
                      ).colorScheme.primaryContainer,
                      checkmarkColor: Theme.of(
                        context,
                      ).colorScheme.onPrimaryContainer,
                    ),
                  );
                }).toList(),
              ),
            ),

            // AI Insights
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.smart_toy,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Insights AI',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Berdasarkan analisis data penjualan, berikut adalah rekomendasi untuk meningkatkan performa bisnis Anda.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Recommendations
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemCount: recommendationTypes.length,
                itemBuilder: (context, index) {
                  final type = recommendationTypes[index];
                  final products = type['products'] as List<Product>;

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: (type['color'] as Color).withOpacity(
                                    0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  type['icon'] as IconData,
                                  color: type['color'] as Color,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      type['title'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    Text(
                                      type['subtitle'] as String,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSurfaceVariant,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          if (products.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Text(
                                  'Tidak ada rekomendasi untuk kategori ini',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurfaceVariant,
                                      ),
                                ),
                              ),
                            )
                          else
                            ...products.map(
                              (product) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surface,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.outline.withOpacity(0.2),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: NetworkImage(product.imageUrl),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            product.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.w500,
                                                ),
                                          ),
                                          Text(
                                            'Rp ${product.price.toStringAsFixed(0)} • Stok: ${product.stock}',
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      product.isAvailable
                                          ? Icons.check_circle
                                          : Icons.cancel,
                                      color: product.isAvailable
                                          ? Colors.green
                                          : Colors.red,
                                      size: 20,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
