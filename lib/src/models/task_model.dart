// To parse this JSON data, do
//
//     final task = taskFromJson(jsonString);

import 'dart:convert';

Task taskFromJson(String str) => Task.fromJson(json.decode(str));

String taskToJson(Task data) => json.encode(data.toJson());

class Task {
    Task({
        this.id,
        this.description,
        this.title,
        this.completed = false,
    });
    
    String id;
    String description;
    String title;
    bool completed;

    factory Task.fromJson(Map<String, dynamic> json) => Task(
        description: json["description"],
        title: json["title"],
        completed: json["completed"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "description": description,
        "title": title,
        "completed": completed,
        "id": id,
    };
}

