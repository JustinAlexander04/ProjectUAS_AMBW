import 'package:flutter/material.dart';
import 'package:flutter_application_uas/widgets/add_todo_dialog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/local_storage_service.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabase = Supabase.instance.client;
  List<dynamic> todos = [];
  bool isLoading = true;
  String userEmail = '';

  @override
  void initState() {
    super.initState();
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final res = await supabase
        .from('todos')
        .select()
        .eq('user_id', user.id)
        .order('time', ascending: true);

    setState(() {
      todos = res;
      userEmail = user.email ?? 'User';
      isLoading = false;
    });
  }

  void _confirmDelete(int todoId) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Hapus To-Do'),
            content: const Text('Apakah kamu yakin ingin menghapus to-do ini?'),
            actions: [
              TextButton(
                child: const Text('Batal'),
                onPressed: () => Navigator.pop(context),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text('Hapus'),
                onPressed: () async {
                  await supabase.from('todos').delete().eq('id', todoId);
                  if (mounted) {
                    Navigator.pop(context); // tutup dialog
                    _loadTodos(); // refresh
                  }
                },
              ),
            ],
          ),
    );
  }

  Future<void> _logout() async {
    await supabase.auth.signOut();
    await LocalStorageService.clearSession();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do $userEmail Hari Ini'),
        actions: [
          IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : todos.isEmpty
              ? const Center(child: Text("Belum ada tugas harian"))
              : ListView.builder(
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  final bool isDone = todo['is_done'] ?? false;

                  return ListTile(
                    title: Text(
                      todo['title'] ?? '',
                      style: TextStyle(
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    subtitle: Text(todo['category'] ?? '-'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            isDone
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                          ),
                          onPressed: () async {
                            await supabase
                                .from('todos')
                                .update({'is_done': !isDone})
                                .eq('id', todo['id']);
                            _loadTodos();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          color: Colors.red,
                          onPressed: () => _confirmDelete(todo['id']),
                        ),
                      ],
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            builder:
                (_) => Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.check),
                        title: const Text('Tambah To-Do'),
                        onTap: () {
                          Navigator.pop(context); // tutup sheet
                          showDialog(
                            context: context,
                            builder:
                                (_) => AddTodoDialog(onTodoAdded: _loadTodos),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Logout'),
                        onTap: () {
                          Navigator.pop(context); // tutup sheet
                          _logout();
                        },
                      ),
                    ],
                  ),
                ),
          );
        },
      ),
    );
  }
}
