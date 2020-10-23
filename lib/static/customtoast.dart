import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CustomToast{
  static showToast({String text,
    Icon icon,
    Color backgroundColor,
    Color color,
    ToastGravity gravity,
    double height,
    double width,
    EdgeInsets padding,
    Duration duration,
    List<BoxShadow> boxShadow,
    @required FToast fToast}) {

    Widget toast = Container(
      alignment: Alignment.center,
      height: height != null ? height : null,
      width: width != null ? width : null,
      padding: padding != null ? padding : EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60.0),
        color: backgroundColor != null ? backgroundColor : Colors.black54,
        boxShadow: boxShadow
      ),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(children: [
          WidgetSpan(child: icon != null ? icon : Container(), alignment: PlaceholderAlignment.middle),
          TextSpan(text: text != null ? "\t\t" + text : " ", style: TextStyle( color: color != null ? color : Colors.white),),
        ]),
      ),
    );
    fToast.showToast(
      child: toast,
      gravity: gravity != null ? gravity : ToastGravity.BOTTOM,
      toastDuration: duration,
    );
  }
}

/*
FToast fToast;
@override
void initState() {
  super.initState();
  fToast = FToast();
  fToast.init(context);
}
*/