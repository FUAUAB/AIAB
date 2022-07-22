import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/core/helpers/helperMethods.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

import '../../../app_localizations.dart';

class BuildCustomerBlock extends StatefulWidget {
  const BuildCustomerBlock({
    Key? key,
    required this.customer,
  }) : super(key: key);

  final Customer customer;

  @override
  _BuildCustomerBlockState createState() => _BuildCustomerBlockState();
}

class BuildCustomerContactPersonBlock extends StatefulWidget {
  const BuildCustomerContactPersonBlock(this.contactPerson, {Key? key})
      : super(key: key);

  final V111CustomerEmployee contactPerson;

  @override
  _BuildCustomerContactPersonBlockState createState() =>
      _BuildCustomerContactPersonBlockState();
}

class _BuildCustomerBlockState extends State<BuildCustomerBlock> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 15.0, top: 10.0, bottom: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(7.0),
            bottomRight: Radius.circular(7.0),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: Card(
            color: CustomColors.oddRow,
            margin: EdgeInsets.all(2.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(7.0),
                bottomRight: Radius.circular(7.0),
              ),
            ),
            elevation: 0,
            child: Wrap(
              direction: Axis.horizontal,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    customerDetailsBlockTopSection(context),
                    customerDetailsBlockContentRow(
                        context,
                        AppLocalizations.of(context)!
                            .translate('customer.details.adress'),
                        widget.customer.address!.street!,
                        CustomColors.evenRow),
                    customerDetailsBlockContentRow(
                        context,
                        AppLocalizations.of(context)!
                            .translate('customer.details.zipcode'),
                        widget.customer.address!.postalCode!,
                        CustomColors.oddRow),
                    customerDetailsBlockContentRow(
                        context,
                        AppLocalizations.of(context)!
                            .translate('customer.details.place'),
                        widget.customer.address!.city!,
                        CustomColors.evenRow),
                    customerDetailsBlockContentRow(
                        context,
                        AppLocalizations.of(context)!
                            .translate('customer.details.phonenumber'),
                        widget.customer.contactInformation!.phone!,
                        CustomColors.oddRow,
                        TextDecoration.underline,
                        Theme.of(context).colorScheme.primary,
                        true),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container customerDetailsBlockTopSection(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: CustomColors.oddRow,
        borderRadius: BorderRadius.all(
          Radius.circular(7.0),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 6,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                    child: TextButton(
                      child: Text(
                        widget.customer.customerId.toString() +
                            AppLocalizations.of(context)!.translate('minus') +
                            widget.customer.name.toString(),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          customerDetailsRoute,
                          arguments: widget.customer,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          customerDetailsRoute,
                          arguments: widget.customer,
                        );
                      },
                      child: Column(
                        children: [
                          Container(
                            decoration: (BoxDecoration(
                              color: CustomColors.greyIconBackground,
                              borderRadius: BorderRadius.circular(7),
                            )),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                FontAwesomeIcons.info,
                                color: Colors.white,
                                size: (18),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Container customerDetailsBlockContentRow(
    BuildContext context, String name, String value, Color backgroundColor,
    [TextDecoration? textDecoration = TextDecoration.none,
    Color? color = CustomColors.black,
    bool isPhoneNumber = false]) {
  return Container(
    color: backgroundColor,
    child: Row(children: <Widget>[
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
              child: Text(
                name,
                textAlign: TextAlign.left,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                    color: CustomColors.black,
                    backgroundColor: backgroundColor),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            GestureDetector(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 11),
                child: Text(
                  value,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15.0,
                    color: color,
                    decoration: textDecoration,
                    backgroundColor: backgroundColor,
                  ),
                ),
              ),
              onTap: () async {
                isPhoneNumber == true
                    ? performCall(value)
                    : print('not address');
              },
            )
          ],
        ),
      ),
    ]),
  );
}

class _BuildCustomerContactPersonBlockState
    extends State<BuildCustomerContactPersonBlock> {
  @override
  Widget build(BuildContext context) {
    var phoneNum = widget.contactPerson.contactInformation.mobile.isNotEmpty
        ? widget.contactPerson.contactInformation.mobile
        : widget.contactPerson.contactInformation.phone;
    var email = widget.contactPerson.contactInformation.email;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: CustomColors.greyContainerBorder,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(7.0),
          ),
        ),
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            Column(
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
                    child: Container(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  GestureDetector(
                                    child: Text(
                                      widget.contactPerson.firstName.isNotEmpty
                                          ? widget.contactPerson.employeeId
                                                  .toString() +
                                              " - " +
                                              widget.contactPerson.initials +
                                              " " +
                                              widget.contactPerson.firstName +
                                              widget.contactPerson.lastName
                                          : widget.contactPerson.employeeId
                                                  .toString() +
                                              " - " +
                                              widget.contactPerson.initials +
                                              " " +
                                              widget.contactPerson.lastName,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: TITLE_FONT_SIZE,
                                        color: CustomColors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: <Widget>[
                                email.isNotEmpty
                                    ? Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: CustomColors.evenRow,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight:
                                                        Radius.circular(5),
                                                    bottomLeft:
                                                        Radius.circular(5),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.zero,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      if (email.isEmpty) return;
                                                      performEmail(email);
                                                    },
                                                    icon: Icon(
                                                      Icons.mail,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: 22,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 8,
                                      ),
                                SizedBox(
                                  height: 2,
                                ),
                                phoneNum.isNotEmpty
                                    ? Align(
                                        alignment: Alignment.topRight,
                                        child: GestureDetector(
                                          child: Column(
                                            children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  color: CustomColors.evenRow,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(5),
                                                    topLeft: Radius.circular(5),
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets.zero,
                                                  child: IconButton(
                                                    onPressed: () {
                                                      if (phoneNum.isEmpty)
                                                        return;
                                                      performCall(phoneNum);
                                                    },
                                                    icon: Icon(
                                                      FontAwesomeIcons.phone,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .primary,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    : SizedBox(
                                        height: 8,
                                      ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
