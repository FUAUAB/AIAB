import 'package:flutter/material.dart';

import '../../../app_localizations.dart';
import '../../Styles/colors_style.dart';

forgotPasswordDialog(context, title) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 180.0,
          width: 350.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 60.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Text(
                          title,
                          style: TextStyle(
                            color: CustomColors.textWhite,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('dialogs.password.change'),
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: MaterialButton(
                        color: Theme.of(context).colorScheme.primary,
                        textColor: Colors.white,
                        onPressed: () => Navigator.pop(context),
                        child: Text(AppLocalizations.of(context)!
                            .translate('dialogs.close')),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

closeAppDialog(context) {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(AppLocalizations.of(context)!.translate('dialogs.app.close')),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(AppLocalizations.of(context)!.translate('dialogs.no')),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(AppLocalizations.of(context)!.translate('dialogs.yes')),
        ),
      ],
    ),
  );
}
