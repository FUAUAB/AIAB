import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/core/helpers/helperMethods.dart';
import 'package:work_order_app/core/responsive/responsive.dart';
import 'package:work_order_app/cubit/work_order/work_order_cubit.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';
import 'package:work_order_app/presentation/widgets/dialogs/dialog_notification.dart';
import 'package:work_order_app/presentation/widgets/generics/build_state.dart';
import 'package:work_order_app/presentation/widgets/table/details_block_table_row.dart';

import '../../../app_localizations.dart';

class WorkOrderBlockCosts extends StatefulWidget {
  const WorkOrderBlockCosts(
      {Key? key,
      required this.workOrderDetail,
      required this.workOrder,
      required this.costTypesList})
      : super(key: key);

  final V112WorkOrderDetail? workOrderDetail;
  final V112WorkOrder? workOrder;
  final List<CostType> costTypesList;

  @override
  _WorkOrderBlockCostsState createState() => _WorkOrderBlockCostsState();
}

class WorkOrderBlockText extends StatefulWidget {
  const WorkOrderBlockText(
      {Key? key,
      required this.workOrderDetail,
      required this.workOrder,
      required this.workOrderCubit})
      : super(key: key);

  final V112WorkOrderDetail? workOrderDetail;
  final V112WorkOrder? workOrder;
  final WorkOrderCubit? workOrderCubit;

  @override
  _WorkOrderBlockTextState createState() => _WorkOrderBlockTextState();
}

class WorkOrderBlockHours extends StatefulWidget {
  const WorkOrderBlockHours(
      {Key? key,
      required this.workOrderDetail,
      required this.workOrder,
      this.workOrderCubit})
      : super(key: key);

  final V112WorkOrderDetail? workOrderDetail;
  final V112WorkOrder? workOrder;
  final WorkOrderCubit? workOrderCubit;

  @override
  _WorkOrderBlockHoursState createState() => _WorkOrderBlockHoursState();
}

class WorkOrderBlockArticle extends StatefulWidget {
  const WorkOrderBlockArticle(
      {Key? key,
      required this.workOrderDetail,
      required this.workOrder,
      this.workOrderCubit})
      : super(key: key);

  final V112WorkOrderDetail? workOrderDetail;
  final V112WorkOrder? workOrder;
  final WorkOrderCubit? workOrderCubit;

  @override
  _WorkOrderBlockArticleState createState() => _WorkOrderBlockArticleState();
}

class WorkOrderAddBlockArticle extends StatefulWidget {
  const WorkOrderAddBlockArticle(
      {Key? key,
      required this.selectedProducts,
      required this.deleteProductFromSearchedList,
      required this.updateSelectedProductQuantity})
      : super(key: key);

  final Product? selectedProducts;
  final ValueChanged<String>? deleteProductFromSearchedList;
  final ValueChanged<List<dynamic>>? updateSelectedProductQuantity;

  @override
  _WorkOrderAddBlockArticleState createState() =>
      _WorkOrderAddBlockArticleState();
}

