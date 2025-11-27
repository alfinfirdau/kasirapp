# Firebase Setup untuk Kasir App

## Langkah-langkah Setup Firebase

### 1. Buat Proyek Firebase
1. Buka [Firebase Console](https://console.firebase.google.com/)
2. Klik "Create a project" atau "Tambah proyek"
3. Masukkan nama proyek (contoh: kasir-app-project)
4. Ikuti langkah-langkah setup sampai proyek selesai dibuat

### 2. Aktifkan Layanan Firebase
Di Firebase Console, aktifkan layanan berikut:
- **Authentication**: Untuk login/logout pengguna
- **Firestore Database**: Untuk menyimpan data produk dan transaksi
- **Storage**: Untuk menyimpan gambar produk (opsional)

### 3. Setup Authentication
1. Pergi ke Authentication > Sign-in method
2. Aktifkan Email/Password provider
3. (Opsional) Aktifkan provider lain seperti Google, Facebook, dll.

### 4. Setup Firestore Database
1. Pergi ke Firestore Database
2. Klik "Create database"
3. Pilih "Start in test mode" untuk development
4. Pilih lokasi database (contoh: asia-southeast1 untuk Indonesia)

### 5. Setup Storage (Opsional)
1. Pergi ke Storage
2. Klik "Get started"
3. Pilih lokasi yang sama dengan Firestore

### 6. Konfigurasi Aplikasi

#### Android Setup
1. Di Firebase Console, klik ikon Android untuk menambah app
2. Package name: `com.example.kasirapp`
3. Download `google-services.json`
4. Ganti file `android/app/google-services.json` dengan file yang didownload

#### iOS Setup
1. Di Firebase Console, klik ikon iOS untuk menambah app
2. Bundle ID: `com.example.kasirapp`
3. Download `GoogleService-Info.plist`
4. Ganti file `ios/Runner/GoogleService-Info.plist` dengan file yang didownload

### 7. Update Firebase Options
1. Jalankan perintah berikut untuk generate firebase_options.dart:
   ```
   flutterfire configure
   ```
   Atau update manual file `lib/firebase_options.dart` dengan API keys dari Firebase Console.

### 8. API Keys yang Perlu Diupdate
Update file `lib/firebase_options.dart` dengan nilai-nilai berikut dari Firebase Console:

- `apiKey`: Dari Project settings > General > Web API Key
- `appId`: Dari app settings (Android/iOS)
- `messagingSenderId`: Dari Project settings
- `projectId`: ID proyek Firebase Anda
- `storageBucket`: Nama bucket storage
- `measurementId`: Untuk Analytics (opsional)

### 9. Testing
1. Jalankan aplikasi: `flutter run`
2. Coba fitur login/register
3. Coba tambah produk dan transaksi

## Struktur Database Firestore

### Collections
- `products`: Data produk
- `transactions`: Data transaksi
- `users`: Data pengguna (opsional)

### Product Document Structure
```json
{
  "id": "string",
  "name": "string",
  "price": "number",
  "description": "string",
  "imageUrl": "string (optional)",
  "category": "string (optional)",
  "stock": "number",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Transaction Document Structure
```json
{
  "id": "string",
  "date": "string (ISO 8601)",
  "items": [
    {
      "productId": "string",
      "productName": "string",
      "quantity": "number",
      "price": "number",
      "subtotal": "number"
    }
  ],
  "total": "number",
  "payment": "number",
  "change": "number",
  "paymentMethod": "string",
  "userId": "string (optional)"
}
```

## Troubleshooting

### Error: "FirebaseOptions cannot be null"
- Pastikan `firebase_options.dart` sudah diupdate dengan API keys yang benar
- Pastikan Firebase.initializeApp() dipanggil di main.dart

### Error: "Permission denied"
- Pastikan Firestore rules sudah benar
- Untuk development, gunakan test mode rules

### Error: "Plugin not found"
- Jalankan `flutter clean` lalu `flutter pub get`
- Restart IDE dan emulator/device

## Security Rules (Firestore)

Untuk production, update Firestore rules di Firebase Console:

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Allow read/write for authenticated users
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

## Storage Rules (Opsional)

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}