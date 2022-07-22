import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:search_choices/search_choices.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/cubit/work_order/work_order_cubit.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

import '../../../app_localizations.dart';

deleteDialogNotification(
    BuildContext blocContext,
    title,
    description,
    int? orderId,
    int? lineId,
    int? subLineId,
    String? productId,
    String type,
    deleteProductFromSearchedList,
    int? companyId,
    int? branchId) {
  var width = MediaQuery.of(blocContext).size.width;

  return showDialog(
    context: blocContext,
    builder: (context) => AlertDialog(
      title: dialogNotificationTitle(width, title, context),
      titlePadding: EdgeInsets.only(top: 0, left: 0, right: 0),
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      contentPadding: EdgeInsets.only(top: 15, left: 0, bottom: 15, right: 0),
      actionsPadding: EdgeInsets.only(top: 0, bottom: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(
        5.0,
      ))),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context)!
                        .translate('blocks.remove.confirmation'),
                    style: TextStyle(
                      color: CustomColors.blackBorder,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: ' ' + description,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: ' ' +
                        AppLocalizations.of(context)!
                            .translate('blocks.remove.confirmation.final'),
                    style: TextStyle(
                      color: CustomColors.blackBorder,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 1.0,
          ),
        ],
      ),
      actions: <Widget>[
        dialogCancelButton(
            context, AppLocalizations.of(context)!.translate('dialogs.no')),
        OutlinedButton(
          onPressed: () {
            _deleteItem(blocContext, orderId, lineId, subLineId, productId,
                type, deleteProductFromSearchedList, companyId, branchId);
            Navigator.of(context).pop(true);
          },
          child: Text(
            AppLocalizations.of(context)!.translate('dialogs.yes'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          style: dialogButtonStyle(CustomColors.YesNotificationBackground),
        ),
      ],
    ),
  );
}

deleteDialogNotificationWorkOrder(BuildContext blocContext, title, message,
    int index, Function callback, V112WorkOrder workOrder) {
  var width = MediaQuery.of(blocContext).size.width;

  return showDialog(
    context: blocContext,
    builder: (context) => AlertDialog(
      title: dialogNotificationTitle(width, title, context),
      titlePadding: EdgeInsets.only(top: 0, left: 0, right: 0),
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      contentPadding: EdgeInsets.only(top: 15, left: 0, bottom: 15, right: 0),
      actionsPadding: EdgeInsets.only(top: 0, bottom: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(
        5.0,
      ))),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context)!
                        .translate('dialogs.is.sure'),
                    style: TextStyle(
                      color: CustomColors.blackBorder,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: ' ' + message,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: ' ' +
                        AppLocalizations.of(context)!
                            .translate('blocks.remove.confirmation.final'),
                    style: TextStyle(
                      color: CustomColors.blackBorder,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 1.0,
          ),
        ],
      ),
      actions: <Widget>[
        dialogCancelButton(
            context, AppLocalizations.of(context)!.translate('dialogs.no')),
        OutlinedButton(
          onPressed: () {
            WorkOrderDetailType.selectedImage.removeAt(index);
            callback.call();
            // _deleteItem(blocContext, orderId, lineId, subLineId, type);
            Navigator.of(context).pop(true);
          },
          child: Text(
            AppLocalizations.of(context)!.translate('dialogs.yes'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          style: dialogButtonStyle(CustomColors.YesNotificationBackground),
        ),
      ],
    ),
  );
}

editProductDialogNotification(BuildContext blocContext, title, message,
    WorkOrderDetailChangeRequest workOrderDetailChangeRequest, String type) {
  var width = MediaQuery.of(blocContext).size.width;

  return showDialog(
    context: blocContext,
    builder: (context) => AlertDialog(
      title: dialogNotificationTitle(width, title, context),
      titlePadding: EdgeInsets.only(top: 0, left: 0, right: 0),
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      contentPadding: EdgeInsets.only(top: 15, left: 0, bottom: 15, right: 0),
      actionsPadding: EdgeInsets.only(top: 0, bottom: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(
        5.0,
      ))),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context)!
                        .translate('Product aantal aanpassen naar'),
                    style: TextStyle(
                      color: CustomColors.blackBorder,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: ' ' + message,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: '?',
                    style: TextStyle(
                      color: CustomColors.blackBorder,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            // TextField(
            //   decoration: InputDecoration(
            //     hintText: message,
            //     border: InputBorder.none,
            //   ),
            //   maxLines: 4,
            // ),
          ),
          Divider(
            color: Colors.grey,
            height: 1.0,
          ),
        ],
      ),
      actions: <Widget>[
        dialogCancelButton(
            context, AppLocalizations.of(context)!.translate('dialogs.no')),
        dialogEditButton(
          blocContext,
          workOrderDetailChangeRequest,
          null,
          type,
          AppLocalizations.of(context)!.translate('dialogs.save'),
          null,
        ),
      ],
    ),
  );
}

