import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  String taskName = '';
  String limitDate = '';
  // String limitTime = '';
  String priority = '';

  // TaskCard(String taskName, String limitDate, String limitTime, int priority) {
  //   this.taskName = taskName;
  //   this.limitDate = limitDate;
  //   this.limitTime = limitTime;
  //   this.priority = priority;
  // }

  TaskCard(String taskName, String limitDate, String priority) {
    this.taskName = taskName;
    this.limitDate = limitDate;
    this.priority = priority;
  }

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(Object context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(widget.taskName, style: TextStyle(fontSize: 20.0)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(toPriorityString(widget.priority),
                style: TextStyle(fontSize: 20.0)),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(widget.limitDate, style: TextStyle(fontSize: 20.0)),
            // VerticalDivider(),
            // Text(widget.limitTime, style: TextStyle(fontSize: 20.0)),
          ],
        ),
      ],
    );
  }

  String toPriorityString(String priority) {
    switch (priority) {
      case '1':
        return '超高';
      case '2':
        return '高';
      case '3':
        return '中';
      case '4':
        return '低';
      default:
        return '無';
    }
  }
}
