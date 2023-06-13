import 'package:flutter/material.dart';
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
  List<BloodPressure> bloodList= [];
  int toggleSelectIndex = 0;
  int itemCount = 5;

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

  Future<void> getBloodPressureList() async {
    await BloodPressure.getBloodPressures().then((value) {
      bloodList = value;
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
      body: Column(
        children: [
          const SizedBox(height: 10.0,),
          RoundedToggleButton(
            select: _select,
            children: const [
              Text('달력'),
              Text('기록표'),
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
          Expanded(

            child: (toggleSelectIndex == 0) ? TableCalendar(
              firstDay: DateTime.utc(2010, 10, 16),
              lastDay: DateTime.utc(2030, 3, 14),
              focusedDay: DateTime.now(),
            ) : ListView.separated(
              itemCount: itemCount,
              itemBuilder: (BuildContext context, int index) {
                return const BloodListTile(
                  sys: '130',
                  dia: '100',
                  pulse: '60',
                  date: '2023-05-23',
                  time: '13:55',
                );
              },
              separatorBuilder: (BuildContext context, int index) => const Divider(),
            ),
          ),
        ],
      ),
    );
  }
}

