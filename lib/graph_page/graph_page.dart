import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miggo_care/graph_page/update_page.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


import '../BloodPressure/BloodPressure.dart';
import '../bluetooth/ble_device.dart';
import 'components/rounded_toggle_button.dart';
import 'components/average_banner.dart';
import 'components/date_banner.dart';

class GraphPage extends StatefulWidget {
  const GraphPage({Key? key, required this.bleDevice,}) : super(key: key);

  final BleDevice bleDevice;

  @override
  State<GraphPage> createState() => _GraphPageState();
}

class _GraphPageState extends State<GraphPage> {

  final List<bool> _selectTime = <bool>[true, false, false];
  late final BleDevice bleDevice;

  DateTime currentDate = DateTime.now();
  DateTime targetDate = DateTime.now();
  String dateString = DateFormat('yyyy년 MM월 dd일').format(DateTime.now());

  int toggleSelectIndex = 0;

  List<BloodPressure> bloodList= [];

  String avgSys = '00';
  String avgDia = '00';
  String avgPulse = '00';


  late ChartAxis _currentAxis;

  ChartAxis _yearAxis() {
    return DateTimeAxis(
      interval: 1,
      visibleMinimum: DateTime(targetDate.year, 1),
      visibleMaximum: DateTime(targetDate.year, 12),
      intervalType: DateTimeIntervalType.months,
      dateFormat: DateFormat('M월'),
      minimum: DateTime(targetDate.year, 1),
      maximum: DateTime(targetDate.year, 12),
    );
  }

  ChartAxis _monthAxis() {
    return DateTimeAxis(
      interval: 1,

      visibleMinimum: DateTime(targetDate.year, targetDate.month, 1),
      visibleMaximum: DateTime(targetDate.year, targetDate.month, 25),

      intervalType: DateTimeIntervalType.days,
      dateFormat: DateFormat('d일'),
      minimum: DateTime(targetDate.year, targetDate.month, 1),
      maximum: DateTime(targetDate.year, targetDate.month+1, 0),
    );
  }

