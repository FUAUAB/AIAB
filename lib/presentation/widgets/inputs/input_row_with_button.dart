import 'package:flutter/material.dart';

import '../../Styles/colors_style.dart';

class BuildInputRowWithButton extends StatefulWidget {
  const BuildInputRowWithButton({
    Key? key,
    required this.inputValue,
    required this.fieldName,
    required this.buttonIcon,
  }) : super(key: key);

  final dynamic inputValue;
  final String fieldName;
  final IconData buttonIcon;

  @override
  _BuildInputRowWithButtonState createState() =>
      _BuildInputRowWithButtonState();
}

class _BuildInputRowWithButtonState extends State<BuildInputRowWithButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
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
              flex: 6,
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
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.0),
                          bottomLeft: Radius.circular(7.0),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: CustomColors.greyBorder),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7.0),
                          bottomLeft: Radius.circular(7.0),
                        ),
                      ),
                      contentPadding: EdgeInsets.fromLTRB(10.0, 10.0, 0, 10.0),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              // child: SizedBox(
              //   child: Container(),
              // ),
              flex: 2,
              child: Container(
                child: ConstrainedBox(
                  constraints: BoxConstraints.tightFor(
                    height: 35.0,
                    width: 10.0,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).colorScheme.primary,
                      shadowColor: CustomColors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(7.0),
                          topRight: Radius.circular(7.0),
                        ),
                      ),
                    ),
                    onPressed: () => print('test'),
                    child: Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(
                        widget.buttonIcon,
                        color: CustomColors.white,
                        size: 24,
                      ),
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
