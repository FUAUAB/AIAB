import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:week_of_year/date_week_extensions.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/data/services/work_order_service.dart';
import 'package:work_order_app/locator.dart';

part 'work_order_state.dart';

class WorkOrderCubit extends Cubit<WorkOrderState> {
  var _workOrderService = locator<WorkOrderService>();

  WorkOrderCubit() : super(WorkOrderInitial());

  Future<void> getWorkOrders(int customerId) async {
    try {
      emit(WorkOrderListLoading());
      final currentState = state;

      var loadedWorkOrders = <V112WorkOrder>[];
      var loadedFilters = <String>[];
      if (currentState is WorkOrderListLoaded) {
        loadedWorkOrders = currentState.workOrders;
        loadedFilters = currentState.filters;
        emit(WorkOrderListLoaded(loadedWorkOrders, loadedFilters));
      } else {
        final workOrders =
            await _workOrderService.getWorkOrders(customerId: customerId);

        final branches = await _workOrderService.getFilters();
        emit(WorkOrderListLoaded(workOrders, branches));
      }
    } catch (e) {
      emit(WorkOrderError(e.toString()));
    }
  }

  Future<void> filterWorkOrdersOnBranchId({
    required String branch,
    required List<V112WorkOrder> fullList,
    required bool isForEmployee,
  }) async {
    try {
      final currentState = state;

      var filteredWorkOrders = <V112WorkOrder>[];
      var loadedFilters = <String>[];
      int branchId = int.parse(branch);

      if (currentState is WorkOrderListLoaded) {
        loadedFilters = currentState.filters;
      }
      if (currentState is WorkOrderEmployeeListLoaded) {
        loadedFilters = currentState.filters;
      }

      filteredWorkOrders =
          fullList.where((e) => e.branchId == branchId).toList();

      if (branchId == 0) {
        filteredWorkOrders = fullList;
      }

      if (isForEmployee) {
        emit(WorkOrderEmployeeListLoaded(filteredWorkOrders, loadedFilters));
      } else {
        emit(WorkOrderListLoaded(filteredWorkOrders, loadedFilters));
      }
    } catch (e) {
      emit(WorkOrderError(e.toString()));
    }
  }

  Future<void> getWorkOrderById(
      int workOrderId, int? companyId, int? branchId) async {
    try {
      emit(WorkOrderLoading());
      final currentState = state;

      final costTypes = await _workOrderService.getCostTypesList();

      var loadedWorkOrder = new V112WorkOrder();
      if (currentState is WorkOrderLoaded) {
        loadedWorkOrder = currentState.workOrder;
        emit(
          WorkOrderLoaded(
            loadedWorkOrder,
            costTypes,
          ),
        );
      }
      final workOrder = await _workOrderService.getWorkOrderById(
          workOrderId: workOrderId, companyId: companyId!, branchId: branchId!);
      emit(
        WorkOrderLoaded(
          workOrder,
          costTypes,
        ),
      );
    } catch (e) {
      emit(
        WorkOrderError("Werkorder niet kunnen vinden"),
      );
    }
  }

