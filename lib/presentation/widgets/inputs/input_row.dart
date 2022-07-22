import 'package:flutter/material.dart';

import '../../styles/colors_style.dart';

class BuildInputRow extends StatefulWidget {
  const BuildInputRow({
    Key? key,
    required this.inputValue,
    required this.fieldName,
  }) : super(key: key);

  final dynamic inputValue;
  final String fieldName;

  @override
  _BuildInputRowState createState() => _BuildInputRowState();
}

class _BuildInputRowState extends State<BuildInputRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              flex: 3,
              child: Container(
                child: Text(
                  "${widget.fieldName}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Container(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 35.0,
                  ),
                  child: TextFormField(
                    initialValue: "${widget.inputValue}",
                    style: TextStyle(
                      fontSize: 16,
                    ),
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      hintText: "${widget.fieldName}",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.greyBorder),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.greyBorder),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
                      filled: true,
                      fillColor: Colors.white,
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
