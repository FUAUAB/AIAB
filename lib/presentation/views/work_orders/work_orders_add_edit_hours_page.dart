import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:search_choices/search_choices.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/cubit/employee/employee_cubit.dart';
import 'package:work_order_app/cubit/work_order/work_order_cubit.dart';
import 'package:work_order_app/presentation/widgets/blocks/work_counter_order_block.dart';
import 'package:work_order_app/presentation/widgets/datetimePicker/datetime_picker_formFields.dart';
import 'package:work_order_app/presentation/widgets/generics/build_state.dart';

import '../../../app_localizations.dart';
import '../../../core/responsive/responsive.dart';
import '../../styles/colors_style.dart';
import '../../widgets/menus/navigation_drawer.dart';

class WorkOrdersAddHoursPage extends StatefulWidget {
  const WorkOrdersAddHoursPage({Key? key, required this.data})
      : super(key: key);

  final Map data;

  @override
  _WorkOrdersAddHoursState createState() => _WorkOrdersAddHoursState();
}

class WorkOrdersEditHoursPage extends StatefulWidget {
  const WorkOrdersEditHoursPage({Key? key, required this.data})
      : super(key: key);

  final Map data;

  @override
  _WorkOrdersEditHoursState createState() => _WorkOrdersEditHoursState();
}

class _WorkOrdersAddHoursState extends State<WorkOrdersAddHoursPage> {
  final ScrollController _scrollController = ScrollController();
  V112WorkOrder workOrder = new V112WorkOrder();
  late WorkOrderDetailRequest workOrderDetailRequest;

  DateTime? startDateTime;
  DateTime? endDateTime;

  _updateStartDate(DateTime _startDateTime) {
    setState(() => startDateTime = _startDateTime);
  }

  _updateEndDate(DateTime _endDateTime) {
    setState(() => endDateTime = _endDateTime);
  }

  late var workOrderCubit;
  bool evenRow = true;

  late var employeeCubit;
  List<V12Employee> employees = [];
  V12Employee _selectedValue = new V12Employee();
  String? _selectedValue2 = "";

  updateSelectedValueAndSelectedValue2(String? selectedValue2) {
    setState(
      () {
        _selectedValue2 = selectedValue2;
        String idFromSelectedValue =
            _selectedValue2.toString().split('-').first.trim();
        _selectedValue =
            employees.firstWhere((x) => x.id.toString() == idFromSelectedValue);
      },
    );
  }

  List<Job> workOrderJobs = [];
  Job selectedJob = new Job();

  updateSelectedJob(Job newSelectedJob) {
    setState(
      () {
        selectedJob = newSelectedJob;
      },
    );
  }

