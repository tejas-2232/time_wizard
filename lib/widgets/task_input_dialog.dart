import 'package:flutter/material.dart';

class TaskInputDialog extends StatefulWidget {
  const TaskInputDialog({super.key});

  @override
  State<TaskInputDialog> createState() => _TaskInputDialogState();
}

class _TaskInputDialogState extends State<TaskInputDialog> {
  final _taskNameController = TextEditingController();
  final _projectNameController = TextEditingController();
  
  @override
  void dispose() {
    _taskNameController.dispose();
    _projectNameController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Start New Timer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _taskNameController,
            decoration: const InputDecoration(
              labelText: 'Task Name',
              hintText: 'What are you working on?',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.next,
            autofocus: true,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _projectNameController,
            decoration: const InputDecoration(
              labelText: 'Project Name (optional)',
              hintText: 'Which project is this for?',
              border: OutlineInputBorder(),
            ),
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _submit(),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Start Timer'),
        ),
      ],
    );
  }
  
  void _submit() {
    Navigator.pop(
      context,
      {
        'taskName': _taskNameController.text.trim().isNotEmpty
            ? _taskNameController.text.trim()
            : 'Untitled Task',
        'projectName': _projectNameController.text.trim().isNotEmpty
            ? _projectNameController.text.trim()
            : null,
      },
    );
  }
}