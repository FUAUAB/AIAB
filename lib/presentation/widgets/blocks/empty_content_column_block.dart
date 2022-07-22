import 'package:flutter/material.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

Column buildNoContentColumn(BuildContext context, String text) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Container(
        height: 100,
        padding: EdgeInsets.only(left: 20, top: 20),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20.0, color: CustomColors.black),
        ),
      ),
    ],
  );
}
