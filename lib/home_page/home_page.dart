import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:miggo_care/_BloodPressure/BloodPressure.dart';
import 'package:miggo_care/_UserInfo/UserInfo.dart';
import 'package:miggo_care/home_page/datasync_page.dart';
import 'package:miggo_care/main.dart';
import 'package:miggo_care/settings_page/sub_page/alarm.dart';

import 'components/rounded_button.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key,}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<AlarmInfo> alarmList = [];
  String? lastMeasure;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadAlarmInfo();
    loadUserInfo();
    loadBloodPressure();
    loadLastMeasure();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  String? avgSys;
  String? avgDia;
  String? avgPulse;

  Future<void> loadBloodPressure() async {
    BloodPressure.getAverageBloodPressure().then((value) {
      setState(() {
        avgSys = value['averageSystolic']!.toStringAsFixed(0);
        avgDia = value['averageDiastolic']!.toStringAsFixed(0);
        avgPulse = value['averagePulse']!.toStringAsFixed(0);
      });
    });
  }


  Future<void> loadAlarmInfo() async {
    AlarmInfo.getAlarmInfo().then((value) {
      setState(() {
        alarmList = value;
      });
    });
  }

  UserInfo? userInfo;
  String? name;
  String? age;
  String? birthdate;

  Future<void> loadUserInfo() async {
    UserPreferences.getUserInfo().then((value) {
      setState(() {
        userInfo = value;
        name = userInfo!.name;
        birthdate = DateFormat('yyyy년 MM월 dd일').format(userInfo!.birthdate);
        age = calculateAge(userInfo!.birthdate);
      });
    });
  }

  Future<void> loadLastMeasure() async {
    BloodPressure.getLatestMeasuredDate().then((value) {
      setState(() {
        if(value != null) {
          lastMeasure = DateFormat('yy/MM/dd hh:mm').format(value);
        } else {
          lastMeasure = null;
        }
      });
    });
  }

  String calculateAge(DateTime? birthDate) {
    final currentDate = DateTime.now();
    int age = currentDate.year - birthDate!.year;
    if(currentDate.month < birthDate.month || (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
      age--;
    }
    return age.toString();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("MIGGO CARE", style: TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0), fontWeight: FontWeight.bold),),
      ),
      body: Padding (
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                width: size.width,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('안녕하세요! 사용자님', style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10.0,),
                    Text('미꼬케어의 오신것을 환영합니다.',  style: TextStyle(fontSize: 17.0, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0,),
            Expanded(
              flex: 3,
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: const Color.fromRGBO(59, 130, 197, 0.7),
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monitor_heart_outlined, size: 40.0, color: Colors.white,),
                          const Spacer(),
                          Text(lastMeasure ?? '', style: TextStyle(fontSize: 15.0, color: Colors.white, fontWeight: FontWeight.bold),),
                        ],
                      ),
                      const SizedBox(height: 10.0,),
                      const Text('혈압 가져오기', style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold, ),),
                      const SizedBox(height: 10.0,),
                      const Spacer(),
                      Center(
                        child: RoundedButton(
                          text: '가져오기',
                          backgroundColor: Colors.white,
                          textColor: const Color.fromRGBO(59, 130, 197, 0.7),
                          press: () {
                            //Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const DataSyncPage()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0,),
            Expanded(
              flex: 3,
              child: Container(
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Main(pageIndex: 1,)),
                                  (route) => false);
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color.fromRGBO(234, 97, 142, 0.7),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('혈압 기록', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 10.0,),
                                Text('나의 평균 혈압', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 5.0,),
                                const Divider(color: Colors.white,),
                                Row(
                                  children: [
                                    Text('$avgSys/$avgDia', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
                                    const SizedBox(width: 5.0,),
                                    Text('mmHg', style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text('$avgPulse', style: TextStyle(color: Colors.white, fontSize: 15.0, fontWeight: FontWeight.bold),),
                                    const SizedBox(width: 5.0,),
                                    Text('bpm', style: TextStyle(color: Colors.white, fontSize: 10.0, fontWeight: FontWeight.bold),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AlarmPage(id: 1,)),
                          );
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color.fromRGBO(38, 175, 79, 0.7),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('알림', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 10.0,),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: alarmList.length,
                                    itemBuilder: (BuildContext context, int index) {
                                      List<String> weekdays = ['', '월', '화', '수', '목', '금', '토', '일'];
                                      return alarmList.isNotEmpty ? Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('매주 ${alarmList[index].daysOfWeek.map((number) => weekdays[number]).join('/')}요일', style: const TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),),
                                          Text('${alarmList[index].period} ${alarmList[index].hour}:${alarmList[index].minute.toString().padLeft(2, '0')}', style: const TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),),
                                          const SizedBox(height: 10.0,),
                                        ],
                                      ) : const Text('등록된 알림이 없습니다.', style: TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Main(pageIndex: 3,)),
                                  (route) => false);
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15.0),
                              color: const Color.fromRGBO(59, 130, 197, 0.7),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('내 정보', style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),),
                                const SizedBox(height: 10.0,),
                                Text('$name($age세)', style: const TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),),
                                Text(birthdate ?? '', style: const TextStyle(color: Colors.white, fontSize: 13.0, fontWeight: FontWeight.bold),),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}



