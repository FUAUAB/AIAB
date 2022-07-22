import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

ThemeData didata() {
  final ThemeData theme = ThemeData.light();
  return theme.copyWith(
    primaryColor: CustomColors.didataBlue,
    colorScheme: ColorScheme.light(
      primary: CustomColors.didataBlue,
      secondary: CustomColors.didataOrange,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: CustomColors.didataBlue,
      disabledColor: CustomColors.buttonDisabled,
      colorScheme: ColorScheme.light(
        primary: CustomColors.buttonGreen,
      ),
    ),
    secondaryHeaderColor: CustomColors.didataOrange,
    scaffoldBackgroundColor: CustomColors.oddRow,
    appBarTheme: AppBarTheme(
      backgroundColor: CustomColors.didataBlue,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );
}
