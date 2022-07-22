import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/cubit/product/product_cubit.dart';
import 'package:work_order_app/cubit/work_order/work_order_cubit.dart';
import 'package:work_order_app/presentation/widgets/blocks/work_counter_order_block.dart';
import 'package:work_order_app/presentation/widgets/generics/build_state.dart';
import 'package:work_order_app/presentation/widgets/searchbar/scanner_search.dart';

import '../../../app_localizations.dart';
import '../../styles/colors_style.dart';
import '../../widgets/menus/navigation_drawer.dart';

class WorkOrdersAddProductPage extends StatefulWidget {
  const WorkOrdersAddProductPage({Key? key, required this.data})
      : super(key: key);

  final Map data;

  @override
  _WorkOrdersProductState createState() => _WorkOrdersProductState();
}

class _WorkOrdersProductState extends State<WorkOrdersAddProductPage> {
  final ScrollController _scrollController = ScrollController();

  V112WorkOrder workOrder = new V112WorkOrder();
  late WorkOrderDetailRequest workOrderDetailRequest;
  late var productCubit;
  late var workOrderCubit;
  String title = "add";

  late List<Product> selectedProducts = <Product>[];
  late List<dynamic> selectedProductsQuantities = [];
  late List<dynamic> selectedProductQuantity = [];
  late int? _selectedProductValue = 0;

  updateProductSkuSearchTerm(String productSkuSearchTerm) {
    if (selectedProducts
        .any((x) => x.productId.toString() == productSkuSearchTerm)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(AppLocalizations.of(context)!
              .translate('work.order.add.product.already.selected')),
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    } else {
      Product selectedProduct = new Product();
      productCubit.getProductByIdEan(productSkuSearchTerm).then((value) {
        setState(() {
          selectedProduct = this.productCubit.state.product as Product;
          setState(() => selectedProducts.add(selectedProduct));
          var newQuantity = [selectedProduct.productId, 1.0];
          updateSelectedProductQuantity(newQuantity);
          FocusManager.instance.primaryFocus?.unfocus();
        });
      });
    }
  }

  updateSelectedProductQuantity(List<dynamic> selectedProductQuantity) {
    setState(() {
      selectedProductsQuantities
          .removeWhere((x) => x[0] == selectedProductQuantity[0]);
      selectedProductsQuantities.add(selectedProductQuantity);
    });
  }

  deleteProductFromSearchedList(String productSkuSearchTerm) {
    setState(() {
      selectedProducts
          .removeWhere((x) => x.productId.toString() == productSkuSearchTerm);
    });
  }

  @override
  void initState() {
    super.initState();
    workOrder = widget.data["workOrder"];
    workOrderDetailRequest = widget.data["workOrderDetailRequest"];
    workOrderCubit = widget.data['workOrderCubit'];
    context.read<WorkOrderCubit>().getWorkOrderById(
        workOrder.orderId, workOrder.companyId, workOrder.branchId);
    productCubit = context.read<ProductCubit>();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        workOrderCubit.getWorkOrderById(
            workOrder.orderId, workOrder.companyId, workOrder.branchId);
        return true;
      },
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: DefaultTabController(
          length: 8,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            drawer: NavigationDrawerWidget(),
            appBar: AppBar(
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(50),
                child: ScannerFieldView(updateProductSkuSearchTerm),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
              centerTitle: true,
              title: Text(AppLocalizations.of(context)!
                  .translate('work.order.add.product.title')),
              actions: <Widget>[
                IconButton(
                  onPressed: () {
                    workOrderCubit.getWorkOrderById(workOrder.orderId,
                        workOrder.companyId, workOrder.branchId);
                    Navigator.pop(context);
                  },
                  icon: Icon(FontAwesomeIcons.caretSquareLeft),
                ),
              ],
            ),
            body: Container(
              padding: const EdgeInsets.all(10.0),
              child: _workOrderProductArticle(context, selectedProducts),
            ),
            // _productWidget(products, null, selectedProducts),
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: CustomColors.greyContainerBorder,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 6.0, right: 20.0, bottom: 6.0),
                child: Row(children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: ElevatedButton(
                      onPressed: () {
                        workOrderCubit.getWorkOrderById(workOrder.orderId,
                            workOrder.companyId, workOrder.branchId);
                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!
                            .translate('cancel.message'),
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: CustomColors.buttonDisabled,
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
                        var workOrderProducts = <WorkOrderProduct>[];
                        selectedProducts.forEach((element) {
                          var workOrderProduct = WorkOrderProduct();
                          double quantity = selectedProductsQuantities
                              .where((e) => e[0] == element.productId)
                              .first[1];
                          workOrderProduct.productId = element.productId;
                          workOrderProduct.quantityRequired = quantity;
                          workOrderProduct.quantityMadeAvailable = 0;
                          workOrderProducts.add(workOrderProduct);
                        });

                        workOrderDetailRequest.lineType =
                            WorkOrderDetailType.Article; // 0 is Product
                        workOrderCubit.createWorkOrderDetail(
                            workOrderDetailRequest,
                            workOrderProducts,
                            WorkOrderDetailType.Article);

                        Navigator.pop(context);
                      },
                      child: Text(
                        AppLocalizations.of(context)!.translate('save.message'),
                        style: TextStyle(
                          fontSize: 17,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: CustomColors.buttonGreen,
                      ),
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _workOrderProductArticle(
      BuildContext context, List<Product> selectedProducts) {
    if (selectedProducts.length > 0) {
      return Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: ListView.separated(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return _workOrderAddBlockArticle(selectedProducts[index]);
          },
          separatorBuilder: (context, index) {
            return Divider();
          },
          itemCount: selectedProducts.length,
        ),
      );
    } else {
      return buildEmpty();
    }
  }

  Widget _workOrderAddBlockArticle(Product selectedProducts) {
    return WorkOrderAddBlockArticle(
        selectedProducts: selectedProducts,
        deleteProductFromSearchedList: deleteProductFromSearchedList,
        updateSelectedProductQuantity: updateSelectedProductQuantity);
  }
}
