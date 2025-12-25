
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../models/cart_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class CartController extends GetxController {
  final FirebaseFirestore _db;
  final FirebaseAuth _auth;

  CartController({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _db = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;
  
  var cartItems = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch cart items when the user login status changes
    _auth.userChanges().listen((user) {
      if (user != null) {
        fetchCartItems();
      } else {
        cartItems.clear();
      }
    });
  }

  Future<void> fetchCartItems() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      var snapshot = await _db.collection('users').doc(user.uid).collection('cart').get();
      cartItems.value = snapshot.docs.map((doc) => CartItem.fromMap(doc.data())).toList();
    } catch (e) {
      print("Error fetching cart: $e");
    }
  }

  Future<void> _saveCartItem(CartItem item) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).collection('cart').doc(item.product.id).set(item.toMap());
    } catch (e) {
      print("Error saving cart item: $e");
    }
  }

  Future<void> _deleteCartItem(String productId) async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      await _db.collection('users').doc(user.uid).collection('cart').doc(productId).delete();
    } catch (e) {
      print("Error deleting cart item: $e");
    }
  }

  void addToCart(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      cartItems[index].quantity++;
      cartItems.refresh();
      _saveCartItem(cartItems[index]);
    } else {
      var newItem = CartItem(product: product);
      cartItems.add(newItem);
      _saveCartItem(newItem);
    }
  }

  void removeFromCart(Product product) {
    cartItems.removeWhere((item) => item.product.id == product.id);
    _deleteCartItem(product.id);
  }

  void decreaseQuantity(Product product) {
    int index = cartItems.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (cartItems[index].quantity > 1) {
        cartItems[index].quantity--;
        cartItems.refresh();
        _saveCartItem(cartItems[index]);
      } else {
        removeFromCart(product);
      }
    }
  }

  Future<void> checkout() async {
    final user = _auth.currentUser;
    if (user == null || cartItems.isEmpty) return;

    try {
      isLoading.value = true;
      final orderId = _db.collection('users').doc(user.uid).collection('orders').doc().id;
      final newOrder = OrderModel(
        id: orderId,
        userId: user.uid,
        items: List.from(cartItems),
        totalAmount: total,
        timestamp: DateTime.now(),
      );

      // Save order to Firestore
      await _db.collection('users').doc(user.uid).collection('orders').doc(orderId).set(newOrder.toMap());

      // Clear cart in Firestore
      final cartBatch = _db.batch();
      final cartSnapshot = await _db.collection('users').doc(user.uid).collection('cart').get();
      for (var doc in cartSnapshot.docs) {
        cartBatch.delete(doc.reference);
      }
      await cartBatch.commit();

      // Clear local cart
      cartItems.clear();
      Get.snackbar("Success", "Order placed successfully!", snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar("Error", "Checkout failed: $e", snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  var isLoading = false.obs;

  double get subtotal => cartItems.fold(0, (sum, item) => sum + item.total);
  double get tax => subtotal * 0.1; // 10% tax
  double get total => subtotal + tax;

  int get totalItems => cartItems.fold(0, (sum, item) => sum + item.quantity);
}
