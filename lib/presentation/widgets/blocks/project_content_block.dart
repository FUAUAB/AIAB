import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mavis_api_client/api.dart';

import '../../../app_localizations.dart';
import '../../../core/constants/constants.dart';
import '../../Styles/colors_style.dart';
import '../table/details_block_table_row.dart';

class ProjectContentBlock extends StatefulWidget {
  final Project project;

  const ProjectContentBlock({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  State<ProjectContentBlock> createState() => _ProjectContentBlockState();
}

class _ProjectContentBlockState extends State<ProjectContentBlock> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: CustomColors.oddRow,
      margin: EdgeInsets.all(2.0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: CustomColors.greyContainerBorder,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(7.0),
      ),
      elevation: 0,
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: CustomColors.oddRow,
                borderRadius: BorderRadius.all(
                  Radius.circular(7.0),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                          child: Text(
                            widget.project.name,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: TITLE_FONT_SIZE,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            DetailsBlockTableRow(
              rowColor: CustomColors.evenRow,
              cellTitle: "Adres",
              cellText: widget.project.address.street,
            ),
            DetailsBlockTableRow(
              rowColor: CustomColors.oddRow,
              cellTitle: "Streetname",
              cellText: widget.project.address.streetName,
            ),
            DetailsBlockTableRow(
              rowColor: CustomColors.evenRow,
              cellTitle: "Housenumber",
              cellText: widget.project.address.houseNumber,
            ),
            DetailsBlockTableRow(
              rowColor: CustomColors.oddRow,
              cellTitle: "Postcode",
              cellText: widget.project.address.postalCode,
            ),
            DetailsBlockTableRow(
              rowColor: CustomColors.evenRow,
              cellTitle: "Plaats",
              cellText: widget.project.address.city,
            ),
            DetailsBlockTableRow(
              rowColor: CustomColors.oddRow,
              cellTitle: "Telefoonnummer",
              cellText: widget.project.contactInformation.phone,
              // isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}