  Future<void> getScheduledWorkOrdersForEmployee(
      String? type, String? specificDate) async {
    try {
      emit(ScheduledWorkOrdersForEmployeeListLoading());
      final currentState = state;

      var scheduledWorkOrdersForEmployeeList = <V112WorkOrder>[];
      if (currentState is ScheduledWorkOrdersForEmployeeListLoaded) {
        scheduledWorkOrdersForEmployeeList =
            currentState.scheduledWorkOrdersForEmployeeList;
        emit(ScheduledWorkOrdersForEmployeeListLoaded(
            scheduledWorkOrdersForEmployeeList));
      }

      final scheduleForEmployeeList =
          await _workOrderService.getScheduleForEmployee();
      final allWorkOrders =
          await _workOrderService.getWorkOrders(customerId: 0);
      scheduledWorkOrdersForEmployeeList = allWorkOrders
          .where((x) =>
              scheduleForEmployeeList.any((s) => s.workOrderId == x.orderId))
          .toList();

      var workOrdersDailyByEmployee = <V112WorkOrder>[];
      var workOrdersWeeklyByEmployee = <V112WorkOrder>[];
      var workOrdersMonthlyByEmployee = <V112WorkOrder>[];
      var workOrdersSpecificDateForEmployee = <V112WorkOrder>[];

      switch (type) {
        case EmployeeWorkOrdersType.Day:
          getEmployeeDailyWorkOrders(
              scheduledWorkOrdersForEmployeeList, workOrdersDailyByEmployee);
          emit(ScheduledWorkOrdersForEmployeeListLoaded(
              workOrdersDailyByEmployee));
          break;

        case EmployeeWorkOrdersType.Week:
          getEmployeeWeeklyWorkOrders(
              scheduledWorkOrdersForEmployeeList, workOrdersWeeklyByEmployee);
          emit(ScheduledWorkOrdersForEmployeeListLoaded(
              workOrdersWeeklyByEmployee));
          break;

        case EmployeeWorkOrdersType.Month:
          getEmployeeMonthlyWorkOrders(
              scheduledWorkOrdersForEmployeeList, workOrdersMonthlyByEmployee);
          emit(
            ScheduledWorkOrdersForEmployeeListLoaded(
                workOrdersMonthlyByEmployee),
          );
          break;

        case EmployeeWorkOrdersType.SpecificDate:
          getEmployeeSpecificDateWorkOrders(scheduledWorkOrdersForEmployeeList,
              workOrdersSpecificDateForEmployee, specificDate!);
          emit(ScheduledWorkOrdersForEmployeeListLoaded(
              workOrdersSpecificDateForEmployee));
          break;

        default:
          emit(ScheduledWorkOrdersForEmployeeListLoaded(
              scheduledWorkOrdersForEmployeeList));
      }
    } catch (e) {
      emit(WorkOrderError(e.toString()));
    }
  }

  Future<void> getWorkOrdersByEmployee(String employeeId) async {
    try {
      emit(WorkOrderEmployeeListLoading());
      final currentState = state;

      var loadedEmployeeWorkOrders = <V112WorkOrder>[];
      var loadedFilters = <String>[];
      if (currentState is WorkOrderEmployeeListLoaded) {
        loadedEmployeeWorkOrders = currentState.workOrders;
        loadedFilters = currentState.filters;
        emit(WorkOrderEmployeeListLoaded(
            loadedEmployeeWorkOrders, loadedFilters));
      }
      final workOrdersByEmployee =
          await _workOrderService.getWorkOrdersByEmployee(employeeId);

      final filters = await _workOrderService.getFilters();

      emit(WorkOrderEmployeeListLoaded(workOrdersByEmployee, filters));
    } catch (e) {
      emit(WorkOrderError(e.toString()));
    }
  }

  void getEmployeeSpecificDateWorkOrders(
      List<V112WorkOrder> workOrdersByEmployee,
      List<V112WorkOrder> workOrdersDailyByEmployee,
      String specificDate) {
    for (V112WorkOrder workOrderProduct in workOrdersByEmployee) {
      var date = workOrderProduct.schedule!.startTime.toString();
      if (date.toString().contains('T')) {
        date = date.substring(0, date.indexOf('T'));
      } else {
        date = date.substring(0, date.indexOf(' '));
      }
      if (date == specificDate.split(' ').first) {
        workOrdersDailyByEmployee.add(workOrderProduct);
      }
    }
  }

  void getEmployeeMonthlyWorkOrders(List<V112WorkOrder> workOrdersByEmployee,
      List<V112WorkOrder> workOrdersMonthlyByEmployee) {
    for (V112WorkOrder workOrderProduct in workOrdersByEmployee) {
      workOrdersMonthlyByEmployee.add(workOrderProduct);
    }
  }

  void getEmployeeWeeklyWorkOrders(List<V112WorkOrder> workOrdersByEmployee,
      List<V112WorkOrder> workOrdersWeeklyByEmployee) {
    for (V112WorkOrder workOrderProduct in workOrdersByEmployee) {
      var date = workOrderProduct.schedule!.startTime.toString();
      DateTime currentDate = DateTime.parse(date);
      var weekOfYear = DateTime.now().weekOfYear;
      var currentDateWeekOfYear = currentDate.weekOfYear;
      if (weekOfYear == currentDateWeekOfYear) {
        workOrdersWeeklyByEmployee.add(workOrderProduct);
      }
    }
  }

