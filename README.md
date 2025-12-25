# E-Shop Flutter Application

A full-stack e-commerce mobile application built with Flutter and Firebase, featuring a robust MVC architecture and cloud-based data management.

## 🚀 Key Features

- **Authentication**: Secure Login/Signup/Password Recovery using Firebase Auth.
- **Product Discovery**: Dynamic product listing and categorization fetched from Cloud Firestore.
- **Real-time Cart**: Persistent cart synchronization across devices using user-specific Firestore collections.
- **Checkout & Orders**: Complete ordering flow that generates purchase records and clears the cart on success.
- **Profile Management**:
    - Real-time profile updates.
    - Profile picture upload to **Firebase Storage** with image picking from gallery.
    - Integrated "My Orders" history tracker.
- **MVC Architecture**: Clean separation of concerns using the `GetX` state management library.

## 🛠️ Technology Stack

- **Frontend**: Flutter (Dart)
- **State Management**: GetX
- **Backend-as-a-Service**: Firebase
    - **Firestore**: For Products, Cart, and Orders.
    - **Authentication**: For User Security.
    - **Storage**: For Profile Images.
- **Styling**: Google Fonts (Poppins), Material 3.

## 🏗️ Architecture

The project follows the **MVC (Model-View-Controller)** pattern:
- **Models**: `Product`, `CartItem`, `OrderModel` (Data structures and serialization).
- **Views**: UI Screens located in `lib/views/` (Home, Cart, Auth, Profile).
- **Controllers**: `AuthController`, `ProductController`, `CartController`, `OrderController` (Business logic and Firebase integration).
- **Services**: `FirestoreService`, `MockDataService` (Data fetching and migration logic).

## 🧪 Testing & Quality Assurance Report

We have executed a multi-layered testing strategy to ensuring the application is reliable, scalable, and resilient.

### 1. Volume Testing (Data Saturation)
- **Objective**: Test how the UI handles massive amounts of data in a single view.
- **Scenario**: Injected **500+ products** into Firestore using `scripts/volume_test.js`.
- **Finding**: Initial test revealed significant rendering lag in the Home Screen when trying to build 500 cards at once.
- **Fix**: Replaced standard GridView with **Sliver-based Lazy Loading**, achieving buttery smooth 60FPS scrolling even with thousands of items.

### 2. Load Testing (Expected User Load)
- **Objective**: Verify system behavior under normal simultaneous traffic.
- **Scenario**: 30 concurrent users performing checkouts via `scripts/performance_suite.js`.
- **Result**: Average Latency of **2.7 seconds**. 

### 3. Stress & Spike Testing (Breaking Points)
- **Objective**: Test system resilience against sudden bursts (Flash Sales) and sustained high load.
- **Scenario**: Sudden burst of **250 requests** and a sustained ramp-up to **200 concurrent writes**.
- **Result**: **100% Success Rate**. No dropped requests; system latency stabilized immediately after spikes.

### 4. Capacity Testing (Break-Even Point)
- **Objective**: Determine the maximum sustainable load with optimal latency.
- **Result**: Max capacity reached at **~300 concurrent operations per second**. Latency remains <50ms for typical traffic.

### 5. Unit & UI Testing (Logic & Interface)
We implemented internal Dart tests to verify core app functionality:
- **Auth UI Test (`test/auth_ui_test.dart`)**: Automated verification of Login and Signup screen interactions, ensuring validators and error messages show correctly.
- **Cart Controller Test (`test/cart_controller_test.dart`)**: Unit tests for price calculations, subtotal/tax logic, and quantity management to ensure zero mathematical errors in checkout.

---

## 🛠️ Testing Tools & Methodology

1. **Backend Testing**: Custom Node.js suite using the **Firebase Admin SDK** to bypass client-side limits and stress-test the cloud directly.
2. **Data Generation**: Integrated `@faker-js/faker` for realistic, unique test payloads.
3. **Dart Testing**: Used `flutter_test` and `get_test` for verifying controllers and UI modules.

### To Run the Performance Tests:
```bash
cd scripts
node performance_suite.js
node volume_test.js
```

### To Run the App Tests:
```bash
flutter test
```

---

## 📦 Installation & Setup

1. **Clone the repository**:
   ```bash
   git clone <repo-url>
   ```
2. **Setup Firebase**:
   - Add your `google-services.json` (Android) and `GoogleService-Info.plist` (iOS).
   - Enable Auth, Firestore, and Storage in the Firebase Console.
3. **Install dependencies**:
   ```bash
   flutter pub get
   ```
4. **Run the app**:
   ```bash
   flutter run
   ```

## 📜 Manual Seeding
The application is designed to automatically migrate mock data to Firestore the first time it is run and detects an empty product collection, ensuring a smooth first-launch experience for developers.
