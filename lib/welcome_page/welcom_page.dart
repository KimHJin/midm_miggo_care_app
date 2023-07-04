import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:miggo_care/_UserInfo/UserInfo.dart';
import 'components/rounded_button.dart';
import 'terms_page.dart';


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