  @override
  void initState() {
    super.initState();
    workOrder = widget.data["workOrder"];
    workOrderDetailRequest = widget.data["workOrderDetailRequest"];
    workOrderDetailRequest.hours = new WorkOrderHours();
    employeeCubit = context.read<EmployeeCubit>();
    workOrderCubit = widget.data['workOrderCubit'];
    context.read<WorkOrderCubit>().getWorkOrderById(
        workOrder.orderId, workOrder.companyId, workOrder.branchId);

    employeeCubit.getEmployees().then(
      (value) {
        setState(
          () {
            employees = this.employeeCubit.state.employees;
            _selectedValue = employees[0];
            _selectedValue2 = _selectedValue.id.toString() +
                " - " +
                _selectedValue.name.toString();
          },
        );
      },
    );

    workOrderCubit.getWorkOrderJobs(workOrder.companyId).then(
      (value) {
        setState(
          () {
            workOrderJobs = this.workOrderCubit.state.workOrdersJobs;
            workOrderJobs[0].isSelected = true;
            selectedJob = workOrderJobs[0];
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        workOrderCubit.getWorkOrderById(
            workOrder.orderId, workOrder.companyId, workOrder.branchId);
        return true;
      },
      child: DefaultTabController(
        length: 8,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          drawer: NavigationDrawerWidget(),
          appBar: buildAddEditHoursAppBar(context, workOrder.orderId,
              workOrder.companyId, workOrder.branchId, workOrderCubit),
          body: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                buildAddHoursTabBar(
                  context,
                  AppLocalizations.of(context)!.translate(
                      'work.order.add.edit.hours.page.tab.add.hours'),
                  AppLocalizations.of(context)!.translate(
                      'work.order.add.edit.hours.page.tab.closed.orders.hours'),
                ),
                Expanded(
                  child: Container(
                    child: TabBarView(
                      children: [
                        LayoutBuilder(
                          builder: (BuildContext context,
                              BoxConstraints viewportConstraints) {
                            return SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.only(
                                    left: 20, top: 20, right: 20),
                                child: IntrinsicHeight(
                                  child: Container(
                                    child: Responsive.isMobile(context)
                                        ? Column(
                                            children: <Widget>[
                                              buildAddEditHoursTab1ContentEmployeesDatePickerExpanded(
                                                  context,
                                                  _updateStartDate,
                                                  _updateEndDate,
                                                  null,
                                                  null,
                                                  employees,
                                                  _selectedValue2,
                                                  _selectedValue,
                                                  updateSelectedValueAndSelectedValue2),
                                              buildAddEditHoursTab1ContentWorkOrderActivitiesBlocksExpanded(
                                                  context,
                                                  workOrderJobs,
                                                  _scrollController,
                                                  evenRow,
                                                  updateSelectedJob,
                                                  left: 0,
                                                  top: 30),
                                            ],
                                          )
                                        : Row(
                                            children: <Widget>[
                                              buildAddEditHoursTab1ContentEmployeesDatePickerExpanded(
                                                  context,
                                                  _updateStartDate,
                                                  _updateEndDate,
                                                  null,
                                                  null,
                                                  employees,
                                                  _selectedValue2,
                                                  _selectedValue,
                                                  updateSelectedValueAndSelectedValue2),
                                              buildAddEditHoursTab1ContentWorkOrderActivitiesBlocksExpanded(
                                                  context,
                                                  workOrderJobs,
                                                  _scrollController,
                                                  evenRow,
                                                  updateSelectedJob),
                                            ],
                                          ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        _loadClosedWorkOrderProductsHours(
                            workOrder, workOrderCubit),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
              child: Row(
                children: <Widget>[
                  buildExpandedAddEditHoursCancelButton(
                      context,
                      workOrderCubit,
                      workOrder.orderId,
                      workOrder.companyId,
                      workOrder.branchId),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        var workOrderHour = new WorkOrderHours();
                        workOrderHour.employeeId = _selectedValue.id;
                        workOrderHour.startTime = startDateTime!;
                        workOrderHour.endTime = endDateTime!;
                        workOrderHour.job = selectedJob;
                        workOrderDetailRequest.lineType =
                            WorkOrderDetailType.Hours; // 6 is Hours

                        workOrderCubit.createWorkOrderDetail(
                            workOrderDetailRequest,
                            workOrderHour,
                            WorkOrderDetailType.Hours);
                        Navigator.pop(context);
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _loadClosedWorkOrderProductsHours(
      V112WorkOrder workOrder, WorkOrderCubit workOrderCubit) {
    return BlocConsumer<WorkOrderCubit, WorkOrderState>(
      listener: (context, state) {
        if (state is WorkOrderDetailsDeleted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!
                  .translate('work.order.delete.order.details')),
              backgroundColor: CustomColors.buttonGreen,
            ),
          );
        }
        if (state is WorkOrderDetailsAdded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!
                  .translate('work.order.add.order.details')),
              backgroundColor: CustomColors.buttonGreen,
            ),
          );
        }
        if (state is WorkOrderDetailsEdited) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 2),
              content: Text(AppLocalizations.of(context)!
                  .translate('work.order.update.order.details')),
              backgroundColor: CustomColors.buttonGreen,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is WorkOrderLoading) {
          return buildLoading(context);
        } else if (state is WorkOrderLoaded) {
          var workOrderDetails = state.workOrder.details;

          if (workOrderDetails.length > 0) {
            bool closedHours = false;
            for (var detail in workOrderDetails) {
              var response = getLineTypeEnum(detail.lineType!).toLowerCase();
              if (response == "hours") {
                closedHours = true;
              }
            }
            return Align(
              alignment: Alignment.topCenter,
              child: closedHours
                  ? ListView.builder(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      itemBuilder: (context, index) {
                        switch (
                            getLineTypeEnum(workOrderDetails[index].lineType!)
                                .toLowerCase()) {
                          case "hours":
                            return _loadClosedWorkOrderProductsHoursBlock(
                                workOrderDetails[index],
                                state.workOrder,
                                workOrderCubit);
                          default:
                            return Container();
                        }
                      },
                      itemCount: workOrderDetails.length,
                    )
                  : buildWarning(
                      AppLocalizations.of(context)!.translate(
                          'work.order.add.edit.hours.page.tab.closed.orders.hours.no.hourse.found'),
                    ),
            );
          } else if (state is WorkOrderError) {
            return buildWarning(AppLocalizations.of(context)!.translate(
                'work.order.add.edit.hours.page.tab.closed.orders.hours.no.hourse.found'));
          } else {
            return buildEmpty();
          }
        } else {
          return buildEmpty();
        }
      },
    );
  }

  Widget _loadClosedWorkOrderProductsHoursBlock(
      V112WorkOrderDetail workOrderDetail,
      V112WorkOrder workOrder,
      WorkOrderCubit workOrderCubit) {
    return WorkOrderBlockHours(
        workOrderDetail: workOrderDetail,
        workOrder: workOrder,
        workOrderCubit: workOrderCubit);
  }
}

class _WorkOrdersEditHoursState extends State<WorkOrdersEditHoursPage> {
  final ScrollController _scrollController = ScrollController();
  late WorkOrderDetailChangeRequest workOrderDetailChangeRequest;
  late WorkOrderHours workOrderDetailsHours;

  DateTime? startDateTime;
  DateTime? endDateTime;

  _updateStartDate(DateTime _startDateTime) {
    setState(() => startDateTime = _startDateTime);
  }

  _updateEndDate(DateTime _endDateTime) {
    setState(() => endDateTime = _endDateTime);
  }

  late var workOrderCubit;
  bool evenRow = true;

  late var employeeCubit;
  List<V12Employee> employees = [];
  V12Employee _selectedValue = new V12Employee();
  String? _selectedValue2 = "";

  updateSelectedValueAndSelectedValue2(String? selectedValue2) {
    setState(() {
      _selectedValue2 = selectedValue2;
      String idFromSelectedValue =
          _selectedValue2.toString().split('-').first.trim();
      _selectedValue =
          employees.firstWhere((x) => x.id.toString() == idFromSelectedValue);
    });
  }

  List<Job> workOrderJobs = [];
  Job selectedJob = new Job();

  updateSelectedJob(Job newSelectedJob) {
    setState(() {
      selectedJob = newSelectedJob;
    });
  }

  @override
  void initState() {
    super.initState();
    workOrderDetailsHours = widget.data["workOrderDetailsHours"];
    workOrderDetailChangeRequest = widget.data["workOrderDetailChangeRequest"];
    workOrderDetailChangeRequest.hours = new WorkOrderHours();
    employeeCubit = context.read<EmployeeCubit>();
    workOrderCubit = widget.data['workOrderCubit'];

    setState(() {
      startDateTime = workOrderDetailsHours.startTime;
      endDateTime = workOrderDetailsHours.endTime;
    });

    employeeCubit.getEmployees().then((value) {
      setState(() {
        employees = this.employeeCubit.state.employees;
        _selectedValue = employees.firstWhere(
            (element) => element.id == workOrderDetailsHours.employeeId);
        _selectedValue2 = _selectedValue.id.toString() +
            " - " +
            _selectedValue.name.toString();
      });
    });

    workOrderCubit
        .getWorkOrderJobs(workOrderDetailChangeRequest.companyId)
        .then((value) {
      setState(() {
        List<Job> workOrderJobsFromApi =
            this.workOrderCubit.state.workOrdersJobs;
        List<Job> workOrderJobs2 = [];
        for (var jb in workOrderJobsFromApi) {
          var job = jb;
          if (job.id == workOrderDetailsHours.job.id) {
            workOrderJobs.add(job);
          } else {
            workOrderJobs2.add(job);
          }
        }
        workOrderJobs.addAll(workOrderJobs2);

        workOrderJobs
            .firstWhere((element) => element.id == workOrderDetailsHours.job.id)
            .isSelected = true;
        selectedJob = workOrderJobs.firstWhere(
            (element) => element.id == workOrderDetailsHours.job.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        workOrderCubit.getWorkOrderById(
            workOrderDetailChangeRequest.orderId,
            workOrderDetailChangeRequest.companyId,
            workOrderDetailChangeRequest.branchId);
        return true;
      },
      child: DefaultTabController(
        length: 8,
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          drawer: NavigationDrawerWidget(),
          appBar: buildAddEditHoursAppBar(
              context,
              workOrderDetailChangeRequest.orderId,
              workOrderDetailChangeRequest.companyId,
              workOrderDetailChangeRequest.branchId,
              workOrderCubit),
          body: DefaultTabController(
            length: 1,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  buildEditHoursTabBar(
                      context,
                      AppLocalizations.of(context)!.translate(
                          'work.order.add.edit.hours.page.tab.edit.hours')),
                  Expanded(
                    child: Container(
                      child: TabBarView(children: [
                        LayoutBuilder(builder: (BuildContext context,
                            BoxConstraints viewportConstraints) {
                          return SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    padding: EdgeInsets.only(
                                        left: 20, top: 20, right: 20),
                                    child: IntrinsicHeight(
                                      child: Container(
                                        child: Responsive.isMobile(context)
                                            ? Column(children: <Widget>[
                                                buildAddEditHoursTab1ContentEmployeesDatePickerExpanded(
                                                    context,
                                                    _updateStartDate,
                                                    _updateEndDate,
                                                    startDateTime,
                                                    endDateTime,
                                                    employees,
                                                    _selectedValue2,
                                                    _selectedValue,
                                                    updateSelectedValueAndSelectedValue2),
                                                buildAddEditHoursTab1ContentWorkOrderActivitiesBlocksExpanded(
                                                    context,
                                                    workOrderJobs,
                                                    _scrollController,
                                                    evenRow,
                                                    updateSelectedJob,
                                                    left: 0,
                                                    top: 30),
                                              ])
                                            : Row(children: <Widget>[
                                                buildAddEditHoursTab1ContentEmployeesDatePickerExpanded(
                                                    context,
                                                    _updateStartDate,
                                                    _updateEndDate,
                                                    startDateTime,
                                                    endDateTime,
                                                    employees,
                                                    _selectedValue2,
                                                    _selectedValue,
                                                    updateSelectedValueAndSelectedValue2),
                                                buildAddEditHoursTab1ContentWorkOrderActivitiesBlocksExpanded(
                                                    context,
                                                    workOrderJobs,
                                                    _scrollController,
                                                    evenRow,
                                                    updateSelectedJob),
                                              ]),
                                      ),
                                    ),
                                  ),
                                ]),
                          );
                        }),
                      ]),
                    ),
                  ),
                ]),
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
                  left: 5.0, top: 6.0, right: 9.0, bottom: 6.0),
              child: Row(children: <Widget>[
                buildExpandedAddEditHoursCancelButton(
                    context,
                    workOrderCubit,
                    workOrderDetailChangeRequest.orderId,
                    workOrderDetailChangeRequest.companyId,
                    workOrderDetailChangeRequest.branchId),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  flex: 1,
                  child: ElevatedButton(
                    onPressed: () {
                      workOrderDetailChangeRequest.hours.employeeId =
                          _selectedValue.id;
                      workOrderDetailChangeRequest.hours.startTime =
                          startDateTime;
                      workOrderDetailChangeRequest.hours.endTime = endDateTime;
                      workOrderDetailChangeRequest.hours.job = selectedJob;
                      workOrderDetailChangeRequest.lineType = "6"; // 6 is Hours

                      workOrderCubit
                          .editWorkOrderDetail(workOrderDetailChangeRequest);
                      Navigator.pop(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)!.translate('save.message'),
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
      ),
    );
  }
}

AppBar buildAddEditHoursAppBar(BuildContext context, int orderId, int companyId,
    int branchId, workOrderCubit) {
  return AppBar(
    backgroundColor: Theme.of(context).colorScheme.primary,
    centerTitle: true,
    title: Text(AppLocalizations.of(context)!
            .translate('work.order.add.edit.hours.page.title') +
        " - " +
        orderId.toString()),
    actions: <Widget>[
      IconButton(
        onPressed: () {
          workOrderCubit.getWorkOrderById(orderId, companyId, branchId);
          Navigator.pop(context);
        },
        icon: Icon(FontAwesomeIcons.caretSquareLeft),
      ),
    ],
  );
}

Container buildAddHoursTabBar(
    BuildContext context, String tab1Title, String tab2Title) {
  return Container(
    color: CustomColors.evenRow,
    child: TabBar(
        labelColor: Colors.black,
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 18,
        ),
        indicatorColor: Theme.of(context).colorScheme.secondary,
        indicatorWeight: 5,
        tabs: [
          Tab(
            child: Text(
              tab1Title,
              textAlign: TextAlign.center,
            ),
          ),
          Tab(
            child: Text(
              tab2Title,
              textAlign: TextAlign.center,
            ),
          ),
        ]),
  );
}

Container buildEditHoursTabBar(BuildContext context, String tab1Title) {
  return Container(
    color: CustomColors.evenRow,
    child: TabBar(
        labelColor: Colors.black,
        labelStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 18,
        ),
        indicatorColor: Theme.of(context).colorScheme.secondary,
        indicatorWeight: 5,
        tabs: [
          Tab(
            child: Text(
              tab1Title,
            ),
          ),
        ]),
  );
}

Widget buildAddEditHoursTab1ContentEmployeesDatePickerExpanded(
    BuildContext context,
    _updateStartDate,
    _updateEndDate,
    DateTime? startDateTime,
    DateTime? endDateTime,
    List<V12Employee> employees,
    String? _selectedValue2,
    V12Employee _selectedValue,
    updateSelectedValueAndSelectedValue2) {
  return Container(
    width: Responsive.isMobile(context)
        ? MediaQuery.of(context).size.width
        : MediaQuery.of(context).size.width / 2,
    padding: EdgeInsets.only(right: 10),
    alignment: Alignment.topCenter,
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Text(
              AppLocalizations.of(context)!
                  .translate('work.order.add.edit.hours.page.tab.new.activity'),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Container(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                AppLocalizations.of(context)!
                    .translate('work.order.add.edit.hours.page.tab.empolyees'),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: CustomColors.black,
                ),
              ),
            ),
          ),
          employeesWidget(context, employees, _selectedValue2, _selectedValue,
              updateSelectedValueAndSelectedValue2),
          DateTimeRangePickerWidget(
              _updateStartDate, _updateEndDate, startDateTime, endDateTime),
        ]),
  );
}

Widget employeesWidget(
  BuildContext context,
  List<V12Employee> employees,
  String? _selectedValue2,
  V12Employee _selectedValue,
  updateSelectedValueAndSelectedValue2,
) {
  return Container(
    height: 55,
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
    child: Row(children: <Widget>[
      Expanded(
        flex: 6,
        child: Padding(
          padding: const EdgeInsets.only(left: 15),
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
                    ],
                  ),
                ),
              ),
            ),
            isCaseSensitiveSearch: false,
            items: employees.map(
              (value) {
                return DropdownMenuItem(
                  child: Text(
                    value.id.toString() + " - " + value.name.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.0,
                    ),
                  ),
                  value: value.id.toString() + " - " + value.name.toString(),
                );
              },
            ).toList(),
            value: _selectedValue2,
            hint: AppLocalizations.of(context)!.translate(
                'work.order.add.edit.hours.page.tab.select.empolyee'),
            searchHint: null,
            onChanged: (value) {
              updateSelectedValueAndSelectedValue2(value);
            },
            dialogBox: true,
            isExpanded: true,
            displayClearIcon: false,
            padding: 0,
            // menuConstraints:
            //     BoxConstraints.tight(Size.fromHeight(350)),
          ),
        ),
      ),
      // Expanded(
      //   flex: 1,
      //   child: Column(children: <Widget>[
      //     StreamBuilder<CustomerCubit>(
      //         stream: null,
      //         builder: (context, snapshot) {
      //           return Align(
      //             alignment: Alignment.topRight,
      //             child: GestureDetector(
      //               onTap: () {
      //                 Navigator.of(context).pushNamed(
      //                   workOrdersEmployeeRoute,
      //                   arguments: {
      //                     'employeeId': _selectedValue.id.toString(),
      //                   },
      //                 );
      //               },
      //               child: Column(children: [
      //                 Icon(
      //                   FontAwesomeIcons.plusSquare,
      //                   color: Theme.of(context).colorScheme.primary,
      //                   size: (49),
      //                 ),
      //               ]),
      //             ),
      //           );
      //         }),
      //   ]),
      // ),
    ]),
  );
}

