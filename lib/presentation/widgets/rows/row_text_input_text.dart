import 'package:flutter/material.dart';

import '../../styles/colors_style.dart';

class BuildRowTextInputText extends StatefulWidget {
  const BuildRowTextInputText({
    Key? key,
    required this.leftTextValue,
    required this.inputValue,
    required this.rightTextValue,
    required this.color,
    required this.controller,
  }) : super(key: key);

  final String leftTextValue;
  final String inputValue;
  final String rightTextValue;
  final Color color;
  final TextEditingController controller;

  @override
  _BuildRowTextInputTextState createState() => _BuildRowTextInputTextState();
}

class _BuildRowTextInputTextState extends State<BuildRowTextInputText> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                child: Text(
                  "${widget.leftTextValue}",
                  style: TextStyle(
                    fontSize: 15.0,
                    color: CustomColors.textBlack,
                  ),
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 1,
              child: Container(
                height: 30,
                child: TextFormField(
                  textAlign: TextAlign.end,
                  controller: widget.controller,
                  keyboardType: TextInputType.number,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.blackBorder,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: CustomColors.blackBorder,
                      ),
                    ),
                    contentPadding: EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ),
            Spacer(),
            Expanded(
              flex: 1,
              child: Container(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${widget.rightTextValue}",
                    style: TextStyle(
                      fontSize: 15.0,
                      color: CustomColors.textBlack,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
