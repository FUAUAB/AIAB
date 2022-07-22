import 'package:flutter/material.dart';

import '../../../app_localizations.dart';
import '../../Styles/colors_style.dart';

final double fontSize = 14.0;
final double padding = 20.0;

class DetailsBlockTableRow extends StatelessWidget {
  const DetailsBlockTableRow({
    Key? key,
    required this.cellText,
    required this.rowColor,
    required this.cellTitle,
  }) : super(key: key);

  final String cellText;
  final String cellTitle;
  final Color rowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: rowColor,
      child: Row(
        children: [
          Expanded(
            //LEFT SIDE OF TABLE ROW
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: padding, vertical: padding / 2),
                  child: Text(
                    cellTitle,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            //RIGHT SIDE OF TABLE ROW
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: padding, vertical: padding / 2),
                  child: Text(
                    cellText,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsBlockRowDividerTitle extends StatelessWidget {
  const DetailsBlockRowDividerTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.primary,
            width: 2.0,
          ),
        ),
        color: CustomColors.evenRow,
      ),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: padding, vertical: padding / 2),
            child: Text(
              AppLocalizations.of(context)!
                  .translate('add.product.technical.data'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DetailsBlockTableRowExtraDescription extends StatelessWidget {
  const DetailsBlockTableRowExtraDescription({
    Key? key,
    required this.cellText,
    required this.rowColor,
    required this.cellTitle,
  }) : super(key: key);

  final String cellText;
  final String cellTitle;
  final Color rowColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: rowColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: padding, vertical: padding / 2),
                      child: Text(
                        cellTitle,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: padding, vertical: padding / 2),
                        child: Text(
                          cellText,
                          style: TextStyle(
                            fontSize: fontSize,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