Widget buildAddEditHoursTab1ContentWorkOrderActivitiesBlocksExpanded(
    BuildContext context,
    List<Job> workOrderJobs,
    ScrollController scrollController,
    bool evenRow,
    updateSelectedJob,
    {double left = 10,
    double top = 10}) {
  return Expanded(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: left),
            child: Row(children: <Widget>[
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 10, top: top),
                    child: Text(
                      AppLocalizations.of(context)!.translate(
                          'work.order.add.edit.hours.page.tab.order.activities'),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  Container(
                    child: Column(children: [
                      _loadWorkOrderActivities(context, workOrderJobs,
                          scrollController, evenRow, updateSelectedJob),
                    ]),
                  ),
                ],
              )),
            ]),
          ),
        ]),
  );
}

Widget _loadWorkOrderActivities(BuildContext context, List<Job> jobs,
    ScrollController _scrollController, bool evenRow, updateSelectedJob) {
  if (jobs.length > 0) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      width: double.infinity,
      child: Scrollbar(
        isAlwaysShown: true,
        controller: _scrollController,
        child: ListView.builder(
          padding: EdgeInsets.only(bottom: 50),
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: jobs.length,
          itemBuilder: (BuildContext context, int index) {
            if (evenRow) {
              evenRow = false;
            } else {
              evenRow = true;
            }
            return new InkWell(
              splashColor: Theme.of(context).colorScheme.primary,
              onTap: () {
                jobs.forEach((element) => element.isSelected = false);
                jobs[index].isSelected = true;
                updateSelectedJob(jobs[index]);
              },
              child: new JobRadioItem(jobs[index], evenRow),
            );
          },
        ),
      ),
    );
  } else {
    return Text('');
  }
}

