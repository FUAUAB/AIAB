import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

ThemeData bus() {
  final ThemeData theme = ThemeData.light();
  return theme.copyWith(
    primaryColor: CustomColors.busOrange,
    colorScheme: ColorScheme.light(
      primary: CustomColors.busOrange,
      secondary: CustomColors.busGrey,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: CustomColors.busOrange,
      disabledColor: CustomColors.buttonDisabled,
      colorScheme: ColorScheme.light(
        primary: CustomColors.buttonGreen,
      ),
    ),
    secondaryHeaderColor: CustomColors.busOrange,
    scaffoldBackgroundColor: CustomColors.oddRow,
    appBarTheme: AppBarTheme(
      backgroundColor: CustomColors.busGrey,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );
}
