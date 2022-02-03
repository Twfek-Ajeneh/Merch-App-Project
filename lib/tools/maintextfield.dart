import 'package:flutter/material.dart';

import 'package:project/tools/colors.dart';

class MainTextField extends StatelessWidget {
  MainTextField({
    Key? key,
    required this.label,
    required this.type,
    required this.validator,
    required this.controller,
    this.showFunction,
    this.show,
    this.W,
    this.H,
    this.f = false,
  }) : super(key: key);

  final String label;
  final String type;
  final String? Function(String?) validator;
  final TextEditingController controller;
  final Function()? showFunction;
  final bool? show;
  final double? W;
  final int? H;
  bool f;

  get fieldtype {
    if (type == "email")
      return TextInputType.emailAddress;
    else if (type == "password" || type == "confirm")
      return TextInputType.visiblePassword;
    else if (type == "name" || type == "comment")
      return TextInputType.text;
    else if (type == "number")
      return TextInputType.number;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AllColors.fieldColor,
            borderRadius: BorderRadius.circular(5),
          ),
          width: W == null ? 350 : W,
          height: H == null ? 46 : 26 * (H!.toDouble()),
        ),
        Container(
          width: W == null ? 350 : W,
          padding: const EdgeInsets.only(left: 10, right: 5),
          child: TextFormField(
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w300,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: label,
              hintStyle: TextStyle(
                color: AllColors.hintTextColor,
                fontWeight: FontWeight.w300,
              ),
              suffixIcon: type == "password"
                  ? IconButton(
                      onPressed: showFunction,
                      icon: show == true
                          ? Icon(
                              Icons.visibility_off,
                              size: 21,
                              color: AllColors.hintTextColor,
                            )
                          : Icon(
                              Icons.visibility,
                              size: 21,
                              color: Color(0xFF01a2fc),
                            ),
                    )
                  : type == "comment"
                      ? IconButton(
                          onPressed: showFunction,
                          icon: Icon(
                            Icons.send_rounded,
                            size: 21,
                            color: AllColors.hintTextColor,
                          ),
                        )
                      : null,
            ),
            textAlignVertical: TextAlignVertical.center,
            cursorColor: AllColors.secondryColor,
            keyboardType: fieldtype,
            obscureText: show == null ? false : show!,
            controller: controller,
            validator: (value) => validator(value),
            maxLines: H == null ? 1 : H,
            readOnly: f,
          ),
        ),
      ],
    );
  }
}
