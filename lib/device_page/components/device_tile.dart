import 'package:flutter/material.dart';
import 'package:miggo_care/main.dart';

class DeviceTile extends StatelessWidget {
  const DeviceTile({Key? key, required this.title, required this.icon, required this.backgroundColor, required this.deviceName, required this.macAddress, required this.onTap}) : super(key: key);

  final String title;
  final IconData icon;
  final Color backgroundColor;
  final String? deviceName;
  final String? macAddress;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 120.0,
      width: size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          color: backgroundColor,
          /*
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1.0,
              blurRadius: 5.0,
              offset: const Offset(4,4),
            )
          ]*/
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontSize: 30.0, color: Colors.white, fontWeight: FontWeight.bold),),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            (deviceName == null) ? Text('연결된 기기 없음', style: TextStyle(fontSize: 10.0, color: Colors.white)) : Text(deviceName!, style: TextStyle(fontSize: 13.0, color: Colors.white),),
            (deviceName == null) ? SizedBox(height: 0,) : Text(macAddress!, style: TextStyle(fontSize: 10.0, color: Colors.white),),
          ],
        ),
        leading: Icon(icon, size: 50.0, color: Colors.white,),
        onTap: onTap,
      ),
    );
  }
}
