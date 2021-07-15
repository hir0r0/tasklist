import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:tasklist/db_provider.dart';
import 'package:tasklist/task_card_entity.dart';
import 'task_card.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage() : super();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  List<TaskCard> _tasks = <TaskCard>[];
  int cnt = 0;
  String _limitText = '';
  List<DropdownMenuItem<int>> _items = [];
  late int _selectItem;
  late TaskCardEntity entity;

  TextEditingController _titleEditController = TextEditingController();
  TextEditingController _limitEditController = TextEditingController();
  TextEditingController _priorityEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setItems();
    _selectItem = _items[0].value!;
    _priorityEditController.text = "1";
    Future<List<TaskCardEntity>> list = DBProvider().selectAll();
    list.asStream().forEach((entities) {
      for (entity in entities) {
        TaskCard card = TaskCard(entity);
        _tasks.add(card);
      }
      _tasks.sort(comparator);
      setState(() {});
    });
  }

  void setItems() {
    _items
      ..add(DropdownMenuItem(
        child: Text(
          '超高',
        ),
        value: 1,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          '高',
        ),
        value: 2,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          '中',
        ),
        value: 3,
      ))
      ..add(DropdownMenuItem(
        child: Text(
          '低',
        ),
        value: 4,
      ));
  }

  Comparator<TaskCard> comparator = (a, b) =>
      a.limitDate.compareTo(b.limitDate) == 0
          ? a.priority.compareTo(b.priority)
          : a.limitDate.compareTo(b.limitDate);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
        backgroundColor: Colors.grey,
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return Slidable(
            actionPane: SlidableScrollActionPane(),
            actions: <Widget>[
              IconSlideAction(
                caption: 'Done',
                color: Colors.green,
                icon: Icons.check,
                onTap: () => {
                  DBProvider().deleteTaskCardById(_tasks[index].id),
                  _tasks.removeAt(index),
                  setState(() {}),
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => {
                  DBProvider().deleteTaskCardById(_tasks[index].id),
                  _tasks.removeAt(index),
                  setState(() {}),
                },
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
                onTap: () => {
                  DBProvider().deleteTaskCardById(_tasks[index].id),
                  _tasks.removeAt(index),
                  setState(() {}),
                },
              ),
              IconSlideAction(
                caption: 'Delete',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => {
                  DBProvider().deleteTaskCardById(_tasks[index].id),
                  _tasks.removeAt(index),
                  setState(() {}),
                },
              ),
              IconSlideAction(
                caption: 'Close',
                color: Colors.grey,
                icon: Icons.close,
                onTap: () => {},
              ),
            ],
            actionExtentRatio: 1 / 6,
            child: Container(child: _tasks[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTasK,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTasK() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Column(
            children: <Widget>[
              AlertDialog(
                title: Text("ダイアログ"),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      TextField(
                        decoration: InputDecoration(
                            hintText: "タイトル", labelText: 'タイトル'),
                        maxLength: 20,
                        controller: _titleEditController,
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: "yyyy/mm/dd",
                          labelText: '期限',
                        ),
                        controller: _limitEditController,
                        onTap: () => _selectDate(context),
                        readOnly: true,
                      ),
                      DropdownButton(
                          items: _items,
                          value: _selectItem,
                          onChanged: (value) {
                            setState(() {
                              _selectItem = int.parse(value.toString());
                              _priorityEditController.text =
                                  _selectItem.toString();
                            });
                          }),
                    ],
                  ),
                ),
                actions: <Widget>[
                  // ボタン領域
                  TextButton(
                    child: Text("Cancel"),
                    onPressed: onPressedCancel,
                  ),
                  TextButton(
                    child: Text("OK"),
                    onPressed: onPressedOk,
                  ),
                ],
              ),
            ],
          );
        });
      },
    );
  }

  void onPressedCancel() {
    setState(() {
      _titleEditController.text = '';
      _limitEditController.text = '';
      _priorityEditController.text = '';
      _selectItem = _items[0].value!;
    });
    Navigator.pop(context);
  }

  void onPressedOk() {
    if (_titleEditController.text.isNotEmpty &&
        _limitEditController.text.isNotEmpty &&
        _priorityEditController.text.isNotEmpty) {
      entity = TaskCardEntity(
          id: 0,
          taskName: _titleEditController.text,
          limitDate: _limitEditController.text,
          priority: _priorityEditController.text);
      DBProvider().insertTaskCard(entity).then((val) {
        entity.id = val;
        _tasks.add(TaskCard(entity));
        setState(() {
          _titleEditController.text = '';
          _limitEditController.text = '';
          _priorityEditController.text = '';
          _selectItem = _items[0].value!;
        });
        _tasks.sort(comparator);
        Navigator.pop(context);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2099),
    );

    if (selected != null) {
      setState(() {
        _limitText = selected.year.toString() +
            "/" +
            zeroPadding(selected.month.toString()) +
            "/" +
            zeroPadding(selected.day.toString());
        _limitEditController.text = _limitText;
      });
    }
  }

  String zeroPadding(String str) {
    return str.length == 1 ? "0" + str : str;
  }
}
