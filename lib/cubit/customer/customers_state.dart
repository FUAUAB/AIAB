part of 'customers_cubit.dart';

abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object> get props => [];
}

///---------------------------------------------------LIST
class CustomerListInitial extends CustomerState {}

class CustomerListLoading extends CustomerState {}

class CustomerListLoaded extends CustomerState {
  final List<Customer> customers;

  const CustomerListLoaded(this.customers);

  @override
  List<Object> get props => [this.customers];
}

class CustomerEnhancedListLoaded extends CustomerState {
  final List<V111CustomerEnhanced> customers;

  const CustomerEnhancedListLoaded(this.customers);

  @override
  List<Object> get props => [this.customers];
}

class CustomerListError extends CustomerState {
  final String errorMessage;

  CustomerListError(this.errorMessage);
}

///--------------------------------------------------SINGLE
class CustomerInitial extends CustomerState {
  const CustomerInitial();
}

class CustomerLoading extends CustomerState {
  const CustomerLoading();
}

class CustomerLoaded extends CustomerState {
  final Customer customer;

  const CustomerLoaded(this.customer);

  @override
  List<Object> get props => [this.customer];
}

class CustomerEnhancedLoaded extends CustomerState {
  final V111CustomerEnhanced customer;

  const CustomerEnhancedLoaded(this.customer);

  @override
  List<Object> get props => [this.customer];
}

class CustomerError extends CustomerState {
  const CustomerError();
}
