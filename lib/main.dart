import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:miggo_care/home_page/home_page.dart';
import 'package:miggo_care/log_page/log_page.dart';
import 'package:miggo_care/device_page/device_page.dart';
import 'package:miggo_care/profile_page/profile_page.dart';
import 'package:miggo_care/settings_page/settings_page.dart';

import 'package:miggo_care/welcome_page/welcom_page.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isNotFirst = false;

  sleep(const Duration(seconds: 1));

  runApp(MyApp(isNotFirst: isNotFirst,));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key, required this.isNotFirst}) : super(key: key);

  final bool? isNotFirst;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  bool? isNotFirst;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isNotFirst = widget.isNotFirst;
    FlutterNativeSplash.remove();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Welcome to Miggo Care App',
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
      ),
      home: (isNotFirst != true) ? const WelcomePage() : const Main(),
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {

  int _selectIndex = 0;

  final List<Widget> _pages= const <Widget>[
    HomePage(),
    MyLogPage(),
    MyDevicePage(),
    MyProfilePage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '홈'),
          BottomNavigationBarItem(icon: Icon(Icons.note_alt_outlined), label: '기록'),
          BottomNavigationBarItem(icon: Icon(Icons.devices), label: '내 기기'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '내 정보'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '설정'),
        ],
        currentIndex: _selectIndex,
        selectedItemColor: const Color.fromRGBO(59, 130, 197, 1.0),
        onTap: (int index){
          setState(() {
            _selectIndex = index;
          });
        },
      ),
    );
  }
}


