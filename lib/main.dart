import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  List<Widget> _tasks = <Widget>[];
  int cnt = 0;
  String _limitText = '';
  List<DropdownMenuItem<int>> _items = [];
  var _selectItem = 1;

  TextEditingController _titleEditController = TextEditingController();
  TextEditingController _limitEditController = TextEditingController();
  TextEditingController _priorityEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    setItems();
    _selectItem = _items[0].value!;
    _priorityEditController.text = "1";
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: _tasks,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTasK,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }

  void _addTasK() {
    // _items.add(Divider());
    // TaskCard task =
    //     new TaskCard('タスク' + cnt.toString(), '2021/06/20', '00:00', 0);
    // _items.add(task);
    // cnt++;
    // setState(() {});
    showDialog(
      context: context,
      builder: (context) => Column(
        children: <Widget>[
          AlertDialog(
            title: Text("ダイアログ"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextField(
                    decoration:
                        InputDecoration(hintText: "タイトル", labelText: 'タイトル'),
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
                          _priorityEditController.text = _selectItem.toString();
                        });
                      }),
                ],
              ),
            ),
            actions: <Widget>[
              // ボタン領域
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("OK"),
                onPressed: () => {
                  if (!_titleEditController.text.isEmpty &&
                      !_limitEditController.text.isEmpty &&
                      !_priorityEditController.text.isEmpty)
                    {
                      _tasks.add(Divider()),
                      _tasks.add(TaskCard(
                          _titleEditController.text,
                          _limitEditController.text,
                          _priorityEditController.text)),
                      setState(() {
                        _titleEditController.text = '';
                        _limitEditController.text = '';
                        _priorityEditController.text = '';
                      }),
                      Navigator.pop(context),
                    }
                },
              ),
            ],
          ),
        ],
      ),
    );
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
            selected.month.toString() +
            "/" +
            selected.day.toString();
        _limitEditController.text = _limitText;
      });
    }
  }
}
