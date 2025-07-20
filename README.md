# KakaoFarm

**KakaoFarm** adalah aplikasi mobile berbasis Flutter yang digunakan untuk memonitor dan mengelola pertanian digital menggunakan Firebase Realtime Database. Aplikasi ini dirancang untuk memberikan kemudahan dalam melihat data sensor, mengelola node pertanian, serta mempermudah proses pemantauan secara realtime.

## 🚀 Fitur Utama

- ✅ Menampilkan daftar node pertanian (farm nodes)
- 📶 Update data sensor secara realtime dari Firebase
- 🧭 Menyimpan dan memilih node yang terakhir digunakan (SharedPreferences)
- 📱 Desain antarmuka mobile yang intuitif

## 📦 Teknologi yang Digunakan

- [Flutter](https://flutter.dev/) – Framework UI untuk aplikasi mobile
- [Firebase Realtime Database](https://firebase.google.com/products/realtime-database) – Backend untuk data sensor secara realtime
- [Shared Preferences](https://pub.dev/packages/shared_preferences) – Penyimpanan lokal sederhana untuk pilihan pengguna

## 🧠 Arsitektur

Aplikasi ini menggunakan pendekatan berbasis *Controller* untuk memisahkan logika bisnis dari antarmuka. Contohnya adalah `NodeController` yang bertanggung jawab atas:

- Manajemen daftar node pertanian
- Pengambilan data dari Firebase
- Penyimpanan node terakhir yang digunakan

```dart
class NodeController {
  List<String> _farmNodes = [];
  int? _selectedIndex;
  Map<String, Map<String, dynamic>> _farmDataMap = {};
  
  List<String> get farmNodes => _farmNodes;
  int? get selectedIndex => _selectedIndex;
  Map<String, Map<String, dynamic>> get farmDataMap => _farmDataMap;

}
