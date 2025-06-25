import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
    final taskProvider = context.read<TaskProvider>();
    taskProvider.tasksApi();
  }


  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();
    final tasks = taskProvider.tasks;

    return Scaffold(
      appBar: AppBar(
        title: Text('My Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              context.read<ThemeProvider>().changeTheme();
            },
          ),
        ],        
      ),      
      //body: TextButton(onPressed:() => context.push('/form'), child: Text('New')),

      body: 
        ReorderableListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index){
            final task = tasks[index];
            return ListTile(
              key: ValueKey(task.id),
              title: Text(task.title, style: TextStyle(decoration: task.completed ? TextDecoration.lineThrough : TextDecoration.none),),
              leading: Checkbox(value: task.completed, onChanged: (_) { taskProvider.statusTask(task.id); }),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: () => context.push('/form/${task.id}'), icon: Icon(Icons.edit)),
                  IconButton(
                    onPressed: () => showDialog(
                      context: context, 
                      builder: (context)=>AlertDialog(
                        content: Text('delete task?'),
                        actions: [
                          TextButton.icon(onPressed: () => context.pop(), icon: Icon(Icons.cancel_rounded), label: Text ('cancel') ),
                          TextButton.icon(onPressed: () {
                            taskProvider.deleteTask(task.id);
                            Navigator.pop(context);
                            }, 
                            icon: Icon(Icons.delete), label: Text ('Delete') ),
                        ],
                      ))
                  , icon: Icon(Icons.delete_forever_rounded)),
                  Icon(Icons.drag_indicator_rounded)
                ],
              ),
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