  void getEmployeeDailyWorkOrders(List<V112WorkOrder> workOrdersByEmployee,
      List<V112WorkOrder> workOrdersDailyByEmployee) {
    for (V112WorkOrder workOrderProduct in workOrdersByEmployee) {
      var today = DateTime.now().toString();
      today = today.substring(0, today.indexOf(' '));
      var date = workOrderProduct.schedule!.startTime.toString();
      if (date.toString().contains('T')) {
        date = date.substring(0, date.indexOf('T'));
      } else {
        date = date.substring(0, date.indexOf(' '));
      }
      if (date == today) {
        workOrdersDailyByEmployee.add(workOrderProduct);
      }
    }
  }

  Future<void> getWorkOrderJobs(int? companyId) async {
    try {
      emit(WorkOrderJobsListLoading());
      final workOrdersJobs =
          await _workOrderService.getWorkOrderJobs(companyId: companyId);
      emit(WorkOrderJobsListLoaded(workOrdersJobs));
    } catch (e) {
      emit(WorkOrderError(e.toString()));
    }
  }

  Future<void> createWorkOrderDetail(
      WorkOrderDetailRequest workOrderDetailRequest,
      dynamic workOrderDetails,
      String workOrderDetailType) async {
    try {
      final isCreated = await _workOrderService.createWorkOrderDetail(
          workOrderDetailRequest: workOrderDetailRequest,
          workOrderDetails: workOrderDetails,
          workOrderDetailType: workOrderDetailType);

      if (isCreated) {
        emit(WorkOrderDetailsAdded());
        getWorkOrderById(workOrderDetailRequest.orderId,
            workOrderDetailRequest.companyId, workOrderDetailRequest.branchId);
      } else {
        emit(WorkOrderDetailsAddedError(
            "Werkorder details niet kunnen toevoegen."));
        getWorkOrderById(workOrderDetailRequest.orderId,
            workOrderDetailRequest.companyId, workOrderDetailRequest.branchId);
      }
    } catch (e) {
      emit(WorkOrderError(e.toString()));
      getWorkOrderById(workOrderDetailRequest.orderId,
          workOrderDetailRequest.companyId, workOrderDetailRequest.branchId);
    }
  }

  Future<void> editWorkOrderDetail(
      WorkOrderDetailChangeRequest workOrderDetailChangeRequest) async {
    try {
      final isEdited = await _workOrderService.editWorkOrderDetail(
          workOrderDetailChangeRequest: workOrderDetailChangeRequest);

      if (isEdited) {
        emit(WorkOrderDetailsEdited());
        getWorkOrderById(
            workOrderDetailChangeRequest.orderId,
            workOrderDetailChangeRequest.companyId,
            workOrderDetailChangeRequest.branchId);
      } else {
        emit(WorkOrderDetailsEditError(
            "Werkorder details niet kunnen toevoegen."));
        getWorkOrderById(
            workOrderDetailChangeRequest.orderId,
            workOrderDetailChangeRequest.companyId,
            workOrderDetailChangeRequest.branchId);
      }
    } catch (e) {
      getWorkOrderById(
          workOrderDetailChangeRequest.orderId,
          workOrderDetailChangeRequest.companyId,
          workOrderDetailChangeRequest.branchId);
      emit(WorkOrderError(e.toString()));
    }
  }

  Future<void> deleteWorkOrderDetail(int workOrderId, int orderLineId,
      int orderSubLineId, int? companyId, int? branchId) async {
    try {
      final isDeleted = await _workOrderService.deleteWorkOrderDetail(
          workOrderId: workOrderId,
          orderLineId: orderLineId,
          orderSubLineId: orderSubLineId,
          companyId: companyId,
          branchId: branchId);

      if (isDeleted) {
        emit(WorkOrderDetailsDeleted());
        getWorkOrderById(workOrderId, companyId, branchId);
      } else {
        emit(WorkOrderDetailsDeletedError(
            "Werkorder details niet kunnen verwijderen."));
        getWorkOrderById(workOrderId, companyId, branchId);
      }
    } catch (e) {
      emit(WorkOrderError(e.toString()));
      getWorkOrderById(workOrderId, companyId, branchId);
    }
  }

