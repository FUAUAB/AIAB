import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mavis_api_client/api.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:work_order_app/app_localizations.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/cubit/work_order/work_order_cubit.dart';
import 'package:work_order_app/presentation/widgets/blocks/empty_content_column_block.dart';
import 'package:work_order_app/presentation/widgets/generics/build_state.dart';

class WorkOrdersMonthlyTab extends StatefulWidget {
  const WorkOrdersMonthlyTab({Key? key}) : super(key: key);

  @override
  _WorkOrdersMonthlyTabState createState() => _WorkOrdersMonthlyTabState();
}

class _WorkOrdersMonthlyTabState extends State<WorkOrdersMonthlyTab> {
  var workOrders;

  @override
  Widget build(BuildContext context) {
    context.read<WorkOrderCubit>().getScheduledWorkOrdersForEmployee(
          EmployeeWorkOrdersType.Month,
          null,
        );
    return Scaffold(
      body: _loadMonthlyAppointments(),
    );
  }

  Widget _loadMonthlyAppointments() {
    return BlocBuilder<WorkOrderCubit, WorkOrderState>(
      builder: (context, state) {
        if (state is ScheduledWorkOrdersForEmployeeListLoaded) {
          workOrders = state.scheduledWorkOrdersForEmployeeList;
          return SfCalendar(
            dataSource: TaskDataSource(workOrders),
            view: CalendarView.month,
            monthViewSettings: MonthViewSettings(
              appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
              showTrailingAndLeadingDates: false,
            ),
            todayHighlightColor: Theme.of(context).colorScheme.secondary,
            selectionDecoration: BoxDecoration(
              border: Border.all(
                width: 2,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            firstDayOfWeek: 1,
            headerHeight: 60,
            headerStyle: CalendarHeaderStyle(
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                fontSize: 20,
                fontStyle: FontStyle.normal,
                letterSpacing: 2,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            showNavigationArrow: true,
            onTap: _onSelectionChanged,
          );
        } else {
          return buildLoading(context);
        }
      },
    );
  }

  void _onSelectionChanged(CalendarTapDetails details) {
    Navigator.of(context).pushNamed(
      workOrdersSpecificDateRoute,
      arguments: details.date,
    );
  }
}

class TaskDataSource extends CalendarDataSource {
  TaskDataSource(List<V112WorkOrder> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).date;
  }

  @override
  DateTime getEndTime(int index) {
    var startTime = _getMeetingData(index).date;
    var estimatedTime = _getMeetingData(index).estimatedHours;
    return DateTime(startTime.year, startTime.month, startTime.day,
        startTime.hour + estimatedTime.round());
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).orderId!.toString() +
        ' ' +
        _getMeetingData(index).description!;
  }

  V112WorkOrder _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final V112WorkOrder meetingData;
    if (meeting is V112WorkOrder) {
      meetingData = meeting;
    }

    return meetingData;
  }
}
