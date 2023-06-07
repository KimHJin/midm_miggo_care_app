import 'package:flutter/material.dart';



class RoundedToggleButton extends StatelessWidget {
  const RoundedToggleButton({Key? key, required this.select, required this.children, required this.onPressed}) : super(key: key);

  final List<bool> select;
  final List<Widget> children;
  final Function(int) onPressed;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ToggleButtons(
      constraints: BoxConstraints(
          minWidth : ((size.width - 30)/2),
          minHeight: 30.0
      ),
      direction: Axis.horizontal,
      onPressed: onPressed,
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      isSelected: select,
      children: children,
    );
  }
}
