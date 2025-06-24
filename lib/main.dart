import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'pages/form_page.dart';
import 'pages/list_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers:[
        ChangeNotifierProvider(create: (_) => TaskProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider())
      ],
      child: const MyApp(),)
  );
}

final GoRouter _router = GoRouter(
  routes:[
    GoRoute(
      path: '/',
      builder: (context, state) => const ListPage()
    ),
    GoRoute(
      path: '/form',
      builder: (context, state) => const FormPage()
    ),
    GoRoute(
      path: '/form/:id',
      builder: (context, state){
        final id = state.pathParameters['id'];
        return FormPage(id: id,);
      }),
  ]);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();

    return MaterialApp.router(
      routerConfig: _router,
      title: 'To_Do App',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.theme,
    );
  }
}

class Task {
  final String id;
  final String title;
  final bool completed;

  Task ({
    required this.id,
    required this.title,
    this.completed = false,
  });
}

class TaskProvider extends ChangeNotifier{
  final List<Task> tasks = [];

  void addTask(Task task){
    tasks.insert(0,task);
    notifyListeners();
  }

  void deleteTask(String id){
    tasks.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  void updateTask (String id, String newTitle){

    final index= tasks.indexWhere((item) => item.id == id);
    tasks[index] = Task(id: tasks[index].id, title: newTitle, completed: tasks[index].completed);
    notifyListeners();
  }

  void statusTask(String id){
    final index= tasks.indexWhere((item) => item.id == id);
    tasks[index] = Task(id: tasks[index].id, title: tasks[index].title, completed: !tasks[index].completed);

    final task = tasks.removeAt(index);
    if(task.completed == true){      
      tasks.add(task);
    }else{
      tasks.insert(0, task);
    }

    notifyListeners();
  }

  Task getTask(String id){
    final index= tasks.indexWhere((item) => item.id == id);

    return tasks[index];
  }

  void reorderTasks(int oldIndex, int newIndex){
    if( oldIndex < newIndex){
      newIndex -= 1;
    }
    final task = tasks.removeAt(oldIndex);
    tasks.insert(newIndex, task);
    notifyListeners();
  }

  void completedTask(String id, bool completed){
    final index= tasks.indexWhere((item) => item.id == id);
    if(completed == true){
      final task = tasks.removeAt(index);
      tasks.add(task);
    }
    notifyListeners();
  }
}


class ThemeProvider extends ChangeNotifier{
  ThemeMode theme= ThemeMode.light;

  ThemeMode actualTheme(){
    return theme;
  }

  void changeTheme(){
    theme = (theme == ThemeMode.light) ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}