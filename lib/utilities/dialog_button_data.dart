import 'package:flutter/material.dart';

class DialogButtonData{
  String text;
  Color backColor;
  Function() onTapped;

  DialogButtonData({required this.text, required this.backColor, required this.onTapped});
}
