import 'package:flutter/material.dart';
import 'package:miggo_care/bluetooth/ble_device.dart';
import '../connect_page/first_connect_page.dart';
import 'terms_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key, required this.bleDevice}) : super(key: key);

  final BleDevice bleDevice;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.25,),
            const Text(
              "미꼬 케어에 오신것을 환영합니다!",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: size.height * 0.08,),
            Image.asset("assets/miggo_splash_image.png", height: size.height * 0.3,),
            const Spacer(),
            Container(
              width: size.width,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(59, 130, 197, 1.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: TextButton(
                style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 10)),
                onPressed: (){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                      builder: (BuildContext context) => TermsPage(bleDevice: bleDevice,)),
                          (route) => false
                  );
                },
                child: const Text("시작하기", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


