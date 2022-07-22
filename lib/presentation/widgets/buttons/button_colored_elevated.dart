import 'package:flutter/material.dart';

class BuildColoredElevatedButton extends StatefulWidget {
  const BuildColoredElevatedButton({
    Key? key,
    required this.text,
    required this.buttonColor,
    required this.fontSize,
    required this.onClicked,
  }) : super(key: key);

  final String text;
  final Color buttonColor;
  final double fontSize;
  final VoidCallback? onClicked;

  @override
  _BuildColoredElevatedButtonState createState() =>
      _BuildColoredElevatedButtonState();
}

class _BuildColoredElevatedButtonState
    extends State<BuildColoredElevatedButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onClicked,
      child: Text(
        "${widget.text}",
        style: TextStyle(
          fontSize: widget.fontSize,
        ),
      ),
      style: ElevatedButton.styleFrom(
        primary: widget.buttonColor,
      ),
    );
  }
}
