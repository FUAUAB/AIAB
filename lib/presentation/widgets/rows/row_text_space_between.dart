import 'package:flutter/material.dart';

import '../../styles/colors_style.dart';

class BuildTextRowSpaceBetween extends StatelessWidget {
  const BuildTextRowSpaceBetween({
    Key? key,
    required this.leftText,
    required this.rightText,
  }) : super(key: key);

  final String leftText;
  final dynamic rightText;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              leftText,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            Text(
              "$rightText",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
