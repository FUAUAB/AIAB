import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:search_choices/search_choices.dart';
import 'package:work_order_app/core/variables/api_variables.dart';
import 'package:work_order_app/cubit/customer/customers_cubit.dart';
import 'package:work_order_app/cubit/project/project_cubit.dart';
import 'package:work_order_app/cubit/work_order/work_order_cubit.dart';
import 'package:work_order_app/presentation/widgets/inputs/textfield_widget.dart';

import '../../../app_localizations.dart';
import '../../styles/colors_style.dart';
import '../../widgets/menus/navigation_drawer.dart';

class WorkOrdersAddWorkOrderPage extends StatefulWidget {
  const WorkOrdersAddWorkOrderPage({Key? key, required this.data})
      : super(key: key);

  final Map data;

  @override
  _WorkOrdersAddWorkOrderPageState createState() =>
      _WorkOrdersAddWorkOrderPageState();
}

class _WorkOrdersAddWorkOrderPageState
    extends State<WorkOrdersAddWorkOrderPage> {
  final TextEditingController workOrderAddingTextController =
      new TextEditingController();

  late WorkOrderRequest workOrderRequest;
  late var workOrderCubit;
  late var customerCubit;
  late var projectCubit;
  late var selectedCustomer = new Customer();
  var selectedProject = new Project();

  late List<Customer> customersList = <Customer>[];
  late List<Project> projectsList = <Project>[];

  _updateSelectedCustomer(int customerId) {
    setState(
      () {
        context.read<ProjectCubit>().getProjectByCustomerId(customerId).then(
          (value) {
            setState(
              () {
                projectsList = this.projectCubit.state.projects;
              },
            );
          },
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    workOrderRequest = widget.data["workOrderRequest"];
    workOrderCubit = widget.data['workOrderCubit'];
    customerCubit = context.read<CustomerCubit>();
    projectCubit = context.read<ProjectCubit>();
    if (ApiVariables.customers.isEmpty) {
      customerCubit.getCustomers().then(
        (value) {
          setState(
            () {
              ApiVariables.customers = this.customerCubit.state.customers;
              customersList = ApiVariables.customers;
            },
          );
        },
      );
    } else {
      customersList = ApiVariables.customers;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        drawer: NavigationDrawerWidget(),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          centerTitle: true,
          title: Text(
              AppLocalizations.of(context)!.translate('add.work.order.title')),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(FontAwesomeIcons.caretSquareLeft),
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10.0),
          child: newWorkOrderDialogContent(
              workOrderAddingTextController,
              context,
              workOrderCubit,
              workOrderRequest,
              _updateSelectedCustomer),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: CustomColors.greyContainerBorder,
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 20.0, top: 6.0, right: 20.0, bottom: 6.0),
            child: Row(children: <Widget>[
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('cancel.message'),
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: CustomColors.buttonDisabled,
                  ),
                ),
              ),
              SizedBox(
                width: 20,
              ),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: () async {
                    workOrderRequest.description =
                        workOrderAddingTextController.text;
                    if (selectedCustomer.customerId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(AppLocalizations.of(context)!
                              .translate('add.work.order.customer.empty')),
                          backgroundColor: CustomColors.deleteBackgroundColor,
                        ),
                      );
                    } else if (selectedProject.projectId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(AppLocalizations.of(context)!
                              .translate('add.work.order.project.empty')),
                          backgroundColor: CustomColors.deleteBackgroundColor,
                        ),
                      );
                    } else if (workOrderRequest.description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          duration: Duration(seconds: 2),
                          content: Text(AppLocalizations.of(context)!
                              .translate('add.work.order.description.empty')),
                          backgroundColor: CustomColors.deleteBackgroundColor,
                        ),
                      );
                    } else {
                      await workOrderCubit.createWorkOrder(workOrderRequest,
                          selectedCustomer, selectedProject, context);
                    }
                  },
                  child: Text(
                    AppLocalizations.of(context)!.translate('add.message'),
                    style: TextStyle(
                      fontSize: 17,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: CustomColors.buttonGreen,
                  ),
                ),
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Container newWorkOrderDialogContent(
      TextEditingController workOrderAddingTextController,
      BuildContext blocContext,
      WorkOrderCubit workOrderCubit,
      WorkOrderRequest workOrderRequest,
      updatedSelectedCustomer) {
    return Container(
      decoration: BoxDecoration(color: CustomColors.evenRow),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3.0),
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                  AppLocalizations.of(blocContext)!
                      .translate('add.work.order.select.customer.title'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: CustomColors.black)),
            ),
          ),
          customersWidget(blocContext, updatedSelectedCustomer),
          Container(
            child: Padding(
              padding: EdgeInsets.only(top: 15, bottom: 10),
              child: Text(
                  AppLocalizations.of(blocContext)!
                      .translate('add.work.order.select.project.title'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: CustomColors.black)),
            ),
          ),
          projectsWidget(blocContext),
          Padding(
            padding: EdgeInsets.only(top: 15, bottom: 10),
            child: Text(
                AppLocalizations.of(blocContext)!
                    .translate('add.work.order.description.title'),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                    color: CustomColors.black)),
          ),
          InputTextFieldWidget(
            searchController: workOrderAddingTextController,
            hintText: AppLocalizations.of(blocContext)!
                .translate('add.work.order.description.hint'),
            type: 'customer',
            title: "Project",
            isForOrder: false,
          ),
        ],
      ),
    );
  }

  Widget customersWidget(BuildContext context, updatedSelectedCustomer) {
    return Container(
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
      child: SearchChoices.single(
        underline: SizedBox.shrink(),
        buildDropDownDialog:
            (titleBar, searchBar, list, closeButton, dropDownContext) =>
                AnimatedContainer(
          padding: MediaQuery.of(dropDownContext).viewInsets,
          duration: const Duration(milliseconds: 300),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
        items: customersList.map(
          (value) {
            return DropdownMenuItem(
              child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    value.customerId.toString() + " - " + value.name.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  )),
              value: value,
            );
          },
        ).toList(),
        hint: Padding(
          padding: const EdgeInsets.all(12.0),
          child: customersList.length >= 1
              ? Text(
                  AppLocalizations.of(context)!
                      .translate('add.work.order.select.customer'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: CustomColors.black))
              : Text(
                  AppLocalizations.of(context)!
                      .translate('add.work.order.customers.are.loaded'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: CustomColors.black)),
        ),
        searchHint: null,
        onChanged: (value) {
          setState(() {
            selectedCustomer = value;
            updatedSelectedCustomer(selectedCustomer.customerId);
          });
        },
        value: selectedCustomer,
        dialogBox: true,
        isExpanded: true,
        displayClearIcon: false,
        padding: 0,
      ),
    );
  }

  Widget projectsWidget(BuildContext context) {
    return Container(
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
      child: SearchChoices.single(
        underline: SizedBox.shrink(),
        buildDropDownDialog:
            (titleBar, searchBar, list, closeButton, dropDownContext) =>
                AnimatedContainer(
          padding: MediaQuery.of(dropDownContext).viewInsets,
          duration: const Duration(milliseconds: 300),
          child: Card(
            margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
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
        items: projectsList.map((value) {
          return DropdownMenuItem(
            child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Text(
                  value.projectId.toString() + " - " + value.name.toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 17.0,
                  ),
                )),
            value: value,
          );
        }).toList(),
        hint: Padding(
          padding: const EdgeInsets.all(12.0),
          child: selectedCustomer.customerId == null
              ? Text(
                  AppLocalizations.of(context)!.translate(
                      'add.work.order.select.first.customer.then.project'),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      color: CustomColors.black))
              : projectsList.length >= 1
                  ? Text(
                      AppLocalizations.of(context)!
                          .translate('add.work.order.select.project'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: CustomColors.black))
                  : Text(
                      AppLocalizations.of(context)!
                          .translate('add.work.order.no.projects.available'),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                          color: CustomColors.black)),
        ),
        searchHint: null,
        onChanged: (value) {
          selectedProject = value;
        },
        dialogBox: true,
        isExpanded: true,
        displayClearIcon: false,
        padding: 0,
      ),
    );
  }
}
