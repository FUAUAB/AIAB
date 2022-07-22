import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/cubit/authentication/authentication_cubit.dart';
import 'package:work_order_app/cubit/employee/employee_cubit.dart';
import 'package:work_order_app/cubit/product/product_cubit.dart';
import 'package:work_order_app/presentation/views/authentication/login_page.dart';
import 'package:work_order_app/presentation/views/loading/loading_first_time_screen.dart';
import 'package:work_order_app/presentation/views/loading/loading_screen.dart';
import 'package:work_order_app/presentation/views/work_orders/work_orders_add_product_page.dart';
import 'package:work_order_app/presentation/views/work_orders/work_orders_add_work_order_page.dart';
import 'package:work_order_app/presentation/views/work_orders/work_orders_specific_date_page.dart';

// import 'package:workOrderApp/presentation/views/work_orders/workOrders_edit_hours_page.dart';

import '../../cubit/customer/customers_cubit.dart';
import '../../cubit/project/project_cubit.dart';
import '../../cubit/work_order/work_order_cubit.dart';
import '../../presentation/views/customers/customer_details_page.dart';
import '../../presentation/views/customers/customer_page.dart';
import '../../presentation/views/index.dart';
import '../../presentation/views/projects/project_page.dart';
import '../../presentation/views/work_orders/work_orders_add_edit_hours_page.dart';
import '../../presentation/views/work_orders/work_orders_details_page.dart';
import '../../presentation/views/work_orders/work_orders_employee_page.dart';
import '../../presentation/views/work_orders/work_orders_page.dart';
import '../../presentation/views/work_orders/work_orders_photo_page.dart';
import '../constants/constants.dart';

