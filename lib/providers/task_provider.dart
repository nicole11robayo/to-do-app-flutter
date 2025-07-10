
import 'package:dio/dio.dart';
import '../models/task.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskProvider extends StateNotifier<List<Task>>{
  TaskProvider(): super([]);

  Future<void> fetchTasks() async{ 

    final dio = Dio(
      BaseOptions(
        headers: {
          'User-Agent': 'FlutterApp/1.0',
          'Accept': 'application/json',
        },
      ),
    );

    try {      
      final response =  await dio.get('https://jsonplaceholder.typicode.com/todos');
      final todosApi = response.data as List;

      final List<Task> loadedTasks = todosApi.take(5).map((item) => Task.fromJson(item)).toList();

      state = [...state, ...loadedTasks];  
      // ignore: empty_catches
      } catch (e) { 
      }
  }

  void addTask(Task task){
    state = [task, ...state];
  }

  void deleteTask(String id){
    final newState= state.where((task) => task.id != id).toList();
    state= newState;
    
  }

  void updateTask (String id, String newTitle){

    state = [
      for (final task in state)
        if (task.id == id)
          Task(id: task.id, title: newTitle, completed: task.completed)
        else
          task,
    ];
  }

  void changeTaskStatus(String id){ 
    List<Task> updated = [
      for (final task in state)
        if (task.id == id)
          Task(id: task.id, title: task.title, completed: !task.completed)
        else
          task,
    ];

    final index = updated.indexWhere((t) => t.id == id);
    final task = updated.removeAt(index);

    if (task.completed) {
      updated.add(task);
    } else {
      updated.insert(0, task);
    }

    state = updated;
  }

  Task getTask(String id){
    return state.firstWhere((task) => task.id == id);
  }

  void reorderTasks(int oldIndex, int newIndex){
    final updated = [...state];

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final task = updated.removeAt(oldIndex);
    updated.insert(newIndex, task);
    state = updated;
  }

  void completedTask(String id, bool completed){
    final updated = [...state];

    final index = updated.indexWhere((task) => task.id == id);
    final task = updated.removeAt(index);

    if (completed) {
      updated.add(task);
    } else {
      updated.insert(0, task);
    }

    state = updated;
  }
}

final taskProvider = StateNotifierProvider<TaskProvider, List<Task>>(
  (ref) => TaskProvider(),
);