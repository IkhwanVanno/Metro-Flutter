🛍️ MetroShoppingG E-Commerce
Aplikasi E-Commerce berbasis Flutter dengan integrasi Firebase untuk autentikasi, notifikasi, dan manajemen data produk.
Project ini dirancang dengan arsitektur modular, konfigurasi dinamis, dan kemudahan dalam pengaturan environment.

🚀 Persyaratan Sistem
Sebelum menjalankan proyek ini, pastikan kamu sudah menginstal:
Flutter SDK
 (versi terbaru)
Dart SDK
Android Studio
 atau Visual Studio Code
Firebase Console
Emulator Android / iOS atau perangkat fisik

MetroShoppingG/
│
├── lib/
│   ├── config/
│   │   └── app_config.dart       # File konfigurasi baseUrl API
│   ├── firebase_options.dart     # File konfigurasi Firebase
│   └── main.dart                 # Entry point aplikasi
│
├── android/
│   └── app/
│       └── google-services.json  # Konfigurasi Firebase Android
│
├── ios/
│   └── Runner/
│       └── GoogleService-Info.plist # Konfigurasi Firebase iOS
│
├── firebase.json                 # Konfigurasi Firebase project
└── pubspec.yaml                  # Dependency Flutter

⚙️ Setup Proyek
Ikuti langkah-langkah berikut untuk men-setup proyek di lokal:

1️⃣ Clone Repositori
git clone https://github.com/yourusername/MetroShoppingG.git
cd MetroShoppingG

2️⃣ Install Dependency
flutter pub get

3️⃣ Konfigurasi Base URL API
Buka file:
lib/config/app_config.dart
Lalu ubah nilai baseUrl sesuai endpoint API kamu:
class AppConfig {
  static const String baseUrl = "https://your-api-url.com/api/";
}

🔥 Integrasi Firebase
Untuk mengaktifkan Firebase pada proyek ini, ikuti langkah-langkah berikut:

4️⃣ Tambahkan File Konfigurasi Firebase
Tempel file berikut ke dalam lokasi yang sesuai:
| File                       | Lokasi                                |
| -------------------------- | ------------------------------------- |
| `firebase.json`            | di root project (`/`)                 |
| `firebase_options.dart`    | `lib/firebase_options.dart`           |
| `google-services.json`     | `android/app/google-services.json`    |
| `GoogleService-Info.plist` | `ios/Runner/GoogleService-Info.plist` |

⚠️ Catatan: Pastikan semua file berasal dari Firebase Console yang sesuai dengan package name aplikasi kamu.

▶️ Jalankan Aplikasi
Setelah konfigurasi selesai, jalankan perintah berikut:
flutter run

Atau tentukan platform secara spesifik:
flutter run -d chrome        # Untuk Web
flutter run -d emulator-5554 # Untuk Android Emulator
flutter run -d ios           # Untuk iOS

🧩 Build Release
Untuk Android:
flutter build apk --release
Untuk iOS:
flutter build ios --release

📚 Catatan Tambahan
Pastikan koneksi internet aktif untuk mengakses API dan Firebase.
Gunakan flutter clean jika ada error build setelah menyalin file Firebase.
Jika ada masalah autentikasi Firebase, periksa kembali google-services.json dan GoogleService-Info.plist.

👨‍💻 Pengembang

MetroShoppingG E-Commerce
Dikembangkan oleh Ikhwan Vanno
📧 Email: [ikhwanvanno750@gmail.com]
📅 Tahun: 2025