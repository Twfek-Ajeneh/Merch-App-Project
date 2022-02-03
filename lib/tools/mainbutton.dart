import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton({
    Key? key,
    required this.label,
    required this.function,
    this.W,
    this.color
  }) : super(key: key);

  final String label;
  final Function()? function;
  final double? W;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: W == null ? 350 : W,
      height: 45,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(5)),
      child: ElevatedButton(
        onPressed: function,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w300,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(color),
          elevation: MaterialStateProperty.all(5),
        ),
      ),
    );
  }
}
