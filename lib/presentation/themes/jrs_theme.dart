import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

ThemeData jrs() {
  final ThemeData theme = ThemeData.light();
  return theme.copyWith(
    primaryColor: CustomColors.jrsBlue,
    colorScheme: ColorScheme.light(
      primary: CustomColors.jrsBlue,
      secondary: CustomColors.jrsBlack,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: CustomColors.jrsBlue,
      disabledColor: CustomColors.buttonDisabled,
      colorScheme: ColorScheme.light(
        primary: CustomColors.buttonGreen,
      ),
    ),
    secondaryHeaderColor: CustomColors.jrsBlack,
    scaffoldBackgroundColor: CustomColors.oddRow,
    appBarTheme: AppBarTheme(
      backgroundColor: CustomColors.jrsBlue,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );
}
