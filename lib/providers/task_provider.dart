import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../models/task.dart';

class TaskProvider extends ChangeNotifier{
  final List<Task> tasks = [];

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

      tasks.addAll(loadedTasks);
      notifyListeners();
        
      } catch (e) {
        print('error fetching tasks: $e');      
      }
  }

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

  void changeTaskStatus(String id){ 
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