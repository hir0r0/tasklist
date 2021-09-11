import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:tasklist/db_provider.dart';
import 'package:tasklist/task_card_entity.dart';
import 'task_card.dart';

import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage() : super();

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TaskCard> _tasks = <TaskCard>[];
  List<DropdownMenuItem<int>> _items = [];
  late int _selectItem;
  int _taskId = 0;

  TextEditingController _titleEditController = TextEditingController();
  TextEditingController _limitEditController = TextEditingController();
  TextEditingController _priorityEditController = TextEditingController();

  // 通知用プラグイン
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    _initializePlatformSpecifics();

    setItems();
    _selectItem = _items[0].value!;
    _priorityEditController.text = "1";
    // Future<List<TaskCardEntity>> list = DBProvider().selectAll();
    // list.asStream().forEach((entities) {
    //   for (TaskCardEntity entity in entities) {
    //     TaskCard card = TaskCard(entity);
    //     _tasks.add(card);
    //   }
    //   _tasks.sort(comparator);
    //   setState(() {});
    // });
    DBProvider().selectAll().then(
      (list) {
        list.forEach(
          (entity) {
            setState(
              () {
                TaskCard card = TaskCard(entity);
                _tasks.add(card);
                _tasks.sort(comparator);
              },
            );
          },
        );
      },
    );
  }

  void _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()!
        .requestPermissions(
          alert: false,
          badge: true,
          sound: false,
        );
  }

  void _initializePlatformSpecifics() {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    var initializationSettingsIOS = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
      onDidReceiveLocalNotification: (id, title, body, payload) async {
        // your call back to the UI
      },
    );

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      //onNotificationClick(payload); // your call back to the UI
    });
  }

  Future<void> _scheduleNotification(int _id, String _date, int _cnt) async {
    var locale = tz.getLocation('Asia/Tokyo');
    tz.setLocalLocation(locale);
    var _dates = _date.split("/");
    var tzDatetime = tz.TZDateTime(locale, int.parse(_dates[0]),
        int.parse(_dates[1]), int.parse(_dates[2]), 9, 0);
    var scheduleNotificationDateTime = tz.TZDateTime.from(tzDatetime, locale);
    // tz.TZDateTime.parse(tz.getLocation('Asia/Tokyo'), _date);
    var androidChannelSpecifics = AndroidNotificationDetails(
      'CHANNEL_ID 1',
      'CHANNEL_NAME 1',
      "CHANNEL_DESCRIPTION 1",
      icon: 'app_icon',
      //sound: RawResourceAndroidNotificationSound('my_sound'),
      largeIcon: DrawableResourceAndroidBitmap('app_icon'),
      enableLights: true,
      color: const Color.fromARGB(255, 255, 0, 0),
      ledColor: const Color.fromARGB(255, 255, 0, 0),
      ledOnMs: 1000,
      ledOffMs: 500,
      importance: Importance.max,
      priority: Priority.high,
      playSound: false,
      timeoutAfter: 5000,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iosChannelSpecifics = IOSNotificationDetails(
        //sound: 'my_sound.aiff',
        );
    var platformChannelSpecifics = NotificationDetails(
      android: androidChannelSpecifics,
      iOS: iosChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(
      _id,
      '未完了タスク通知:' + _id.toString(),
      _cnt.toString() + '件のタスクがあります。',
      scheduleNotificationDateTime,
      platformChannelSpecifics,
      payload: 'Test Payload',
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
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
      endDrawer: Drawer(
        child: ListView(
          children: <Widget>[
            ListTile(
              title: Text("設定"),
              trailing: Icon(Icons.settings),
              onTap: () {},
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
              key: UniqueKey(), //Key(_tasks[index].id.toString()),
              child: ListTile(
                  minVerticalPadding: 1.5,
                  title: _tasks[index],
                  onTap: () {
                    _editTask(_tasks[index]);
                  }),
              onDismissed: (direction) {
                DBProvider().deleteTaskCardById(_tasks[index].id);
                setState(() {
                  _tasks.removeAt(index);
                });
              });
          /* Slidable Widget  
          Slidable(
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
            ),
          ); */
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
        tooltip: 'Add Task',
        child: Icon(Icons.add),
      ),
    );
  }

  void _editTask(TaskCard target) {
    _titleEditController.text = target.taskName;
    _limitEditController.text = target.limitDate;
    _selectItem = int.parse(target.priority);
    _taskId = target.id;
    _addTask();
  }

  void _addTask() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                          hint: Text("優先度"),
                          items: _items,
                          value: _selectItem,
                          onChanged: (value) {
                            setState(
                              () {
                                _selectItem = int.parse(value.toString());
                                _priorityEditController.text =
                                    _selectItem.toString();
                              },
                            );
                          },
                        ),
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
          },
        );
      },
    );
  }

  void onPressedCancel() {
    setState(
      () {
        _titleEditController.text = '';
        _limitEditController.text = '';
        _selectItem = _items[0].value!;
        _priorityEditController.text = _selectItem.toString();
        _taskId = 0;
      },
    );
    Navigator.pop(context);
  }

  void onPressedOk() {
    if (_titleEditController.text.isNotEmpty &&
        _limitEditController.text.isNotEmpty &&
        _priorityEditController.text.isNotEmpty) {
      TaskCardEntity entity = TaskCardEntity(
          id: _taskId != 0 ? _taskId : 0,
          taskName: _titleEditController.text,
          limitDate: _limitEditController.text,
          priority: _priorityEditController.text);
      if (entity.id == 0) {
        DBProvider().insertTaskCard(entity).then(
          (val) {
            entity.id = val;
            _tasks.add(TaskCard(entity));
            setState(() {
              _titleEditController.text = '';
              _limitEditController.text = '';
              _selectItem = _items[0].value!;
              _priorityEditController.text = _selectItem.toString();
              _taskId = 0;
            });
            _tasks.sort(comparator);
            Navigator.pop(context);
          },
        );
      } else {
        DBProvider().updateTaskCard(entity).then(
          (val) {
            setState(() {
              _titleEditController.text = '';
              _limitEditController.text = '';
              _selectItem = _items[0].value!;
              _priorityEditController.text = _selectItem.toString();
              _taskId = 0;
              replace(TaskCard(entity));
            });
            _tasks.sort(comparator);
            Navigator.pop(context);
          },
        );
      }
    }
  }

  void replace(TaskCard target) {
    for (TaskCard card in _tasks) {
      if (card.id == target.id) {
        card.taskName = target.taskName;
        card.limitDate = target.limitDate;
        card.priority = target.priority;
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _limitEditController.text == ''
          ? DateTime.now()
          : DateFormat('yyyy/MM/dd').parse(_limitEditController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2099),
    );

    if (selected != null) {
      setState(() {
        String _limitText = selected.year.toString() +
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
