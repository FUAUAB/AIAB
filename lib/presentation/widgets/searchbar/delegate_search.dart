import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mavis_api_client/api.dart';

import '../../../app_localizations.dart';
import '../../../core/constants/constants.dart';
import '../../styles/colors_style.dart';

Container searchFieldView(BuildContext context, List<dynamic> searchList,
    String searchHint, updateSelectedProduct) {
  return Container(
    height: 60.0,
    color: CustomColors.evenRow,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 3,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxHeight: 36.0,
                  ),
                  child: ListTile(
                    title: TextField(
                      readOnly: true,
                      onTap: () => showSearch(
                        context: context,
                        delegate: DelegateSearch(
                          searchList: searchList,
                          updateSelectedProduct: updateSelectedProduct,
                          searchHint: searchHint,
                        ),
                      ),
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.fromLTRB(15.0, 0, 0, 0),
                        suffixIcon: Icon(
                          FontAwesomeIcons.search,
                          color: Theme.of(context).colorScheme.primary,
                          size: 17,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        hintText: AppLocalizations.of(context)!
                                .translate('search.title') +
                            searchHint,
                        hintStyle: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class DelegateSearch extends SearchDelegate<dynamic> {
  DelegateSearch({
    required this.searchList,
    required this.updateSelectedProduct,
    required this.searchHint,
  });

  final List<dynamic> searchList;
  final ValueChanged<V13ShopProduct> updateSelectedProduct;
  final String searchHint;

  Future _scanBarcode(BuildContext context) async {
    String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
      "#ff6666",
      "Cancel",
      true,
      ScanMode.BARCODE,
    );
    query = barcodeScanRes;
  }

  @override
  String get searchFieldLabel => searchHint == 'product'
      ? 'Zoek of scan een artikel'
      : 'Zoek een ' + (searchHint);

  @override
  List<Widget> buildActions(BuildContext context) {
    if (searchHint == 'product') {
      return [
        IconButton(
          icon: Icon(Icons.scanner),
          color: Theme.of(context).primaryColor,
          onPressed: () => {_scanBarcode(context)},
        ),
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear),
        ),
      ];
    } else {
      return [
        IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear),
        ),
      ];
    }
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
    return StreamBuilder<List<dynamic>>(
      initialData: searchList,
      builder: (context, searchList) {
        if (!searchList.hasData) {
          return Center(
            child: Text("Geen data Beschikbaar!"),
          );
        }
        var searchType =
            searchList.data!.first.runtimeType.toString().toLowerCase();
        var results;
        switch (searchType) {
          case customerType:
            results = searchList.data!.where(
              (item) =>
                  item.name!.toLowerCase().contains(query.toLowerCase()) ||
                  item.customerId!.toString().contains(query),
            );
            break;
          case workOrderType:
            results = searchList.data!.where(
              (item) =>
                  item.description!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  item.orderId!.toString().contains(query),
            );
            break;
          case productType:
            results = searchList.data!.where(
              (item) =>
                  item.description!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  item.productId!.toString().contains(query),
            );
            break;
          default:
        }

        var listView = ListView(
          children: switchCaseSearchResult(
                  results, context, searchType, updateSelectedProduct)
              .toList(),
        );
        return listView;
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<List<dynamic>>(
      initialData: searchList,
      builder: (context, searchList) {
        if (!searchList.hasData || searchList.data!.length == 0) {
          return Center(
            child: Text("Geen data Beschikbaar!"),
          );
        }
        var searchType =
            searchList.data!.first.runtimeType.toString().toLowerCase();
        var results;
        switch (searchType) {
          case customerType:
            results = searchList.data!.where(
              (item) =>
                  item.name!.toLowerCase().contains(query.toLowerCase()) ||
                  item.customerId!.toString().contains(query),
            );
            break;
          case workOrderType:
            results = searchList.data!.where(
              (item) =>
                  item.description!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  item.orderId!.toString().contains(query),
            );
            break;
          case productType:
            results = searchList.data!.where(
              (item) =>
                  item.productData.name.first.value!
                      .toLowerCase()
                      .contains(query.toLowerCase()) ||
                  item.productId!.toString().contains(query),
            );
            break;
          default:
        }

        var listView = ListView(
            children: switchCaseSearchSuggestionResult(
                results, context, searchType, updateSelectedProduct));
        return listView;
      },
    );
  }

  switchCaseSearchSuggestionResult(results, BuildContext context,
      String searchType, ValueChanged<V13ShopProduct> updateSelectedProduct) {
    switch (searchType) {
      case customerType:
        return results
            .map<ListTile>(
              (item) => ListTile(
                title: Text(
                  item.customerId.toString() + " - " + item.name!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    customerDetailsRoute,
                    arguments: item,
                  );
                },
              ),
            )
            .toList();
      case workOrderType:
        return results
            .map<ListTile>(
              (item) => ListTile(
                title: Text(
                  item.orderId.toString() + " - " + item.description!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    workOrderDetailsRoute,
                    arguments: {
                      'workOrder': item,
                    },
                  );
                },
              ),
            )
            .toList();
      case productType:
        return results
            .map<ListTile>(
              (item) => ListTile(
                title: Text(
                  item.productId.toString() +
                      " - " +
                      item.productData.gtin +
                      " - " +
                      item.productData.name.first.value!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                onTap: () {
                  updateSelectedProduct(item);
                  Navigator.pop(context);
                  // Navigator.of(context).pushNamed(
                  //   workOrderDetailsRoute,
                  //   arguments: {
                  //     'product': item,
                  //   },
                  // );
                },
              ),
            )
            .toList();
      default:
    }
  }

  switchCaseSearchResult(results, BuildContext context, String searchType,
      ValueChanged<V13ShopProduct> updateSelectedProduct) {
    switch (searchType) {
      case customerType:
        return results
            .map<ListTile>(
              (item) => ListTile(
                title: Text(
                  item.customerId.toString() + " - " + item.name!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                leading: Icon(Icons.account_circle),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    customerDetailsRoute,
                    arguments: item,
                  );
                },
              ),
            )
            .toList();
      case workOrderType:
        return results
            .map<ListTile>(
              (item) => ListTile(
                title: Text(
                  item.orderId.toString() + " - " + item.description!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                leading: Icon(FontAwesomeIcons.firstOrder),
                onTap: () {
                  Navigator.of(context).pushNamed(
                    workOrderDetailsRoute,
                    arguments: {
                      'workOrder': item,
                    },
                  );
                },
              ),
            )
            .toList();
      case productType:
        return results
            .map<ListTile>(
              (item) => ListTile(
                title: Text(
                  item.productId.toString() +
                      " - " +
                      item.productData.gtin +
                      " - " +
                      item.productData.name.first.value!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                leading: Icon(FontAwesomeIcons.firstOrder),
                onTap: () {
                  updateSelectedProduct(item);
                  Navigator.pop(context);
                },
              ),
            )
            .toList();
      default:
    }
  }
}
