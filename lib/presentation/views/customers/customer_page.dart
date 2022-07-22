import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/core/variables/api_variables.dart';
import 'package:work_order_app/presentation/widgets/appbars/appbar_title_with_search.dart';
import 'package:work_order_app/presentation/widgets/blocks/customer_block.dart';

import '../../../app_localizations.dart';
import '../../../cubit/customer/customers_cubit.dart';
import '../../widgets/generics/build_state.dart';
import '../../widgets/menus/navigation_drawer.dart';
import '../../widgets/searchbar/delegate_search.dart';

class CustomerPage extends StatelessWidget {
  final TextEditingController searchController = new TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    if (ApiVariables.customers.isEmpty) {
      BlocProvider.of<CustomerCubit>(context).getCustomers();
    }

    return Scaffold(
      appBar: buildAppBarTitleWithSearch(
          context,
          AppLocalizations.of(context)!.translate('customer.title'),
          _customersSearch()),
      drawer: NavigationDrawerWidget(),
      body: _loadCustomers(),
    );
  }

  Widget _customersSearch() {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is CustomerListLoading) {
          return buildEmpty();
        } else {
          if (state is CustomerListLoaded) {
            ApiVariables.customers = state.customers;
          }
          return searchFieldView(
              context, ApiVariables.customers, SearchTermType.Customer, null);
        }
      },
    );
  }

  Widget _loadCustomers() {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is CustomerListLoading) {
          return buildLoading(context);
        } else {
          if (state is CustomerListLoaded) {
            ApiVariables.customers = state.customers;
          }
          return Scrollbar(
            controller: _scrollController,
            thumbVisibility: true,
            child: ListView.builder(
              controller: _scrollController,
              itemBuilder: (context, index) {
                if (index < ApiVariables.customers.length)
                  return BuildCustomerBlock(
                    customer: ApiVariables.customers[index],
                  );
                else {
                  return buildLoading(context);
                }
              },
              itemCount: ApiVariables.customers.length,
            ),
          );
        }
      },
    );
  }
}
