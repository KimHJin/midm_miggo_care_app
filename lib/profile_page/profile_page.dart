import 'package:flutter/material.dart';

class MyProfilePage extends StatefulWidget {
  const MyProfilePage({Key? key}) : super(key: key);

  @override
  State<MyProfilePage> createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.blue),
        title: const Text("내 정보", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Icon(Icons.person),
              Text('사용자님'),
            ],
          ),
          Expanded(flex:4, child: Container(color: Colors.blue,)),
        ],
      )
    );
  }
}
