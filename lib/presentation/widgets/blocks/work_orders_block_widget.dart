import 'package:flutter/material.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/presentation/widgets/blocks/work_order_block.dart';

class WorkOrdersBlockWidget extends StatefulWidget {
  const WorkOrdersBlockWidget(this.workOrders, {Key? key}) : super(key: key);

  final List<V112WorkOrder> workOrders;

  @override
  _WorkOrdersBlockWidgetState createState() => _WorkOrdersBlockWidgetState();
}

class _WorkOrdersBlockWidgetState extends State<WorkOrdersBlockWidget> {
  ScrollController _scrollController =
      ScrollController(initialScrollOffset: 0.0);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
      thumbVisibility: true,
      child: ListView.builder(
        controller: _scrollController,
        itemBuilder: (context, index) {
          return BuildWorkOrderDetailsBlock(
              workOrder: widget.workOrders[index], context: context);
        },
        itemCount: widget.workOrders.length,
      ),
    );
  }
}