addWorkOrderTextDialog(
    BuildContext blocContext,
    title,
    WorkOrderCubit workOrderCubit,
    WorkOrderDetailRequest workOrderDetailRequest,
    String type) {
  var width = MediaQuery.of(blocContext).size.width;
  TextEditingController workOrderAddingTextController =
      new TextEditingController();

  return showDialog(
    context: blocContext,
    builder: (context) => AlertDialog(
      title: dialogNotificationTitle(width, title, context),
      titlePadding: EdgeInsets.only(top: 0, left: 0, right: 0),
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      contentPadding: EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 0),
      actionsPadding: EdgeInsets.only(top: 0, bottom: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(
        5.0,
      ))),
      content: textDialogContent(
          workOrderAddingTextController, "Voer hier het werkorder line tekst"),
      actions: <Widget>[
        dialogCancelButton(
            context, AppLocalizations.of(context)!.translate('dialogs.cancel')),
        dialogAddButton(
          blocContext,
          workOrderCubit,
          workOrderDetailRequest,
          workOrderAddingTextController,
          type,
          AppLocalizations.of(context)!.translate('dialogs.add'),
          null,
        ),
      ],
    ),
  );
}

editWorkOrderTextDialog(BuildContext blocContext, title,
    WorkOrderDetailChangeRequest workOrderDetailChangeRequest, String type) {
  var width = MediaQuery.of(blocContext).size.width;
  TextEditingController workOrderAddingTextController =
      new TextEditingController();
  workOrderAddingTextController.text = workOrderDetailChangeRequest.description;

  return showDialog(
    context: blocContext,
    builder: (context) => AlertDialog(
      title: dialogNotificationTitle(width, title, context),
      titlePadding: EdgeInsets.only(top: 0, left: 0, right: 0),
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      contentPadding: EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 0),
      actionsPadding: EdgeInsets.only(top: 0, bottom: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(
        5.0,
      ))),
      content: textDialogContent(
          workOrderAddingTextController, workOrderAddingTextController.text),
      actions: <Widget>[
        dialogCancelButton(
            context, AppLocalizations.of(context)!.translate('dialogs.cancel')),
        dialogEditButton(
          blocContext,
          workOrderDetailChangeRequest,
          workOrderAddingTextController,
          type,
          AppLocalizations.of(context)!.translate('dialogs.save'),
          null,
        ),
      ],
    ),
  );
}

addWorkOrderCostDialog(
    BuildContext blocContext,
    title,
    WorkOrderCubit workOrderCubit,
    WorkOrderDetailRequest workOrderDetailRequest,
    String type,
    List<CostType> costTypes,
    int? selectedCostValue) {
  var selectedCostDetails = <CostDetail>[];
  int? _selectedCostValue = selectedCostValue;
  var width = MediaQuery.of(blocContext).size.width;
  return showDialog(
    context: blocContext,
    builder: (context) => AlertDialog(
      title: dialogNotificationTitle(
          width,
          title == "add"
              ? AppLocalizations.of(context)!
                  .translate('dialogs.work.order.add.cost')
              : AppLocalizations.of(context)!
                  .translate('dialogs.work.order.edit.cost'),
          context),
      titlePadding: EdgeInsets.only(top: 0, left: 0, right: 0),
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      contentPadding: EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 0),
      actionsPadding: EdgeInsets.only(top: 0, bottom: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(
        5.0,
      ))),
      content: costDialogContent(
          costTypes, _selectedCostValue, selectedCostDetails, context),
      actions: <Widget>[
        dialogCancelButton(
            context, AppLocalizations.of(context)!.translate('dialogs.cancel')),
        dialogAddButton(
          blocContext,
          workOrderCubit,
          workOrderDetailRequest,
          null,
          type,
          title == "add"
              ? AppLocalizations.of(context)!.translate('dialogs.add')
              : AppLocalizations.of(context)!.translate('dialogs.edit'),
          selectedCostDetails,
        ),
      ],
    ),
  );
}

