import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miggo_care/_BloodPressure/BloodPressure.dart';
import 'package:miggo_care/_UserInfo/UserInfo.dart';
import 'components/rounded_button.dart';
import 'terms_page.dart';

/*
List<BloodPressure> demoList = [
  BloodPressure(systolic: 150, diastolic: 85, pulse: 80, measuredAt: DateTime(2023, 6, 01, 08, 53)),
  BloodPressure(systolic: 134, diastolic: 87, pulse: 85, measuredAt: DateTime(2023, 6, 01, 15, 23)),
  BloodPressure(systolic: 165, diastolic: 89, pulse: 78, measuredAt: DateTime(2023, 6, 02, 10, 48)),
  BloodPressure(systolic: 187, diastolic: 86, pulse: 79, measuredAt: DateTime(2023, 6, 03, 07, 35)),
  BloodPressure(systolic: 135, diastolic: 82, pulse: 76, measuredAt: DateTime(2023, 6, 03, 10, 28)),
  BloodPressure(systolic: 120, diastolic: 91, pulse: 77, measuredAt: DateTime(2023, 6, 03, 13, 56)),
  BloodPressure(systolic: 115, diastolic: 96, pulse: 76, measuredAt: DateTime(2023, 6, 04, 08, 34)),
  BloodPressure(systolic: 131, diastolic: 92, pulse: 74, measuredAt: DateTime(2023, 6, 04, 13, 31)),
  BloodPressure(systolic: 141, diastolic: 85, pulse: 73, measuredAt: DateTime(2023, 6, 05, 08, 15)),
  BloodPressure(systolic: 135, diastolic: 81, pulse: 75, measuredAt: DateTime(2023, 6, 05, 13, 05)),
  BloodPressure(systolic: 132, diastolic: 88, pulse: 74, measuredAt: DateTime(2023, 6, 06, 08, 13)),
  BloodPressure(systolic: 156, diastolic: 82, pulse: 76, measuredAt: DateTime(2023, 6, 06, 13, 46)),
  BloodPressure(systolic: 167, diastolic: 89, pulse: 77, measuredAt: DateTime(2023, 6, 06, 15, 51)),
  BloodPressure(systolic: 152, diastolic: 85, pulse: 75, measuredAt: DateTime(2023, 6, 06, 18, 35)),
  BloodPressure(systolic: 113, diastolic: 82, pulse: 72, measuredAt: DateTime(2023, 6, 07, 10, 16)),
  BloodPressure(systolic: 132, diastolic: 81, pulse: 78, measuredAt: DateTime(2023, 6, 08, 12, 11)),
  BloodPressure(systolic: 128, diastolic: 80, pulse: 80, measuredAt: DateTime(2023, 6, 09, 09, 36)),
  BloodPressure(systolic: 121, diastolic: 80, pulse: 81, measuredAt: DateTime(2023, 6, 10, 08, 38)),
  BloodPressure(systolic: 122, diastolic: 83, pulse: 82, measuredAt: DateTime(2023, 6, 11, 09, 49)),
  BloodPressure(systolic: 133, diastolic: 84, pulse: 80, measuredAt: DateTime(2023, 6, 11, 15, 37)),
  BloodPressure(systolic: 142, diastolic: 85, pulse: 76, measuredAt: DateTime(2023, 6, 12, 18, 48)),
  BloodPressure(systolic: 165, diastolic: 86, pulse: 75, measuredAt: DateTime(2023, 6, 13, 06, 46)),
  BloodPressure(systolic: 170, diastolic: 90, pulse: 76, measuredAt: DateTime(2023, 6, 13, 08, 18)),
  BloodPressure(systolic: 132, diastolic: 92, pulse: 74, measuredAt: DateTime(2023, 6, 13, 15, 27)),
  BloodPressure(systolic: 132, diastolic: 93, pulse: 73, measuredAt: DateTime(2023, 6, 14, 11, 55)),
  BloodPressure(systolic: 142, diastolic: 100, pulse: 77, measuredAt: DateTime(2023, 6, 14, 16, 58)),
  BloodPressure(systolic: 121, diastolic: 82, pulse: 75, measuredAt: DateTime(2023, 6, 15, 10, 37)),
  BloodPressure(systolic: 132, diastolic: 85, pulse: 71, measuredAt: DateTime(2023, 6, 16, 10, 27)),
  BloodPressure(systolic: 141, diastolic: 86, pulse: 70, measuredAt: DateTime(2023, 6, 17, 13, 16)),
  BloodPressure(systolic: 144, diastolic: 84, pulse: 68, measuredAt: DateTime(2023, 6, 18, 12, 24)),
  BloodPressure(systolic: 132, diastolic: 83, pulse: 70, measuredAt: DateTime(2023, 6, 19, 15, 35)),
  BloodPressure(systolic: 142, diastolic: 81, pulse: 71, measuredAt: DateTime(2023, 6, 20, 09, 17)),
  BloodPressure(systolic: 130, diastolic: 82, pulse: 72, measuredAt: DateTime(2023, 6, 20, 12, 13)),
  BloodPressure(systolic: 131, diastolic: 83, pulse: 73, measuredAt: DateTime(2023, 6, 21, 09, 25)),
  BloodPressure(systolic: 135, diastolic: 85, pulse: 75, measuredAt: DateTime(2023, 6, 21, 12, 42)),
  BloodPressure(systolic: 133, diastolic: 86, pulse: 69, measuredAt: DateTime(2023, 6, 21, 15, 47)),
  BloodPressure(systolic: 145, diastolic: 81, pulse: 70, measuredAt: DateTime(2023, 6, 22, 07, 23)),
  BloodPressure(systolic: 135, diastolic: 90, pulse: 72, measuredAt: DateTime(2023, 6, 22, 13, 10)),
  BloodPressure(systolic: 167, diastolic: 91, pulse: 68, measuredAt: DateTime(2023, 6, 23, 08, 12)),
  BloodPressure(systolic: 178, diastolic: 92, pulse: 68, measuredAt: DateTime(2023, 6, 23, 14, 14)),
  BloodPressure(systolic: 135, diastolic: 86, pulse: 69, measuredAt: DateTime(2023, 6, 24, 10, 11)),
  BloodPressure(systolic: 141, diastolic: 88, pulse: 67, measuredAt: DateTime(2023, 6, 25, 13, 05)),
  BloodPressure(systolic: 135, diastolic: 81, pulse: 70, measuredAt: DateTime(2023, 6, 26, 15, 19)),
  BloodPressure(systolic: 151, diastolic: 89, pulse: 71, measuredAt: DateTime(2023, 6, 27, 08, 28)),
  BloodPressure(systolic: 131, diastolic: 82, pulse: 72, measuredAt: DateTime(2023, 6, 28, 09, 31)),
  BloodPressure(systolic: 133, diastolic: 82, pulse: 70, measuredAt: DateTime(2023, 6, 28, 15, 34)),
  BloodPressure(systolic: 137, diastolic: 82, pulse: 68, measuredAt: DateTime(2023, 6, 29, 09, 41)),
  BloodPressure(systolic: 142, diastolic: 83, pulse: 75, measuredAt: DateTime(2023, 6, 30, 10, 06)),
  BloodPressure(systolic: 153, diastolic: 87, pulse: 76, measuredAt: DateTime(2023, 6, 30, 13, 03)),
  BloodPressure(systolic: 135, diastolic: 80, pulse: 74, measuredAt: DateTime(2023, 6, 31, 14, 00)),
];
*/

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  String selectedGender = '남';

  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;

  final List<String> _years = List.generate(100, (index) => (2023 - index).toString());
  final List<String> _months = List.generate(12, (index) => (index + 1).toString());
  final List<String> _days = List.generate(31, (index) => (index + 1).toString());

  bool isButtonEnabled = false;

  void updateButtonState() {
    setState(() {
      isButtonEnabled = nameController.text.isNotEmpty &&
          heightController.text.isNotEmpty &&
          weightController.text.isNotEmpty &&
          (selectedYear != null && selectedMonth != null && selectedDay != null);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.addListener(updateButtonState);
    heightController.addListener(updateButtonState);
    weightController.addListener(updateButtonState);
    /*
    for(BloodPressure bp in demoList) {
      BloodPressure.insertBloodPressure(bp);
    }*/
  }

  @override
  void dispose() {
    nameController.dispose();
    heightController.dispose();
    weightController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text("사용자 정보", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Container(
          //alignment: Alignment.center,
          //height: size.height,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "환영합니다 미꼬케어입니다.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const Text(
                  "먼저 사용자 정보를 입력해주세요.",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(height: 30.0,),
                TextField(
                  maxLength: 4,
                  controller: nameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: '이름',
                    counterText:''
                  ),
                ),

                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownButton<String>(
                          value: selectedYear,
                          isExpanded: true,
                          underline: SizedBox(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedYear = newValue;
                            });
                          },
                          items: _years.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text('년도'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0,),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownButton<String>(
                          value: selectedMonth,
                          isExpanded: true,
                          underline: SizedBox(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedMonth = newValue;
                            });
                          },
                          items: _months.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text('월'),
                        ),
                      ),
                    ),
                    const SizedBox(width: 5.0,),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(left: 10.0, right: 10.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: DropdownButton<String>(
                          value: selectedDay,
                          isExpanded: true,
                          underline: SizedBox(),

                          onChanged: (String? newValue) {
                            setState(() {
                              selectedDay = newValue;
                            });
                          },
                          items: _days.map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          hint: Text('일'),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    Radio<String>(
                      value: '남',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                    const Text('남성'),
                    Radio<String>(
                      value: '여',
                      groupValue: selectedGender,
                      onChanged: (value) {
                        setState(() {
                          selectedGender = value!;
                        });
                      },
                    ),
                    const Text('여성'),
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: heightController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '키',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                        ],
                      ),
                    ),
                    //const SizedBox(width: 20.0,),
                    const Text(' cm', style: TextStyle(fontSize: 20.0),),
                    //const SizedBox(width: 20.0,),
                  ],
                ),
                const SizedBox(height: 10.0,),
                Row(
                  children: [
                    Flexible(
                      child: TextField(
                        controller: weightController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: '몸무게',
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(3),
                        ],
                      ),
                    ),
                    // SizedBox(width: 20.0,),
                    const Text(' kg', style: TextStyle(fontSize: 20.0),),
                    //const SizedBox(width: 20.0,),
                  ],
                ),
                const SizedBox(height: 20.0,),
                RoundedButton(
                  textColor: Colors.white,
                  text: '다음',
                  press: isButtonEnabled ? (){
                    String name = nameController.text;
                    DateTime birthdate = DateTime(int.parse(selectedYear!), int.parse(selectedMonth!), int.parse(selectedDay!));
                    double height = double.parse(heightController.text);
                    double weight = double.parse(weightController.text);

                    UserInfo userInfo = UserInfo(
                      name: name,
                      birthdate: birthdate,
                      height: height,
                      weight: weight,
                      gender: selectedGender, // 선택된 성별 추가
                    );

                    UserPreferences.setUserInfo(userInfo).then((_) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('저장 완료'),
                            content: const Text('사용자 정보가 저장되었습니다.'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    });

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const TermsPage()),
                    );
                  } : null,
                ),
                const SizedBox(height: 15.0,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}



