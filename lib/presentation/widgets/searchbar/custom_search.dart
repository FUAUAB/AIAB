import 'package:flutter/material.dart';
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/presentation/styles/colors_style.dart';

import '../../../core/constants/constants.dart';
import '../generics/build_state.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<dynamic> searchList;
  String searchLabel;
  String searchType;

  bool? forNewAction;

  CustomSearchDelegate({
    required this.searchList,
    required this.searchLabel,
    required this.searchType,
    this.forNewAction,
  });

  @override
  String get searchFieldLabel => 'Zoek $searchLabel';

  @override
  ThemeData appBarTheme(BuildContext context) {
    return ThemeData(
      textTheme: TextTheme(
        subtitle1: TextStyle(color: Colors.black),
        subtitle2: TextStyle(color: Colors.black),
        headline6: TextStyle(
          decorationColor: Colors.white,
          color: Colors.white,
          fontSize: TITLE_FONT_SIZE,
        ),
      ),
      listTileTheme: ListTileThemeData(
        textColor: Theme.of(context).colorScheme.primary,
      ),
      hintColor: Colors.white,
      inputDecorationTheme: InputDecorationTheme(
        border: InputBorder.none,
      ),
      appBarTheme: AppBarTheme(
        color: Theme.of(context).colorScheme.primary,
        titleTextStyle: TextStyle(
          color: Colors.white,
        ),
        toolbarTextStyle: TextStyle(
          color: Colors.white,
        ),
        elevation: 5,
      ),

      dividerTheme: DividerThemeData(
        color: Colors.white,
      ),
      primaryIconTheme: IconThemeData(color: Colors.white),

      textSelectionTheme: TextSelectionThemeData(
        cursorColor: Theme.of(context).colorScheme.primary,
      ), // cursor color
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          query = '';
        },
        icon: Icon(Icons.clear),
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(context, searchList);
      },
      icon: Icon(Icons.arrow_back),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      initialData: searchList,
      builder: (context, searchList) {
        List<dynamic> results = [];

        if (!searchList.hasData || searchList.data!.length == 0) {
          return Center(
            child: Text("Geen resultaten gevonden."),
          );
        }

        switch (searchType) {
          case SearchType.customer:
            List<Customer> customers = searchList.data! as List<Customer>;
            customers.map((customer) => customer.name.toLowerCase());
            results = customers
                .where((listItem) =>
                    listItem.name.toLowerCase().contains(query.toLowerCase()) ||
                    listItem.customerId
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .toList();
            if (results.length == 0) {
              return buildNoSearchResults(context);
            }
            break;
          case SearchType.project:
            List<Project> projects = searchList.data! as List<Project>;
            projects.map((project) => project.name.toLowerCase());
            results = projects
                .where(
                  (listItem) =>
                      listItem.name
                          .toLowerCase()
                          .contains(query.toLowerCase()) ||
                      listItem.projectId
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()),
                )
                .toList();
            if (results.length == 0) {
              return buildNoSearchResults(context);
            }
            break;
          case SearchType.workorder:
            List<V112WorkOrder> workorders =
                searchList.data! as List<V112WorkOrder>;
            workorders.map((workorder) => workorder.description.toLowerCase());
            results = workorders
                .where(
                  (listItem) =>
                      listItem.description
                          .toLowerCase()
                          .contains(query.toLowerCase()) ||
                      listItem.orderId
                          .toString()
                          .toLowerCase()
                          .contains(query.toLowerCase()),
                )
                .toList();
            if (results.length == 0) {
              return buildNoSearchResults(context);
            }
            break;
        }

        return Scrollbar(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (BuildContext context, int index) {
              return Card(
                child: _SearchResultItem(
                  searchType: searchType,
                  item: results[index],
                  forNewAction: forNewAction,
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SearchResultItem extends StatelessWidget {
  final dynamic item;
  final String searchType;

  bool? forNewAction;

  _SearchResultItem(
      {Key? key,
      required this.item,
      required this.searchType,
      this.forNewAction})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (searchType) {
      case SearchType.customer:
        Customer customer = item;
        return ListTile(
          title: Text(
            customer.customerId.toString() + " - " + customer.name.toString(),
            style: TextStyle(fontSize: BUTTON_FONT_SIZE),
          ),
          subtitle: customer.secondName.isEmpty
              ? Text("-")
              : Text(customer.secondName),
          onTap: () {
            if (forNewAction == true) {
              Navigator.pop(context, customer);
            } else {
              Navigator.of(context)
                  .pushNamed(customerDetailsRoute, arguments: customer);
            }
          },
        );
      case SearchType.workorder:
        V112WorkOrder workorder = item;
        return ListTile(
          title: Text(
            workorder.orderId.toString() +
                " - " +
                workorder.description.toString(),
            style: TextStyle(fontSize: BUTTON_FONT_SIZE),
          ),
          subtitle: workorder.customerName.isEmpty
              ? Text("-")
              : Text(
                  workorder.customerName,
                  style: TextStyle(color: CustomColors.black),
                ),
          onTap: () {
            Navigator.of(context).pushNamed(
              workOrderDetailsRoute,
              arguments: {
                'workOrder': workorder,
              },
            );
          },
        );

      default:
        return Text("");
    }
  }
}
