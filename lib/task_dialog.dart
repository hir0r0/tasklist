import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskDialog extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _TaskDialogState();
}

class _TaskDialogState extends State {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('タスク入力')),
      body: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('タイトル：', style: TextStyle(fontSize: 20.0)),
        ],
      ),
    );
  }
}
