import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/core/helpers/helperMethods.dart';
import 'package:work_order_app/cubit/customer/customers_cubit.dart';
import 'package:work_order_app/presentation/widgets/appbars/appbar_title.dart';
import 'package:work_order_app/presentation/widgets/blocks/customer_block.dart';
import 'package:work_order_app/presentation/widgets/blocks/empty_content_column_block.dart';
import 'package:work_order_app/presentation/widgets/blocks/work_orders_block_widget.dart';
import 'package:work_order_app/presentation/widgets/generics/build_state.dart';
import 'package:work_order_app/presentation/widgets/menus/navigation_drawer.dart';

import '../../../app_localizations.dart';
import '../../../cubit/work_order/work_order_cubit.dart';
import '../../styles/colors_style.dart';

class CustomerDetailsPage extends StatefulWidget {
  const CustomerDetailsPage({Key? key, required this.customer})
      : super(key: key);

  final Customer customer;

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> {
  final TextEditingController searchController = new TextEditingController();
  final ScrollController _scrollController = ScrollController();

  late var workOrderCubit;
  late var customerCubit;
  late V111CustomerEnhanced customerEnhanced;

  @override
  void initState() {
    super.initState();
    workOrderCubit = context.read<WorkOrderCubit>();
    workOrderCubit.getWorkOrders(widget.customer.customerId);
    customerCubit = context.read<CustomerCubit>();
    customerCubit.getCustomerEnhancedById(widget.customer.customerId);
    customerCubit
        .getCustomerEnhancedById(widget.customer.customerId)
        .then((value) {
      setState(() {
        customerEnhanced =
            this.customerCubit.state.customer as V111CustomerEnhanced;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: NavigationDrawerWidget(),
      appBar: buildAppBarTitle(context, widget.customer.name!),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.oddRow,
                      borderRadius: BorderRadius.all(
                        Radius.circular(7.0),
                      ),
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 4, horizontal: 0),
                                  child: TextButton(
                                    child: Text(
                                      widget.customer.customerId.toString() +
                                          " - " +
                                          widget.customer.name.toString(),
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    onPressed: () {},
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: CustomColors.evenRow,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 11),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('customer.details.adress'),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      color: CustomColors.black,
                                      backgroundColor: CustomColors.evenRow),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 11),
                                child: Text(
                                  widget.customer.address!.street!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: CustomColors.black,
                                      backgroundColor: CustomColors.evenRow),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: CustomColors.oddRow,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 11),
                                child: Text(
                                  AppLocalizations.of(context)!
                                      .translate('customer.details.zipcode'),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      color: CustomColors.black,
                                      backgroundColor: CustomColors.oddRow),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 11),
                                child: Text(
                                  widget.customer.address!.postalCode!,
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontSize: 15.0,
                                      color: CustomColors.black,
                                      backgroundColor: CustomColors.oddRow),
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    color: CustomColors.evenRow,
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 11),
                              child: Text(
                                AppLocalizations.of(context)!
                                    .translate('customer.details.place'),
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0,
                                    color: CustomColors.black,
                                    backgroundColor: CustomColors.evenRow),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 11),
                              child: Text(
                                widget.customer.address!.city!,
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 15.0,
                                    color: CustomColors.black,
                                    backgroundColor: CustomColors.evenRow),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: CustomColors.oddRow,
                      borderRadius: BorderRadius.all(
                        Radius.circular(7.0),
                      ),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 11),
                                child: Text(
                                  AppLocalizations.of(context)!.translate(
                                      'customer.details.phonenumber'),
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15.0,
                                      color: CustomColors.black,
                                      backgroundColor: CustomColors.oddRow),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 11),
                                  child: Text(
                                    widget.customer.contactInformation!.phone!,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 15.0,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      backgroundColor: CustomColors.oddRow,
                                    ),
                                  ),
                                )
                              ],
                            ),
                            onTap: () {
                              var phoneNum = widget.customer.contactInformation
                                      .mobile.isNotEmpty
                                  ? widget.customer.contactInformation.mobile
                                  : widget.customer.contactInformation.phone;
                              if (phoneNum.isEmpty) return;
                              performCall(phoneNum);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    thickness: 2,
                    height: 2,
                    color: CustomColors.greyBorder,
                  ),
                ],
              ),
            ),
            TabBar(
              tabs: [
                Tab(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('work.order.details.title'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.of(context)!
                        .translate('customer.details.tab.contactPerson'),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [
                  _getWorkOrder(),
                  _getCustomerContactPersons(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getWorkOrder() {
    return Column(
      children: [
        Expanded(
          // A flexible child that will grow to fit the viewport but
          // still be at least as big as necessary to fit its contents.
          child: Container(
            height: 120.0,
            alignment: Alignment.center,
            child: BlocBuilder<WorkOrderCubit, WorkOrderState>(
              builder: (context, state) {
                if (state is WorkOrderListLoading) {
                  return buildLoading(context);
                }
                if (state is WorkOrderListLoaded &&
                    state.workOrders.length > 0) {
                  return WorkOrdersBlockWidget(state.workOrders);
                } else {
                  return buildNoContentColumn(
                      context,
                      AppLocalizations.of(context)!
                          .translate('customer.no.orders.available'));
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _getCustomerContactPersons() {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is CustomerListLoading) {
          return buildLoading(context);
        } else if (state is CustomerEnhancedLoaded &&
            state.customer.contactPersons.length > 0) {
          return Scrollbar(
            controller: _scrollController,
            isAlwaysShown: true,
            child: ListView.separated(
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index < state.customer.contactPersons.length) {
                  var contactPersons = state.customer.contactPersons[index];
                  return BuildCustomerContactPersonBlock(contactPersons);
                } else {
                  return buildLoading(context);
                }
              },
              separatorBuilder: (context, index) {
                return Divider();
              },
              itemCount: state.customer.contactPersons.length,
            ),
          );
        } else {
          return Text(AppLocalizations.of(context)!.translate('error.message'));
        }
      },
    );
  }
}
