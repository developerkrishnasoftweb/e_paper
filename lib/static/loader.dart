import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
class Loader{
  final BuildContext context;
  final String text;
  final Color color;
  Loader({@required this.context, this.text, this.color}){
    Future<void> _loader(context, text) async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: <Widget>[
                Container(
                  height: 40,
                  width: 40,
                  margin: EdgeInsets.only(left: 10, right: 15),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(color != null ? color : Colors.blue),
                    strokeWidth: 4,
                  ),
                ),
                Container(
                  child: Text(text != null ? text : "Please wait..."),
                )
              ],
            ),
            scrollable: false,
          );
        },
      );
    }
    _loader(context, text);
  }
}