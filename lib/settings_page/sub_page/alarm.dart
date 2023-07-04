import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:miggo_care/settings_page/components/rounded_button.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class AlarmInfo {
  int? id;
  final int hour;
  final int minute;
  final String period;
  final List<int> daysOfWeek;
  final bool isEnabled;

  AlarmInfo({
    this.id,
    required this.hour,
    required this.minute,
    required this.period,
    required this.daysOfWeek,
    required this.isEnabled,
  });

  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minute': minute,
      'period': period,
      'dayOfWeek': daysOfWeek.join(','),
      'isEnabled': isEnabled ? 1 : 0,
    };
  }

  static AlarmInfo fromMap(Map<String, dynamic> map) {
    return AlarmInfo(
      id: map['id'],
      hour: map['hour'],
      minute: map['minute'],
      period: map['period'],
      daysOfWeek: (map['dayOfWeek'] as String).split(',').map(int.parse).toList(),
      isEnabled: map['isEnabled'] == 1,
    );
  }

  static Future<Database> openDb() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'alarm.db'),
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute('''
        CREATE TABLE alarm (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          hour INTEGER NOT NULL,
          minute INTEGER NOT NULL,
          period TEXT,
          dayOfWeek INTEGER NOT NULL,
          isEnabled INTEGER NOT NULL
        )
      ''');
      },
    );
  }

  static Future<void> insertAlarmInfo(AlarmInfo alarmInfo) async {
    final db = await openDb();

    await db.insert(
      'alarm',
      alarmInfo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<List<AlarmInfo>> getAlarmInfo() async {
    final db = await openDb();

    final List<Map<String, dynamic>> maps = await db.query('alarm');

    return List.generate(maps.length, (i) {
      return AlarmInfo.fromMap(maps[i]);
    });
  }

  static Future<void> deleteAlarmInfo(int id) async {
    final db = await openDb();

    await db.delete(
      'alarm',
      where: 'id = ?',
      whereArgs: [id],
    );

    // 삭제 후 아이디 재정렬
    final List<Map<String, dynamic>> maps = await db.query('alarm');
    final List<AlarmInfo> alarmInfos =
    List.generate(maps.length, (i) => AlarmInfo.fromMap(maps[i]));

    for (int i = 0; i < alarmInfos.length; i++) {
      await db.update(
        'alarm',
        {'id': i + 1},
        where: 'id = ?',
        whereArgs: [alarmInfos[i].id],
      );
    }
  }
}


class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key}) : super(key: key);

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  List<AlarmInfo> alarmList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initNotification();
    loadAlarmInfo();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> loadAlarmInfo() async {
    AlarmInfo.getAlarmInfo().then((value) {
      setState(() {
        alarmList = value;
      });
    });
  }

  initNotification() async {
    AndroidInitializationSettings androidSetting = AndroidInitializationSettings('mipmap/ic_launcher');


    InitializationSettings initializationSettings = InitializationSettings(
        android: androidSetting,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      //알림 누를때 함수실행하고 싶으면
      //onSelectNotification: 함수명추가
    );
  }

  Future<void> showNotification() async {
    const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'channel_id',
      'channel name',
      priority: Priority.high,
      importance: Importance.max,
      showWhen: false,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      0, 'title', 'body', notificationDetails, payload: 'item x',
    );
  }

  bool isSwitched = false;
  List<String> weekdays = ['', '월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text("알림설정", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: alarmList.length,
        itemBuilder: (BuildContext context, index) {
          return Card(
            child: ListTile(
              onTap: () {},
              onLongPress: () {
                setState(() {
                  AlarmInfo.deleteAlarmInfo(index+1);
                  loadAlarmInfo();
                });
              },
              title: Text('${alarmList[index].hour}:${alarmList[index].minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 30.0),),
              leading: Text(alarmList[index].period),
              subtitle: Text(alarmList[index].daysOfWeek.map((number) => weekdays[number]).join(', '), style: const TextStyle(color: Colors.blue),),
              /*
              trailing: Switch(
                value: isSwitched,
                onChanged: (value) {
                  setState(() {
                    isSwitched = value;
                  });
                },
              ),*/
            ),
          );
        }
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const SetAlarmPage()),
          );
        },
        backgroundColor: const Color.fromRGBO(59, 130, 197, 1.0),
        child: const Icon(Icons.add),
      ),

    );
  }
}


