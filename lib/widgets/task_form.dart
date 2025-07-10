import 'package:flutter/material.dart';

import '../l10n/app_localizations.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:go_router/go_router.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


class TaskForm extends ConsumerStatefulWidget {
  final String? id;
  const TaskForm({super.key, this.id});

  @override
  ConsumerState<TaskForm> createState() => _TaskFormState();
}

class _TaskFormState extends ConsumerState<TaskForm> {

  final TextEditingController controller = TextEditingController();
  bool editingNow = false;
  String previousTitle= '';

  @override
  void initState() {
    super.initState();

    if (widget.id != null){
      final task = ref.read(taskProvider.notifier).getTask(widget.id!);
      controller.text= task.title;
      previousTitle= task.title;
      editingNow=true;
    }
  }

  void formTaskSubmit (){
    final title= controller.text;
    final notifier = ref.read(taskProvider.notifier);

    if(editingNow){
      notifier.updateTask(widget.id!, title);

      FirebaseAnalytics.instance.logEvent(
        name: 'task_updated',
        parameters: {
          'previous_task_title': previousTitle,
          'new_task_title': title,
        }
      );
        
    }else{
      final id= DateTime.now().millisecondsSinceEpoch.toString();
      notifier.addTask(Task(id: id, title: title));

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