import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'package:firebase_analytics/firebase_analytics.dart';


class TaskTile extends StatelessWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.read<TaskProvider>();

    return ListTile(
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.completed
              ? TextDecoration.lineThrough
              : TextDecoration.none,
        ),
      ),
      leading: Checkbox(
        value: task.completed,
        onChanged: (_) {
          taskProvider.changeTaskStatus(task.id);

          FirebaseAnalytics.instance.logEvent(
            name: 'task_status_changed',
            parameters: {
              'task_id' : task.id,
              'task_title': task.title,
              'new_task_status': !task.completed ? 'completed' : 'incomplete',
            }
          );
        },
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () => context.push('/form/${task.id}'),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: Text(AppLocalizations.of(context)!.delete_task),
                actions: [
                  TextButton.icon(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.cancel_rounded),
                    label: Text(AppLocalizations.of(context)!.cancel),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      taskProvider.deleteTask(task.id);
                      Navigator.pop(context);

                      FirebaseAnalytics.instance.logEvent(
                        name: 'task_deleted',
                        parameters: {
                          'task_title_deleted': task.title,
                        }
                      );
                    },
                    icon: Icon(Icons.delete),
                    label: Text(AppLocalizations.of(context)!.delete),
                  ),
                ],
              ),
            ),
            icon: Icon(Icons.delete_forever_rounded),
          ),
          Icon(Icons.drag_indicator_rounded),
        ],
      ),
    );
  }
}