class SetAlarmPage extends StatefulWidget {
  const SetAlarmPage({Key? key}) : super(key: key);

  @override
  State<SetAlarmPage> createState() => _SetAlarmPageState();
}

class _SetAlarmPageState extends State<SetAlarmPage> {

  String? hour = '1';
  String? minute = '00';
  String? period = '오전';
  String week = '';

  final List<String> _periods = ["오전", "오후"];
  final List<bool> _selectedDays = [false, false, false, false, false, false, false];
  final List<String> _daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];

  String? result;

  bool isSelectedWeek = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50.0,),
            const Text('알림', style: TextStyle(fontSize: 25.0),),
            const SizedBox(height: 20.0,),
            Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                border: Border.all(color: Colors.grey, width: 0.5),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          period = _periods[index];
                        });
                      },
                      children: List<Widget>.generate(_periods.length, (index) {
                        return Center(child: Text(_periods[index]));
                      }),
                    ),
                  ),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          hour = (index+1).toString();
                        });
                      },
                      children: List<Widget>.generate(12, (index) {
                        return Center(child: Text((index+1).toString()),);
                      }),
                    ),
                  ),
                  const Text(':'),
                  Expanded(
                    child: CupertinoPicker(
                      itemExtent: 40,
                      onSelectedItemChanged: (index) {
                        setState(() {
                          minute = index.toString().padLeft(2,'0');
                        });
                      },
                      children: List<Widget>.generate(60, (index) {
                        return Center(child: Text(index.toString().padLeft(2,'0')));
                      }),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20.0,),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white, // 배경색 설정
              ),
              child: ToggleButtons(
                constraints: BoxConstraints(
                  minHeight: 50.0,
                  minWidth: (MediaQuery.of(context).size.width - 28)/7,
                ),
                isSelected: _selectedDays,
                onPressed: (index) {
                  setState(() {
                    _selectedDays[index] = !_selectedDays[index];
                    week = '';
                    for(int i=0; i<7; i++) {
                      if(_selectedDays[i] == true) {
                        week = week + _daysOfWeek[i];
                      }
                    }
                    if(_selectedDays[0] || _selectedDays[1] || _selectedDays[2] || _selectedDays[3] || _selectedDays[4] || _selectedDays[5] || _selectedDays[6]) {
                      isSelectedWeek = true;
                    } else {
                      isSelectedWeek = false;
                    }
                  });
                },
                children: _daysOfWeek.map((day) => Text(day)).toList(),
              ),
            ),
            const SizedBox(height: 20.0,),
            Text(isSelectedWeek ? '매주 $week $period $hour:$minute' : '요일을 선택해주세요.', style: TextStyle(fontSize: 20.0),),
            const Spacer(),
            RoundedButton(
              textColor: Colors.white,
              text: '저장',
              press: isSelectedWeek == false ? null :
              () {
                List<int> alarmWeek = [];
                for(int i=0; i<7; i++) {
                  if(_selectedDays[i] == true) {
                    alarmWeek.add(i+1);
                  }
                }
                AlarmInfo alarm = AlarmInfo(hour: int.parse(hour!), minute: int.parse(minute!), period: period!, daysOfWeek: alarmWeek, isEnabled: true);
                AlarmInfo.insertAlarmInfo(alarm);

                Navigator.pop(context);
                //Navigator.popUntil(context, ModalRoute.withName('/AlarmPage'));
              },
            ),
            const SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }
}

