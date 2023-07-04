import 'package:flutter/material.dart';

class BloodListTile extends StatelessWidget {
  const BloodListTile({Key? key, required this.index, required this.sys, required this.dia, required this.pulse, required this.date, required this.time}) : super(key: key);

  final String index;
  final String sys;
  final String dia;
  final String pulse;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(child: Center(child: Text(index, style: const TextStyle(fontSize: 12.0,),))),
          Expanded(child: Center(child: Text(sys, style: const TextStyle(fontSize: 12.0,),))),
          Expanded(child: Center(child: Text(dia, style: const TextStyle(fontSize: 12.0,),))),
          Expanded(child: Center(child: Text(pulse, style: const TextStyle(fontSize: 12.0,),))),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(date, style: TextStyle(fontSize: 12.0,),),
                Text(time, style: TextStyle(fontSize: 12.0,),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
