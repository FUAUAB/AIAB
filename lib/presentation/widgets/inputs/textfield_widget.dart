import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import '../../styles/colors_style.dart';

class InputTextFieldWidget extends StatefulWidget {
  final TextEditingController searchController;
  final String hintText;
  final String type;
  final String title;
  final bool isForOrder;
  final String? forType;
  final VoidCallback? onTap;
  final int? orderId;
  final double? searchBarheight;
  final Cubit? bloc;

  const InputTextFieldWidget({
    Key? key,
    required this.searchController,
    required this.hintText,
    required this.type,
    required this.title,
    required this.isForOrder,
    this.forType,
    this.searchBarheight,
    this.onTap,
    this.orderId,
    this.bloc,
  }) : super(key: key);

  @override
  State<InputTextFieldWidget> createState() => _InputTextFieldWidgetState();
}

class _InputTextFieldWidgetState extends State<InputTextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomColors.evenRow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: widget.searchController,
            textAlignVertical: TextAlignVertical.center,
            maxLines: 3,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CustomColors.greyBorder),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: CustomColors.greyBorder),
              ),
              isDense: true,
              contentPadding: EdgeInsets.fromLTRB(5, 5, 5, 5),
              filled: true,
              fillColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
