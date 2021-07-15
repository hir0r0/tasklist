import 'package:flutter/material.dart';
import 'package:tasklist/task_card_entity.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  late int id;
  String taskName = '';
  String limitDate = '';
  String priority = '';

  TaskCard(TaskCardEntity entity) {
    this.id = entity.id;
    this.taskName = entity.taskName;
    this.limitDate = entity.limitDate;
    this.priority = entity.priority;
  }

  @override
  _TaskCardState createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(Object context) {
    return Card(
      shape: RoundedRectangleBorder(
        // side: BorderSide(color: Colors.white70, width: 0),
        borderRadius: BorderRadius.circular(0),
      ),
      color: toConvColor(widget.priority),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.taskName, style: TextStyle(fontSize: 22.0)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(widget.limitDate, style: TextStyle(fontSize: 18.0)),
              Text(toPriorityString(widget.priority),
                  style: TextStyle(fontSize: 18.0)),
            ],
          ),
        ],
      ),
    );
  }

  Color toConvColor(String priority) {
    switch (priority) {
      case '1':
        return Colors.red.shade100;
      case '2':
        return Colors.orange.shade100;
      case '3':
        return Colors.lightGreen.shade200;
      case '4':
        return Colors.lightBlue.shade100;
      default:
        return Colors.white;
    }
  }

  String toPriorityString(String priority) {
    switch (priority) {
      case '1':
        return '超高';
      case '2':
        return '　高';
      case '3':
        return '　中';
      case '4':
        return '　低';
      default:
        return '　無';
    }
  }
}
