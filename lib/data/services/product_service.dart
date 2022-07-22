// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/core/api/client.dart';

class ProductService {
  final Client client;
  final SharedPreferences sharedPreferences;

  ProductService({required this.client, required this.sharedPreferences});

  Future<Product?> getProductById({required String productId}) async {
    try {
      var type = "0"; // 0 is product, 2 is EAN
      if (productId.length > 10) {
        type = "2";
      }
      final product =
          await client.productApi.product(id: productId, type: type);
      return product;
    } catch (e) {
      return null;
    }
  }
}
