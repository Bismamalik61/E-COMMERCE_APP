import 'package:get/get.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var isLoading = false.obs;
  var userName = 'XYZ'.obs;
  var userEmail = 'xyz@gmail.com'.obs;

  void updateProfile(String name, String email) {
    userName.value = name;
    userEmail.value = email;
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    isLoggedIn.value = true;
    isLoading.value = false;
    Get.offAllNamed('/home');
  }

  void logout() {
    isLoggedIn.value = false;
    Get.offAllNamed('/login');
  }

  Future<void> signup(String name, String email, String password) async {
    isLoading.value = true;
    await Future.delayed(const Duration(seconds: 1)); // Simulate network
    isLoggedIn.value = true;
    isLoading.value = false;
    Get.offAllNamed('/home');
  }
}
