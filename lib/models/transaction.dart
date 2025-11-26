class TransactionItem {
  final String productId;
  final String productName;
  final int quantity;
  final double price;
  final double subtotal;

  const TransactionItem({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.subtotal,
  });

  factory TransactionItem.fromMap(Map<String, dynamic> map) {
    return TransactionItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      quantity: map['quantity'] ?? 0,
      price: (map['price'] ?? 0.0).toDouble(),
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'price': price,
      'subtotal': subtotal,
    };
  }
}

class Transaction {
  final String id;
  final DateTime date;
  final List<TransactionItem> items;
  final double total;
  final double payment;
  final double change;
  final String paymentMethod;

  const Transaction({
    required this.id,
    required this.date,
    required this.items,
    required this.total,
    required this.payment,
    required this.change,
    required this.paymentMethod,
  });

  factory Transaction.fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] ?? '',
      date: DateTime.parse(map['date'] ?? DateTime.now().toIso8601String()),
      items:
          (map['items'] as List<dynamic>?)
              ?.map((item) => TransactionItem.fromMap(item))
              .toList() ??
          [],
      total: (map['total'] ?? 0.0).toDouble(),
      payment: (map['payment'] ?? 0.0).toDouble(),
      change: (map['change'] ?? 0.0).toDouble(),
      paymentMethod: map['paymentMethod'] ?? 'Cash',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'items': items.map((item) => item.toMap()).toList(),
      'total': total,
      'payment': payment,
      'change': change,
      'paymentMethod': paymentMethod,
    };
  }
}

// Dummy data untuk transaksi
class TransactionData {
  static List<Transaction> getDummyTransactions() {
    return [
      Transaction(
        id: 'TRX001',
        date: DateTime.now().subtract(const Duration(hours: 2)),
        items: [
          TransactionItem(
            productId: '1',
            productName: 'Nasi Goreng Special',
            quantity: 2,
            price: 25000,
            subtotal: 50000,
          ),
          TransactionItem(
            productId: '6',
            productName: 'Es Teh Manis',
            quantity: 1,
            price: 5000,
            subtotal: 5000,
          ),
        ],
        total: 55000,
        payment: 60000,
        change: 5000,
        paymentMethod: 'Cash',
      ),
      Transaction(
        id: 'TRX002',
        date: DateTime.now().subtract(const Duration(hours: 4)),
        items: [
          TransactionItem(
            productId: '3',
            productName: 'Sate Ayam',
            quantity: 1,
            price: 30000,
            subtotal: 30000,
          ),
          TransactionItem(
            productId: '7',
            productName: 'Jus Jeruk Segar',
            quantity: 2,
            price: 12000,
            subtotal: 24000,
          ),
        ],
        total: 54000,
        payment: 55000,
        change: 1000,
        paymentMethod: 'Cash',
      ),
      Transaction(
        id: 'TRX003',
        date: DateTime.now().subtract(const Duration(hours: 6)),
        items: [
          TransactionItem(
            productId: '5',
            productName: 'Mie Goreng Jawa',
            quantity: 1,
            price: 20000,
            subtotal: 20000,
          ),
          TransactionItem(
            productId: '10',
            productName: 'Kentang Goreng',
            quantity: 1,
            price: 15000,
            subtotal: 15000,
          ),
          TransactionItem(
            productId: '8',
            productName: 'Kopi Hitam',
            quantity: 1,
            price: 8000,
            subtotal: 8000,
          ),
        ],
        total: 43000,
        payment: 50000,
        change: 7000,
        paymentMethod: 'Cash',
      ),
      Transaction(
        id: 'TRX004',
        date: DateTime.now().subtract(const Duration(days: 1)),
        items: [
          TransactionItem(
            productId: '2',
            productName: 'Ayam Bakar Madu',
            quantity: 1,
            price: 35000,
            subtotal: 35000,
          ),
          TransactionItem(
            productId: '9',
            productName: 'Mineral Water',
            quantity: 3,
            price: 4000,
            subtotal: 12000,
          ),
        ],
        total: 47000,
        payment: 50000,
        change: 3000,
        paymentMethod: 'Cash',
      ),
      Transaction(
        id: 'TRX005',
        date: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        items: [
          TransactionItem(
            productId: '11',
            productName: 'Pizza Margherita',
            quantity: 1,
            price: 45000,
            subtotal: 45000,
          ),
          TransactionItem(
            productId: '6',
            productName: 'Es Teh Manis',
            quantity: 2,
            price: 5000,
            subtotal: 10000,
          ),
        ],
        total: 55000,
        payment: 55000,
        change: 0,
        paymentMethod: 'Cash',
      ),
    ];
  }
}
