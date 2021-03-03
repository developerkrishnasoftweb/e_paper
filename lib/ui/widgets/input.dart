
import '../../constant/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget input(
    {@required BuildContext context,
    InputDecoration decoration,
    TextStyle style,
    GestureTapCallback onTap,
    TextEditingController controller,
    bool obscureText,
    bool autoFocus,
    ValueChanged<String> onChanged,
    VoidCallback onEditingComplete,
    String text,
    TextInputType keyboardType,
    bool readOnly,
    EdgeInsetsGeometry margin,
    double width,
    TextStyle labelStyle,
    TextInputAction textInputAction,
    FocusNode focusNode,
    double height,
    int maxLines}) {
  Size size = MediaQuery.of(context).size;
  return Container(
    margin: margin ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
    width: width ?? size.width,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        text != null
            ? Text(
                text ?? " ",
                style: labelStyle ??
                    Theme.of(context).textTheme.bodyText1.copyWith(
                        color: Colors.grey,
                        fontSize: 13,
                        fontWeight: FontWeight.bold),
              )
            : SizedBox(),
        SizedBox(
          height: text != null ? 5 : 0,
        ),
        Container(
          height: height ?? 55,
          child: TextFormField(
            autofocus: autoFocus ?? false,
            maxLines: maxLines ?? 1,
            decoration: decoration ?? null,
            style: style ?? null,
            onTap: onTap ?? null,
            controller: controller ?? null,
            obscureText: obscureText ?? false,
            onChanged: onChanged ?? null,
            onEditingComplete: onEditingComplete ?? null,
            textInputAction: textInputAction ?? null,
            keyboardType: keyboardType,
            readOnly: readOnly ?? false,
            focusNode: focusNode,
            cursorColor: primaryColor,
          ),
        ),
      ],
    ),
  );
}

OutlineInputBorder border({double borderRadius}) {
  return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius ?? 5),
      borderSide: BorderSide(color: Colors.grey));
}
