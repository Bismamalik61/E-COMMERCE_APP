import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home/home_screen.dart';
import 'home/search_screen.dart';
import 'cart/cart_screen.dart';
import 'profile/profile_screen.dart';
import '../../controllers/cart_controller.dart';

class NavigationMenu extends StatelessWidget {
  final CartController cartController = Get.put(CartController());
  final RxInt selectedIndex = 0.obs;

  NavigationMenu({super.key});

  final List<Widget> screens = [
    const HomeScreen(),
    const SearchScreen(),
    CartScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => screens[selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: selectedIndex.value,
          onDestinationSelected: (index) => selectedIndex.value = index,
          destinations: [
            const NavigationDestination(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            const NavigationDestination(
                icon: Icon(Icons.search), label: 'Search'),
            NavigationDestination(
              icon: Badge(
                label: Obx(() => Text(cartController.totalItems.toString())),
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              label: 'Cart',
            ),
            const NavigationDestination(icon: Icon(Icons.person_outline), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}
