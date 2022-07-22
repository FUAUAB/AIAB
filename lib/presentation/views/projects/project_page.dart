import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mavis_api_client/api.dart';

import '../../../app_localizations.dart';
import '../../../core/constants/constants.dart';
import '../../../cubit/customer/customers_cubit.dart';
import '../../../cubit/project/project_cubit.dart';
import '../../../cubit/project/project_state.dart';
import '../../widgets/appbars/appbar_title_with_search.dart';
import '../../widgets/blocks/project_content_block.dart';
import '../../widgets/generics/build_state.dart';
import '../../widgets/menus/navigation_drawer.dart';
import '../../widgets/searchbar/delegate_search.dart';

class ProjectPage extends StatelessWidget {
  const ProjectPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<CustomerCubit>().getCustomers();
    context.read<ProjectCubit>().getProjects();
    return Scaffold(
      appBar: buildAppBarTitleWithSearch(
          context,
          AppLocalizations.of(context)!.translate('Alle projecten'),
          _customersSearch()),
      drawer: NavigationDrawerWidget(),
      body: _loadProjects(),
    );
  }

  Widget _loadProjects() {
    return BlocBuilder<ProjectCubit, ProjectState>(
      builder: (context, state) {
        if (state is ProjectLoading) {
          return buildLoading(context);
        }
        List<Project> projects = [];
        if (state is ProjectsLoaded) {
          projects = state.projects;
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: getProjectGridcount(context),
                childAspectRatio: 1),
            shrinkWrap: true,
            itemCount: projects.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                  onTap: () {
                    WorkOrderRequest workOrderRequest = new WorkOrderRequest();
                    workOrderRequest.customerId = projects[index].customerId;
                    // addNewWorkOrderDialog(context, "Add work order text", projects[index], context.read<WorkOrderCubit>(), workOrderRequest);
                  },
                  child: ProjectContentBlock(project: projects[index]));
            },
          ),
        );
      },
    );
  }

  Widget _customersSearch() {
    return BlocBuilder<CustomerCubit, CustomerState>(
      builder: (context, state) {
        if (state is CustomerListLoading) {
          return buildEmpty();
        } else if (state is CustomerListLoaded) {
          return searchFieldView(
              context, state.customers, SearchTermType.Customer, null);
        } else {
          return Text(AppLocalizations.of(context)!.translate('error.message'));
        }
      },
    );
  }
}
