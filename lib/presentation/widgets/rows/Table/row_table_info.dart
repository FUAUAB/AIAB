import 'package:flutter/material.dart';

import '../../../styles/colors_style.dart';

class BuildInfoColumn extends StatefulWidget {
  const BuildInfoColumn({
    Key? key,
    required this.fieldName,
    required this.evenRow,
  }) : super(key: key);

  final String fieldName;
  final bool evenRow;

  @override
  _BuildInfoColumnState createState() => _BuildInfoColumnState();
}

class _BuildInfoColumnState extends State<BuildInfoColumn> {
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
                          color: Theme.of(context).colorScheme.primary,
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
