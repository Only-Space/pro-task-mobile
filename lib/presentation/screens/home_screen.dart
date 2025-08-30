import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pro_task_mobile/data/models/todo_list_model.dart';
import 'package:pro_task_mobile/data/models/task_model.dart';
import 'package:pro_task_mobile/presentation/screens/setting_screen.dart';
import 'package:pro_task_mobile/presentation/screens/todo_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Controller untuk text field pada dialog tambah list
  final _newListController = TextEditingController();

  // Box Hive untuk menyimpan TodoList
  late final Box<TodoList> _todoListBox;

  @override
  void initState() {
    super.initState();
    // Mengambil referensi box yang sudah dibuka di main.dart
    _todoListBox = Hive.box<TodoList>('todoListBox');
  }

  @override
  void dispose() {
    _newListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Pro Task Mobile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 1,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              // Navigasi ke halaman pengaturan saat ikon ditekan
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddListDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // Widget utama untuk membangun body, menggunakan ValueListenableBuilder
  Widget _buildBody() {
    // ValueListenableBuilder adalah cara paling efisien untuk membangun UI
    // yang bereaksi terhadap perubahan data di Hive.
    // UI akan otomatis diperbarui setiap kali ada data yang ditambah,
    // diubah, atau dihapus dari box.
    return ValueListenableBuilder(
      valueListenable: _todoListBox.listenable(),
      builder: (context, Box<TodoList> box, _) {
        // Jika box kosong, tampilkan pesan informatif
        if (box.values.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.inventory_2_outlined,
                  size: 80,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Anda belum memiliki papan tugas.',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                const Text(
                  'Tekan tombol \'+\' untuk memulai.',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          );
        }

        // Jika ada data, tampilkan dalam bentuk ListView
        return ListView.builder(
          padding: const EdgeInsets.all(8.0),
          itemCount: box.values.length,
          itemBuilder: (context, index) {
            final todoList = box.getAt(index);
            // Kita perlu memeriksa jika todoList tidak null
            if (todoList == null) {
              return const SizedBox.shrink(); // Widget kosong jika ada data aneh
            }

            // Menghitung jumlah tugas yang selesai
            int totalTasks = todoList.tasks.length;
            int completedTasks = todoList.tasks
                .where((task) => task.isCompleted)
                .length;

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.blueAccent.withOpacity(0.1),
                  child: Text(
                    '${((totalTasks > 0 ? (completedTasks / totalTasks) : 0) * 100).toInt()}%',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
                title: Text(
                  todoList.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
                subtitle: Text(
                  '$completedTasks dari $totalTasks tugas selesai',
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () => _confirmDeleteList(todoList),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TodoDetailScreen(todoList: todoList),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi penghapusan
  void _confirmDeleteList(TodoList listToDelete) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Papan Tugas?'),
          content: Text(
            'Apakah Anda yakin ingin menghapus "${listToDelete.title}"? Semua tugas di dalamnya juga akan terhapus.',
          ),
          actions: [
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Hapus'),
              onPressed: () {
                listToDelete
                    .delete(); // Ini adalah fungsi bawaan HiveObject untuk menghapus
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog penambahan list baru
  void _showAddListDialog() {
    _newListController
        .clear(); // Bersihkan controller setiap kali dialog dibuka
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Papan Tugas Baru'),
          content: TextField(
            controller: _newListController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Contoh: Proyek Kuliah',
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Tambah'),
              onPressed: () {
                final String title = _newListController.text.trim();
                if (title.isNotEmpty) {
                  _addTodoList(title);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menambahkan data TodoList baru ke Hive
  void _addTodoList(String title) {
    // HiveList perlu diinisialisasi dan dihubungkan dengan sebuah box.
    // Meskipun list tugasnya masih kosong, ini adalah langkah penting.
    final taskBox = Hive.box<Task>('taskBox');
    final newTodoList = TodoList(title: title, tasks: HiveList(taskBox));
    _todoListBox.add(newTodoList);
  }
}
