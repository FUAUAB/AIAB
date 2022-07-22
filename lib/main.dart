import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/core/helpers/bloc_observer.dart';
import 'package:work_order_app/core/helpers/theme_controller.dart';
import 'package:work_order_app/locator.dart' as dependencyInjection;

import 'app_localizations.dart';
import 'core/helpers/route_generator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dependencyInjection.init();
  await FlutterDownloader.initialize(ignoreSsl: true);
  final sharedPreferences = await SharedPreferences.getInstance();
  final themeController = ThemeController(sharedPreferences: sharedPreferences);

  BlocOverrides.runZoned(
    () {
      runApp(WorkOrderApp(themeController));
    },
    blocObserver: SimpleBlocObserver(),
  );
}

//USED FOR DEVELOPMENT ONLY. DELETE WHEN GOING LIVE!
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

class WorkOrderApp extends StatefulWidget {
  final ThemeController themeController;

  const WorkOrderApp(this.themeController, {Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<WorkOrderApp> {
  final RouteGenerator _routeGenerator = RouteGenerator();

  @override
  Widget build(BuildContext context) {
    var themeController = widget.themeController;
    return AnimatedBuilder(
      animation: themeController,
      builder: (context, _) {
        return ThemeControllerProvider(
          controller: themeController,
          child: MaterialApp(
            title: "Work Order app",
            debugShowCheckedModeBanner: false,
            onGenerateRoute: _routeGenerator.generateRoute,
            supportedLocales: [
              Locale('nl', ''),
            ],
            // These delegates make sure that the localization data for the proper language is loaded
            localizationsDelegates: [
              // THIS CLASS WILL BE ADDED LATER
              // A class which loads the translations from JSON files
              AppLocalizations.delegate,
              // Built-in localization of basic text for Material widgets
              GlobalMaterialLocalizations.delegate,

              GlobalCupertinoLocalizations.delegate,
              DefaultWidgetsLocalizations.delegate,
              // Built-in localization for text direction LTR/RTL
              GlobalWidgetsLocalizations.delegate,
            ],
            // Returns a locale which will be used by the app
            localeResolutionCallback: (locale, supportedLocales) {
              // Check if the current device locale is supported
              for (var supportedLocale in supportedLocales) {
                if (supportedLocale.languageCode == locale?.languageCode &&
                    supportedLocale.countryCode == locale?.countryCode) {
                  return supportedLocale;
                }
              }
              // If the locale of the device is not supported, use the first one
              // from the list (English, in this case).
              return supportedLocales.first;
            },
            theme: buildCurrentTheme(themeController),
            initialRoute: loadingRoute,
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _routeGenerator.dispose();
    super.dispose();
  }
}
