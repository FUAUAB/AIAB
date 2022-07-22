import 'package:flutter/material.dart';

import '../../../styles/colors_style.dart';

class BuildRowTableCell extends StatefulWidget {
  const BuildRowTableCell({
    Key? key,
    required this.fieldValue,
    required this.fieldName,
    required this.evenRow,
  }) : super(key: key);

  final dynamic fieldValue;
  final String fieldName;
  final bool evenRow;

  @override
  _BuildRowTableCellState createState() => _BuildRowTableCellState();
}

class _BuildRowTableCellState extends State<BuildRowTableCell> {
  Color _rowColor = CustomColors.evenRow;

  @override
  void initState() {
    super.initState();
    if (widget.evenRow == false) {
      _rowColor = CustomColors.oddRow;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.top,
      children: <TableRow>[
        TableRow(
          children: <Widget>[
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 32,
                width: 32,
                color: _rowColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "${widget.fieldName}",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.top,
              child: Container(
                height: 32,
                width: 32,
                color: _rowColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Text(
                        "${widget.fieldValue}",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
