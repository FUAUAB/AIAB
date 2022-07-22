import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';
import 'package:work_order_app/presentation/widgets/blocks/bottom_section_search_work_order_by_customer.dart';
import 'package:work_order_app/presentation/widgets/blocks/empty_content_column_block.dart';
import 'package:work_order_app/presentation/widgets/blocks/work_orders_block_widget.dart';

import '../../../app_localizations.dart';
import '../../../core/constants/constants.dart';
import '../../../cubit/work_order/work_order_cubit.dart';
import '../../widgets/generics/build_state.dart';
import '../../widgets/menus/navigation_drawer.dart';
import '../../widgets/searchbar/custom_search.dart';
import '../../widgets/searchbar/search_bar_filter.dart';

class WorkOrdersPage extends StatefulWidget {
  const WorkOrdersPage({Key? key, this.data}) : super(key: key);

  final Map? data;

  @override
  State<WorkOrdersPage> createState() => _WorkOrdersPageState();
}

class _WorkOrdersPageState extends State<WorkOrdersPage> {
  List<V112WorkOrder> allWorkorders = [];
  late List<V112WorkOrder> _workOrderList;
  late List<dynamic> _filterItems;
  String? _filterValue;

  @override
  Widget build(BuildContext context) {
    _filterItems = [];
    BlocProvider.of<WorkOrderCubit>(context).getWorkOrders(0);
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("Alle werkorders"),
          actions: <Widget>[
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(FontAwesomeIcons.squareCaretLeft),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: BlocBuilder<WorkOrderCubit, WorkOrderState>(
              builder: (context, state) {
                if (state is WorkOrderListLoaded) {
                  return BuildSearchBarFilterWidget(
                    hintText: 'werkorder',
                    title: "Werkorder",
                    onTap: () => showSearch(
                      context: context,
                      delegate: CustomSearchDelegate(
                        searchList: _workOrderList,
                        searchLabel: 'werkorder',
                        searchType: SearchType.workorder,
                      ),
                    ),
                    selectedValue: _filterValue,
                    items: _filterItems,
                    onChangedAction: (newValue) {
                      _filterValue = newValue;
                      context.read<WorkOrderCubit>().filterWorkOrdersOnBranchId(
                            branch: _filterValue!.substring(0, 1),
                            fullList: allWorkorders,
                            isForEmployee: false,
                          );
                    },
                  );
                } else {
                  return buildAppBarLoading(context);
                }
              },
            ),
          ),
        ),
        drawer: NavigationDrawerWidget(),
        bottomNavigationBar: BottomSectionSearchWorkOrderByCustomer(),
        body: BlocConsumer<WorkOrderCubit, WorkOrderState>(
          listener: (context, state) {
            if (state is WorkOrderAddedError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  duration: Duration(seconds: 2),
                  content: Text(AppLocalizations.of(context)!
                      .translate('add.work.order.not.added')),
                  backgroundColor: CustomColors.deleteBackgroundColor,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is WorkOrderListLoading) {
              return buildLoading(context);
            }

            if (state is WorkOrderListLoaded && state.workOrders.length > 0) {
              if (_filterValue == null) {
                allWorkorders = state.workOrders;
              }
              _workOrderList = state.workOrders;
              _filterItems = state.filters;

              return WorkOrdersBlockWidget(state.workOrders);
            } else {
              return buildNoContentColumn(
                context,
                AppLocalizations.of(context)!.translate(
                  'work.order.no.orders.available',
                ),
              );
            }
          },
        ),
      ),
    );
  }

  // Widget _workOrdersSearch() {
  //   return BlocBuilder<WorkOrderCubit, WorkOrderState>(
  //     builder: (context, state) {
  //       if (state is WorkOrderListLoading) {
  //         return buildEmpty();
  //       } else if (state is WorkOrderListLoaded) {
  //         return searchAndFilterView(
  //           context,
  //           state.workOrders,
  //           SearchTermType.WorkOrder,
  //           null,
  //         );
  //       } else {
  //         return Text(AppLocalizations.of(context)!.translate('error.message'));
  //       }
  //     },
  //   );
  // }
}
