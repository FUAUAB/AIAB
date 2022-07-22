part of 'work_order_cubit.dart';

abstract class WorkOrderState extends Equatable {
  const WorkOrderState();

  @override
  List<Object> get props => [];
}

class WorkOrderInitial extends WorkOrderState {
  const WorkOrderInitial();
}

class WorkOrderLoading extends WorkOrderState {
  const WorkOrderLoading();
}

class WorkOrderLoaded extends WorkOrderState {
  final V112WorkOrder workOrder;
  final List<CostType> costTypes;

  const WorkOrderLoaded(
    this.workOrder,
    this.costTypes,
  );

  @override
  List<Object> get props => [this.workOrder, this.costTypes];
}

class WorkOrderListLoading extends WorkOrderState {
  const WorkOrderListLoading();
}

class WorkOrderEmployeeListLoading extends WorkOrderState {
  const WorkOrderEmployeeListLoading();
}

class WorkOrderListLoaded extends WorkOrderState {
  final List<V112WorkOrder> workOrders;
  final List<String> filters;

  const WorkOrderListLoaded(this.workOrders, this.filters);

  @override
  List<Object> get props => [this.workOrders, this.filters];
}

class WorkOrderEmployeeListLoaded extends WorkOrderState {
  final List<V112WorkOrder> workOrders;
  final List<String> filters;

  const WorkOrderEmployeeListLoaded(this.workOrders, this.filters);

  @override
  List<Object> get props => [
        this.workOrders,
        [this.filters]
      ];
}

class WorkOrderUpdateLoading extends WorkOrderState {
  const WorkOrderUpdateLoading();
}

class WorkOrderUpdateLoaded extends WorkOrderState {
  final int responseCode;

  const WorkOrderUpdateLoaded(this.responseCode);

  @override
  List<Object> get props => [this.responseCode];
}

class WorkOrderUpdateError extends WorkOrderState {}

class WorkOrderError extends WorkOrderState {
  final String errorMessage;

  const WorkOrderError(this.errorMessage);

  @override
  List<Object> get props => [this.errorMessage];
}

class WorkOrderJobsListLoading extends WorkOrderState {
  const WorkOrderJobsListLoading();
}

class WorkOrderJobsListLoaded extends WorkOrderState {
  final List<Job> workOrdersJobs;

  const WorkOrderJobsListLoaded(this.workOrdersJobs);

  @override
  List<Object> get props => [this.workOrdersJobs];
}

class CreateWorkOrderDetailLoading extends WorkOrderState {
  const CreateWorkOrderDetailLoading();
}

class CreateWorkOrderLoading extends WorkOrderState {
  const CreateWorkOrderLoading();
}

class WorkOrderDetailsAdded extends WorkOrderState {}

class WorkOrderAdded extends WorkOrderState {}

class WorkOrderAddedError extends WorkOrderState {
  final String errorMessage;

  const WorkOrderAddedError(this.errorMessage);

  @override
  List<Object> get props => [this.errorMessage];
}

class WorkOrderDetailsAddedError extends WorkOrderState {
  final String errorMessage;

  const WorkOrderDetailsAddedError(this.errorMessage);

  @override
  List<Object> get props => [this.errorMessage];
}

class WorkOrderAttachmentAdded extends WorkOrderState {
  const WorkOrderAttachmentAdded();
}

class WorkOrderAttachmentLoading extends WorkOrderState {
  const WorkOrderAttachmentLoading();
}

class AddWorkOrderAttachmentError extends WorkOrderState {
  final String errorMessage;

  const AddWorkOrderAttachmentError(this.errorMessage);

  @override
  List<Object> get props => [this.errorMessage];
}

class WorkOrderDetailsEdited extends WorkOrderState {}

class WorkOrderDetailsEditError extends WorkOrderState {
  final String errorMessage;

  const WorkOrderDetailsEditError(this.errorMessage);

  @override
  List<Object> get props => [this.errorMessage];
}

class WorkOrderDetailsDeleted extends WorkOrderState {}

class WorkOrderDetailsDeletedError extends WorkOrderState {
  final String errorMessage;

  const WorkOrderDetailsDeletedError(this.errorMessage);

  @override
  List<Object> get props => [this.errorMessage];
}

class WorkOrderImageDeleted extends WorkOrderState {}

class CostTypesListLoading extends WorkOrderState {
  const CostTypesListLoading();
}

class CostTypesListLoaded extends WorkOrderState {
  final List<CostType> costTypesList;

  const CostTypesListLoaded(this.costTypesList);

  @override
  List<Object> get props => [this.costTypesList];
}

class CostTypesListError extends WorkOrderState {
  final String errorMessage;

  const CostTypesListError(this.errorMessage);

  @override
  List<Object> get props => [this.errorMessage];
}

class ImageListLoading extends WorkOrderState {
  const ImageListLoading();
}

class ImageListLoaded extends WorkOrderState {
  final List<String> imageList;

  const ImageListLoaded(this.imageList);

  @override
  List<Object> get props => [this.imageList];
}

class ScheduledWorkOrdersForEmployeeListLoading extends WorkOrderState {
  const ScheduledWorkOrdersForEmployeeListLoading();
}

class ScheduledWorkOrdersForEmployeeListLoaded extends WorkOrderState {
  final List<V112WorkOrder> scheduledWorkOrdersForEmployeeList;

  const ScheduledWorkOrdersForEmployeeListLoaded(
      this.scheduledWorkOrdersForEmployeeList);

  @override
  List<Object> get props => [this.scheduledWorkOrdersForEmployeeList];
}
