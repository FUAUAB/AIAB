import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/presentation/themes/breur_theme.dart';
import 'package:work_order_app/presentation/themes/bus_theme.dart';
import 'package:work_order_app/presentation/themes/didata_theme.dart';
import 'package:work_order_app/presentation/themes/dozon_theme.dart';
import 'package:work_order_app/presentation/themes/jrs_theme.dart';

class ThemeController extends ChangeNotifier {
  static const themePrefKey = 'theme';

  final SharedPreferences sharedPreferences;
  String? _currentTheme;

  ThemeController({required this.sharedPreferences}) {
    _currentTheme = sharedPreferences.getString(themePrefKey) ?? didataTheme;
  }

  String get currentTheme => _currentTheme!;

  void setTheme(String theme) {
    _currentTheme = theme;
    notifyListeners();
    sharedPreferences.setString(themePrefKey, theme);
  }

  static ThemeController of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<ThemeControllerProvider>()
            as ThemeControllerProvider;
    return provider.controller;
  }
}

class ThemeControllerProvider extends InheritedWidget {
  const ThemeControllerProvider({
    required this.controller,
    required Widget child,
  }) : super(child: child);

  final ThemeController controller;

  @override
  bool updateShouldNotify(ThemeControllerProvider old) =>
      controller != old.controller;
}

const String didataTheme = ApiDomains.DIDATA;
const String breurTheme = ApiDomains.BREUR;
const String jrsTheme = ApiDomains.JRS;
const String busTheme = ApiDomains.BUS;
const String dozonTheme = ApiDomains.DOZON;

ThemeData buildCurrentTheme(ThemeController themeController) {
  switch (themeController.currentTheme) {
    case didataTheme:
      return didata();
    case breurTheme:
      return breur();
    case jrsTheme:
      return jrs();
    case busTheme:
      return bus();
    case dozonTheme:
      return dozon();

    default:
      return didata();
  }
}
