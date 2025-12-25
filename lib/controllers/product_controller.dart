import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/firestore_service.dart';

class ProductController extends GetxController {
  final FirestoreService _firestoreService = FirestoreService();
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;
  var categories = <String>[].obs;
  var isLoading = true.obs;
  var selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
    
    // Listen for changes and update filtered list
    ever(products, (_) => _updateData());
    ever(selectedCategory, (_) => _updateFilteredList());
  }

  void fetchProducts() async {
    try {
      isLoading.value = true;
      var fetchedProducts = await _firestoreService.getProducts();
      
      if (fetchedProducts.isEmpty) {
        await _firestoreService.migrateMockData();
        fetchedProducts = await _firestoreService.getProducts();
      }
      
      products.value = fetchedProducts;
    } catch (e) {
      Get.snackbar("Error", "Failed to load products: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void _updateData() {
    // Cache categories
    final cats = products.map((p) => p.category).toSet().toList();
    cats.sort();
    cats.insert(0, 'All');
    categories.value = cats;
    
    _updateFilteredList();
  }

  void _updateFilteredList() {
    if (selectedCategory.value == 'All') {
      filteredProducts.value = products;
    } else {
      filteredProducts.value = products.where((p) => p.category == selectedCategory.value).toList();
    }
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }
}
