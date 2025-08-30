import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pro_task_mobile/data/models/task_model.dart';
import 'package:pro_task_mobile/data/models/todo_list_model.dart';

class TodoDetailScreen extends StatefulWidget {
  final TodoList todoList;

  const TodoDetailScreen({super.key, required this.todoList});

  @override
  State<TodoDetailScreen> createState() => _TodoDetailScreenState();
}

class _TodoDetailScreenState extends State<TodoDetailScreen> {
  late final Box<Task> _taskBox;

  @override
  void initState() {
    super.initState();
    _taskBox = Hive.box<Task>('taskBox');
  }

  // --- WIDGET BUILDER UTAMA ---
  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder dihapus karena menyebabkan error.
    // Kita akan mengandalkan setState untuk me-refresh UI di halaman ini.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todoList.title),
        elevation: 1,
      ),
      body: widget.todoList.tasks.isEmpty
          ? _buildEmptyState() // Tampilkan ini jika tidak ada tugas
          : _buildTaskList(widget
              .todoList.tasks), // Tampilkan daftar tugas jika ada
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialog(),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  // --- UI UNTUK TAMPILAN KOSONG ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_box_outline_blank,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada tugas di sini.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          const Text(
            'Tekan tombol \'+\' untuk menambahkan tugas pertama.',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // --- UI UNTUK DAFTAR TUGAS ---
  Widget _buildTaskList(HiveList<Task> tasks) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        final isOverdue = task.deadline != null &&
            !task.isCompleted &&
            task.deadline!.isBefore(DateTime.now());

        // Warna teks dinamis berdasarkan tema
        final textColor = Theme.of(context).textTheme.bodyLarge?.color;

        return Dismissible(
          key: UniqueKey(),
          background: _buildDismissibleBackground(
              Colors.blue, Icons.edit, Alignment.centerLeft),
          secondaryBackground: _buildDismissibleBackground(
              Colors.red, Icons.delete, Alignment.centerRight),
          confirmDismiss: (direction) async {
            if (direction == DismissDirection.endToStart) { // Geser ke kiri (Hapus)
              return await _confirmDeleteTask(task);
            } else { // Geser ke kanan (Edit)
              _showTaskDialog(taskToEdit: task);
              return false; // Jangan hapus item dari list
            }
          },
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: IntrinsicHeight(
              child: Row(
                children: [
                  // Bilah Indikator Prioritas
                  Container(
                    width: 6,
                    decoration: BoxDecoration(
                      color: _getPriorityColor(task.priority),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      contentPadding: const EdgeInsets.only(
                          left: 10, right: 16, top: 8, bottom: 8),
                      // Checkbox di sebelah kiri
                      leading: Checkbox(
                        value: task.isCompleted,
                        onChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              task.isCompleted = value;
                              task.save();
                              widget.todoList
                                  .save(); // PENTING: simpan juga listnya
                            });
                          }
                        },
                        activeColor: Colors.blueAccent,
                      ),
                      // Judul tugas
                      title: Text(
                        task.name,
                        style: TextStyle(
                          decoration: task.isCompleted
                              ? TextDecoration.lineThrough
                              : TextDecoration.none,
                          color: task.isCompleted ? Colors.grey : textColor,
                        ),
                      ),
                      // Subtitle untuk deadline
                      subtitle: task.deadline != null
                          ? Text(
                              DateFormat('dd MMM yyyy, HH:mm')
                                  .format(task.deadline!),
                              style: TextStyle(
                                  color:
                                      isOverdue ? Colors.red : Colors.grey,
                                  fontSize: 12),
                            )
                          : null,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper untuk membuat background gestur geser
  Widget _buildDismissibleBackground(
      Color color, IconData icon, Alignment alignment) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      alignment: alignment,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Icon(icon, color: Colors.white),
    );
  }

  // Helper untuk mendapatkan warna prioritas
  Color _getPriorityColor(int priority) {
    switch (priority) {
      case 2: // Tinggi
        return Colors.red.shade400;
      case 1: // Sedang
        return Colors.orange.shade400;
      default: // Rendah
        return Colors.green.shade400;
    }
  }

  // --- DIALOG DAN LOGIKA ---

  // Dialog untuk Tambah/Edit Tugas
  void _showTaskDialog({Task? taskToEdit}) {
    final isEditing = taskToEdit != null;
    final title = isEditing ? 'Edit Tugas' : 'Tugas Baru';
    final TextEditingController nameController =
        TextEditingController(text: taskToEdit?.name ?? '');
    int selectedPriority = taskToEdit?.priority ?? 0;
    DateTime? selectedDeadline = taskToEdit?.deadline;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: Text(title),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      autofocus: true,
                      decoration:
                          const InputDecoration(labelText: 'Nama Tugas'),
                    ),
                    const SizedBox(height: 20),
                    // Dropdown untuk prioritas
                    DropdownButtonFormField<int>(
                      value: selectedPriority,
                      decoration:
                          const InputDecoration(labelText: 'Prioritas'),
                      items: const [
                        DropdownMenuItem(value: 0, child: Text('Rendah')),
                        DropdownMenuItem(value: 1, child: Text('Sedang')),
                        DropdownMenuItem(value: 2, child: Text('Tinggi')),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setDialogState(() {
                            selectedPriority = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    // Pilihan untuk menambah/mengubah deadline
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text("Deadline"),
                      subtitle: Text(selectedDeadline == null
                          ? 'Tidak diatur'
                          : DateFormat('dd MMM yyyy, HH:mm')
                              .format(selectedDeadline!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final now = DateTime.now();
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: selectedDeadline ?? now,
                          firstDate: now,
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate == null) return;

                        final pickedTime = await showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.fromDateTime(
                              selectedDeadline ?? now),
                        );
                        if (pickedTime == null) return;

                        setDialogState(() {
                          selectedDeadline = DateTime(
                            pickedDate.year,
                            pickedDate.month,
                            pickedDate.day,
                            pickedTime.hour,
                            pickedTime.minute,
                          );
                        });
                      },
                    )
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Batal'),
                ),
                TextButton(
                  onPressed: () {
                    final name = nameController.text.trim();
                    if (name.isNotEmpty) {
                      if (isEditing) {
                        _editTask(taskToEdit!, name, selectedPriority,
                            selectedDeadline);
                      } else {
                        _addTask(name, selectedPriority, selectedDeadline);
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Simpan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // Dialog konfirmasi hapus tugas
  Future<bool> _confirmDeleteTask(Task task) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Tugas?'),
        content:
            Text('Anda yakin ingin menghapus tugas "${task.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Batal'),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (result == true) {
      _deleteTask(task);
    }
    return result ?? false;
  }

  // --- FUNGSI LOGIKA DATA (CRUD) ---

  // Menambah task baru
  Future<void> _addTask(
      String name, int priority, DateTime? deadline) async {
    setState(() async {
      final newTask =
          Task(name: name, priority: priority, deadline: deadline);
      await _taskBox.add(newTask); // Simpan task ke box-nya sendiri dulu
      widget.todoList.tasks.add(newTask); // Lalu tambahkan ke daftar
      await widget.todoList.save();
    });
  }

  // Mengedit task yang ada
  Future<void> _editTask(
      Task task, String name, int priority, DateTime? deadline) async {
    setState(() async {
      task.name = name;
      task.priority = priority;
      task.deadline = deadline;
      await task.save(); // Cukup simpan task-nya, UI akan update
    });
  }

  // Menghapus task
  Future<void> _deleteTask(Task task) async {
    setState(() async {
      widget.todoList.tasks.remove(task);
      await widget.todoList.save();
      await task.delete(); // Hapus juga dari box-nya
    });
  }
}

