import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_order_app/cubit/authentication/authentication_cubit.dart';

import '../../../app_localizations.dart';
import '../../../core/constants/constants.dart';
import '../../styles/colors_style.dart';
import '../../views/authentication/login_page.dart';
import '../buttons/button_colored_elevated.dart';

class NavigationDrawerWidget extends StatelessWidget {
  final AuthenticationCubit cubit = AuthenticationCubit();

  @override
  Widget build(context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).colorScheme.primary,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 0),
          child: ListView(
            children: <Widget>[
              const SizedBox(height: 20),
              _buildMenuItem(
                  text:
                      AppLocalizations.of(context)!.translate('menus.schedule'),
                  icon: FontAwesomeIcons.calendarAlt,
                  tileColor: CustomColors.white,
                  textColor: CustomColors.black,
                  onClicked: () {
                    _selectedMenuItem(context, 0);
                  }),
              const SizedBox(height: 10),
              _buildMenuItem(
                  text: AppLocalizations.of(context)!
                      .translate('work.order.employee.title'),
                  icon: FontAwesomeIcons.clipboardList,
                  tileColor: CustomColors.white,
                  textColor: CustomColors.black,
                  onClicked: () {
                    _selectedMenuItem(context, 2);
                  }),
              const SizedBox(height: 10),
              const Divider(
                height: 30.0,
                thickness: 5,
              ),
              const SizedBox(height: 10),
              _buildMenuItem(
                  text:
                      AppLocalizations.of(context)!.translate('menus.customer'),
                  icon: FontAwesomeIcons.userAlt,
                  tileColor: CustomColors.white,
                  textColor: CustomColors.black,
                  onClicked: () {
                    _selectedMenuItem(context, 1);
                  }),
              const SizedBox(height: 10),
              const Divider(
                height: 30.0,
                thickness: 5,
              ),
              const SizedBox(height: 10),
              _buildMenuItem(
                  text: AppLocalizations.of(context)!
                      .translate('menus.work.orders'),
                  icon: FontAwesomeIcons.clipboardList,
                  tileColor: CustomColors.white,
                  textColor: CustomColors.black,
                  onClicked: () {
                    _selectedMenuItem(context, 3);
                  }),
              const SizedBox(height: 10),
              const Divider(
                height: 30.0,
                thickness: 5,
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 25.0,
              ),
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    BuildColoredElevatedButton(
                      text: AppLocalizations.of(context)!
                          .translate('menus.logout'),
                      buttonColor: Theme.of(context).colorScheme.secondary,
                      fontSize: 18,
                      onClicked: () {
                        cubit.logout();
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) => LoginPage()),
                            (Route<dynamic> route) => false);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required String text,
    required IconData icon,
    final Color? tileColor,
    final Color? textColor,
    VoidCallback? onClicked,
  }) {
    final fontSize = 18.0;

    return ListTile(
      leading: Icon(
        icon,
        color: textColor,
      ),
      title: Text(text, style: TextStyle(color: textColor, fontSize: fontSize)),
      onTap: onClicked,
      tileColor: tileColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  _selectedMenuItem(context, int index) {
    switch (index) {
      case 0:
        Navigator.of(context).pushNamedIfNotCurrent(homeRoute);
        break;
      case 1:
        Navigator.of(context).pushNamedIfNotCurrent(customersRoute);
        break;
      case 2:
        Navigator.of(context).pushNamedIfNotCurrent(workOrdersEmployeeRoute);
        break;
      case 3:
        Navigator.of(context).pushNamedIfNotCurrent(workOrdersRoute);
        break;
    }
  }
}

//Checks for current route. If true, the navigator won't add the same page to the stack, if false: it goes to the selected page.
extension NavigatorStateExtension on NavigatorState {
  void pushNamedIfNotCurrent(String routeName, {Object? arguments}) {
    if (!_isCurrent(routeName)) {
      Navigator.popUntil(context, ModalRoute.withName(homeRoute));
      pushNamed(routeName);
    } else {
      Navigator.of(context).pop();
    }
  }

  bool _isCurrent(String routeName) {
    bool isCurrent = false;
    popUntil((route) {
      if (route.settings.name == routeName) {
        isCurrent = true;
      }
      return true;
    });
    return isCurrent;
  }
}