  Future<void> createWorkOrder(WorkOrderRequest workOrderRequest,
      Customer customer, Project project, BuildContext context) async {
    final currentState = state;
    try {
      final isCreated = await _workOrderService.createWorkOrderInERP(
          workOrderRequest: workOrderRequest,
          customer: customer,
          project: project);
      if (isCreated != 0) {
        final createdWorkOrder = await _workOrderService.getWorkOrderById(
            workOrderId: isCreated, companyId: null, branchId: null);
        if (currentState is WorkOrderListLoaded) {
          _loadWorkOrder(createdWorkOrder, context, currentState);
        } else {
          _loadWorkOrder(createdWorkOrder, context);
        }
      } else {
        emit(WorkOrderAddedError("Werkorder niet kan toegevoegd worden."));
        if (currentState is WorkOrderListLoaded) {
          getWorkOrders(0);
        } else {
          getWorkOrdersByEmployee("");
        }
      }
    } catch (e) {
      emit(WorkOrderAddedError("Werkorder niet kan toegevoegd worden."));
      if (currentState is WorkOrderListLoaded) {
        getWorkOrders(0);
      } else {
        getWorkOrdersByEmployee("");
      }
    }
  }

  Future<void> addWorkOrderAttachment(List<MultipartFile> uploadedFiles,
      int workOrderId, int companyId, int branchId) async {
    try {
      final isAdded = await _workOrderService.addWorkOrderAttachment(
          uploadedFiles: uploadedFiles,
          branchId: branchId,
          companyId: companyId,
          workOrderId: workOrderId);
      if (isAdded) {
        emit(WorkOrderAttachmentAdded());
        getWorkOrderById(workOrderId, companyId, branchId);
      } else {
        emit(AddWorkOrderAttachmentError(
            "Werkorder bijlage niet kunnen toevoegen."));
        getWorkOrderById(workOrderId, companyId, branchId);
      }
    } catch (e) {
      emit(WorkOrderError(e.toString()));
      getWorkOrderById(workOrderId, companyId, branchId);
    }
  }

  Future<void> downloadWorkOrderAttachment(
    int attachmentType,
    String workorderReference,
    int sequenceId,
    String fileName,
    int workOrderId,
    int companyId,
    int branchId,
  ) async {
    try {
      final isDownloaded = await _workOrderService.downloadWorkOrderAttachment(
        attachmentType: attachmentType,
        workorderReference: workorderReference,
        sequenceId: sequenceId,
        fileName: fileName,
      );

      if (!isDownloaded) {
        emit(
          AddWorkOrderAttachmentError(
              "Werkorder bijlage niet kunnen downloaden."),
        );
        getWorkOrderById(workOrderId, companyId, branchId);
      }
    } catch (e) {
      emit(WorkOrderError(e.toString()));
      getWorkOrderById(workOrderId, companyId, branchId);
    }
  }

  Future<void> deleteWorkOrderAttachment(
    int attachmentType,
    String workorderReference,
    int sequenceId,
    int workOrderId,
    int companyId,
    int branchId,
  ) async {
    try {
      final isDeleted = await _workOrderService.deleteWorkOrderAttachment(
        attachmentType: attachmentType,
        workorderReference: workorderReference,
        sequenceId: sequenceId,
      );

      if (isDeleted) {
        emit(WorkOrderImageDeleted());
        getWorkOrderById(workOrderId, companyId, branchId);
      } else {
        emit(
          AddWorkOrderAttachmentError(
              "Werkorder bijlage niet kunnen verwijderen."),
        );
        getWorkOrderById(workOrderId, companyId, branchId);
      }
    } catch (e) {
      emit(WorkOrderError(e.toString()));
      getWorkOrderById(workOrderId, companyId, branchId);
    }
  }

  void _loadWorkOrder(V112WorkOrder createdWorkOrder, BuildContext context,
      [WorkOrderListLoaded? currentState]) {
    Navigator.of(context).pushNamed(
      workOrderDetailsRoute,
      arguments: {
        'workOrder': createdWorkOrder,
      },
    ).then(
      (_) => {
        if (currentState is WorkOrderListLoaded)
          {getWorkOrders(0)}
        else
          {getWorkOrdersByEmployee("")}
      },
    );
  }
}
