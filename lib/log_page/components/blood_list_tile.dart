import 'package:flutter/material.dart';

class BloodListTile extends StatelessWidget {
  const BloodListTile({Key? key, required this.sys, required this.dia, required this.pulse, required this.date, required this.time}) : super(key: key);

  final String sys;
  final String dia;
  final String pulse;
  final String date;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(width: 20.0,),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(date, style: const TextStyle(fontSize: 13.0),),
                Text(time, style: const TextStyle(fontSize: 13.0),),
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('수축기'),
                const SizedBox(height: 10.0,),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(sys), const SizedBox(width: 3.0,), const Text('mmHg', style: TextStyle(fontSize: 8.0),)],)
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('이완기'),
                const SizedBox(height: 10.0,),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(dia), const SizedBox(width: 3.0,), const Text('mmHg', style: TextStyle(fontSize: 8.0))],)
              ],
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('맥박'),
                const SizedBox(height: 10.0,),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [Text(pulse), const SizedBox(width: 3.0,), const Text('bpm', style: TextStyle(fontSize: 8.0))],)
              ],
            ),
          ),
          const Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('고혈압'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
