import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:pro_task_mobile/data/models/task_model.dart';
import 'package:pro_task_mobile/data/models/todo_list_model.dart';
import 'package:pro_task_mobile/presentation/providers/theme_provider.dart';
import 'package:pro_task_mobile/presentation/screens/home_screen.dart';

void main() async {
  // Pastikan Flutter binding sudah siap
  WidgetsFlutterBinding.ensureInitialized();

  // Inisialisasi Hive
  await Hive.initFlutter();

  // Registrasi Adapter yang sudah di-generate
  Hive.registerAdapter(TodoListAdapter());
  Hive.registerAdapter(TaskAdapter());

  // Buka "box" (tabel) yang akan kita gunakan
  await Hive.openBox<TodoList>('todoListBox');
  await Hive.openBox<Task>('taskBox');
  await Hive.openBox('settingsBox'); // Box baru untuk pengaturan

  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const ProTaskApp(),
    ),
  );
}

class ProTaskApp extends StatelessWidget {
  const ProTaskApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'ProTask',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black87,
              elevation: 1,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFF121212),
            cardColor: const Color(0xFF1E1E1E),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.blueAccent,
              foregroundColor: Colors.white,
            ),
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          debugShowCheckedModeBanner: false,
          home: HomeScreen(), // Halaman utama kita
        );
      },
    );
  }
}
