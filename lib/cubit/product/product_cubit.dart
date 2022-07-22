import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/data/services/product_service.dart';
import 'package:work_order_app/locator.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  var _productService = locator<ProductService>();

  ProductCubit() : super(ProductInitial());

  Future<void> getProductByIdEan(String productId) async {
    try {
      emit(ProductLoading());
      final product =
          await _productService.getProductById(productId: productId);
      emit(ProductLoaded(product!));
    } catch (e) {
      emit(ProductError("Product niet kunnen vinden"));
    }
  }
}
