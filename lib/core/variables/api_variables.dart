import 'package:mavis_api_client/api.dart';

abstract class ApiVariables {
  // Customers
  static List<Customer> customers = [];

  // My WorkOrders
  //! If used, think about a reload button.
  //! If a new WorkOrder is added when the app is in use it won't be shown, since it isn't known.
  //! A reload button would allow the user to refresh the data when he/she/it wants.
  //! A timer is also an option. Say after 5/10 minutes the app is allowed to execute the API call again.
  static List<V112WorkOrder> myWorkOrders = [];

  // All WorkOrders
  //! If used, think about a reload button.
  //! If a new WorkOrder is added when the app is in use it won't be shown, since it isn't known.
  //! A reload button would allow the user to refresh the data when he/she/it wants.
  //! A timer is also an option. Say after 5/10 minutes the app is allowed to execute the API call again.
  static List<V112WorkOrder> allWorkOrders = [];
}
