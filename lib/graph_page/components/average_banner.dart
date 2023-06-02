import 'package:flutter/material.dart';


class AverageBanner extends StatelessWidget {
  final String averageBloodPressure;
  final String averagePulse;

  const AverageBanner({
    super.key,
    required this.averageBloodPressure,
    required this.averagePulse,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Container(
              color: const Color.fromRGBO(59, 130, 197, 1.0),
              child: Column(
                children: [
                  const SizedBox(height: 3.0,),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(width: 5.0,),
                      Text('평균 혈압', style: TextStyle(color: Colors.white),),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(averageBloodPressure, style: const TextStyle(color: Colors.white, fontSize: 40.0),),
                      const SizedBox(width: 10.0,),
                      const Text('mmHg', style: TextStyle(color: Colors.white,),),
                      const SizedBox(width: 10.0,),
                    ],
                  ),
                ],
              )
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
            color: const Color.fromRGBO(234, 97, 142, 1.0),
            child: Column(
              children: [
                const SizedBox(height: 3.0,),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(width: 5.0,),
                    Text('맥박', style: TextStyle(color: Colors.white),),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(averagePulse, style: const TextStyle(color: Colors.white, fontSize: 40.0),),
                    const SizedBox(width: 10.0,),
                    const Text('bpm', style: TextStyle(color: Colors.white,)),
                    const SizedBox(width: 10.0,),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}