editWorkOrderCostDialog(
    BuildContext blocContext,
    title,
    WorkOrderDetailChangeRequest workOrderDetailChangeRequest,
    String type,
    List<CostType> costTypes,
    int? selectedCostValue) {
  var selectedCostDetails = <CostDetail>[];
  int? _selectedCostValue = selectedCostValue;
  var width = MediaQuery.of(blocContext).size.width;
  return showDialog(
    context: blocContext,
    builder: (context) => AlertDialog(
      title: dialogNotificationTitle(
          width,
          title == "add"
              ? AppLocalizations.of(context)!
                  .translate('dialogs.work.order.add.cost')
              : AppLocalizations.of(context)!
                  .translate('dialogs.work.order.edit.cost'),
          context),
      titlePadding: EdgeInsets.only(top: 0, left: 0, right: 0),
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      contentPadding: EdgeInsets.only(top: 0, left: 0, bottom: 0, right: 0),
      actionsPadding: EdgeInsets.only(top: 0, bottom: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(
        5.0,
      ))),
      content: costDialogContent(
          costTypes, _selectedCostValue, selectedCostDetails, context),
      actions: <Widget>[
        dialogCancelButton(
            context, AppLocalizations.of(context)!.translate('dialogs.cancel')),
        dialogEditButton(
          blocContext,
          workOrderDetailChangeRequest,
          null,
          type,
          title == "add"
              ? AppLocalizations.of(context)!.translate('dialogs.add')
              : AppLocalizations.of(context)!.translate('dialogs.edit'),
          selectedCostDetails,
        ),
      ],
    ),
  );
}

Container dialogNotificationTitle(double width, title, BuildContext context) {
  return Container(
      margin: EdgeInsets.only(bottom: 0),
      width: width - (20 * 100 / 100),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Text(title,
            style: TextStyle(color: Colors.white), textAlign: TextAlign.center),
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5),
          topRight: Radius.circular(5),
        ),
        color: Theme.of(context).colorScheme.primary,
      ));
}

Container textDialogContent(
    TextEditingController workOrderAddingTextController, String hint) {
  String _inputText = workOrderAddingTextController.text;
  return Container(
    margin: EdgeInsets.only(top: 0),
    decoration: BoxDecoration(color: CustomColors.evenRow),
    child: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0, top: 0),
          // Added a statefulbuilder to be able to get the amount of characters inputted by the user.
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return TextField(
                autofocus: true,
                onChanged: (value) {
                  setState(
                    () {
                      _inputText = value;
                    },
                  );
                },
                inputFormatters: [
                  // The user can only input 45 characters.
                  LengthLimitingTextInputFormatter(45),
                ],
                controller: workOrderAddingTextController,
                style: TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  // This is to show the characteramount to the user.
                  counterText: '${_inputText.length.toString()} / 45',
                ),
                maxLines: 3,
              );
            },
          ),
        ),
        Divider(
          color: Colors.grey,
          height: 1.0,
        ),
      ],
    ),
  );
}

Container costDialogContent(
  List<CostType> costTypes,
  int? _selectedCostValue,
  List<CostDetail> selectedCostDetails,
  BuildContext context,
) {
  return Container(
    margin: EdgeInsets.only(top: 0),
    decoration: BoxDecoration(color: CustomColors.evenRow),
    child: new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _costsWidget(
            costTypes, _selectedCostValue, selectedCostDetails, context),
        Divider(
          color: Colors.grey,
          height: 1.0,
        ),
      ],
    ),
  );
}

OutlinedButton dialogAddButton(
    BuildContext context,
    WorkOrderCubit workOrderCubit,
    WorkOrderDetailRequest workOrderDetailRequest,
    TextEditingController? workOrderAddingTextController,
    String type,
    String buttonText,
    List<CostDetail>? selectedCostDetails) {
  return OutlinedButton(
    onPressed: () {
      _addItem(context, workOrderCubit, workOrderDetailRequest,
          workOrderAddingTextController, type, selectedCostDetails);
      Navigator.of(context).pop(true);
    },
    child: Text(
      buttonText,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    style: dialogButtonStyle(CustomColors.YesNotificationBackground),
  );
}

OutlinedButton dialogEditButton(
    BuildContext context,
    WorkOrderDetailChangeRequest workOrderDetailChangeRequest,
    TextEditingController? workOrderAddingTextController,
    String type,
    String buttonText,
    List<CostDetail>? selectedCostDetails) {
  return OutlinedButton(
    onPressed: () {
      _editItem(context, workOrderDetailChangeRequest,
          workOrderAddingTextController, type, selectedCostDetails);
      Navigator.of(context).pop(true);
    },
    child: Text(
      buttonText,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    style: dialogButtonStyle(CustomColors.YesNotificationBackground),
  );
}

OutlinedButton dialogCancelButton(BuildContext context, String text) {
  return OutlinedButton(
    onPressed: () => Navigator.of(context).pop(false),
    child: Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        backgroundColor: CustomColors.greyIconBackground,
      ),
    ),
    style: dialogButtonStyle(CustomColors.greyIconBackground),
  );
}

