import 'package:get/get.dart';
import '../models/product_model.dart';
import '../services/mock_data_service.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var isLoading = true.obs;
  var selectedCategory = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  void fetchProducts() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 500));
    products.value = MockDataService.getProducts();
    isLoading.value = false;
  }

  List<Product> get filteredProducts {
    if (selectedCategory.value == 'All') {
      return products;
    }
    return products.where((p) => p.category == selectedCategory.value).toList();
  }

  void changeCategory(String category) {
    selectedCategory.value = category;
  }

  List<String> get categories {
    final cats = products.map((p) => p.category).toSet().toList();
    cats.insert(0, 'All');
    return cats;
  }
}
