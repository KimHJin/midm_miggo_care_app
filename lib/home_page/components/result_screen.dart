import 'package:flutter/material.dart';


class ResultText extends StatelessWidget {
  final String title;
  final String value;
  final String unit;

  const ResultText({
    super.key,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromRGBO(189, 224, 254, 1),
      child: Column(
        children: [
          const SizedBox(height: 5.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(width: 5.0,),
              Text(title, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(59, 130, 197, 1.0),),)
            ],
          ),
          Expanded(
            child: Center(
              child: Text(value, style: const TextStyle(fontSize: 60.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(59, 130, 197, 1.0),),),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(unit, style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(59, 130, 197, 1.0),),),
              const SizedBox(width: 5.0,),
            ],
          ),
          const SizedBox(height: 5.0,),
        ],
      ),
    );
  }
}
