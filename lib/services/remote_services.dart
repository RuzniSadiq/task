import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/task.dart';

class RemoteServices {
  String uri = "https://62dc17b457ac3c3f3c55bde8.mockapi.io/tasks";
  Future getTasks() async {
    Task task = Task();

    try {
      final response = await http.get(Uri.parse(uri));

      if (response.statusCode == 200) {
        var json = response.body;
        return task.taskFromJson(json);
      } else {
        throw Exception('Failed to load data');
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future createTask(String name, String description, String date) async {
    Task taskData = Task(name: name, description: description, date: date);

    try {
      final response = await http.post(Uri.parse(uri),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(taskData.toJson()));

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      print(e);
    }
  }

  Future updateTask(
      String id, String name, String description, String date) async {
    Task taskData = Task(name: name, description: description, date: date);

    try {
      final response = await http.put(Uri.parse("$uri/$id"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(taskData.toJson()));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      return e.toString();
    }
  }

  Future deleteTask(String id) async {
    try {
      final response = await http.delete(Uri.parse("$uri/$id"));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on Exception catch (e) {
      return e.toString();
    }
  }
}
