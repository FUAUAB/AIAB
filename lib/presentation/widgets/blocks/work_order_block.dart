import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/core/helpers/helperMethods.dart';
import 'package:work_order_app/core/helpers/map_launcher.dart';
import 'package:work_order_app/core/responsive/responsive.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

import '../../../app_localizations.dart';

class BuildWorkOrderDetailsBlock extends StatefulWidget {
  const BuildWorkOrderDetailsBlock({
    Key? key,
    required this.workOrder,
    required this.context,
  }) : super(key: key);

  final V112WorkOrder workOrder;
  final BuildContext context;

  // final ProductCubit productCubit;

  @override
  _BuildWorkOrderDetailsBlockState createState() =>
      _BuildWorkOrderDetailsBlockState();
}

class _BuildWorkOrderDetailsBlockState<WorkOrder>
    extends State<BuildWorkOrderDetailsBlock> {
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    int isOpened = isVisible ? 2 : 0;
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
              children: [
                //Werkorders
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    workOrderDetailsBlockTopSection(context),
                    workOrderDetailsBlockContentSection(context),
                    workOrderDetailsBlockContentHiddenSection(context),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Center(
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  child: RotatedBox(
                                    quarterTurns: isOpened,
                                    child: MaterialButton(
                                      onPressed: () => setState(
                                        () => isVisible = !isVisible,
                                      ),
                                      child: Icon(
                                        FontAwesomeIcons.chevronDown,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary,
                                        size: 18,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IntrinsicHeight workOrderDetailsBlockTopSection(BuildContext context) {
    return IntrinsicHeight(
      child: Responsive.isMobile(context)
          ? Stack(
              children: [
                Container(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      WorkOrderDetailType.selectedImage.clear();
                      Navigator.of(context).pushNamed(
                        workOrderDetailsRoute,
                        arguments: {
                          'workOrder': widget.workOrder,
                        },
                      );
                    },
                    child: Container(
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
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          workOrderDetailsRoute,
                          arguments: {
                            'workOrder': widget.workOrder,
                          },
                        );
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          AppLocalizations.of(context)!
                                  .translate('blocks.work.order') +
                              widget.workOrder.orderId.toString(),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        widget.workOrder.schedule!.startTime == null
                            ? "-"
                            : "Gepland: " +
                                getDateOnly(
                                    widget.workOrder.schedule!.startTime),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: Text(
                        "Gemaakt: " + getDateOnly(widget.workOrder.date),
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18.0, color: CustomColors.black),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Text(
                        widget.workOrder.customerId.toString() +
                            " - " +
                            widget.workOrder.description.toString(),
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            workOrderDetailsRoute,
                            arguments: {
                              'workOrder': widget.workOrder,
                            },
                          );
                        },
                        child: Container(
                          padding: EdgeInsets.only(
                            left: 8,
                            top: 10,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!
                                    .translate('blocks.work.order') +
                                widget.workOrder.orderId.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                          left: 8,
                          bottom: 10,
                        ),
                        child: Text(
                          widget.workOrder.customerId.toString() +
                              " - " +
                              widget.workOrder.description.toString(),
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                widget.workOrder.schedule!.startTime == null
                                    ? "-"
                                    : "Gepland: " +
                                        getDateOnly(widget
                                            .workOrder.schedule!.startTime),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            Container(
                              child: Text(
                                "Gemaakt: " +
                                    getDateOnly(widget.workOrder.date),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 18.0, color: CustomColors.black),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            WorkOrderDetailType.selectedImage.clear();
                            Navigator.of(context).pushNamed(
                              workOrderDetailsRoute,
                              arguments: {
                                'workOrder': widget.workOrder,
                              },
                            );
                          },
                          child: Container(
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
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Container workOrderDetailsBlockContentSection(BuildContext context) {
    var address = widget.workOrder.shippingAddress!.address!.street! +
        " " +
        widget.workOrder.shippingAddress!.address!.houseNumber! +
        " " +
        widget.workOrder.shippingAddress!.address!.houseNumberAddition +
        widget.workOrder.shippingAddress!.address!.city! +
        " " +
        widget.workOrder.shippingAddress!.address!.postalCode!;
    return Container(
      child: Responsive.isMobile(context)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  color: CustomColors.evenRow,
                  child: Row(
                    children: buildNameAndValueForWorkOrderContent(
                        AppLocalizations.of(context)!
                            .translate('blocks.work.order.type'),
                        widget.workOrder.workOrderClass!.description ?? "-",
                        context),
                  ),
                ),
                Container(
                  color: CustomColors.oddRow,
                  child: Row(
                    children: buildNameAndValueForWorkOrderContent(
                        AppLocalizations.of(context)!
                            .translate('blocks.work.order.location'),
                        widget.workOrder.shippingAddress!.address!.street! +
                            " " +
                            widget.workOrder.shippingAddress!.address!
                                .houseNumber! +
                            " " +
                            widget.workOrder.shippingAddress!.address!
                                .houseNumberAddition,
                        context,
                        valueColor: Theme.of(context).colorScheme.primary,
                        isAddress: true,
                        address: address),
                  ),
                ),
                Container(
                  color: CustomColors.oddRow,
                  child: Row(
                    children: buildNameAndValueForWorkOrderContent(
                        "",
                        widget.workOrder.shippingAddress!.address!.city! +
                            " " +
                            widget.workOrder.shippingAddress!.address!
                                .postalCode!,
                        context,
                        valueColor: Theme.of(context).colorScheme.primary,
                        isAddress: true,
                        address: address),
                  ),
                ),
                Container(height: 2.0, color: CustomColors.greyBorder),
                Container(
                  color: CustomColors.evenRow,
                  child: Row(
                    children: buildNameAndValueForWorkOrderContent(
                        AppLocalizations.of(context)!
                            .translate('blocks.work.order.project'),
                        widget.workOrder.projectId.toString() == "null"
                            ? ""
                            : widget.workOrder.projectId.toString() +
                                " - " +
                                widget.workOrder.projectName,
                        context),
                  ),
                ),
                Container(
                  color: CustomColors.oddRow,
                  child: Row(
                    children: buildNameAndValueForWorkOrderContent(
                        AppLocalizations.of(context)!
                            .translate('blocks.work.order.contact'),
                        widget.workOrder.customerReference.toString(),
                        context),
                  ),
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Container(
                        color: CustomColors.evenRow,
                        child: Row(
                          children: buildNameAndValueForWorkOrderContent(
                              AppLocalizations.of(context)!
                                  .translate('blocks.work.order.type'),
                              widget.workOrder.workOrderClass!.description ??
                                  "-",
                              context),
                        ),
                      ),
                      Container(
                        color: CustomColors.oddRow,
                        child: Row(
                          children:
                              buildNameAndValueForWorkOrderContent(
                                  AppLocalizations.of(context)!
                                      .translate('blocks.work.order.location'),
                                  widget.workOrder.shippingAddress!.address!
                                          .street! +
                                      " " +
                                      widget.workOrder.shippingAddress!.address!
                                          .houseNumber! +
                                      " " +
                                      widget.workOrder.shippingAddress!.address!
                                          .houseNumberAddition,
                                  context,
                                  valueColor:
                                      Theme.of(context).colorScheme.primary,
                                  isAddress: true,
                                  address: address),
                        ),
                      ),
                      Container(
                        color: CustomColors.oddRow,
                        child: Row(
                          children: buildNameAndValueForWorkOrderContent(
                              "",
                              widget.workOrder.shippingAddress!.address!.city! +
                                  " " +
                                  widget.workOrder.shippingAddress!.address!
                                      .postalCode!,
                              context,
                              valueColor: Theme.of(context).colorScheme.primary,
                              isAddress: true,
                              address: address),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        child: VerticalDivider(
                          thickness: 1.5,
                          color: CustomColors.greyBorder,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    children: [
                      Container(
                        color: CustomColors.evenRow,
                        child: Row(
                          children: buildNameAndValueForWorkOrderContent(
                              AppLocalizations.of(context)!
                                  .translate('blocks.work.order.project'),
                              widget.workOrder.projectId.toString() == "null"
                                  ? ""
                                  : widget.workOrder.projectId.toString() +
                                      " - " +
                                      widget.workOrder.projectName,
                              context),
                        ),
                      ),
                      Container(
                        color: CustomColors.oddRow,
                        child: Row(
                          children: buildNameAndValueForWorkOrderContent(
                              AppLocalizations.of(context)!
                                  .translate('blocks.work.order.contact'),
                              widget.workOrder.customerReference.toString(),
                              context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Container workOrderDetailsBlockContentHiddenSection(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Visibility(
            visible: isVisible,
            child: Responsive.isMobile(context)
                ? Column(
                    children: <Widget>[
                      Container(
                        color: CustomColors.evenRow,
                        child: Row(
                          children: buildNameAndValueForWorkOrderContent(
                              AppLocalizations.of(context)!
                                  .translate('blocks.work.order.reference'),
                              widget.workOrder.customerReference.toString(),
                              context),
                        ),
                      ),
                      Container(
                        color: CustomColors.oddRow,
                        child: Row(
                          children: buildNameAndValueForWorkOrderContent(
                              AppLocalizations.of(context)!
                                  .translate('blocks.work.order.responsible'),
                              widget.workOrder.responsibleEmployeeId
                                          .toString() ==
                                      "null"
                                  ? ""
                                  : widget.workOrder.responsibleEmployeeId
                                          .toString() +
                                      " - " +
                                      widget.workOrder.responsibleEmployeeName,
                              context),
                        ),
                      ),
                      Container(height: 2.0, color: CustomColors.greyBorder),
                      Container(
                        color: CustomColors.evenRow,
                        child: Row(
                          children: buildNameAndValueForWorkOrderContent(
                              AppLocalizations.of(context)!.translate(
                                  'blocks.work.order.customerOrderNumber'),
                              widget.workOrder.customerOrderNumber.toString(),
                              context),
                        ),
                      ),
                      Container(
                        color: CustomColors.oddRow,
                        child: Row(
                          children: buildNameAndValueForWorkOrderContent(
                              "", "", context),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: <Widget>[
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Container(
                              color: CustomColors.evenRow,
                              child: Row(
                                children: buildNameAndValueForWorkOrderContent(
                                    AppLocalizations.of(context)!.translate(
                                        'blocks.work.order.reference'),
                                    widget.workOrder.customerReference
                                        .toString(),
                                    context),
                              ),
                            ),
                            Container(
                              color: CustomColors.oddRow,
                              child: Row(
                                children: buildNameAndValueForWorkOrderContent(
                                    AppLocalizations.of(context)!.translate(
                                        'blocks.work.order.responsible'),
                                    widget.workOrder.responsibleEmployeeId
                                                .toString() ==
                                            "null"
                                        ? ""
                                        : widget.workOrder.responsibleEmployeeId
                                                .toString() +
                                            " - " +
                                            widget.workOrder
                                                .responsibleEmployeeName,
                                    context),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 0,
                        child: Column(
                          children: [
                            Container(
                              height: 75,
                              child: VerticalDivider(
                                thickness: 1.5,
                                color: CustomColors.greyBorder,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Column(
                          children: [
                            Container(
                              color: CustomColors.evenRow,
                              child: Row(
                                children: buildNameAndValueForWorkOrderContent(
                                    AppLocalizations.of(context)!.translate(
                                        'blocks.work.order.customerOrderNumber'),
                                    widget.workOrder.customerOrderNumber
                                        .toString(),
                                    context),
                              ),
                            ),
                            Container(
                              color: CustomColors.oddRow,
                              child: Row(
                                children: buildNameAndValueForWorkOrderContent(
                                    "", "", context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
          )
        ],
      ),
    );
  }
}

buildNameAndValueForWorkOrderContent(
    String name, String value, BuildContext context,
    {Color valueColor = CustomColors.black,
    bool isAddress = false,
    String address = ""}) {
  return <Widget>[
    Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Text(
              name,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                  color: CustomColors.black),
            ),
          ),
        ],
      ),
    ),
    Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: GestureDetector(
              child: RichText(
                text: TextSpan(
                  text: value,
                  style: TextStyle(fontSize: 15.0, color: valueColor),
                ),
              ),
              onTap: () async {
                isAddress == true
                    ? MapsLauncher.launchQuery(address)
                    : print('not address');
              },
            ),
          ),
        ],
      ),
    ),
  ];
}
