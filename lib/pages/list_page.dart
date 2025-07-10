import 'package:app_to_do/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';

import '../providers/locale_provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/task_tile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';


class ListPage extends ConsumerStatefulWidget{ 
  const ListPage({super.key});

  @override
  ConsumerState<ListPage> createState() => _ListPageState();
}

class _ListPageState extends ConsumerState<ListPage> {

  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.logEvent(
      name: 'app_initialized',
      parameters: {'message': 'App started successfully'},
    );
    
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(taskProvider.notifier).fetchTasks();

      FirebaseAnalytics.instance.logEvent(
      name: 'tasks_fetched_api',
      parameters: {
        'message': 'Tasks form API fetched successfully',
      },
    );
    });
  }


  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskProvider);
    final locale = ref.watch(localeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
        actions: [          
          DropdownButton<Locale>(
            value: locale,
            icon: const Icon(Icons.language, color: Colors.blue),
            items: const [
              DropdownMenuItem(
                value: Locale('en'),
                child: Text('En'),
              ),
              DropdownMenuItem(
                value: Locale('es'),
                child: Text('Es'),
              ),
            ],
            onChanged: (Locale? newLocale) {
              if (newLocale != null) {
                ref.read(localeProvider.notifier).setLocale(newLocale);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              ref.read(themeProvider.notifier).changeTheme();              
            },
          ),         
        ],        
      ),      

      body: 
        ReorderableListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index){
            final task = tasks[index];
            return  TaskTile(
              key: ValueKey(task.id),
              task: task
              );
            
          },
          onReorder: (oldIndex, newIndex) {
            ref.read(taskProvider.notifier).reorderTasks(oldIndex, newIndex);
          },
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('/form'),
            child: const Icon(Icons.add),
          ),
    );
  }
}