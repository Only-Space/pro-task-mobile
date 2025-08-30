# ProTask Mobile

Aplikasi **Todo List** sederhana dengan pendekatan **offline-first** untuk mengelola tugas harian, dibangun menggunakan **Flutter**.

---

## 🚀 Tentang Proyek

**ProTask** adalah aplikasi manajemen tugas yang dirancang untuk membantu pengguna mengatur berbagai daftar pekerjaan, mulai dari proyek kuliah hingga daftar belanja.  
Dengan fokus pada **pengalaman pengguna yang cepat** dan **fungsionalitas offline**, semua data disimpan secara lokal di perangkat menggunakan **database Hive**, memastikan aksesibilitas bahkan tanpa koneksi internet.

---

## ✨ Fitur Utama

- **Manajemen Papan Tugas**
  - Buat, hapus, dan kelola beberapa daftar tugas (papan) yang berbeda.

- **Manajemen Tugas Lengkap**
  - **Checklist** – Tandai tugas sebagai selesai dengan efek visual yang jelas.
  - **Prioritas** – Atur prioritas (Tinggi, Sedang, Rendah) dengan indikator warna intuitif.
  - **Deadline** – Tetapkan tanggal dan waktu deadline untuk setiap tugas.

- **Gestur Cepat**
  - Geser **ke kanan** untuk mengedit tugas.
  - Geser **ke kiri** untuk menghapus tugas dengan konfirmasi.

- **Mode Gelap & Terang**  
  Tema aplikasi dapat disesuaikan untuk kenyamanan visual.

- **Penyimpanan Lokal**  
  Semua data aman tersimpan di perangkat, tanpa memerlukan koneksi internet.

---

## 🛠️ Dibangun Dengan

- **Framework**: [Flutter](https://flutter.dev/)  
- **Bahasa**: Dart  
- **Database Lokal**: [Hive](https://docs.hivedb.dev/#/)  
- **State Management**: [Provider](https://pub.dev/packages/provider)  
- **Formatting Tanggal**: [intl](https://pub.dev/packages/intl)  
- **Code Generation**: [build_runner](https://pub.dev/packages/build_runner)  

---

## ⚙️ Memulai

### Prasyarat
Pastikan **Flutter SDK** sudah terpasang.  
Panduan instalasi: [Flutter Installation Guide](https://docs.flutter.dev/get-started/install)

### Instalasi

```bash
# 1. Clone repositori
git clone https://github.com/URL_REPOSITORI_ANDA/pro-task-mobile.git

# 2. Masuk ke direktori proyek
cd pro-task-mobile

# 3. Instal semua dependensi
flutter pub get

# 4. Jalankan code generator untuk Hive
flutter pub run build_runner build --delete-conflicting-outputs

# 5. Jalankan aplikasi
flutter run


📂 lib/
 ┣ 📜 main.dart          # Entry point aplikasi
 ┣ 📂 data/
 ┃ ┗ 📂 models/          # Model data (Task, TodoList) untuk Hive
 ┣ 📂 presentation/
 ┃ ┣ 📂 providers/       # Provider untuk state management
 ┃ ┣ 📂 screens/         # UI untuk setiap halaman (Home, Detail, Settings)
 ┃ ┗ 📂 widgets/         # Komponen UI yang bisa dipakai ulang