  ChartAxis _dayAxis() {
    return DateTimeAxis(
      interval: 6,
      visibleMinimum: DateTime(targetDate.year, targetDate.month, targetDate.day, 0, 0, 1),
      visibleMaximum: DateTime(targetDate.year, targetDate.month, targetDate.day, 24, 00, 00),
      intervalType: DateTimeIntervalType.hours,
      dateFormat: DateFormat('hh:mm'),
      minimum: DateTime(targetDate.year, targetDate.month, targetDate.day, 0, 0, 1),
      maximum: DateTime(targetDate.year, targetDate.month, targetDate.day, 24, 00, 00),

    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bleDevice = widget.bleDevice;
    _currentAxis = _dayAxis();
    getBloodListByDay().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> getBloodListByDay() async {
    await BloodPressure.getBloodPressuresByDay(targetDate.year, targetDate.month, targetDate.day).then((value) {
      bloodList = value;
      if(bloodList.isEmpty) {
        avgSys = '00';
        avgDia = '00';
        avgPulse = '00';
      } else {
        int sumSys = 0;
        int sumDia = 0;
        int sumPulse = 0;
        for (var element in bloodList) {
          sumSys += element.systolic;
          sumDia += element.diastolic;
          sumPulse += element.pulse;
        }
        avgSys = (sumSys ~/ bloodList.length).toString();
        avgDia = (sumDia ~/ bloodList.length).toString();
        avgPulse = (sumPulse ~/ bloodList.length).toString();
      }
    });
  }

  Future<void> getBloodListByMonth() async {
    await BloodPressure.getBloodPressuresByMonth(targetDate.year, targetDate.month).then((value) {
      bloodList = value;
      if(bloodList.isEmpty) {
        avgSys = '00';
        avgDia = '00';
        avgPulse = '00';
      } else {
        int sumSys = 0;
        int sumDia = 0;
        int sumPulse = 0;
        for (var element in bloodList) {
          sumSys += element.systolic;
          sumDia += element.diastolic;
          sumPulse += element.pulse;
        }
        avgSys = (sumSys ~/ bloodList.length).toString();
        avgDia = (sumDia ~/ bloodList.length).toString();
        avgPulse = (sumPulse ~/ bloodList.length).toString();
      }
    });
  }

  Future<void> getBloodListByYear() async {
    await BloodPressure.getBloodPressuresByYear(targetDate.year).then((value) {
      bloodList = value;
      if(bloodList.isEmpty) {
        avgSys = '00';
        avgDia = '00';
        avgPulse = '00';
      } else {
        int sumSys = 0;
        int sumDia = 0;
        int sumPulse = 0;
        for (var element in bloodList) {
          sumSys += element.systolic;
          sumDia += element.diastolic;
          sumPulse += element.pulse;
        }
        avgSys = (sumSys ~/ bloodList.length).toString();
        avgDia = (sumDia ~/ bloodList.length).toString();
        avgPulse = (sumPulse ~/ bloodList.length).toString();
      }
    });
  }

  void _incrementDate(int index) {
    if(index == 0) {
      if(!(currentDate.year == targetDate.year && currentDate.month == targetDate.month && currentDate.day == targetDate.day)) {
        targetDate = targetDate.add(const Duration(days: 1));
      }
      dateString = DateFormat('yyyy년 MM월 dd일').format(targetDate);
      _currentAxis = _dayAxis();
      getBloodListByDay().then((value) {
        return;
      });
    } else if(index == 1) {
      if(!(currentDate.year == targetDate.year && currentDate.month == targetDate.month)) {
        targetDate = DateTime(targetDate.year, targetDate.month+1);
      }
      dateString = DateFormat('yyyy년 MM월').format(targetDate);
      _currentAxis = _monthAxis();
      getBloodListByMonth().then((value) {
        return;
      });
    } else if(index == 2) {
      if(!(currentDate.year == targetDate.year)) {
        targetDate = DateTime(targetDate.year+1);
      }
      dateString = DateFormat('yyyy년').format(targetDate);
      _currentAxis = _yearAxis();
      getBloodListByYear().then((value) {
        return;
      });
    }
  }

  void _decrementDate(int index) {
    if(index == 0) {
      targetDate = targetDate.subtract(const Duration(days: 1));
      dateString = DateFormat('yyyy년 MM월 dd일').format(targetDate);
      _currentAxis = _dayAxis();

    } else if(index == 1) {
      targetDate = DateTime(targetDate.year, targetDate.month-1);
      dateString = DateFormat('yyyy년 MM월').format(targetDate);
      _currentAxis = _monthAxis();
      getBloodListByMonth().then((value) {
        return;
      });
    } else if(index == 2) {
      targetDate = DateTime(targetDate.year-1);
      dateString = DateFormat('yyyy년').format(targetDate);
      _currentAxis = _yearAxis();
      getBloodListByYear().then((value) {
        return;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text("혈압 노트", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
        actions: [
          IconButton(
            icon: const Icon(Icons.install_mobile, color: Colors.blue,),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdatePage(bleDevice: bleDevice,)),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 10.0,),
          RoundedToggleButton(
            selectTime: _selectTime,
            onPressed: (int index){
              setState(() {
                for(int i=0; i<_selectTime.length; i++) {
                  _selectTime[i] = (i==index);
                }
                toggleSelectIndex = index;
                targetDate = DateTime.now();
                if(index == 0) {
                  dateString = DateFormat('yyyy년 MM월 dd일').format(targetDate);
                  _currentAxis = _dayAxis();
                  getBloodListByDay().then((value) {
                    setState(() {});
                  });
                } else if(index == 1) {
                  dateString = DateFormat('yyyy년 MM월').format(targetDate);
                  _currentAxis = _monthAxis();
                  getBloodListByMonth().then((value) {
                    setState(() {});
                  });
                } else if(index == 2) {
                  dateString = DateFormat('yyyy년').format(targetDate);
                  _currentAxis = _yearAxis();
                  getBloodListByYear().then((value) {
                    setState(() {});
                  });
                }
              });
            },
          ),
          DateBanner(
            dateStr: dateString,
            onPressedLeft: () {
              _decrementDate(toggleSelectIndex);
              if(toggleSelectIndex == 0) {
                getBloodListByDay().then((value) {
                  setState(() {});
                });
              } else if(toggleSelectIndex == 1) {
                getBloodListByMonth().then((value) {
                  setState(() {});
                });
              } else if(toggleSelectIndex == 2) {
                getBloodListByYear().then((value) {
                  setState(() {});
                });
              }
            },
            onPressedRight: () {
              _incrementDate(toggleSelectIndex);
              if(toggleSelectIndex == 0) {
                getBloodListByDay().then((value) {
                  setState(() {});
                });
              } else if(toggleSelectIndex == 1) {
                getBloodListByMonth().then((value) {
                  setState(() {});
                });
              } else if(toggleSelectIndex == 2) {
                getBloodListByYear().then((value) {
                  setState(() {});
                });
              }
            },
          ),
          Expanded(
            flex: 5,
            child: Container(
              child: SfCartesianChart(
                primaryXAxis: _currentAxis,
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 180,
                  interval: 20,
                ),
                axes: <ChartAxis>[
                  NumericAxis(
                    name: 'pulseAxis',
                    majorGridLines: const MajorGridLines(width: 0),
                    opposedPosition: true,
                    minimum: 40,
                    maximum: 200,
                    interval: 20,
                  )
                ],
                zoomPanBehavior: ZoomPanBehavior(
                  enablePanning: true,
                  zoomMode: ZoomMode.x,
                ),
                series: <ChartSeries>[
                  HiloSeries<BloodPressure, DateTime>(
                    dataSource: bloodList,
                    xValueMapper: (BloodPressure bp, _) => bp.measuredAt,
                    lowValueMapper: (BloodPressure bp, _) => bp.diastolic,
                    highValueMapper: (BloodPressure bp, _) => bp.systolic,
                  ),
                  LineSeries<BloodPressure, DateTime>(
                    dataSource: bloodList,
                    xValueMapper: (BloodPressure bp, _) => bp.measuredAt,
                    yValueMapper: (BloodPressure bp, _) => bp.pulse == 0 ? null : bp.pulse,
                    yAxisName: 'pulseAxis',
                    markerSettings: const MarkerSettings(
                        isVisible: true,
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex:1,
            child: AverageBanner(averageBloodPressure: '$avgSys/$avgDia', averagePulse: avgPulse,),
          ),
        ],
      ),
    );
  }
}

class BloodPressureData {
  BloodPressureData(this.time, this.sys, this.dia, this.pulse);
  final DateTime time;
  final double? sys;
  final double? dia;
  final double? pulse;
}

