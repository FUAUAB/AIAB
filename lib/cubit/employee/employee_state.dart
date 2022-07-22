part of 'employee_cubit.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();

  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {
  const EmployeeInitial();
}

class EmployeeListLoading extends EmployeeState {
  const EmployeeListLoading();
}

class EmployeeListLoaded extends EmployeeState {
  final List<V12Employee> employees;

  const EmployeeListLoaded(this.employees);

  @override
  List<Object> get props => [this.employees];
}

class EmployeeError extends EmployeeState {
  const EmployeeError();
}

abstract class CustomerEmployeeState extends Equatable {
  const CustomerEmployeeState();

  @override
  List<Object> get props => [];
}

class CustomerEmployeeInitial extends CustomerEmployeeState {
  const CustomerEmployeeInitial();
}

class CustomerEmployeeListLoading extends CustomerEmployeeState {
  const CustomerEmployeeListLoading();
}

class CustomerEmployeeListLoaded extends CustomerEmployeeState {
  final List<V111CustomerEmployee> customersEmployee;

  const CustomerEmployeeListLoaded(this.customersEmployee);

  @override
  List<Object> get props => [this.customersEmployee];
}

class CustomerError extends CustomerEmployeeState {
  const CustomerError();
}
