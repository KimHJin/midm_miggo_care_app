import 'package:flutter/material.dart';



class RoundedToggleButton extends StatelessWidget {
  const RoundedToggleButton({Key? key, required this.selectTime, required this.onPressed}) : super(key: key);

  final List<bool> selectTime;
  final Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ToggleButtons(
      constraints: BoxConstraints(
          minWidth : ((size.width - 30)/3),
          minHeight: 30.0
      ),
      direction: Axis.horizontal,
      onPressed: onPressed,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      isSelected: selectTime,
      children: const <Widget>[
        Text('1일'),
        Text('1개월'),
        Text('1년'),
      ],
    );
  }
}
