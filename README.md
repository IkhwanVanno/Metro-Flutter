# 🛍️ MetroShoppingG - Flutter E-Commerce App

**MetroShoppingG** adalah aplikasi **E-Commerce** berbasis **Flutter** yang terintegrasi dengan **Firebase**.
Aplikasi ini dirancang untuk memberikan pengalaman berbelanja modern dan cepat, dengan sistem autentikasi, pengelolaan produk, dan notifikasi real-time menggunakan Firebase.

---

## 🚀 Fitur Utama

* 🛒 Lihat dan beli produk secara online
* 🔐 Login & autentikasi menggunakan **Firebase Auth**
* 🧾 Menampilkan detail produk dan keranjang belanja
* 📦 Sinkronisasi data melalui **Firebase Realtime/Firestore**
* 🔔 Notifikasi push untuk update dan promo

---

## 📦 Persiapan Awal

### 1. Clone Project dan Install Dependency

```bash
git clone <repository-url>
cd MetroShoppingG
flutter pub get
```

### 2. Jalankan Project

```bash
flutter run
```

---

## ⚙️ Konfigurasi API (baseUrl)

1. Buka file:

   ```
   lib/config/app_config.dart
   ```

2. Ubah `baseUrl` sesuai endpoint API kamu:

   ```dart
   class AppConfig {
     static const String baseUrl = "https://your-api-url.com/api/";
   }
   ```

---

## 🔥 Integrasi Firebase

### 1. Siapkan Firebase Project

1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Buat project baru (misal: **MetroShoppingG**)
3. Tambahkan aplikasi Android dan iOS:

   * Android: masukkan `applicationId` (misal `com.example.metroshoppingg`)
   * iOS: masukkan `Bundle ID` (misal `com.example.metroshoppingg`)

---

### 2. Unduh File Konfigurasi Firebase

Unduh file berikut dari Firebase dan tempel ke lokasi sesuai tabel berikut:

| File                       | Lokasi                                |
| -------------------------- | ------------------------------------- |
| `firebase.json`            | `firebase.json` *(root project)*      |
| `firebase_options.dart`    | `lib/firebase_options.dart`           |
| `google-services.json`     | `android/app/google-services.json`    |
| `GoogleService-Info.plist` | `ios/Runner/GoogleService-Info.plist` |

---

### 3. Tambahkan SHA-1 untuk Login Google (opsional)

Jika login Google tidak berfungsi, tambahkan **SHA-1 key** ke Firebase Console:
Firebase Console → Project Settings → Android App → Tambahkan SHA-1.

#### Cara cek SHA-1 debug:

```bash
.\gradlew signingReport
```

atau

```bash
keytool -list -v -keystore "C:\Users\<USERNAME>\.android\debug.keystore" -storepass android
```

Jika belum ada, buat debug keystore:

```bash
keytool -genkey -v -keystore "C:\Users\<USERNAME>\.android\debug.keystore" -storepass android -keypass android -keyalg RSA -keysize 2048 -validity 10000 -alias androiddebugkey -dname "CN=Android Debug,O=Android,C=US"
```

---

## 🧩 Build Aplikasi

### Untuk Android:

```bash
flutter build apk --release
```

### Untuk iOS:

```bash
flutter build ios --release
```

---

## 📚 Referensi

* [Flutter Documentation](https://docs.flutter.dev)
* [Firebase Console](https://console.firebase.google.com/)
* [FlutterFire (Integrasi Firebase dengan Flutter)](https://firebase.flutter.dev/)
* [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)

---

## 🛠 Teknologi yang Digunakan

* Flutter SDK
* Firebase Authentication & Firestore
* REST API Integration
* Material Design
* State Management (Provider / GetX)

---
