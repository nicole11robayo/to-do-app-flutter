import 'package:app_to_do/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../providers/locale_provider.dart';
import '../providers/task_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/task_tile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../main.dart';

class ListPage extends StatefulWidget { 
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  void initState() {
    super.initState();

    FirebaseAnalytics.instance.logEvent(
      name: 'app_initialized',
      parameters: {'message': 'App started successfully'},
    );
    
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) async {
      final taskProvider = context.read<TaskProvider>();
      await taskProvider.fetchTasks();

      FirebaseAnalytics.instance.logEvent(
      name: 'tasks_fetched_api',
      parameters: {
        'message': 'Tasks form API fetched successfully',
        'task_length_api':  taskProvider.tasks.length},
    );
    });
  }


  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.title),
        actions: [          
          DropdownButton<Locale>(
            value: context.watch<LocaleProvider>().locale,
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
                context.read<LocaleProvider>().setLocale(newLocale);
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeProvider>().changeTheme();              
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
            taskProvider.reorderTasks(oldIndex, newIndex);
          },
          ),

          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('/form'),
            child: const Icon(Icons.add),
          ),
    );
  }
}