ButtonStyle dialogButtonStyle(Color buttonColor) {
  return ButtonStyle(
    backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
    shape: MaterialStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0))),
    padding: MaterialStateProperty.all<EdgeInsets>(
        EdgeInsets.fromLTRB(8, 12, 8, 12)),
  );
}

Widget _costsWidget(List<CostType> costs, int? selectedCostValue,
    List<CostDetail> selectedCostTypes, BuildContext context) {
  var _selectedCostValue = <int>[];
  if (selectedCostValue != null) {
    _selectedCostValue
        .add(costs.indexWhere((element) => element.id == selectedCostValue));
  }

  return Container(
    height: 200,
    decoration: BoxDecoration(
      color: CustomColors.white,
      border: Border.all(
        width: 1,
        color: CustomColors.greyBorder,
      ),
      borderRadius: BorderRadius.all(
        Radius.circular(
          5.0,
        ),
      ),
    ),
    child: Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: SingleChildScrollView(
        child: SearchChoices.multiple(
          buildDropDownDialog:
              (titleBar, searchBar, list, closeButton, dropDownContext) =>
                  AnimatedContainer(
            padding: MediaQuery.of(dropDownContext).viewInsets,
            duration: const Duration(milliseconds: 300),
            child: Card(
              margin: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      titleBar,
                      searchBar,
                      list,
                      closeButton,
                    ]),
              ),
            ),
          ),
          isCaseSensitiveSearch: false,
          items: costs.map((value) {
            return DropdownMenuItem(
              child: Text(
                value.id.toString() + " - " + value.description.toString(),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17.0,
                ),
              ),
              value: value.id.toString() + " - " + value.description.toString(),
            );
          }).toList(),
          selectedItems: _selectedCostValue,
          hint: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              AppLocalizations.of(context)!.translate('dialogs.select.cost'),
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          searchHint: Flexible(
            child: Text(
                AppLocalizations.of(context)!
                    .translate('dialogs.search.and.select.cost'),
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                )),
          ),
          onChanged: (value) {
            value.forEach((x) {
              var newSelectedCostValue = new CostType();
              newSelectedCostValue = costs[x];
              CostDetail costDetail = new CostDetail();
              costDetail.costId = newSelectedCostValue.id;
              costDetail.amount = new Amount();
              costDetail.amount.value = newSelectedCostValue.amount;

              selectedCostTypes.add(costDetail);
            });
          },
          displayItem: (item, selected) {
            return (Row(children: [
              selected
                  ? Icon(
                      Icons.check,
                      color: Colors.green,
                    )
                  : Icon(
                      Icons.check_box_outline_blank,
                      color: Colors.grey,
                    ),
              SizedBox(width: 7),
              Expanded(
                child: item,
              ),
            ]));
          },
          doneButton: (selectedItemsDone, doneContext) {
            return IconButton(
              onPressed: () {
                Navigator.pop(doneContext);
              },
              icon: Icon(Icons.close_sharp,
                  color: Theme.of(context).colorScheme.primary),
            );
          },
          underline: Container(
            height: 1.0,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: Theme.of(context).colorScheme.primary,
                        width: 3.0))),
          ),
          closeButton: (selectedItemClose, doneContext) {
            return ElevatedButton(
                onPressed: () {
                  Navigator.pop(doneContext);
                },
                child: Text(AppLocalizations.of(context)!
                    .translate('dialogs.add.selected')));
          },
          dialogBox: true,
          isExpanded: true,
          displayClearIcon: true,
          padding: 0,
        ),
      ),
    ),
  );
}

