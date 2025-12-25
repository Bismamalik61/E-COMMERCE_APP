import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import 'mock_data_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Products Collection
  Future<List<Product>> getProducts() async {
    try {
      var snapshot = await _db.collection('products').get();
      return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
    } catch (e) {
      print("Error fetching products: $e");
      return [];
    }
  }

  // Categories (derived from products for now)
  Future<List<String>> getCategories() async {
    try {
      var products = await getProducts();
      return products.map((p) => p.category).toSet().toList();
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  // Initial Data Migration
  Future<void> migrateMockData() async {
    try {
      var products = MockDataService.getProducts();
      var batch = _db.batch();
      
      for (var product in products) {
        var docRef = _db.collection('products').doc(product.id);
        batch.set(docRef, product.toMap());
      }
      
      await batch.commit();
      print("Migration complete!");
    } catch (e) {
      print("Migration error: $e");
    }
  }

  // Banner Images
  Future<List<String>> getBannerImages() async {
    // For now returning mock banners, but could be fetched from Firestore 'banners' collection
    return MockDataService.getBannerImages();
  }
}
