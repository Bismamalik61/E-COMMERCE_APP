import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  var cartItems = <CartItem>[].obs;

  void addToCart(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
    } else {
      cartItems.add(CartItem(product: product));
    }
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
  }

  void decreaseQuantity(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
      } else {
        removeFromCart(product);
      }
    }
  }

  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.1; // 10% tax
  double get total => subtotal + tax;

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);
}
