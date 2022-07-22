import 'package:flutter/material.dart';

import '../../../app_localizations.dart';
import '../../styles/colors_style.dart';

class TableBlockWidget extends StatelessWidget {
  //TODO: check and edit to API format
  const TableBlockWidget({
    Key? key,
    required this.id,
    required this.title,
    required this.contextSubject,
    required this.orderId,
    required this.orderDescription,
    required this.status,
    required this.onClicked,
  }) : super(key: key);

  final int id;
  final String title;
  final String contextSubject;
  final int orderId;
  final String orderDescription;
  final String status;
  final VoidCallback onClicked;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
            side: BorderSide(color: CustomColors.greyContainerBorder, width: 1),
            borderRadius: BorderRadius.circular(7.0)),
        child: GestureDetector(
          onTap: onClicked,
          child: Wrap(
            children: [
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                children: <TableRow>[
                  TableRow(
                    decoration: BoxDecoration(
                      color: CustomColors.oddRow,
                    ),
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Container(
                          height: 32,
                          width: 32,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  "$orderId - $orderDescription",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color:
                                        Theme.of(context).colorScheme.primary,
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
              ),
              Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.top,
                columnWidths: const <int, TableColumnWidth>{
                  0: FixedColumnWidth(128),
                  1: FlexColumnWidth(),
                },
                children: <TableRow>[
                  TableRow(
                    decoration: BoxDecoration(
                      color: CustomColors.evenRow,
                    ),
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Container(
                          height: 32,
                          width: 32,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('blocks.status'),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Text(
                                  "$status",
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
                  TableRow(
                    decoration: BoxDecoration(
                      color: CustomColors.oddRow,
                    ),
                    children: <Widget>[
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Container(
                          width: 32,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .translate('blocks.supplier'),
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
                      ),
                      TableCell(
                        verticalAlignment: TableCellVerticalAlignment.top,
                        child: Container(
                          width: 32,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Text(
                                    "$id - $title",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