class _WorkOrderAddBlockArticleState extends State<WorkOrderAddBlockArticle> {
  TextEditingController quantityTextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecorationWorkOrderDetailsBlockMain(),
      child: Column(
        children: [
          //-------------ICON LEFT TOP CORNER--------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: [
                    buildIconWorkOrderDetailsBlock(
                      FontAwesomeIcons.cube,
                      Theme.of(context).colorScheme.primary,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildTitleWorkOrderDetailsBlock(
                            widget.selectedProducts!.description.first),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildContentWorkOrderDetailsBlock(
                            widget.selectedProducts!.productId == null
                                ? "-"
                                : "ProductId: " +
                                    widget.selectedProducts!.productId! +
                                    " - EAN: " +
                                    widget.selectedProducts!.ean!),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 20,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                            color: Theme.of(context).colorScheme.primary,
                            text: AppLocalizations.of(context)!
                                .translate('blocks.quantity')),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: addEditQuantityInput(
                              widget.selectedProducts!.productId,
                              quantityTextController,
                              "add",
                              "1",
                              context,
                              widget.updateSelectedProductQuantity,
                              null),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: <Widget>[
                    buildRowDeleteIconsWorkOrderDetailBlock(
                        context,
                        widget.selectedProducts!.description.first,
                        null,
                        null,
                        null,
                        widget.selectedProducts!.productId,
                        "product",
                        widget.deleteProductFromSearchedList,
                        null,
                        null),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkOrderBlockArticleState extends State<WorkOrderBlockArticle> {
  TextEditingController quantityTextController = new TextEditingController();

  WorkOrderDetailChangeRequest workOrderDetailChangeRequest =
      new WorkOrderDetailChangeRequest();
  V112WorkOrder workOrder = new V112WorkOrder();

  var newQuantity;

  updateEditSelectedProductQuantity(double selectedProductQuantity) {
    setState(() {
      newQuantity = selectedProductQuantity;
    });
  }

  @override
  void initState() {
    super.initState();
    workOrder = widget.workOrder!;
    workOrderDetailChangeRequest.branchId = workOrder.branchId;
    workOrderDetailChangeRequest.companyId = workOrder.companyId;
    workOrderDetailChangeRequest.orderId = workOrder.orderId;
    newQuantity = widget.workOrderDetail!.product!.quantityRequired;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecorationWorkOrderDetailsBlockMain(),
      child: Column(
        children: [
          //-------------ICON LEFT TOP CORNER--------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: [
                    buildIconWorkOrderDetailsBlock(
                      FontAwesomeIcons.cube,
                      Theme.of(context).colorScheme.primary,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildTitleWorkOrderDetailsBlock(
                            widget.workOrderDetail!.description!),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildContentWorkOrderDetailsBlock(
                          widget.workOrderDetail!.product!.productId == null
                              ? "-"
                              : "ArtikelNr: " +
                                  widget.workOrderDetail!.product!.productId!,
                        ),
                      ],
                    ),
                    Responsive.isMobile(context)
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 0.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      AppLocalizations.of(context)!
                                          .translate('blocks.quantity'),
                                      style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontSize: fontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    addEditQuantityInput(
                                        null,
                                        quantityTextController,
                                        "edit",
                                        widget.workOrderDetail!.product!
                                            .quantityRequired
                                            .toStringAsFixed(0),
                                        context,
                                        null,
                                        updateEditSelectedProductQuantity),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              ),
              Responsive.isMobile(context)
                  ? SizedBox()
                  : Align(
                      alignment: Alignment.centerRight,
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 100,
                                child:
                                    buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: AppLocalizations.of(context)!
                                            .translate('blocks.quantity')),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              SizedBox(
                                width: 100,
                                child: addEditQuantityInput(
                                    null,
                                    quantityTextController,
                                    "edit",
                                    widget.workOrderDetail!.product!
                                        .quantityRequired
                                        .toStringAsFixed(0),
                                    context,
                                    null,
                                    updateEditSelectedProductQuantity),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              Container(
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //LEFT SIDE OF TABLE ROW
                      children: <Widget>[
                        Container(
                          decoration: buildBoxDecorationWorkOrderEditIcons(),
                          child: IconButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            onPressed: () {
                              var workOrderProduct = WorkOrderProduct();
                              widget.workOrderDetail!.product!
                                  .quantityRequired = newQuantity;
                              workOrderProduct =
                                  widget.workOrderDetail!.product!;
                              workOrderDetailChangeRequest.product =
                                  workOrderProduct;
                              workOrderDetailChangeRequest.orderLineId =
                                  widget.workOrderDetail!.orderLineId;
                              workOrderDetailChangeRequest.orderSubLineId =
                                  widget.workOrderDetail!.orderSubLineId;
                              workOrderDetailChangeRequest.lineType =
                                  widget.workOrderDetail!.lineType.toString();
                              editProductDialogNotification(
                                  context,
                                  AppLocalizations.of(context)!
                                      .translate('dialogs.product.edit'),
                                  newQuantity.toStringAsFixed(0),
                                  workOrderDetailChangeRequest,
                                  "product");
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            iconSize: 35,
                          ),
                        ),
                      ],
                    ),
                    buildRowDeleteIconsWorkOrderDetailBlock(
                        context,
                        widget.workOrderDetail!.description.toString(),
                        widget.workOrderDetail!.orderLineId,
                        widget.workOrderDetail!.orderSubLineId,
                        widget.workOrderDetail!.orderId,
                        null,
                        "workOrder",
                        null,
                        widget.workOrder!.companyId,
                        widget.workOrder!.branchId),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkOrderBlockCostsState extends State<WorkOrderBlockCosts> {
  double fontSize = 15;
  bool isVisible = false;
  WorkOrderDetailChangeRequest workOrderDetailChangeRequest =
      new WorkOrderDetailChangeRequest();
  V112WorkOrder workOrder = new V112WorkOrder();
  List<CostType> costTypesList = <CostType>[];
  CostDetail _selectedCostValue = new CostDetail();

  @override
  void initState() {
    super.initState();
    workOrder = widget.workOrder!;
    workOrderDetailChangeRequest.branchId = workOrder.branchId;
    workOrderDetailChangeRequest.companyId = workOrder.companyId;
    workOrderDetailChangeRequest.orderId = workOrder.orderId;
    _selectedCostValue = widget.workOrderDetail!.cost;
    costTypesList = widget.costTypesList;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecorationWorkOrderDetailsBlockMain(),
      child: Column(
        children: [
          //-------------ICON LEFT TOP CORNER--------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: [
                    buildIconWorkOrderDetailsBlock(
                      FontAwesomeIcons.euroSign,
                      Theme.of(context).colorScheme.secondary,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildTitleWorkOrderDetailsBlock("Omschrijving:"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildContentWorkOrderDetailsBlock(
                            widget.workOrderDetail!.description!),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: [
                    Row(
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                          width: 20,
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                            color: Theme.of(context).colorScheme.primary,
                            text: ""),
                        buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                            color: Theme.of(context).colorScheme.primary,
                            text: ""),
                        buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                            color: Theme.of(context).colorScheme.primary,
                            text: AppLocalizations.of(context)!
                                .translate('total')),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                            vertical: 5.0,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.black,
                            text: ""),
                        buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                            vertical: 5.0,
                            fontWeight: FontWeight.normal,
                            color: CustomColors.black,
                            text: ""),
                        buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                          vertical: 5.0,
                          fontWeight: FontWeight.normal,
                          color: CustomColors.black,
                          text: AppLocalizations.of(context)!
                                  .translate('euro.icon') +
                              widget.workOrderDetail!.cost!.amount.value
                                  .toString(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //LEFT SIDE OF TABLE ROW
                      children: <Widget>[
                        Container(
                          decoration: buildBoxDecorationWorkOrderEditIcons(),
                          child: IconButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            onPressed: () => {
                              workOrderDetailChangeRequest.orderLineId =
                                  widget.workOrderDetail!.orderLineId,
                              workOrderDetailChangeRequest.cost =
                                  widget.workOrderDetail!.cost,
                              editWorkOrderCostDialog(
                                  context,
                                  "edit",
                                  workOrderDetailChangeRequest,
                                  "cost",
                                  costTypesList,
                                  _selectedCostValue.costId),
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            iconSize: 35,
                          ),
                        ),
                      ],
                    ),
                    buildRowDeleteIconsWorkOrderDetailBlock(
                        context,
                        widget.workOrderDetail!.description.toString(),
                        widget.workOrderDetail!.orderLineId,
                        widget.workOrderDetail!.orderSubLineId,
                        widget.workOrderDetail!.orderId,
                        null,
                        "workOrder",
                        null,
                        widget.workOrder!.companyId,
                        widget.workOrder!.branchId),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkOrderBlockTextState extends State<WorkOrderBlockText> {
  double fontSize = 15;
  bool isVisible = false;
  WorkOrderDetailChangeRequest workOrderDetailChangeRequest =
      new WorkOrderDetailChangeRequest();
  V112WorkOrder workOrder = new V112WorkOrder();

  @override
  void initState() {
    super.initState();
    workOrder = widget.workOrder!;

    workOrderDetailChangeRequest.branchId = workOrder.branchId;
    workOrderDetailChangeRequest.companyId = workOrder.companyId;
    workOrderDetailChangeRequest.orderId = workOrder.orderId;
  }

  @override
  Widget build(BuildContext context) {
    double marginLeft = 0;
    widget.workOrderDetail!.orderSubLineId != 0
        ? marginLeft = 15
        : marginLeft = 0;
    return Container(
      margin: EdgeInsets.only(left: marginLeft, top: 0),
      decoration: buildBoxDecorationWorkOrderDetailsBlockMain(),
      child: Column(
        children: [
          //-------------ICON LEFT TOP CORNER--------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 1,
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: [
                    widget.workOrderDetail!.orderSubLineId == 0
                        ? buildIconWorkOrderDetailsBlock(
                            FontAwesomeIcons.solidEdit, CustomColors.turquoise)
                        : buildEmpty(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildContentWorkOrderDetailsBlock(
                            widget.workOrderDetail!.description! == null
                                ? "..."
                                : widget.workOrderDetail!.description!),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //LEFT SIDE OF TABLE ROW
                      children: <Widget>[
                        Container(
                          decoration: buildBoxDecorationWorkOrderEditIcons(),
                          child: IconButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            onPressed: () => {
                              workOrderDetailChangeRequest.orderLineId =
                                  widget.workOrderDetail!.orderLineId,
                              workOrderDetailChangeRequest.orderSubLineId =
                                  widget.workOrderDetail!.orderSubLineId,
                              workOrderDetailChangeRequest.description =
                                  widget.workOrderDetail!.description,
                              editWorkOrderTextDialog(
                                  context,
                                  "Werkorder tekst aanpassen",
                                  workOrderDetailChangeRequest,
                                  "text"),
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            iconSize: 35,
                          ),
                        ),
                      ],
                    ),
                    buildRowDeleteIconsWorkOrderDetailBlock(
                        context,
                        widget.workOrderDetail!.description.toString(),
                        widget.workOrderDetail!.orderLineId,
                        widget.workOrderDetail!.orderSubLineId,
                        widget.workOrderDetail!.orderId,
                        null,
                        "workOrder",
                        null,
                        widget.workOrder!.companyId,
                        widget.workOrder!.branchId),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WorkOrderBlockHoursState extends State<WorkOrderBlockHours> {
  double fontSize = 15;
  bool isVisible = false;
  WorkOrderDetailChangeRequest workOrderDetailChangeRequest =
      new WorkOrderDetailChangeRequest();
  V112WorkOrder workOrder = new V112WorkOrder();

  @override
  void initState() {
    super.initState();
    workOrder = widget.workOrder!;

    workOrderDetailChangeRequest.branchId = workOrder.branchId;
    workOrderDetailChangeRequest.companyId = workOrder.companyId;
    workOrderDetailChangeRequest.orderId = workOrder.orderId;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: buildBoxDecorationWorkOrderDetailsBlockMain(),
      child: Column(
        children: [
          //-------------ICON LEFT TOP CORNER--------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 5,
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: [
                    buildIconWorkOrderDetailsBlock(
                        FontAwesomeIcons.solidClock, CustomColors.buttonGreen),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        buildTitleWorkOrderDetailsBlock(
                            widget.workOrderDetail!.hours!.job!.description!),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildContentWorkOrderDetailsBlock(widget
                                    .workOrderDetail!.hours!.startTime ==
                                null
                            ? "-"
                            : getDateOnly(
                                    widget.workOrderDetail!.hours!.startTime) +
                                " " +
                                getHoursMinutes(
                                    widget.workOrderDetail!.hours!.startTime,
                                    "both") +
                                " - " +
                                getHoursMinutes(
                                    widget.workOrderDetail!.hours!.endTime,
                                    "both")),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        buildContentWorkOrderDetailsBlock(widget
                                .workOrderDetail!.hours!.employeeId
                                .toString() +
                            " - " +
                            widget.workOrderDetail!.hours!.employeeName),
                      ],
                    ),
                    Responsive.isMobile(context)
                        ? Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: [
                                Row(
                                  children: <Widget>[
                                    buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: AppLocalizations.of(context)!
                                            .translate('blocks.quantity')),
                                    buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: AppLocalizations.of(context)!
                                            .translate('price')),
                                    buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        text: AppLocalizations.of(context)!
                                            .translate('total')),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                      vertical: 5.0,
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.black,
                                      text: widget.workOrderDetail!.hours!
                                                  .startTime ==
                                              null
                                          ? "-"
                                          : getTotalWorkHours(
                                                      widget.workOrderDetail!
                                                          .hours!.startTime
                                                          .toString(),
                                                      widget.workOrderDetail!
                                                          .hours!.endTime
                                                          .toString())
                                                  .toString() +
                                              " uur",
                                    ),
                                    buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                      vertical: 5.0,
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.black,
                                      text: widget.workOrderDetail!.hours!.job!
                                                  .hourlyRate !=
                                              null
                                          ? "€" +
                                              widget.workOrderDetail!.hours!
                                                  .job!.hourlyRate!
                                                  .toStringAsFixed(2)
                                          : "-",
                                    ),
                                    buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                      vertical: 5.0,
                                      fontWeight: FontWeight.normal,
                                      color: CustomColors.black,
                                      text: widget.workOrderDetail!.hours!.job!
                                                  .hourlyRate !=
                                              null
                                          ? "€" +
                                              (widget.workOrderDetail!.hours!
                                                          .job!.hourlyRate *
                                                      getTotalWorkHours(
                                                          widget
                                                              .workOrderDetail!
                                                              .hours!
                                                              .startTime
                                                              .toString(),
                                                          widget
                                                              .workOrderDetail!
                                                              .hours!
                                                              .endTime
                                                              .toString()))
                                                  .toStringAsFixed(2)
                                          : "-",
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
              Responsive.isMobile(context)
                  ? SizedBox()
                  : Expanded(
                      flex: 6,
                      //LEFT SIDE OF TABLE ROW
                      child: Column(
                        children: [
                          Row(
                            children: <Widget>[
                              SizedBox(
                                height: 20,
                                width: 20,
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                  color: Theme.of(context).colorScheme.primary,
                                  text: AppLocalizations.of(context)!
                                      .translate('blocks.quantity')),
                              buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                  color: Theme.of(context).colorScheme.primary,
                                  text: AppLocalizations.of(context)!
                                      .translate('price')),
                              buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                  color: Theme.of(context).colorScheme.primary,
                                  text: AppLocalizations.of(context)!
                                      .translate('total')),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                vertical: 5.0,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.black,
                                text:
                                    widget.workOrderDetail!.hours!.startTime ==
                                            null
                                        ? "-"
                                        : getTotalWorkHours(
                                                    widget.workOrderDetail!
                                                        .hours!.startTime
                                                        .toString(),
                                                    widget.workOrderDetail!
                                                        .hours!.endTime
                                                        .toString())
                                                .toString() +
                                            " uur",
                              ),
                              buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                vertical: 5.0,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.black,
                                text: widget.workOrderDetail!.hours!.job!
                                            .hourlyRate !=
                                        null
                                    ? "€" +
                                        widget.workOrderDetail!.hours!.job!
                                            .hourlyRate!
                                            .toStringAsFixed(2)
                                    : "-",
                              ),
                              buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
                                vertical: 5.0,
                                fontWeight: FontWeight.normal,
                                color: CustomColors.black,
                                text: widget.workOrderDetail!.hours!.job!
                                            .hourlyRate !=
                                        null
                                    ? "€" +
                                        (widget.workOrderDetail!.hours!.job!
                                                    .hourlyRate *
                                                getTotalWorkHours(
                                                    widget.workOrderDetail!
                                                        .hours!.startTime
                                                        .toString(),
                                                    widget.workOrderDetail!
                                                        .hours!.endTime
                                                        .toString()))
                                            .toStringAsFixed(2)
                                    : "-",
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              Container(
                //LEFT SIDE OF TABLE ROW
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      //LEFT SIDE OF TABLE ROW
                      children: <Widget>[
                        Container(
                          decoration: buildBoxDecorationWorkOrderEditIcons(),
                          child: IconButton(
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            onPressed: () => {
                              workOrderDetailChangeRequest.orderLineId =
                                  widget.workOrderDetail!.orderLineId,
                              Navigator.of(context).pushNamed(
                                workOrderEditHoursRoute,
                                arguments: {
                                  'workOrderCubit': widget.workOrderCubit,
                                  'workOrderDetailChangeRequest':
                                      workOrderDetailChangeRequest,
                                  'workOrderDetailsHours':
                                      widget.workOrderDetail!.hours!,
                                },
                              ),
                            },
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            iconSize: 35,
                          ),
                        ),
                      ],
                    ),
                    buildRowDeleteIconsWorkOrderDetailBlock(
                        context,
                        widget.workOrderDetail!.hours.job.description
                            .toString(),
                        widget.workOrderDetail!.orderLineId,
                        widget.workOrderDetail!.orderSubLineId,
                        widget.workOrderDetail!.orderId,
                        null,
                        "workOrder",
                        null,
                        widget.workOrder!.companyId,
                        widget.workOrder!.branchId),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

BoxDecoration buildBoxDecorationWorkOrderDetailsBlockMain() {
  return BoxDecoration(
    color: CustomColors.evenRow,
    border: Border.all(
      width: 1,
      color: CustomColors.greyBorder,
    ),
    borderRadius: BorderRadius.all(
      Radius.circular(
        5.0,
      ),
    ),
  );
}

Row buildIconWorkOrderDetailsBlock(IconData icon, Color boxColor) {
  return Row(
    children: <Widget>[
      SizedBox(
        height: 20,
        width: 20,
        child: DecoratedBox(
          child: Icon(
            icon,
            color: CustomColors.textWhite,
            size: 12.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(3),
              bottomRight: Radius.circular(5),
            ),
            color: boxColor,
          ),
        ),
      ),
    ],
  );
}

Expanded buildTitleWorkOrderDetailsBlock(String text) {
  return Expanded(
    //LEFT SIDE OF TABLE ROW
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 0, bottom: 20, left: 20, right: 10),
          child: Text(
            text,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}

Expanded buildContentWorkOrderDetailsBlock(String content) {
  return Expanded(
    //LEFT SIDE OF TABLE ROW
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 0, bottom: 5, left: 20, right: 20),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 17,
            ),
          ),
        ),
      ],
    ),
  );
}

Expanded buildExpandedContentTitleAndColumnValueWorkOrderDetailsBlock(
    {double vertical = 1.0,
    double horizontal = 1.0,
    FontWeight fontWeight = FontWeight.bold,
    Color color = CustomColors.didataBlue,
    String text = ""}) {
  return Expanded(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: color,
                fontSize: fontSize,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Column addEditQuantityInput(
    String? productId,
    TextEditingController quantityTextController,
    String type,
    String hint,
    BuildContext context,
    [updateAddSelectedProductQuantity,
    updateEditSelectedProductQuantity]) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            width: 70,
            height: 40,
            child: TextField(
              onChanged: (value) {
                var newQuantity = double.tryParse(quantityTextController.text);
                if (newQuantity == 0 || newQuantity == null) {
                  quantityTextController.clear();
                } else {
                  if (type == "add") {
                    var productQuantity = [productId, newQuantity];
                    updateAddSelectedProductQuantity!(productQuantity);
                  } else {
                    updateEditSelectedProductQuantity!(newQuantity);
                  }
                }
              },
              onSubmitted: (value) {
                var newQuantity = double.tryParse(quantityTextController.text);
                if (newQuantity == 0 || newQuantity == null) {
                  quantityTextController.clear();
                } else {
                  if (type == "add") {
                    var productQuantity = [productId, newQuantity];
                    updateAddSelectedProductQuantity!(productQuantity);
                  } else {
                    updateEditSelectedProductQuantity!(newQuantity);
                  }
                }
              },
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: quantityTextController,
              textAlign: TextAlign.center,
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
                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                filled: true,
                fillColor: Colors.white,
                hintText: hint,
                hintStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

Row buildRowDeleteIconsWorkOrderDetailBlock(
    BuildContext context,
    String description,
    int? orderLineId,
    int? orderSubLineId,
    int? orderId,
    String? productId,
    String workOrderText,
    deleteProductFromSearchedList,
    int? companyId,
    int? branchId) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Container(
        decoration: buildBoxDecorationWorkOrderDeleteIcons(),
        child: IconButton(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
          onPressed: () {
            deleteDialogNotification(
                context,
                AppLocalizations.of(context)!.translate('blocks.delete'),
                description,
                orderId,
                orderLineId,
                orderSubLineId,
                productId,
                workOrderText,
                deleteProductFromSearchedList,
                companyId,
                branchId);
          },
          icon: Icon(
            FontAwesomeIcons.solidTrashCan,
            color: CustomColors.DeleteIcon,
          ),
          iconSize: 30,
        ),
      ),
    ],
  );
}

BoxDecoration buildBoxDecorationWorkOrderEditIcons() {
  return BoxDecoration(
    border: Border(
      left: BorderSide(
        color: CustomColors.greyBorder,
        width: 1,
      ),
      bottom: BorderSide(
        color: CustomColors.greyBorder,
        width: 1,
      ),
    ),
  );
}

BoxDecoration buildBoxDecorationWorkOrderDeleteIcons() {
  return BoxDecoration(
    border: Border(
      left: BorderSide(
        color: CustomColors.greyBorder,
        width: 1,
      ),
    ),
  );
}
