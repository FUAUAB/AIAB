import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:work_order_app/app_localizations.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/cubit/work_order/work_order_cubit.dart';
import 'package:work_order_app/presentation/widgets/blocks/empty_content_column_block.dart';
import 'package:work_order_app/presentation/widgets/blocks/work_orders_block_widget.dart';
import 'package:work_order_app/presentation/widgets/generics/build_state.dart';

class WorkOrdersWeeklyTab extends StatefulWidget {
  const WorkOrdersWeeklyTab({Key? key}) : super(key: key);

  @override
  _WorkOrdersWeeklyTabState createState() => _WorkOrdersWeeklyTabState();
}

class _WorkOrdersWeeklyTabState extends State<WorkOrdersWeeklyTab> {
  late final WorkOrderCubit workOrderCubit;

  @override
  void initState() {
    super.initState();
    workOrderCubit = context.read<WorkOrderCubit>();
    workOrderCubit.getScheduledWorkOrdersForEmployee(
      EmployeeWorkOrdersType.Week,
      null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WorkOrderCubit, WorkOrderState>(
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
                  .translate('planning.tab.week.no.orders.available'));
        }
      },
    );
  }
}
