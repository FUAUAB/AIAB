import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:work_order_app/data/services/customer_service.dart';
import 'package:work_order_app/locator.dart';

part 'customers_state.dart';

class CustomerCubit extends Cubit<CustomerState> {
  var _customerService = locator<CustomerService>();

  CustomerCubit() : super(CustomerListInitial());

  Future<void> getCustomers() async {
    try {
      emit(CustomerListLoading());
      final customers = await _customerService.getCustomers();
      emit(CustomerListLoaded(customers));
    } catch (e) {
      emit(CustomerError());
    }
  }

  Future<void> getCustomer(int customerId) async {
    emit(CustomerLoading());
    final customerById =
        await _customerService.getCustomerById(customerId: customerId);
    emit(CustomerLoaded(customerById));
  }

  Future<void> getCustomersEnhanced() async {
    try {
      emit(CustomerListLoading());
      final customers = await _customerService.getCustomersEnhanced();
      emit(CustomerEnhancedListLoaded(customers));
    } catch (e) {
      emit(CustomerError());
    }
  }

  Future<void> getCustomerEnhancedById(int customerId) async {
    emit(CustomerLoading());
    final customerById =
        await _customerService.getCustomerEnhancedById(customerId: customerId);
    emit(CustomerEnhancedLoaded(customerById));
  }
}
