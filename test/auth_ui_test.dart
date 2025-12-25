import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:e_com_app/views/auth/login_screen.dart';
import 'package:e_com_app/controllers/auth_controller.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';

void main() {
  late MockFirebaseAuth mockAuth;
  late MockFirebaseStorage mockStorage;
  late AuthController authController;

  setUp(() {
    Get.testMode = true;
    mockAuth = MockFirebaseAuth();
    mockStorage = MockFirebaseStorage();
    authController = AuthController(auth: mockAuth, storage: mockStorage);
    Get.put(authController);
  });

  tearDown(() {
    Get.reset();
  });

  group('LoginScreen Validation Tests', () {
    testWidgets('Login button shows error when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: LoginScreen()));

      // Tap login button
      await tester.tap(find.text('Login'));
      await tester.pump();

      //  error messages
      expect(find.text('Please enter your email'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Shows error for non-gmail address', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: LoginScreen()));

      // Enter invalid email
      await tester.enterText(find.byType(TextFormField).first, 'user@yahoo.com');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Email must be a @gmail.com address'), findsOneWidget);
    });

    testWidgets('Shows error for short password', (WidgetTester tester) async {
      await tester.pumpWidget(GetMaterialApp(home: LoginScreen()));

      // Enter valid email but short password
      await tester.enterText(find.byType(TextFormField).first, 'user@gmail.com');
      await tester.enterText(find.byType(TextFormField).last, 'pass');
      await tester.tap(find.text('Login'));
      await tester.pump();

      expect(find.text('Password must be 8-15 characters'), findsOneWidget);
    });
  });
}
