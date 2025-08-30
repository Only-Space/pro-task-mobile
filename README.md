ProTask MobileSebuah aplikasi Todo List sederhana yang bersifat offline-first untuk mengelola tugas harian Anda, dibangun menggunakan Flutter.🚀 Tentang ProyekProTask adalah aplikasi manajemen tugas yang dirancang untuk membantu pengguna mengatur berbagai daftar pekerjaan, mulai dari proyek kuliah hingga daftar belanja. Dengan fokus pada pengalaman pengguna yang cepat dan fungsionalitas offline, semua data disimpan secara lokal di perangkat menggunakan database Hive, memastikan aksesibilitas bahkan tanpa koneksi internet.✨ Fitur UtamaManajemen Papan Tugas: Buat, hapus, dan kelola beberapa daftar tugas (papan) yang berbeda.Manajemen Tugas Lengkap:Checklist: Tandai tugas sebagai selesai dengan efek visual yang jelas.Prioritas: Atur prioritas (Tinggi, Sedang, Rendah) dengan indikator warna yang intuitif.Deadline: Tetapkan tanggal dan waktu deadline untuk setiap tugas.Gestur Cepat:Geser ke Kanan untuk mengedit tugas.Geser ke Kiri untuk menghapus tugas dengan konfirmasi.Mode Gelap & Terang: Tema aplikasi yang dapat disesuaikan untuk kenyamanan visual.Penyimpanan Lokal: Semua data aman tersimpan di perangkat Anda, tidak memerlukan koneksi internet.🛠️ Dibangun DenganBerikut adalah beberapa teknologi dan package utama yang digunakan dalam proyek ini:Framework: FlutterBahasa: DartDatabase Lokal: HiveState Management: ProviderFormatting Tanggal: intlCode Generation: build_runner⚙️ MemulaiUntuk menjalankan proyek ini di lingkungan lokal Anda, ikuti langkah-langkah sederhana berikut.PrasyaratPastikan Anda sudah menginstal Flutter SDK di komputer Anda. Untuk panduan instalasi, silakan kunjungi dokumentasi resmi Flutter.InstalasiClone repositori ini:git clone [https://github.com/URL_REPOSITORI_ANDA/pro-task-mobile.git](https://github.com/URL_REPOSITORI_ANDA/pro-task-mobile.git)
Pindah ke direktori proyek:cd pro-task-mobile
Instal semua dependensi:flutter pub get
Jalankan code generator untuk Hive:flutter pub run build_runner build --delete-conflicting-outputs
Jalankan aplikasi:flutter run
📂 Struktur ProyekStruktur folder utama di dalam direktori lib diatur sebagai berikut untuk menjaga keterbacaan dan skalabilitas kode:lib/
|-- main.dart           # File utama untuk menjalankan aplikasi
|-- data/
|   |-- models/         # Definisi model data (Task, TodoList) untuk Hive
|-- presentation/
|   |-- providers/      # Provider untuk state management (contoh: ThemeProvider)
|   |-- screens/        # UI untuk setiap halaman (Home, Detail, Settings)
|   |-- widgets/        # (Opsional) Komponen UI yang bisa dipakai ulang
Dibuat dengan ❤️ dan Flutter.# pro-task-mobile
