import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/app_localizations.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/core/responsive/responsive.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

import '../../../cubit/work_order/work_order_cubit.dart';

class BottomSectionSearchWorkOrderByCustomer extends StatelessWidget {
  const BottomSectionSearchWorkOrderByCustomer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WorkOrderRequest workOrderRequest = new WorkOrderRequest();
    return Container(
      height: Responsive.isMobile(context) ? 120 : 70,
      alignment: Alignment.centerRight,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: CustomColors.greyContainerBorder, width: 2),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
            left: 20.0, top: 5.0, right: 20.0, bottom: 15.0),
        child: Responsive.isMobile(context)
            ? Column(
                children: <Widget>[
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(customersRoute),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('work.order.employee.search.customer'),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 5,
                  // ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          workOrdersAddWorkOrderPage,
                          arguments: {
                            'workOrderCubit': context.read<WorkOrderCubit>(),
                            'workOrderRequest': workOrderRequest,
                          },
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('work.order.add.new.work.order'),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed(customersRoute),
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('work.order.employee.search.customer'),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(
                          workOrdersAddWorkOrderPage,
                          arguments: {
                            'workOrderCubit': context.read<WorkOrderCubit>(),
                            'workOrderRequest': workOrderRequest,
                          },
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('work.order.add.new.work.order'),
                        style: TextStyle(
                          fontSize: 16.0,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
