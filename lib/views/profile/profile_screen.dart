import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 60,
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1633332755192-727a05c4013d?q=80&w=2000&auto=format&fit=crop'),
            ),
            const SizedBox(height: 16),
            Obx(() => Text(
              authController.userName.value,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            )),
            Obx(() => Text(
              authController.userEmail.value,
              style: TextStyle(color: Colors.grey[600]),
            )),
            const SizedBox(height: 32),
            _buildProfileItem(Icons.person_outline, 'My Account', () {
              Get.toNamed('/edit-profile');
            }),
            _buildProfileItem(Icons.shopping_bag_outlined, 'My Orders', () {}),
            _buildProfileItem(Icons.location_on_outlined, 'Shipping Address', () {}),
            _buildProfileItem(Icons.payment_outlined, 'Payment Methods', () {}),
            _buildProfileItem(Icons.settings_outlined, 'Settings', () {}),
            _buildProfileItem(Icons.help_outline, 'Help Center', () {}),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => authController.logout(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: const BorderSide(color: Colors.red),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Logout', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.blue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
