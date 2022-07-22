import 'package:flutter/material.dart';

import '../../styles/colors_style.dart';

class BuildColoredElevatedIconButton extends StatefulWidget {
  const BuildColoredElevatedIconButton({
    Key? key,
    required this.text,
    required this.icon,
    required this.iconSize,
    required this.buttonColor,
    required this.fontSize,
    required this.onClicked,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final double iconSize;
  final Color buttonColor;
  final double fontSize;
  final VoidCallback? onClicked;

  @override
  _BuildColoredElevatedIconButtonState createState() =>
      _BuildColoredElevatedIconButtonState();
}

class _BuildColoredElevatedIconButtonState
    extends State<BuildColoredElevatedIconButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onClicked,
      style: ElevatedButton.styleFrom(
        primary: widget.buttonColor,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(
            widget.icon,
            color: CustomColors.textWhite,
            size: widget.iconSize,
          ),
          SizedBox(width: 1.8),
          Text(
            '${widget.text}',
            style: TextStyle(
              fontSize: widget.fontSize,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
