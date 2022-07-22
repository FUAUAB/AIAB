import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

AppBar buildAppBarTitleWithSearch(BuildContext context, String title,
    [Widget? searchFieldView]) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    centerTitle: true,
    title: Text(title),
    bottom: PreferredSize(
      preferredSize: Size.fromHeight(50),
      child: searchFieldView!,
    ),
    actions: <Widget>[
      IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(FontAwesomeIcons.caretSquareLeft),
      ),
    ],
  );
}
