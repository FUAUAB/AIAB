import 'package:bloc/bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/core/responsive/responsive.dart';

import '../../../core/constants/constants.dart';
import '../../styles/colors_style.dart';

class BuildSearchBarFilterWidget extends StatefulWidget {
  BuildSearchBarFilterWidget({
    Key? key,
    required this.hintText,
    required this.title,
    required this.selectedValue,
    required this.onChangedAction,
    required this.items,
    this.forType,
    this.searchBarheight,
    this.onTap,
    this.orderId,
    this.bloc,
  }) : super(key: key);

  final String hintText;
  final String title;
  final String? forType;
  final VoidCallback? onTap;
  final int? orderId;
  final double? searchBarheight;
  final Cubit? bloc;
  final Function(String) onChangedAction;
  final List<dynamic>? items;

  String? selectedValue;

  @override
  _BuildSearchBarFilterWidgetState createState() =>
      _BuildSearchBarFilterWidgetState();
}

class _BuildSearchBarFilterWidgetState
    extends State<BuildSearchBarFilterWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.searchBarheight ?? 60.0,
      color: CustomColors.evenRow,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: Responsive.isMobile(context) ? 3 : 2,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 36.0,
                    ),
                    child: ListTile(
                      title: TextField(
                        readOnly: true,
                        onTap: widget.onTap,
                        textAlignVertical: TextAlignVertical.center,
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          isDense: true,
                          contentPadding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                          suffixIcon: Icon(
                            FontAwesomeIcons.search,
                            color: Theme.of(context).colorScheme.primary,
                            size: 17,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Zoek ' + widget.hintText,
                          hintStyle: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: EdgeInsets.only(right: 10, top: 9),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2(
                        isExpanded: true,
                        hint: Text("Filter op"),
                        value: widget.selectedValue,
                        items: widget.items == null
                            ? null
                            : widget.items!.map(_buildMenuItem).toList(),
                        onChanged: (dynamic newValue) {
                          widget.onChangedAction(newValue);
                          setState(() {
                            widget.selectedValue = newValue;
                          });
                        },
                        icon: const Icon(Icons.arrow_drop_down_outlined),
                        iconSize: 35,
                        iconEnabledColor:
                            Theme.of(context).colorScheme.secondary,
                        iconDisabledColor: Colors.grey,
                        buttonHeight: 38,
                        buttonPadding: const EdgeInsets.only(
                          left: 14,
                          right: 4,
                        ),
                        buttonDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                          color: CustomColors.white,
                        ),
                        buttonElevation: 0,
                        itemPadding: const EdgeInsets.only(
                          left: 14,
                          right: 14,
                        ),
                        // dropdownMaxHeight: 200,
                        dropdownWidth: Responsive.isMobile(context)
                            ? MediaQuery.of(context).size.width / 2
                            : null,
                        dropdownPadding: EdgeInsets.all(10),
                        dropdownDecoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: CustomColors.white,
                        ),
                        scrollbarThickness: 3,
                        scrollbarAlwaysShow: true,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  DropdownMenuItem<dynamic> _buildMenuItem(dynamic item) {
    var menuItemToBuild;
    if (item is String) {
      menuItemToBuild = DropdownMenuItem(
        value: item.toString(),
        child: Text(
          item.toString(),
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: TEXT_FONT_SIZE,
          ),
        ),
      );
    }
    if (item is BranchInformation) {
      menuItemToBuild = DropdownMenuItem(
        value: item.branchId.toString(),
        child: Text(
          "${item.branchId} - ${item.branchName}",
          style: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
            fontSize: TEXT_FONT_SIZE,
          ),
        ),
      );
    }
    return menuItemToBuild;
  }
}
