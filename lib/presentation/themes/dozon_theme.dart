import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

ThemeData dozon() {
  final ThemeData theme = ThemeData.light();
  return theme.copyWith(
    primaryColor: CustomColors.dozonOrange,
    colorScheme: ColorScheme.light(
      primary: CustomColors.dozonOrange,
      secondary: CustomColors.dozonGrey,
    ),
    buttonTheme: ButtonThemeData(
      buttonColor: CustomColors.dozonOrange,
      disabledColor: CustomColors.buttonDisabled,
      colorScheme: ColorScheme.light(
        primary: CustomColors.buttonGreen,
      ),
    ),
    secondaryHeaderColor: CustomColors.dozonGrey,
    scaffoldBackgroundColor: CustomColors.oddRow,
    appBarTheme: AppBarTheme(
      backgroundColor: CustomColors.dozonOrange,
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),
  );
}
