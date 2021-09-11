class TaskCardEntity {
  int id;
  String taskName;
  String limitDate;
  String priority;

  TaskCardEntity(
      {required this.id,
      required this.taskName,
      required this.limitDate,
      required this.priority});

  Map<String, dynamic> toMap() {
    return {'taskName': taskName, 'limitDate': limitDate, 'priority': priority};
  }

  factory TaskCardEntity.fromMap(Map<String, dynamic> json) => TaskCardEntity(
      id: int.parse(["id"].toString()),
      taskName: json["taskName"],
      limitDate: json["limitDate"],
      priority: json["priority"]);
}
