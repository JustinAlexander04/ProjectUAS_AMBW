import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddTodoDialog extends StatefulWidget {
  final VoidCallback onTodoAdded;

  const AddTodoDialog({super.key, required this.onTodoAdded});

  @override
  State<AddTodoDialog> createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _categoryController = TextEditingController();
  DateTime? _selectedTime;

  final supabase = Supabase.instance.client;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedTime == null) return;

    final user = supabase.auth.currentUser;
    if (user == null) return;

    widget.onTodoAdded();

    await supabase.from('todos').insert({
      'title': _titleController.text,
      'category': _categoryController.text,
      'time': _selectedTime!.toIso8601String(),
      'is_done': false,
      'user_id': user.id,
    });

    if (mounted) Navigator.pop(context); 
  }

  Future<void> _pickDateTime() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2024),
      lastDate: DateTime(2030),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;

    setState(() {
      _selectedTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final timeFormatted = _selectedTime != null
        ? DateFormat('dd MMM yyyy, HH:mm').format(_selectedTime!)
        : 'Pilih waktu';

    return AlertDialog(
      title: const Text('Tambah To-Do'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Judul'),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Wajib diisi' : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: 'Kategori'),
              ),
              const SizedBox(height: 10),
              TextButton.icon(
                icon: const Icon(Icons.calendar_today),
                label: Text(timeFormatted),
                onPressed: _pickDateTime,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: _submit,
        ),
      ],
    );
  }
}