deleteAttachmentNotification(
  BuildContext blocContext,
  description,
  VoidCallback onAgree,
) {
  var width = MediaQuery.of(blocContext).size.width;

  return showDialog(
    context: blocContext,
    builder: (context) => AlertDialog(
      title: dialogNotificationTitle(width, 'Bijlage verwijderen', context),
      titlePadding: EdgeInsets.only(top: 0, left: 0, right: 0),
      insetPadding: EdgeInsets.symmetric(horizontal: 30),
      contentPadding: EdgeInsets.only(top: 15, left: 0, bottom: 15, right: 0),
      actionsPadding: EdgeInsets.only(top: 0, bottom: 10, right: 10),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(
        5.0,
      ))),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 0),
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: AppLocalizations.of(context)!
                        .translate('blocks.remove.attachment.confirmation'),
                    style: TextStyle(
                      color: CustomColors.blackBorder,
                      fontSize: 18,
                    ),
                  ),
                  TextSpan(
                    text: ' ' + description,
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 18,
                        fontWeight: FontWeight.w800),
                  ),
                  TextSpan(
                    text: ' ' +
                        AppLocalizations.of(context)!
                            .translate('blocks.remove.confirmation.final'),
                    style: TextStyle(
                      color: CustomColors.blackBorder,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Divider(
            color: Colors.grey,
            height: 1.0,
          ),
        ],
      ),
      actions: <Widget>[
        dialogCancelButton(
            context, AppLocalizations.of(context)!.translate('dialogs.no')),
        OutlinedButton(
          onPressed: () {
            onAgree();
          },
          child: Text(
            AppLocalizations.of(context)!.translate('dialogs.yes'),
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
            ),
          ),
          style: dialogButtonStyle(CustomColors.YesNotificationBackground),
        ),
      ],
    ),
  );
}

void _deleteItem(
    BuildContext context,
    int? orderId,
    int? orderLineId,
    int? orderSubLineId,
    String? productId,
    String type,
    ValueChanged<String>? deleteProductFromSearchedList,
    int? companyId,
    int? branchId) {
  switch (type) {
    case "workOrder":
      var workOrderCubit = BlocProvider.of<WorkOrderCubit>(context);
      workOrderCubit.deleteWorkOrderDetail(
          orderId!, orderLineId!, orderSubLineId!, companyId, branchId);
      break;

    case "product":
      deleteProductFromSearchedList!(productId!);
      break;
  }
}

void _addItem(
    BuildContext context,
    WorkOrderCubit workOrderCubit,
    WorkOrderDetailRequest workOrderDetailRequest,
    TextEditingController? workOrderAddingTextController,
    String type,
    List<CostDetail>? selectedCostDetails) {
  switch (type) {
    case "text":
      workOrderDetailRequest.lineType = WorkOrderDetailType.Text; // 3 is text
      workOrderCubit.createWorkOrderDetail(workOrderDetailRequest,
          workOrderAddingTextController!.text, WorkOrderDetailType.Text);
      break;
    case "cost":
      workOrderDetailRequest.lineType = WorkOrderDetailType.Costs; // 2 is Cost
      workOrderCubit.createWorkOrderDetail(workOrderDetailRequest,
          selectedCostDetails, WorkOrderDetailType.Costs);
      break;
  }
}

void _editItem(
    BuildContext context,
    WorkOrderDetailChangeRequest workOrderDetailChangeRequest,
    TextEditingController? workOrderAddingTextController,
    String type,
    [List<CostDetail>? selectedCostDetails]) {
  switch (type) {
    case "text":
      var workOrderCubit = BlocProvider.of<WorkOrderCubit>(context);
      workOrderDetailChangeRequest.lineType =
          WorkOrderDetailType.Text; // 3 is text
      workOrderDetailChangeRequest.description =
          workOrderAddingTextController?.text;
      workOrderCubit.editWorkOrderDetail(workOrderDetailChangeRequest);
      break;

    case "cost":
      var workOrderCubit = BlocProvider.of<WorkOrderCubit>(context);
      workOrderDetailChangeRequest.lineType =
          WorkOrderDetailType.Costs; // 2 is cost
      workOrderDetailChangeRequest.cost.costId =
          selectedCostDetails?.first.costId;
      workOrderDetailChangeRequest.cost.amount =
          selectedCostDetails?.first.amount;
      workOrderCubit.editWorkOrderDetail(workOrderDetailChangeRequest);
      break;

    case "product":
      var workOrderCubit = BlocProvider.of<WorkOrderCubit>(context);
      workOrderCubit.editWorkOrderDetail(workOrderDetailChangeRequest);
      break;
  }
}
