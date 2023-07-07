import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:miggo_care/_BloodPressure/BloodPressure.dart';
import 'package:miggo_care/log_page/components/blood_list_tile.dart';
import 'package:miggo_care/log_page/components/rounded_toggle_button.dart';

class MyLogPage extends StatefulWidget {
  const MyLogPage({Key? key}) : super(key: key);

  @override
  State<MyLogPage> createState() => _MyLogPageState();
}

class _MyLogPageState extends State<MyLogPage> {

  final List<bool> _select = <bool>[true, false];
  List<BloodPressure> bloodList = [];
  List<BloodPressure> selectList = [];
  int toggleSelectIndex = 0;
  int itemCount = 5;
  DateTime? _selectDay;
  DateTime? _focusedDay = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadBloodPressure();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> loadBloodPressure() async {
    BloodPressure.getBloodPressures().then((value) {
      setState(() {
        bloodList = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text("혈압 노트", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 10.0,),
            RoundedToggleButton(
              select: _select,
              children: const [
                Text('기록표'),
                Text('달력'),
              ],
              onPressed: (int index) {
                setState(() {
                  for(int i=0; i<_select.length; i++) {
                    _select[i] = (i==index);
                  }
                  toggleSelectIndex = index;
                  if(index == 0) {

                  } else if(index == 1) {

                  }
                });
              },
            ),
            (toggleSelectIndex == 1) ?
            Expanded(
              child: Column(
                children: [
                  SizedBox(
                    height: 260,
                    child: TableCalendar(
                      locale: 'ko_KR',
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: _focusedDay!,

                      shouldFillViewport: true,
                      headerStyle: HeaderStyle(
                        titleCentered: true,
                        titleTextFormatter: (date, locale) => DateFormat.yMMMMd(locale).format(date),
                        formatButtonVisible: false,
                      ),
                      calendarStyle: const CalendarStyle(
                        weekendTextStyle: TextStyle(
                          fontSize: 11.0,
                        ),
                        outsideDaysVisible: false,
                        defaultTextStyle: TextStyle(
                          fontSize: 11.0,
                        ),
                        selectedDecoration: BoxDecoration(
                          color: Colors.blue, // 선택된 날짜 배경색 변경
                          shape: BoxShape.circle,
                        ),
                      ),
                      selectedDayPredicate: (day) => isSameDay(day, _selectDay),
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectDay = selectedDay;
                          _focusedDay = focusedDay;
                          selectList.clear();
                          for(BloodPressure bp in bloodList) {
                            if(bp.measuredAt.year == _selectDay!.year && bp.measuredAt.month == _selectDay!.month && bp.measuredAt.day == _selectDay!.day) {
                              selectList.add(bp);
                            }
                          }
                        });
                      },
                      calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, date, events) {
                          int lenght = 0;
                          for(BloodPressure bp in bloodList) {
                            if (isSameDay(date, bp.measuredAt)) {
                              lenght++;
                            }
                          }
                          if(lenght == 0) return null;
                          return Positioned(
                            bottom: 1,
                            right: 1,
                            child: Container(
                              height: 10.0,
                              width: 15.0,
                              decoration: BoxDecoration(
                                shape: BoxShape.rectangle,
                                color: Colors.blue.withOpacity(0.6),
                              ),
                              child: Center(
                                child: Text(
                                  lenght.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 7.0,
                                  ),
                                ),
                              ),
                            )
                          );
                        },
                        dowBuilder: (context, day) {
                          switch(day.weekday){
                            case 1:
                              return const Center(child: Text('월', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold)),);
                            case 2:
                              return const Center(child: Text('화', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold)),);
                            case 3:
                              return const Center(child: Text('수', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold)),);
                            case 4:
                              return const Center(child: Text('목', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold)),);
                            case 5:
                              return const Center(child: Text('금', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold)),);
                            case 6:
                              return const Center(child: Text('토', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold)),);
                            case 7:
                              return const Center(child: Text('일', style: TextStyle(fontSize: 11.0, fontWeight: FontWeight.bold),),);
                          }
                        },
                        selectedBuilder: (context, day, focusedDay) {
                          return Container(
                            width: 25.0,
                            height: 25.0,
                            decoration: const BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.rectangle,
                            ),
                            child: Center(child: Text(focusedDay.day.toString(), style: const TextStyle(color: Colors.white),)),
                          );
                        }
                      ),
                    ),
                  ),
                  const SizedBox(height: 5.0,),
                  const Divider(),
                  Expanded(
                    child: ListView.separated(
                      itemCount: selectList.length,
                      itemBuilder: (BuildContext context, int index) {
                        int sysValue = selectList[index].systolic;
                        int diaValue = selectList[index].diastolic;
                        Color bpColor;

                        if(sysValue >= 180 || diaValue >= 110) {
                          bpColor = const Color.fromRGBO(240, 0, 0, 0.7);
                        } else if(sysValue >= 160 || diaValue >= 100) {
                          bpColor = const Color.fromRGBO(255, 128, 0, 0.7);
                        } else if(sysValue >= 140 || diaValue >= 90) {
                          bpColor = const Color.fromRGBO(240, 240, 0, 0.7);
                        } else {
                          bpColor = Colors.transparent;
                        }
                        return Card(
                          child: SizedBox(
                            height: 50.0,
                            child: Row(
                             children: [
                               Container(height: 50.0, width: 5.0,color: bpColor,),
                               const SizedBox(width: 20.0,),
                               Text('${selectList[index].systolic.toString()} / ${selectList[index].diastolic.toString()}', style: const TextStyle(fontSize: 20.0),),
                               const SizedBox(width: 3.0,),
                               const Text('mmHg', style: TextStyle(fontSize: 10.0),),
                               const SizedBox(width: 15.0,),
                               Text(selectList[index].pulse.toString(), style: const TextStyle(fontSize: 20.0),),
                               const SizedBox(width: 3.0,),
                               const Text('bpm', style: TextStyle(fontSize: 10.0),),
                               const Spacer(),
                               Text(DateFormat('hh:mm').format(bloodList[index].measuredAt), style: const TextStyle(fontSize: 12.0),),
                               const SizedBox(width: 20.0,),
                             ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) => const Divider(),
                    ),
                  ),
                ],
              ),
            ) : Expanded(
              child: Column(
              children: [
                const Divider(color: Colors.black, thickness: 1.0,),
                const SizedBox(height: 10.0,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(child: Center(child: Text('번호', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),))),
                    Expanded(
                      child: Column(
                        children: [
                          Text('수축기', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),),
                          Text('( mmHg )', style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('이완기', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),),
                          Text('( mmHg )', style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text('맥박', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),),
                          Text('( bpm )', style: TextStyle(fontSize: 8.0, fontWeight: FontWeight.bold),),
                        ],
                      ),
                    ),
                    Expanded(child: Center(child: Text('날짜', style: TextStyle(fontSize: 12.0, fontWeight: FontWeight.bold),))),
                  ],
                ),
                const SizedBox(height: 10.0,),
                const Divider(color: Colors.black, thickness: 1.0,),
                Expanded(
                  child: ListView.separated(
                    itemCount: bloodList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return BloodListTile(
                        index: (index+1).toString(),
                        sys: bloodList[index].systolic.toString(),
                        dia: bloodList[index].diastolic.toString(),
                        pulse: bloodList[index].pulse.toString(),
                        date: DateFormat('yy/MM/dd').format(bloodList[index].measuredAt),
                        time: DateFormat('hh:mm').format(bloodList[index].measuredAt),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) => const Divider(),
                  ),
                ),
              ],
            ),
          ),
          ],
        ),
      ),
    );
  }
}

