import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:todo_app/src/models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks;
  String _baseUrl = "";

  TaskProvider() {
    _tasks = [];
  }

  List<Task> getTasks() {
    return _tasks;
  }

  void saveTask(Task task) {
    _tasks.add(task);
    notifyListeners();
  }

  Future<List<Task>> getTasksFromFireBase() async {
    String url = "$_baseUrl/tasks.json";

    var response = await http.get(url);
    if (response.body == "null") {
      return new List<Task>();
    }

    Map<String, dynamic> decodedResponse = json.decode(response.body);

    List<Task> tasks = new List<Task>();

    decodedResponse.forEach((key, value) {
      tasks.add(Task(
          id: key,
          title: value['title'],
          description: value['description'],
          completed: value['completed']));
    });

    return tasks;
  }

  Future saveTaskOnFireBase(Task task) async {
    String url = "$_baseUrl/tasks.json";

    var response = await http.post(url, body: json.encode(task));

    if (response.statusCode > 201) {
      throw new PlatformException(
        message: 'Hubo un error sadico',
        code: response.statusCode.toString(),
      );
    }

    notifyListeners();
  }

  Future updateTaskOnFireBase(Task task) async {
    String url = "$_baseUrl/tasks/${task.id}.json";

    var response = await http.put(url, body: json.encode(task));

    if (response.statusCode > 201) {
      throw new PlatformException(
        message: 'Hubo un error sadico',
        code: response.statusCode.toString(),
      );
    }

    notifyListeners();
  }

  Future deleteTaskOnFireBase(String id) async {
    String url = "$_baseUrl/tasks/$id.json";

    var response = await http.delete(url);

    if (response.statusCode > 201) {
      throw new PlatformException(
        message: 'Hubo un error sadico',
        code: response.statusCode.toString(),
      );
    }

    notifyListeners();
  }
}
