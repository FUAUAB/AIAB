import 'package:flutter/material.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

class BuildOrderTitleWidget extends StatelessWidget {
  const BuildOrderTitleWidget(
      {Key? key, required this.title, required this.data})
      : super(key: key);

  final String title;
  final Map data;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.evenRow,
        border: Border(
          bottom: BorderSide(color: CustomColors.greyBorder),
        ),
      ),
      height: 80,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25, vertical: 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Text(
                  title + ': ' + data['id'].toString(),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Text(
                  data['description'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
