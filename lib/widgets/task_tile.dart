import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../models/task.dart';
import '../providers/task_provider.dart';
import 'package:go_router/go_router.dart';

import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


class TaskTile extends ConsumerWidget {
  final Task task;
  const TaskTile({super.key, required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(taskProvider.notifier);

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
          notifier.changeTaskStatus(task.id);

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
                      //print('id task delete ${task.id}');
                      notifier.deleteTask(task.id);
                      Navigator.pop(context);

                      FirebaseAnalytics.instance.logEvent(
                        name: 'task_deleted',
                        parameters: {
                          'task_title_deleted': task.title,
                        }
                      );
                      print('event sent');
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