//Switch case that routes the user to the correct page with optional arguments. Default is an errorpage if nothing was found.
class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    final _authenticationCubit = AuthenticationCubit();
    switch (settings.name) {
      //------------------------------Startup-------------
      case loadingRoute:
        return MaterialPageRoute(
          builder: (authContext) => BlocProvider.value(
            value: _authenticationCubit,
            child: LoadingScreen(),
          ),
        );
      case firstTimeRoute:
        return MaterialPageRoute(
          builder: (authContext) => BlocProvider.value(
            value: _authenticationCubit,
            child: FirstTimePage(),
          ),
        );
      case loginRoute:
        return MaterialPageRoute(
          settings: RouteSettings(name: loginRoute),
          builder: (_) => LoginPage(),
        );
      case homeRoute:
        return MaterialPageRoute(
          settings: RouteSettings(name: homeRoute),
          builder: (_) => BlocProvider(
            create: (context) => WorkOrderCubit(),
            child: IndexPage(),
          ),
        );
      //------------------------------Customers-----
      case customersRoute:
        return MaterialPageRoute(
          settings: RouteSettings(name: customersRoute),
          builder: (_) => BlocProvider(
            create: (context) => CustomerCubit(),
            child: CustomerPage(),
          ),
        );

      case customerDetailsRoute:
        return MaterialPageRoute(
          settings: RouteSettings(name: customerDetailsRoute),
          builder: (_) => MultiBlocProvider(
            providers: [
              BlocProvider<CustomerCubit>(
                create: (context) => CustomerCubit(),
              ),
              BlocProvider<WorkOrderCubit>(
                create: (context) => WorkOrderCubit(),
              ),
            ],
            child: CustomerDetailsPage(
              customer: args as Customer,
            ),
          ),
        );

      //-----------------------------WorkOrders-------
      case workOrdersRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<WorkOrderCubit>(
                    create: (context) => WorkOrderCubit()),
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
              ],
              child: WorkOrdersPage(data: args),
            ),
          );
        } else {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<WorkOrderCubit>(
                    create: (context) => WorkOrderCubit()),
                BlocProvider(create: (context) => ProjectCubit()),
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
              ],
              child: WorkOrdersPage(),
            ),
          );
        }

      case workOrdersSpecificDateRoute:
        return MaterialPageRoute(
          settings: RouteSettings(name: calendarDetailsRoute),
          builder: (authContext) => MultiBlocProvider(
            providers: [
              BlocProvider<WorkOrderCubit>(
                  create: (context) => WorkOrderCubit()),
            ],
            child: WorkOrdersSpecificDatePage(
              args: args as DateTime,
            ),
          ),
        );
      case workOrdersEmployeeRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersEmployeeRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => WorkOrderCubit()),
              ],
              child: WorkOrdersEmployeePage(data: args),
            ),
          );
        } else if (args == null) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersEmployeeRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => WorkOrderCubit()),
              ],
              child: WorkOrdersEmployeePage(data: new Map()),
            ),
          );
        }
        return _errorRoute();

      case workOrderDetailsRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<WorkOrderCubit>(
                    create: (context) => WorkOrderCubit()),
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
              ],
              child: WorkOrdersDetailsPage(data: args),
            ),
          );
        }
        return _errorRoute();

      case workOrderAddHoursRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<WorkOrderCubit>(
                    create: (context) => WorkOrderCubit()),
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
                BlocProvider<EmployeeCubit>(
                    create: (context) => EmployeeCubit()),
              ],
              child: WorkOrdersAddHoursPage(data: args),
            ),
          );
        }
        return _errorRoute();
      case workOrderPhotoRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<WorkOrderCubit>(
                    create: (context) => WorkOrderCubit()),
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
                BlocProvider<EmployeeCubit>(
                    create: (context) => EmployeeCubit()),
              ],
              child: WorkOrdersPhotoPage(data: args),
            ),
          );
        }
        return _errorRoute();

      case workOrderEditHoursRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
                BlocProvider<EmployeeCubit>(
                    create: (context) => EmployeeCubit()),
              ],
              child: WorkOrdersEditHoursPage(data: args),
            ),
          );
        }
        return _errorRoute();

      case workOrderAddTextRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<WorkOrderCubit>(
                    create: (context) => WorkOrderCubit()),
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
                BlocProvider<EmployeeCubit>(
                    create: (context) => EmployeeCubit()),
              ],
              child: WorkOrdersAddHoursPage(data: args),
            ),
          );
        }
        return _errorRoute();

      case workOrderEditTextRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
                BlocProvider<EmployeeCubit>(
                    create: (context) => EmployeeCubit()),
              ],
              child: WorkOrdersEditHoursPage(data: args),
            ),
          );
        }
        return _errorRoute();

      case workOrderAddCostRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<WorkOrderCubit>(
                    create: (context) => WorkOrderCubit()),
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
                BlocProvider<EmployeeCubit>(
                    create: (context) => EmployeeCubit()),
              ],
              child: WorkOrdersAddHoursPage(data: args),
            ),
          );
        }
        return _errorRoute();

      case workOrderEditCostRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
                BlocProvider<EmployeeCubit>(
                    create: (context) => EmployeeCubit()),
              ],
              child: WorkOrdersEditHoursPage(data: args),
            ),
          );
        }
        return _errorRoute();

      case workOrderAddProductRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<WorkOrderCubit>(
                    create: (context) => WorkOrderCubit()),
                BlocProvider<ProductCubit>(create: (context) => ProductCubit()),
              ],
              child: WorkOrdersAddProductPage(data: args),
            ),
          );
        }
        return _errorRoute();

      case workOrdersAddWorkOrderPage:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<WorkOrderCubit>(
                    create: (context) => WorkOrderCubit()),
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
                BlocProvider<ProjectCubit>(create: (context) => ProjectCubit()),
              ],
              child: WorkOrdersAddWorkOrderPage(data: args),
            ),
          );
        }
        return _errorRoute();

      case workOrderEditProductRoute:
        if (args is Map) {
          return MaterialPageRoute(
            settings: RouteSettings(name: workOrdersRoute),
            builder: (_) => MultiBlocProvider(
              providers: [
                BlocProvider<CustomerCubit>(
                    create: (context) => CustomerCubit()),
                BlocProvider<EmployeeCubit>(
                    create: (context) => EmployeeCubit()),
              ],
              child: WorkOrdersEditHoursPage(data: args),
            ),
          );
        }

        return _errorRoute();

      case projectsRoute:
        return MaterialPageRoute(
            settings: RouteSettings(name: projectsRoute),
            builder: (_) => MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) => CustomerCubit()),
                    BlocProvider(create: (context) => ProjectCubit()),
                    BlocProvider<WorkOrderCubit>(
                        create: (context) => WorkOrderCubit()),
                  ],
                  child: ProjectPage(),
                ));

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('Pagina niet gevonden'),
        ),
      );
    });
  }

  void dispose() {}
}
