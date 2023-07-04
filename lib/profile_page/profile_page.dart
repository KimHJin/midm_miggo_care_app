import 'package:flutter/material.dart';
import 'package:miggo_care/_UserInfo/UserInfo.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {

  UserInfo? userInfo;
  String? name;
  String? gender;
  String? height;
  String? weight;
  String? age;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserInfo();
  }

  @override
  void dispose() {
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
        age = calculateAge(userInfo!.birthdate);
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
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text("내 정보", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 20.0,),
            Row(
              children: [
                const Icon(Icons.person_outline, size: 40.0,),
                const SizedBox(width: 10.0,),
                Text(name ?? '', style: const TextStyle(fontSize: 30.0),),
              ],
            ),
            const SizedBox(height: 20.0,),
            Expanded(
              flex:4,
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.grey, width: 0.5),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: Container(
                          child: Row(
                            children: [
                              const SizedBox(width: 10.0,),
                              const Text('성별', style: TextStyle(fontSize: 25.0),),
                              Spacer(),
                              Text(gender ?? '', style: TextStyle(fontSize: 25.0),),
                              const SizedBox(width: 10.0,),
                            ],
                          ),
                        )
                      ),
                      const Divider(),
                      Expanded(
                          child: Container(
                            child: Row(
                              children: [
                                const SizedBox(width: 10.0,),
                                const Text('나이', style: TextStyle(fontSize: 25.0),),
                                const Spacer(),
                                Row(
                                  children: [
                                    Text(age ?? '', style: const TextStyle(fontSize: 25.0),),
                                    const SizedBox(width: 5.0,),
                                    const Text('세', style: TextStyle(fontSize: 25.0),),
                                  ],
                                ),
                                const SizedBox(width: 10.0,),
                              ],
                            ),
                          )
                      ),
                      const Divider(),
                      Expanded(
                          child: Container(
                            child: Row(
                              children: [
                                const SizedBox(width: 10.0,),
                                const Text('키', style: TextStyle(fontSize: 25.0),),
                                const Spacer(),
                                Row(
                                  children: [
                                    Text(height ?? '', style: const TextStyle(fontSize: 25.0),),
                                    const SizedBox(width: 5.0,),
                                    const Text('cm', style: TextStyle(fontSize: 20.0),),
                                  ],
                                ),
                                const SizedBox(width: 10.0,),
                              ],
                            ),
                          )
                      ),
                      const Divider(),
                      Expanded(
                          child: Container(
                            child: Row(
                              children: [
                                const SizedBox(width: 10.0,),
                                const Text('몸무게', style: TextStyle(fontSize: 25.0),),
                                const Spacer(),
                                Row(
                                  children: [
                                    Text(weight ?? '', style: const TextStyle(fontSize: 25.0),),
                                    const SizedBox(width: 5.0,),
                                    const Text('kg', style: TextStyle(fontSize: 20.0),),
                                  ],
                                ),
                                const SizedBox(width: 10.0,),
                              ],
                            ),
                          )
                      ),
                    ],
                  ),
                ),
              )
            ),
          ],
        ),
      )
    );
  }
}
