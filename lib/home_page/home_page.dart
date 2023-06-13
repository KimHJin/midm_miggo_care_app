import 'package:flutter/material.dart';
import 'package:miggo_care/main.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key,}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

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
                    Text('안녕하세요! 사용자님', style: TextStyle(fontSize: 25.0),),
                    SizedBox(height: 10.0,),
                    Text('미꼬케어의 오신것을 환영합니다.',  style: TextStyle(fontSize: 15.0),),
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
                  color: Color.fromRGBO(59, 130, 197, 0.7),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 1.0,
                      blurRadius: 5.0,
                      offset: Offset(4,4),
                    )
                  ]
                ),
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.monitor_heart_outlined, size: 45.0, color: Colors.white,),
                      SizedBox(height: 10.0,),
                      Text('혈압 측정하기', style: TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),),
                      SizedBox(height: 15.0,),
                      Expanded(
                        child: Container(
                          alignment: Alignment.center,
                          width: size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1.0,
                                  blurRadius: 5.0,
                                  offset: Offset(4,4),
                                )
                              ]
                          ),
                          child: Text('가져오기', style: TextStyle(color: Color.fromRGBO(59, 130, 197, 0.7), fontSize: 20.0, fontWeight: FontWeight.bold),),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10.0,),
            Expanded(
              flex: 3,
              child: Container(color: Colors.blue,),
            )
          ],
        ),
      )
    );
  }
}



