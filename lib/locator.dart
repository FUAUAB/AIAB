import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/api/client.dart';
import 'data/services/authentication_service.dart';
import 'data/services/customer_service.dart';
import 'data/services/employee_service.dart';
import 'data/services/product_service.dart';
import 'data/services/project_service.dart';
import 'data/services/work_order_service.dart';

GetIt locator = GetIt.instance;

Future<void> init() async {
  locator.registerLazySingleton<AuthenticationService>(
    () => AuthenticationService(
      sharedPreferences: locator(),
      client: locator(),
    ),
  );
  locator.registerLazySingleton<CustomerService>(
      () => CustomerService(client: locator()));
  locator.registerLazySingleton<EmployeeService>(
      () => EmployeeService(client: locator()));
  locator.registerLazySingleton<ProjectService>(
      () => ProjectService(client: locator()));
  locator.registerLazySingleton<WorkOrderService>(
      () => WorkOrderService(client: locator(), sharedPreferences: locator()));
  locator.registerLazySingleton<ProductService>(
      () => ProductService(client: locator(), sharedPreferences: locator()));

  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  locator.registerLazySingleton<Client>(
      () => Client(sharedPreferences: locator()));
}
