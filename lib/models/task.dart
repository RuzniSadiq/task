import 'dart:convert';

class Task {
  final String? id;
  final String? name;
  final String? description;
  final String? date;

  Task({this.id, this.name, this.description, this.date});

  List<Task> taskFromJson(String str) =>
      List<Task>.from(json.decode(str).map((x) => Task.fromJson(x)));
  String taskToJson(List<Task> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

  // receiving data
  factory Task.fromJson(json) {
    return Task(
      id: json["id"],
      name: json["name"],
      description: json["description"],
      date: json["date"],
    );
  }

  // sending data
  Map<String, dynamic> toJson() =>
      {"id": id, "name": name, "description": description, "date": date};
}