class JobRadioItem extends StatelessWidget {
  final Job _item;
  final bool _evenRow;

  JobRadioItem(this._item, this._evenRow);

  @override
  Widget build(BuildContext context) {
    return new Container(
      decoration: new BoxDecoration(
        color: _evenRow ? CustomColors.oddRow : CustomColors.evenRow,
      ),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin:
                      new EdgeInsets.only(left: 10.0, top: 15.0, bottom: 15.0),
                  child: new Text(
                    _item.description.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                        color: CustomColors.black),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 30.0,
                  width: 30.0,
                  child: new Center(
                    child: new Text(
                      _item.id.toString(),
                      style: new TextStyle(
                          color: _item.isSelected
                              ? CustomColors.white
                              : CustomColors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  decoration: new BoxDecoration(
                    color: _item.isSelected
                        ? Theme.of(context).colorScheme.primary
                        : Colors.transparent,
                    border: new Border.all(
                        width: 1.0,
                        color: _item.isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.grey),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30.0),
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
}

Expanded buildExpandedAddEditHoursCancelButton(BuildContext context,
    WorkOrderCubit workOrderCubit, int orderId, int companyId, int branchId) {
  return Expanded(
    flex: 1,
    child: ElevatedButton(
      onPressed: () {
        workOrderCubit.getWorkOrderById(orderId, companyId, branchId);
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
  );
}
