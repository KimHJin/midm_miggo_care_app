import 'package:flutter/material.dart';
import 'package:miggo_care/bluetooth/ble_device.dart';
import 'package:miggo_care/connect_page/second_connect_page.dart';
import 'components/rounded_button.dart';

class FirstConnectPage extends StatelessWidget {
  const FirstConnectPage({Key? key, required this.bleDevice}) : super(key: key);

  final BleDevice bleDevice;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Color.fromRGBO(59, 130, 197, 1.0),),
          title: const Text("제품", style: TextStyle(color: Color.fromRGBO(59, 130, 197, 1.0), fontWeight: FontWeight.bold),),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 20.0,),
              const Text('Miggo Care 혈압계 제품이 있습니까?', style: TextStyle(fontSize: 20.0),),
              SizedBox(height: size.height * 0.1,),
              SizedBox(width: size.width*0.6, height: size.width*0.6, child: Image.asset('assets/miggocare.png')),
              const Spacer(),
              RoundedButton(
                text: '계속해서 진행',
                color: const Color.fromRGBO(59, 130, 197, 1.0),
                textColor: Colors.white,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SecondConnectPage(bleDevice: bleDevice,)),
                  );
                },
              ),
              const SizedBox(height: 10.0,),
            ],
          ),
        )
    );
  }
}
