import '../../constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget button({double height, String text, @required VoidCallback onPressed, Widget child, double width, Color color, EdgeInsets padding, Color textColor, EdgeInsets margin, ShapeBorder shape}){
  Widget childData;
  if(text != null && text != "") {
    childData = Text(text ?? " ",
      style: TextStyle(color: textColor ?? Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
    );
  } else if(child != null) {
    childData = child;
  } else return Container();

  return AnimatedContainer(
    duration: Duration(milliseconds: 800),
    margin: margin ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    width: width ?? double.infinity,
    height: height ?? 50,
    child: FlatButton(
      padding: padding ?? null,
      child: childData,
      color: color ?? primaryColor,
      onPressed: onPressed,
      shape: shape ?? RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
      ),
    ),
  );
}