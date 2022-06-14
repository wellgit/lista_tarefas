class Task {
  int id;
  String title;
  bool isDone;

  Task({
    required this.id,
    required this.title,
    this.isDone = false,
  });

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        isDone: json["isDone"] == 1,
      );

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "id": id,
      "title": title,
      "isDone": isDone ? 1 : 0
    };

    map["id"] = id;

    return map;
  }
}
