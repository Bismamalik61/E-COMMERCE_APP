import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth;
  final FirebaseStorage _storage;
  late Rx<User?> _firebaseUser;

  AuthController({FirebaseAuth? auth, FirebaseStorage? storage})
      : _auth = auth ?? FirebaseAuth.instance,
        _storage = storage ?? FirebaseStorage.instance;
  
  var isLoggedIn = false.obs;
  var isLoading = false.obs;
  var userName = 'XYZ'.obs;
  var userEmail = 'xyz@gmail.com'.obs;
  var profilePicUrl = ''.obs;

  @override
  void onReady() {
    super.onReady();
    _firebaseUser = Rx<User?>(_auth.currentUser);
    _firebaseUser.bindStream(_auth.userChanges());
    ever(_firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) {
    if (user == null) {
      isLoggedIn.value = false;
      if (!Get.testMode) Get.offAllNamed('/login');
    } else {
      isLoggedIn.value = true;
      userEmail.value = user.email ?? '';
      userName.value = user.displayName ?? 'User';
      profilePicUrl.value = user.photoURL ?? '';
      if (!Get.testMode) Get.offAllNamed('/home');
    }
  }

  Future<void> uploadProfilePicture() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      try {
        isLoading.value = true;
        File file = File(pickedFile.path);
        
        // Upload to Firebase Storage
        String uid = _auth.currentUser!.uid;
        Reference ref = _storage.ref().child('profile_pics').child('$uid.jpg');
        await ref.putFile(file);
        
        // Get Download URL
        String downloadUrl = await ref.getDownloadURL();
        
        // Update Firebase Auth user
        await _auth.currentUser?.updatePhotoURL(downloadUrl);
        profilePicUrl.value = downloadUrl;
        
        Get.snackbar("Success", "Profile picture updated!", snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        Get.snackbar("Error", "Upload failed: $e", snackPosition: SnackPosition.BOTTOM);
      } finally {
        isLoading.value = false;
      }
    }
  }

  void updateProfile(String name, String email) {
    userName.value = name;
    userEmail.value = email;
  }

  Future<void> login(String email, String password) async {
    try {
      isLoading.value = true;
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signup(String name, String email, String password) async {
    try {
      isLoading.value = true;
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await credential.user?.updateDisplayName(name);
      userName.value = name;
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
