import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../styles/colors_style.dart';

class BuildDrowpdownWidget extends StatefulWidget {
  final String? hint;
  final ValueChanged? onChanged;
  final List<String> list;
  final TextStyle? hintstyle;
  final TextStyle? style;
  final bool fill;
  final EdgeInsets? contentpending;
  const BuildDrowpdownWidget(
      {Key? key,
      this.hint,
      this.onChanged,
      required this.list,
      this.hintstyle,
      this.style,
      this.fill = false,
      this.contentpending})
      : super(key: key);

  @override
  State<BuildDrowpdownWidget> createState() => _BuildDrowpdownWidgetState();
}

class _BuildDrowpdownWidgetState extends State<BuildDrowpdownWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.0,
      color: CustomColors.evenRow,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2.0),
        child: DropdownButtonFormField<String>(
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: CustomColors.blackBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CustomColors.blackBorder),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CustomColors.blackBorder),
              ),
              fillColor: Colors.white,
              filled: true,
              contentPadding:
                  EdgeInsets.only(top: 5, bottom: 5, left: 16, right: 5),
              // contentPadding: contentpending ??
              //     EdgeInsets.only(
              //         top: Appdimen.dimen12,
              //         bottom: Appdimen.dimen12,
              //         left: Appdimen.dimen16,
              //         right: Appdimen.dimen16),
              isDense: true),
          dropdownColor: Colors.white,
          isDense: true,
          isExpanded: true,
          icon: Icon(
            FontAwesomeIcons.angleDown,
            color: CustomColors.didataBlue,
          ),
          items: widget.list.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: CustomColors.blackBorder),
              ),
            );
          }).toList(),
          onChanged: widget.onChanged,
          hint: Text(
            'Filter',
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: CustomColors.blackBorder),
          ),
        ),
      ),
    );
  }
}
