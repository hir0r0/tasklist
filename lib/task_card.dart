import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:tasklist/task_card_entity.dart';
import 'package:tasklist/db_provider.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  late TaskCardEntity _entity;
  String taskName = '';
  String limitDate = '';
  String priority = '';

  TaskCard(TaskCardEntity entity) {
    this._entity = entity;
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
    return Slidable(
      actionPane: SlidableScrollActionPane(),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Done',
          color: Colors.green,
          icon: Icons.check,
          onTap: _delete,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: _delete,
        ),
        IconSlideAction(
          caption: 'Close',
          color: Colors.grey,
          icon: Icons.close,
          onTap: () => {},
        ),
      ],
      secondaryActions: [
        IconSlideAction(
          caption: 'Done',
          color: Colors.green,
          icon: Icons.check,
          onTap: _delete,
        ),
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: _delete,
        ),
        IconSlideAction(
          caption: 'Close',
          color: Colors.grey,
          icon: Icons.close,
          onTap: () => {},
        ),
      ],
      actionExtentRatio: 1 / 7,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Divider(),
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

  void _delete() {
    // this._entity
    // DBProvider().deleteTaskCard(this._entity);
    setState() => {};
  }
}
