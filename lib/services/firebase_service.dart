import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart' as firestore;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/product.dart';
import '../models/transaction.dart';

class FirebaseService {
  static final firestore.FirebaseFirestore _firestore =
      firestore.FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // Authentication methods
  static Future<User?> signIn(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception('Login gagal: $e');
    }
  }

  static Future<User?> signUp(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } catch (e) {
      throw Exception('Registrasi gagal: $e');
    }
  }

  static Future<void> signOut() async {
    await _auth.signOut();
  }

  static User? get currentUser => _auth.currentUser;

  static Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Product methods
  static Future<void> addProduct(Product product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
    } catch (e) {
      throw Exception('Gagal menambah produk: $e');
    }
  }

  static Future<void> updateProduct(String id, Product product) async {
    try {
      await _firestore.collection('products').doc(id).update(product.toMap());
    } catch (e) {
      throw Exception('Gagal update produk: $e');
    }
  }

  static Future<void> deleteProduct(String id) async {
    try {
      await _firestore.collection('products').doc(id).delete();
    } catch (e) {
      throw Exception('Gagal hapus produk: $e');
    }
  }

  static Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Product.fromMap(data);
      }).toList();
    });
  }

  // Transaction methods
  static Future<void> addTransaction(Transaction transaction) async {
    try {
      await _firestore.collection('transactions').add(transaction.toMap());
    } catch (e) {
      throw Exception('Gagal menambah transaksi: $e');
    }
  }

  static Stream<List<Transaction>> getTransactions() {
    return _firestore.collection('transactions').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Transaction.fromMap(data);
      }).toList();
    });
  }

  static Future<List<Transaction>> getTransactionsByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final querySnapshot = await _firestore
          .collection('transactions')
          .where('date', isGreaterThanOrEqualTo: startDate.toIso8601String())
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return Transaction.fromMap(data);
      }).toList();
    } catch (e) {
      throw Exception('Gagal mengambil transaksi: $e');
    }
  }

  // Storage methods for product images
  static Future<String> uploadProductImage(
    String fileName,
    String filePath,
  ) async {
    try {
      final ref = _storage.ref().child('product_images/$fileName');
      await ref.putFile(File(filePath));
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Gagal upload gambar: $e');
    }
  }

  static Future<void> deleteProductImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Gagal hapus gambar: $e');
    }
  }
}
