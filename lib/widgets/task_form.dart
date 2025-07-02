import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_localizations.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:go_router/go_router.dart';

import 'package:firebase_analytics/firebase_analytics.dart';



class TaskForm extends StatefulWidget {
  final String? id;
  const TaskForm({super.key, this.id});

  @override
  State<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends State<TaskForm> {

  final TextEditingController controller = TextEditingController();
  bool editingNow = false;
  String previousTitle= '';

  @override
  void initState() {
    final taskProvider = context.read<TaskProvider>();
    super.initState();

    if (widget.id != null){
      final task = taskProvider.getTask(widget.id!);
      controller.text= task.title;
      previousTitle= task.title;
      editingNow=true;
    }
  }

  void formTaskSubmit (){
    final title= controller.text;
    final taskProvider = context.read<TaskProvider>();

    if(editingNow){
      taskProvider.updateTask(widget.id!, title);

      FirebaseAnalytics.instance.logEvent(
        name: 'task_updated',
        parameters: {
          'previous_task_title': previousTitle,
          'new_task_title': title,
        }
      );
        
    }else{
      final id= DateTime.now().millisecondsSinceEpoch.toString();
      taskProvider.addTask(Task(id: id, title: title));

      FirebaseAnalytics.instance.logEvent(
        name: 'task_created',
        parameters: {
          'task_title': title,
        },
      );
    }
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: formTaskSubmit,
              icon: Icon(editingNow ? Icons.edit : Icons.add),
              label: Text(editingNow ? AppLocalizations.of(context)!.update : AppLocalizations.of(context)!.add),
            ),
          ],
        );
  }
}