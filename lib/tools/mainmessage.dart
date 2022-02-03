import 'package:flutter/material.dart';
import 'package:project/tools/colors.dart';

class MainMessage {
  static getSnackBar(String label, Color color, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        elevation: 5,
        padding: EdgeInsets.all(10),
        content: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            color: Colors.white,
            fontWeight: FontWeight.w300,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  static getProgressIndicator(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AllColors.secondryColor,
          ),
        );
      },
    );
  }
}
