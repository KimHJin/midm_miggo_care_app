import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:miggo_care/main.dart';

import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'package:miggo_care/settings_page/components/rounded_button.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

class NotificationManager {
  NotificationManager._();

  static init() async {
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('mipmap/ic_launcher');

    InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static tz.TZDateTime makeDate(hour, min, sec) {
    tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime when = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        hour,
        min,
        sec);
    if (when.isBefore(now)) {
      return when.add(const Duration(days: 1));
    } else {
      return when;
    }
  }

  static Future<void> showNotification(int id, String period, int hour, int minute, List<int> dayOfWeek, String body) async{
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Seoul'));

    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'ch_ID',
      'noti',
      priority: Priority.high,
      importance: Importance.max,
    );

    for(int day in dayOfWeek) {
      tz.TZDateTime now = tz.TZDateTime.now(tz.local);
      int nextDay = now.weekday <= day ? day : day+7;

      tz.TZDateTime when = tz.TZDateTime(tz.local, now.year, now.month, now.day + nextDay - now.weekday, (period == '오후' && hour<12) ? hour+12 : hour, minute, 00);

      print(when);

      flutterLocalNotificationsPlugin.zonedSchedule(
        id+(1000*day),
        '미꼬케어 알림',
        body,
        when,
        NotificationDetails(android: androidNotificationDetails),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    }
  }

}


class AlarmInfo {
  int? id;
  final int hour;
  final int minute;
  final String period;
  final List<int> daysOfWeek;
  final String body;
  final bool isEnabled;

  AlarmInfo({
    this.id,
    required this.hour,
    required this.minute,
    required this.period,
    required this.daysOfWeek,
    required this.body,
    required this.isEnabled,
  });

  Map<String, dynamic> toMap() {
    return {
      'hour': hour,
      'minute': minute,
      'period': period,
      'dayOfWeek': daysOfWeek.join(','),
      'body': body,
      'isEnabled': isEnabled ? 1 : 0,
    };
  }

  static AlarmInfo fromMap(Map<String, dynamic> map) {
    return AlarmInfo(
      id: map['id'],
      hour: map['hour'],
      minute: map['minute'],
      period: map['period'],
      daysOfWeek: (map['dayOfWeek'].toString()).split(',').map(int.parse).toList(),
      body: map['body'],
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
          body TEXT,
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
  }
}


class AlarmPage extends StatefulWidget {
  const AlarmPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<AlarmPage> createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {

  int? id;

  List<AlarmInfo> alarmList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    id = widget.id;
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

  bool isSwitched = false;
  List<String> weekdays = ['', '월', '화', '수', '목', '금', '토', '일'];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if(id == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Main(pageIndex: 0,)),
          );
        } else if(id == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Main(pageIndex: 4,)),
          );
        }
        return true;
      },
      child: Scaffold(
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
                onTap: () {
                  /*
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => EditAlarmPage(function: loadAlarmInfo, alarm: alarmList[index],)),
                  );*/
                },
                onLongPress: () async {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('알림 삭제'),
                          content: const Text('알림을 삭제하시겠습니까?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('취소'),
                            ),
                            TextButton(
                              onPressed: () async {
                                print(alarmList[index].id!);
                                for(int day in alarmList[index].daysOfWeek) {
                                  await flutterLocalNotificationsPlugin.cancel(alarmList[index].id! + (1000*day));
                                }
                                setState(() {
                                  AlarmInfo.deleteAlarmInfo(alarmList[index].id!);
                                  loadAlarmInfo();
                                  Navigator.pop(context);
                                });
                              },
                              child: const Text('삭제', style: TextStyle(color: Colors.red),),
                            ),
                          ],
                        );
                      }
                  );
                },
                title: Text('${alarmList[index].hour}:${alarmList[index].minute.toString().padLeft(2, '0')}', style: const TextStyle(fontSize: 30.0),),
                leading: Text(alarmList[index].period),
                subtitle: Text(alarmList[index].daysOfWeek.map((number) => weekdays[number]).join(', '), style: const TextStyle(color: Colors.blue),),
                trailing: Text(alarmList[index].body),
              ),
            );
          }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SetAlarmPage(function: loadAlarmInfo,)),
            );
          },
          backgroundColor: const Color.fromRGBO(59, 130, 197, 1.0),
          child: const Icon(Icons.add),
        ),

      ),
    );
  }
}


class SetAlarmPage extends StatefulWidget {
  const SetAlarmPage({Key? key, required this.function}) : super(key: key);

  final Function() function;

  @override
  State<SetAlarmPage> createState() => _SetAlarmPageState();
}

class _SetAlarmPageState extends State<SetAlarmPage> {

  Function()? func;

  String? hour = '1';
  String? minute = '00';
  String? period = '오전';
  String week = '';

  final List<String> _periods = ["오전", "오후"];
  final List<bool> _selectedDays = [false, false, false, false, false, false, false];
  final List<String> _daysOfWeek = ['월', '화', '수', '목', '금', '토', '일'];

  String? result;

  bool isSelectedWeek = false;
  bool isButtonEnabled = false;

  TextEditingController bodyController = TextEditingController();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  void updateButtonState() {
    setState(() {
      isButtonEnabled = bodyController.text.isNotEmpty && isSelectedWeek;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    func = widget.function;
    NotificationManager.init();
    bodyController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    bodyController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30.0,),
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

                      isButtonEnabled = bodyController.text.isNotEmpty && isSelectedWeek;
                    });
                  },
                  children: _daysOfWeek.map((day) => Text(day)).toList(),
                ),
              ),
              const SizedBox(height: 20.0,),
              Text(isSelectedWeek ? '매주 $week $period $hour:$minute' : '요일을 선택해주세요.', style: const TextStyle(fontSize: 18.0),),
              const SizedBox(height: 10.0,),
              SizedBox(
                height: 60.0,
                child: TextField(
                  controller: bodyController,
                  decoration: const InputDecoration(
                    labelText: '내용',
                  ),
                ),
              ),
              const SizedBox(height: 15.0,),
              RoundedButton(
                textColor: Colors.white,
                text: '저장',
                press: isButtonEnabled == false ? null :
                () async {
                  List<int> alarmWeek = [];
                  for(int i=0; i<7; i++) {
                    if(_selectedDays[i] == true) {
                      alarmWeek.add(i+1);
                    }
                  }
                  String body = bodyController.text;

                  AlarmInfo alarm = AlarmInfo(hour: int.parse(hour!), minute: int.parse(minute!), period: period!, daysOfWeek: alarmWeek, body: body, isEnabled: true);
                  AlarmInfo.insertAlarmInfo(alarm);

                  List<AlarmInfo> alarmList;
                  await AlarmInfo.getAlarmInfo().then((value) {
                    alarmList = value;
                    print(alarmList[alarmList.length-1].id!);
                    NotificationManager.showNotification(alarmList[alarmList.length-1].id!, period!, int.parse(hour!), int.parse(minute!), alarmWeek, body);
                    func!();
                    Navigator.pop(context);
                  });
                },
              ),
              const SizedBox(height: 10.0,),
            ],
          ),
        ),
      ),
    );
  }
}

