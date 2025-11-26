class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  final bool isAvailable;

  const Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.isAvailable = true,
  });

  // Factory constructor untuk membuat dummy data
  factory Product.dummy({
    required String id,
    required String name,
    required String description,
    required double price,
    required String imageUrl,
    required String category,
    required int stock,
  }) {
    return Product(
      id: id,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      category: category,
      stock: stock,
      isAvailable: stock > 0,
    );
  }

  // Copy with method untuk update data
  Product copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    String? category,
    int? stock,
    bool? isAvailable,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      stock: stock ?? this.stock,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }

  // Convert to Map untuk penyimpanan
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
      'stock': stock,
      'isAvailable': isAvailable,
    };
  }

  // Factory constructor dari Map
  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      stock: map['stock'] ?? 0,
      isAvailable: map['isAvailable'] ?? true,
    );
  }

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, stock: $stock)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Product && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

// Dummy data untuk produk
class ProductData {
  static List<Product> getDummyProducts() {
    return [
      Product.dummy(
        id: '1',
        name: 'Nasi Goreng Special',
        description: 'Nasi goreng dengan telur, ayam, dan sayuran segar',
        price: 25000,
        imageUrl:
            'https://images.unsplash.com/photo-1512058564366-18510be2db19?w=400',
        category: 'Makanan',
        stock: 15,
      ),
      Product.dummy(
        id: '2',
        name: 'Ayam Bakar Madu',
        description: 'Ayam bakar dengan saus madu dan rempah-rempah',
        price: 35000,
        imageUrl:
            'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400',
        category: 'Makanan',
        stock: 12,
      ),
      Product.dummy(
        id: '3',
        name: 'Sate Ayam',
        description: 'Sate ayam dengan bumbu kacang dan lontong',
        price: 30000,
        imageUrl:
            'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
        category: 'Makanan',
        stock: 20,
      ),
      Product.dummy(
        id: '4',
        name: 'Bakso Urat',
        description: 'Bakso urat dengan mie dan sayuran',
        price: 18000,
        imageUrl:
            'https://images.unsplash.com/photo-1582878826629-29b7ad1cdc43?w=400',
        category: 'Makanan',
        stock: 25,
      ),
      Product.dummy(
        id: '5',
        name: 'Mie Goreng Jawa',
        description: 'Mie goreng dengan bumbu khas Jawa',
        price: 20000,
        imageUrl:
            'https://images.unsplash.com/photo-1551782450-17144efb5723?w=400',
        category: 'Makanan',
        stock: 18,
      ),
      Product.dummy(
        id: '6',
        name: 'Es Teh Manis',
        description: 'Es teh manis dingin menyegarkan',
        price: 5000,
        imageUrl:
            'https://images.unsplash.com/photo-1499638673689-79a0b5115d87?w=400',
        category: 'Minuman',
        stock: 30,
      ),
      Product.dummy(
        id: '7',
        name: 'Jus Jeruk Segar',
        description: 'Jus jeruk segar tanpa gula tambahan',
        price: 12000,
        imageUrl:
            'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
        category: 'Minuman',
        stock: 22,
      ),
      Product.dummy(
        id: '8',
        name: 'Kopi Hitam',
        description: 'Kopi hitam pekat khas Indonesia',
        price: 8000,
        imageUrl:
            'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=400',
        category: 'Minuman',
        stock: 28,
      ),
      Product.dummy(
        id: '9',
        name: 'Mineral Water',
        description: 'Air mineral dalam kemasan',
        price: 4000,
        imageUrl:
            'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?w=400',
        category: 'Minuman',
        stock: 50,
      ),
      Product.dummy(
        id: '10',
        name: 'Kentang Goreng',
        description: 'Kentang goreng renyah dengan saus',
        price: 15000,
        imageUrl:
            'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
        category: 'Snack',
        stock: 16,
      ),
      Product.dummy(
        id: '11',
        name: 'Pizza Margherita',
        description: 'Pizza dengan keju dan tomat',
        price: 45000,
        imageUrl:
            'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
        category: 'Makanan',
        stock: 8,
      ),
      Product.dummy(
        id: '12',
        name: 'Burger Cheese',
        description: 'Burger dengan keju dan sayuran',
        price: 35000,
        imageUrl:
            'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=400',
        category: 'Makanan',
        stock: 14,
      ),
      Product.dummy(
        id: '13',
        name: 'Rendang Daging',
        description: 'Rendang daging sapi khas Padang dengan bumbu rempah',
        price: 45000,
        imageUrl:
            'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
        category: 'Makanan',
        stock: 10,
      ),
      Product.dummy(
        id: '14',
        name: 'Soto Ayam',
        description: 'Soto ayam dengan kuah kuning dan nasi',
        price: 25000,
        imageUrl:
            'https://images.unsplash.com/photo-1555939594-58d7cb561ad1?w=400',
        category: 'Makanan',
        stock: 15,
      ),
      Product.dummy(
        id: '15',
        name: 'Gado-Gado',
        description: 'Gado-gado dengan bumbu kacang dan lontong',
        price: 22000,
        imageUrl:
            'https://images.unsplash.com/photo-1551782450-17144efb5723?w=400',
        category: 'Makanan',
        stock: 12,
      ),
      Product.dummy(
        id: '16',
        name: 'Ayam Goreng',
        description: 'Ayam goreng crispy dengan sambal',
        price: 28000,
        imageUrl:
            'https://images.unsplash.com/photo-1598103442097-8b74394b95c6?w=400',
        category: 'Makanan',
        stock: 18,
      ),
      Product.dummy(
        id: '17',
        name: 'Teh Tarik',
        description: 'Teh tarik manis hangat khas Malaysia',
        price: 10000,
        imageUrl:
            'https://images.unsplash.com/photo-1499638673689-79a0b5115d87?w=400',
        category: 'Minuman',
        stock: 25,
      ),
      Product.dummy(
        id: '18',
        name: 'Jus Alpukat',
        description: 'Jus alpukat segar dengan susu',
        price: 15000,
        imageUrl:
            'https://images.unsplash.com/photo-1600271886742-f049cd451bba?w=400',
        category: 'Minuman',
        stock: 20,
      ),
      Product.dummy(
        id: '19',
        name: 'Wedang Jahe',
        description: 'Minuman jahe hangat dengan rempah',
        price: 8000,
        imageUrl:
            'https://images.unsplash.com/photo-1497935586351-b67a49e012bf?w=400',
        category: 'Minuman',
        stock: 30,
      ),
      Product.dummy(
        id: '20',
        name: 'Pisang Goreng',
        description: 'Pisang goreng renyah dengan coklat',
        price: 12000,
        imageUrl:
            'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
        category: 'Snack',
        stock: 22,
      ),
      Product.dummy(
        id: '21',
        name: 'Martabak Manis',
        description: 'Martabak manis dengan topping coklat dan keju',
        price: 30000,
        imageUrl:
            'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=400',
        category: 'Snack',
        stock: 8,
      ),
      Product.dummy(
        id: '22',
        name: 'Keripik Singkong',
        description: 'Keripik singkong gurih dan renyah',
        price: 10000,
        imageUrl:
            'https://images.unsplash.com/photo-1573080496219-bb080dd4f877?w=400',
        category: 'Snack',
        stock: 35,
      ),
    ];
  }

  static List<String> getCategories() {
    return ['Semua', 'Makanan', 'Minuman', 'Snack'];
  }
}
