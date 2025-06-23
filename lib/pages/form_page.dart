import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../main.dart';

class FormPage extends StatefulWidget {

  final String? id;
  const FormPage({super.key, this.id});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final TextEditingController controller = TextEditingController();
  bool editingNow = false;

  @override
  void initState() {
    final taskProvider = context.read<TaskProvider>();
    super.initState();

    if (widget.id != null){
      final task = taskProvider.getTask(widget.id!);
      controller.text= task.title;
      editingNow=true;
    }
  }

  void formTask (){
    final title= controller.text;
    final taskProvider = context.read<TaskProvider>();

    if(editingNow){
      taskProvider.updateTask(widget.id!, title);
    }else{
      final id= DateTime.now().millisecondsSinceEpoch.toString();
      taskProvider.addTask(Task(id: id, title: title));
    }
    context.pop();
  }

  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text(editingNow ? 'Edit task' : 'New task'),
    ),
    body: Padding(
      padding: EdgeInsetsGeometry.all(15),
      child: Column(
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: formTask,
              icon: Icon(editingNow ? Icons.edit : Icons.add),
              label: Text(editingNow ? 'update' : 'add'),
            ),
          ],
        ),
    ),
  );
}
}