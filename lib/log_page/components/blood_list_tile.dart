import 'package:flutter/material.dart';

class BloodListTile extends StatelessWidget {
  BloodListTile({Key? key, required this.index, required this.sys, required this.dia, required this.pulse, required this.date, required this.time}) : super(key: key);

  final String index;
  final String sys;
  final String dia;
  final String pulse;
  final String date;
  final String time;

  Color? bpColor;

  @override
  Widget build(BuildContext context) {
    int sysValue = int.parse(sys);
    int diaValue = int.parse(dia);

    if(sysValue >= 180 || diaValue >= 110) {
      bpColor = const Color.fromRGBO(240, 0, 0, 0.7);
    } else if(sysValue >= 160 || diaValue >= 100) {
      bpColor = const Color.fromRGBO(255, 128, 0, 0.7);
    } else if(sysValue >= 140 || diaValue >= 90) {
      bpColor = const Color.fromRGBO(240, 240, 0, 0.7);
    } else {
      bpColor = Colors.transparent;
    }

    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Center(child: CircleAvatar(backgroundColor: bpColor, child: Text(index, style: const TextStyle(fontSize: 12.0, color: Colors.black),),))),
          Expanded(child: Center(child: Text(sys, style: const TextStyle(fontSize: 12.0,),))),
          Expanded(child: Center(child: Text(dia, style: const TextStyle(fontSize: 12.0,),))),
          Expanded(child: Center(child: Text(pulse, style: const TextStyle(fontSize: 12.0,),))),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(date, style: const TextStyle(fontSize: 12.0,),),
                Text(time, style: const TextStyle(fontSize: 12.0,),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
