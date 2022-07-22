import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/presentation/widgets/blocks/work_order_block.dart';
import 'package:work_order_app/presentation/widgets/generics/build_state.dart';

class EmployeeWorkOrdersBlockWidget extends StatefulWidget {
  const EmployeeWorkOrdersBlockWidget(this.workOrders, {Key? key})
      : super(key: key);

  final List<V112WorkOrder> workOrders;

  @override
  _EmployeeWorkOrdersBlockWidgetState createState() =>
      _EmployeeWorkOrdersBlockWidgetState();
}

class _EmployeeWorkOrdersBlockWidgetState
    extends State<EmployeeWorkOrdersBlockWidget> {
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);
  late List<V112WorkOrder> workOrders;

  @override
  void initState() {
    super.initState();
    workOrders = widget.workOrders;
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      isAlwaysShown: true,
      child: ListView.separated(
        itemBuilder: (context, index) {
          return _workOrder(workOrders[index], context);
        },
        separatorBuilder: (context, index) {
          return buildEmpty();
        },
        itemCount: workOrders.length,
      ),
    );
  }

  Widget _workOrder(V112WorkOrder workOrder, BuildContext context) {
    return BuildWorkOrderDetailsBlock(
      workOrder: workOrder,
      context: context,
    );
  }
}
