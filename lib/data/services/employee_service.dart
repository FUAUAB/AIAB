// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/core/api/client.dart';
import 'package:work_order_app/core/constants/constants.dart';

class EmployeeService {
  final Client client;

  EmployeeService({required this.client});

  late SharedPreferences sharedPreferences;

  Future<List<V12Employee>> getEmployees() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var employeeId = sharedPreferences
        .getString(CachedLoginData.employeeIdString)
        .toString();
    try {
      var jobRoleId = 8; // roleId 8 is Mechanic
      List<V12Employee> employeesFromApi =
          await client.employeeApi.getAllCompanyEmployees(jobRoleId: jobRoleId);
      List<V12Employee> employees = [];
      List<V12Employee> employees2 = [];
      for (var emp in employeesFromApi) {
        var employee = emp;
        if (employee.id.toString() == employeeId) {
          employees.add(employee);
        } else {
          employees2.add(employee);
        }
      }

      employees.addAll(employees2);

      return employees;
    } catch (e) {
      return new List.empty();
    }
  }

  Future<List<V111CustomerEmployee>> getCustomerEmployees(
      {required int customerId}) async {
    try {
      List<V111CustomerEmployee> customers = await client.employeeApi
          .getCustomerEmployeesV111(customerId, onlyContacts: true);
      return customers;
    } catch (e) {
      return new List.empty();
    }
  }
}
