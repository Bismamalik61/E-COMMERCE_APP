import 'package:flutter_test/flutter_test.dart';
import 'package:e_com_app/controllers/cart_controller.dart';
import 'package:e_com_app/models/product_model.dart';
import 'package:get/get.dart';

void main() {
   setUp(() {
    Get.put(CartController());
  });
    TestWidgetsFlutterBinding.ensureInitialized();
  group('CartController Tests', () {
    late CartController cartController;
    late Product testProduct;

    setUp(() {
      cartController = CartController();
      testProduct = Product(
        id: '1',
        name: 'Test Product',
        description: 'Test Description',
        price: 100.0,
        imageUrl: 'test.jpg',
        category: 'Test',
        rating: 4.5,
      );
    });

    test('Initial cart should be empty', () {
      expect(cartController.cartItems.length, 0);
      expect(cartController.totalItems, 0);
    });

    test('Adding product should increase quantity', () {
      cartController.addToCart(testProduct);
      expect(cartController.cartItems.length, 1);
      expect(cartController.cartItems[0].quantity, 1);

      cartController.addToCart(testProduct);
      expect(cartController.cartItems.length, 1);
      expect(cartController.cartItems[0].quantity, 2);
    });

    test('Calculations should be correct', () {
      cartController.addToCart(testProduct); 
      expect(cartController.subtotal, 100.0);
      expect(cartController.tax, 10.0);
      expect(cartController.total, 110.0);
    });

    test('Decreasing quantity should remove product when it reaches 0', () {
      cartController.addToCart(testProduct);
      cartController.decreaseQuantity(testProduct);
      expect(cartController.cartItems.length, 0);
    });
  });
}
