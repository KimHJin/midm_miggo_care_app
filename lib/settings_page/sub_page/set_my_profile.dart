import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miggo_care/_UserInfo/UserInfo.dart';

import 'package:miggo_care/settings_page/components/rounded_button.dart';

class SetMyProfilePage extends StatefulWidget {
  const SetMyProfilePage({Key? key}) : super(key: key);

  @override
  State<SetMyProfilePage> createState() => _SetMyProfilePageState();
}

class _SetMyProfilePageState extends State<SetMyProfilePage> {

  UserInfo? userInfo;

  String? name;
  String? height;
  String? weight;
  String? gender;
  String? year;
  String? month;
  String? day;

  TextEditingController? nameController;
  TextEditingController? heightController;
  TextEditingController? weightController;

  String? selectedGender;

  String? selectedYear;
  String? selectedMonth;
  String? selectedDay;

  final List<String> _years = List.generate(100, (index) => (2023 - index).toString());
  final List<String> _months = List.generate(12, (index) => (index + 1).toString());
  final List<String> _days = List.generate(31, (index) => (index + 1).toString());

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserInfo();
  }

  @override
  void dispose() {
    nameController!.dispose();
    heightController!.dispose();
    weightController!.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> loadUserInfo() async {
    UserPreferences.getUserInfo().then((value) {
      setState(() {
        userInfo = value;
        name = userInfo!.name;
        gender = userInfo!.gender;
        height = userInfo!.height.toString();
        weight = userInfo!.weight.toString();

        selectedYear = userInfo!.birthdate.year.toString();
        selectedMonth = userInfo!.birthdate.month.toString();
        selectedDay = userInfo!.birthdate.day.toString();
        selectedGender = gender;
        nameController = TextEditingController(text: name);
        heightController = TextEditingController(text: height);
        weightController = TextEditingController(text: weight);
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
        title: const Text("사용자 정보", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
                  text: '저장',
                  press: () {
                    String name = nameController!.text;
                    DateTime birthdate = DateTime(int.parse(selectedYear!), int.parse(selectedMonth!), int.parse(selectedDay!));
                    double height = double.parse(heightController!.text);
                    double weight = double.parse(weightController!.text);

                    UserInfo userInfo = UserInfo(
                      name: name,
                      birthdate: birthdate,
                      height: height,
                      weight: weight,
                      gender: selectedGender!, // 선택된 성별 추가
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
                                  Navigator.pop(context);
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          );
                        },
                      );
                    });

                  },
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
