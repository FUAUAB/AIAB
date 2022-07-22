import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/data/services/employee_service.dart';
import 'package:work_order_app/locator.dart';

part 'employee_state.dart';

class EmployeeCubit extends Cubit<EmployeeState> {
  var _employeeService = locator<EmployeeService>();

  EmployeeCubit() : super(EmployeeInitial());

  Future<void> getEmployees() async {
    emit(EmployeeListLoading());
    final employees = await _employeeService.getEmployees();
    emit(EmployeeListLoaded(employees));
  }
}

class CustomerEmployeeCubit extends Cubit<CustomerEmployeeState> {
  var _employeeService = locator<EmployeeService>();

  CustomerEmployeeCubit() : super(CustomerEmployeeInitial());

  Future<void> getCustomerEmployees(int customerId) async {
    emit(CustomerEmployeeListLoading());
    final workOrderEmployees =
        await _employeeService.getCustomerEmployees(customerId: customerId);
    emit(CustomerEmployeeListLoaded(workOrderEmployees));
  }
}
