import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_app/app_localizations.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/core/helpers/helperMethods.dart';
import 'package:work_order_app/cubit/work_order/work_order_cubit.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';
import 'package:work_order_app/presentation/widgets/blocks/empty_content_column_block.dart';
import 'package:work_order_app/presentation/widgets/blocks/work_orders_block_widget.dart';
import 'package:work_order_app/presentation/widgets/generics/build_state.dart';

class WorkOrdersDailyTab extends StatefulWidget {
  const WorkOrdersDailyTab({Key? key}) : super(key: key);

  @override
  _WorkOrdersDailyTabState createState() => _WorkOrdersDailyTabState();
}

class _WorkOrdersDailyTabState extends State<WorkOrdersDailyTab> {
  late final WorkOrderCubit workOrderCubit;

  @override
  void initState() {
    super.initState();
    workOrderCubit = context.read<WorkOrderCubit>();
    workOrderCubit.getScheduledWorkOrdersForEmployee(
      EmployeeWorkOrdersType.Day,
      null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _planningTodayTopSection(),
        BlocBuilder<WorkOrderCubit, WorkOrderState>(
          builder: (context, state) {
            if (state is ScheduledWorkOrdersForEmployeeListLoading) {
              return buildLoading(context);
            }
            if (state is ScheduledWorkOrdersForEmployeeListLoaded &&
                state.scheduledWorkOrdersForEmployeeList.length > 0) {
              return Expanded(
                  child: WorkOrdersBlockWidget(
                      state.scheduledWorkOrdersForEmployeeList));
            } else {
              return buildNoContentColumn(
                  context,
                  AppLocalizations.of(context)!
                      .translate('planning.tab.today.no.orders.available'));
            }
          },
        ),
      ],
    );
  }

  Widget _planningTodayTopSection() {
    return Container(
      height: 50,
      padding: EdgeInsets.only(left: 20, top: 20),
      child: Text(
        DateTime.now().day.toString() +
            " " +
            getMonthString(DateTime.now().month) +
            " " +
            DateTime.now().year.toString(),
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 20.0, color: CustomColors.black),
      ),
    );
  }
}
