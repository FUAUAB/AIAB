import 'package:flutter/material.dart';
import 'package:work_order_app/core/helpers/string_helpers.dart';

import '../../../core/constants/constants.dart';
import '../../styles/colors_style.dart';

class DetailsBlockTableRow extends StatelessWidget {
  const DetailsBlockTableRow({
    Key? key,
    required this.cellText,
    required this.rowColor,
    required this.cellTitle,
    this.isLast,
  }) : super(key: key);

  final String cellText;
  final String cellTitle;
  final Color rowColor;
  final bool? isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: isLast == null
          ? BoxDecoration(color: rowColor)
          : BoxDecoration(
              color: CustomColors.oddRow,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
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
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Text(
                    cellTitle.capitalizeFirstLetter(cellTitle),
                    style: TextStyle(
                      fontSize: TEXT_FONT_SIZE,
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
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Text(
                    cellText.capitalizeFirstLetter(cellText),
                    style: TextStyle(
                      fontSize: TEXT_FONT_SIZE,
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
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Text(
              "Technische Gegevens",
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Text(
                        cellTitle,
                        style: TextStyle(
                          fontSize: TEXT_FONT_SIZE,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: Text(
                          cellText,
                          style: TextStyle(
                            fontSize: TEXT_FONT_SIZE,
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
