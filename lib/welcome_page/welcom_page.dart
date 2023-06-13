import 'package:flutter/material.dart';
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
  TextEditingController birthdateController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  String selectedGender = 'Male';

  bool isButtonEnabled = false;

  void updateButtonState() {
    setState(() {
      // 모든 텍스트 필드가 비어있지 않은 경우 버튼 활성화
      isButtonEnabled = nameController.text.isNotEmpty &&
          birthdateController.text.isNotEmpty &&
          heightController.text.isNotEmpty &&
          weightController.text.isNotEmpty;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController.addListener(updateButtonState);
    birthdateController.addListener(updateButtonState);
    heightController.addListener(updateButtonState);
    weightController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    nameController.dispose();
    birthdateController.dispose();
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
          alignment: Alignment.center,
          height: size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 15.0,),
              const Text(
                "환영합니다 미꼬케어입니다.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const Text(
                "먼저 사용자 정보를 입력해주세요.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '이름',
                ),
              ),
              const SizedBox(height: 10.0,),
              TextField(
                controller: birthdateController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '생년월일',
                ),
              ),
              const SizedBox(height: 10.0,),
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: selectedGender,
                    onChanged: (value) {
                      setState(() {
                        selectedGender = value!;
                      });
                    },
                  ),
                  const Text('남성'),
                  Radio<String>(
                    value: 'Female',
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
              TextField(
                controller: heightController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '키',
                ),
              ),
              const SizedBox(height: 10.0,),
              TextField(
                controller: weightController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: '몸무게',
                ),
              ),
              
              const Spacer(),
              RoundedButton(
                textColor: Colors.white,
                text: '다음',
                press: isButtonEnabled ? (){
                  String name = nameController.text;
                  String birthdate = birthdateController.text;
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
                          title: Text('저장 완료'),
                          content: Text('사용자 정보가 저장되었습니다.'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text('확인'),
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
    );
  }
}



