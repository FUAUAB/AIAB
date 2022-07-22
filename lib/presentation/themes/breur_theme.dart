import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

ThemeData breur() {
  final ThemeData theme = ThemeData.light();
  return theme.copyWith(
    primaryColor: CustomColors.breurBlue,
    colorScheme: ColorScheme.light(
      primary: CustomColors.breurBlue,
      secondary: CustomColors.breurGrey,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: CustomColors.breurBlue,
      disabledColor: CustomColors.buttonDisabled,
      colorScheme: ColorScheme.light(
        primary: CustomColors.buttonGreen,
      ),
    ),
    secondaryHeaderColor: CustomColors.breurGrey,
    scaffoldBackgroundColor: CustomColors.oddRow,
    appBarTheme: AppBarTheme(
      backgroundColor: CustomColors.breurBlue,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );
}
