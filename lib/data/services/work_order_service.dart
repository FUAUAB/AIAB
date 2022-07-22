// ignore: import_of_legacy_library_into_null_safe
import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:mavis_api_client/api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/core/api/client.dart';

import '../../core/constants/constants.dart';

class WorkOrderService {
  final Client client;
  final SharedPreferences sharedPreferences;

  WorkOrderService({required this.client, required this.sharedPreferences});

  Future<List<V112WorkOrder>> getWorkOrders({required int customerId}) async {
    try {
      List<V112WorkOrder> workOrders =
          await client.workOrderApi.getAllWorkOrdersV112(
        int.parse(sharedPreferences
            .getString(CachedLoginData.defaultCompanyIdString)!),
        customerId: customerId,
        branchId: 0,
        onlyActive: true,
      ); //branchId 0 is all channels
      workOrders.sort((a, b) => b.date.toString().compareTo(a.date.toString()));
      var filteredWorkOrders =
          workOrders.where((workOrder) => workOrder.status == 10).toList();
      return filteredWorkOrders;
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<BranchInformation>> getWorkorderBranches() async {
    try {
      List<BranchInformation> branches = await client.branchApi
          .getBranchesForCompany(int.parse(sharedPreferences
              .getString(CachedLoginData.defaultCompanyIdString)!));
      return branches;
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<String>> getFilters() async {
    try {
      List<String> filters = [];
      List<BranchInformation> branches = await getWorkorderBranches();
      filters = branches.map((e) => "${e.branchId} - ${e.branchName}").toList();
      filters.insert(0, "0 - Geen filter");
      return filters;
    } catch (e) {
      return List.empty();
    }
  }

  Future<List<V112WorkOrder>> getWorkOrdersByEmployee(String employeeId) async {
    if (employeeId == "") {
      employeeId = sharedPreferences
          .getString(CachedLoginData.employeeIdString)
          .toString();
    }

    if (employeeId != "null") {
      int convertedEmployeeId = int.parse(employeeId);
      try {
        List<V112WorkOrder> workOrders = await client.workOrderApi
            .getAllWorkOrdersV112_1(convertedEmployeeId);

        workOrders
            .sort((a, b) => b.date.toString().compareTo(a.date.toString()));
        return workOrders;
      } catch (e) {
        return List.empty();
      }
    } else {
      return List.empty();
    }
  }

  Future<List<Job>> getWorkOrderJobs({int? companyId}) async {
    try {
      List<Job> workOrderJobs =
          await client.workOrderApi.getJobs(companyId: companyId);
      return workOrderJobs;
    } catch (e) {
      return List.empty();
    }
  }

  Future<V112WorkOrder> getWorkOrderById({
    required int workOrderId,
    required int? companyId,
    required int? branchId,
  }) async {
    if (companyId == null) {
      String defaultCompanyIdString = sharedPreferences
          .getString(CachedLoginData.defaultCompanyIdString)
          .toString();
      companyId = int.parse(defaultCompanyIdString);
    }

    if (branchId == null) {
      String defaultBranchIdString = sharedPreferences
          .getString(CachedLoginData.defaultBranchIdString)
          .toString();
      branchId = int.parse(defaultBranchIdString);
    }
    try {
      final workOrder = await client.workOrderApi
          .getActiveWorkOrder(companyId, branchId, workOrderId);
      return workOrder;
    } catch (e) {
      return new V112WorkOrder();
    }
  }

  Future<int> createWorkOrderInERP(
      {required WorkOrderRequest workOrderRequest,
      required Customer customer,
      required Project project}) async {
    int companyId = int.parse(sharedPreferences
        .getString(CachedLoginData.defaultCompanyIdString)
        .toString());
    int employeeId = int.parse(sharedPreferences
        .getString(CachedLoginData.employeeIdString)
        .toString());
    int branchId = int.parse(sharedPreferences
        .getString(CachedLoginData.defaultBranchIdString)
        .toString());

    workOrderRequest.companyId = companyId;
    workOrderRequest.branchId = branchId;
    workOrderRequest.customerId = customer.customerId;
    workOrderRequest.projectId = project.projectId;

    workOrderRequest.shippingAddress = new V19ShippingAddress();
    workOrderRequest.shippingAddress.customerId = project.customerId;
    workOrderRequest.shippingAddress.name = project.name;
    workOrderRequest.shippingAddress.address = new V19Address();
    workOrderRequest.shippingAddress.address.city = project.address.city;
    workOrderRequest.shippingAddress.address.country = new V19Country();
    workOrderRequest.shippingAddress.address.country.id =
        project.address.countryId;
    workOrderRequest.shippingAddress.address.houseNumber =
        project.address.houseNumber;
    workOrderRequest.shippingAddress.address.houseNumberAddition =
        project.address.houseNumberAddition;
    workOrderRequest.shippingAddress.address.postalCode =
        project.address.postalCode;
    workOrderRequest.shippingAddress.address.street = project.address.street;
    workOrderRequest.shippingAddress.shippingStatus =
        new V12ShippingAddressStatus();
    workOrderRequest.shippingAddress.contactInformation =
        new ContactInformation();
    workOrderRequest.responsibleEmployeeId = employeeId;
    var date = DateTime.now();
    workOrderRequest.date = date;
    workOrderRequest.schedule = new Schedule();
    workOrderRequest.schedule.startTime = date;
    workOrderRequest.schedule.endTime = date;
    try {
      int editWorkOrderDetailResponse =
          await client.workOrderApi.createWorkOrderInERP(workOrderRequest);
      return editWorkOrderDetailResponse;
    } catch (e) {
      return 0;
    }
  }

  Future<bool> createWorkOrderDetail(
      {required WorkOrderDetailRequest workOrderDetailRequest,
      required dynamic workOrderDetails,
      required String workOrderDetailType}) async {
    try {
      switch (workOrderDetailType) {
        case WorkOrderDetailType.Article:
          bool createWorkOrderDetailResponse = false;
          for (WorkOrderProduct workOrderProduct in workOrderDetails) {
            workOrderDetailRequest.product = workOrderProduct;
            createWorkOrderDetailResponse = await client.workOrderApi
                .createWorkOrderDetail(workOrderDetailRequest);
          }
          return createWorkOrderDetailResponse;

        case WorkOrderDetailType.Costs:
          bool createWorkOrderDetailResponse = false;
          for (CostDetail costDetail in workOrderDetails) {
            workOrderDetailRequest.cost = costDetail;
            createWorkOrderDetailResponse = await client.workOrderApi
                .createWorkOrderDetail(workOrderDetailRequest);
          }
          return createWorkOrderDetailResponse;

        case WorkOrderDetailType.Hours:
          workOrderDetailRequest.hours = workOrderDetails;
          bool createWorkOrderDetailResponse = await client.workOrderApi
              .createWorkOrderDetail(workOrderDetailRequest);
          return createWorkOrderDetailResponse;

        case WorkOrderDetailType.Text:
          workOrderDetailRequest.description = workOrderDetails;
          bool createWorkOrderDetailResponse = await client.workOrderApi
              .createWorkOrderDetail(workOrderDetailRequest);
          return createWorkOrderDetailResponse;
        default:
          return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> editWorkOrderDetail(
      {required WorkOrderDetailChangeRequest
          workOrderDetailChangeRequest}) async {
    try {
      bool editWorkOrderDetailResponse = await client.workOrderApi
          .editWorkOrderDetail(workOrderDetailChangeRequest);
      return editWorkOrderDetailResponse;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteWorkOrderDetail(
      {required int workOrderId,
      required int orderLineId,
      required int orderSubLineId,
      required int? companyId,
      required int? branchId}) async {
    try {
      final result = await client.workOrderApi.deleteWorkOrderDetail(
          companyId, branchId, workOrderId, orderLineId, orderSubLineId);
      return result;
    } catch (e) {
      return false;
    }
  }

  Future<List<CostType>> getCostTypesList() async {
    try {
      final costTypes = await client.costTypeApi
          .getCostTypePerCategory(category: "WorkOrder");
      return costTypes;
    } catch (e) {
      return <CostType>[];
    }
  }

  // Future<List<Project>?> getProjects() async {
  //   try {
  //     List<Project> list = await client.proejctApi.getAllProjects();
  //     return list;
  //   } catch (e) {
  //     throw Exception(e.toString());
  //   }
  // }

  Future<bool> addWorkOrderAttachment(
      {required List<http.MultipartFile> uploadedFiles,
      required int companyId,
      required int branchId,
      required int workOrderId}) async {
    var isAdded;
    try {
      for (http.MultipartFile uploadedFile in uploadedFiles) {
        isAdded = await client.workOrderApi.addWorkOrderAttachment(
            uploadedFile, companyId, branchId, workOrderId);
      }
      return isAdded;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> downloadWorkOrderAttachment({
    required int attachmentType,
    required String workorderReference,
    required int sequenceId,
    required String fileName,
  }) async {
    try {
      http.Response response = await client.attachmentApi.getAttachment(
        type: attachmentType,
        reference: workorderReference,
        sequenceId: sequenceId,
      );

      Directory? directory;
      if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        // Default android Download folder.
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      }

      // Required to access the URL/URI from the response. Otherwise 401 error.
      var headers = {
        'Authorization':
            'Bearer ${sharedPreferences.getString(CachedLoginData.tokenResponse)}',
        'content-type': 'application/json',
      };

      String? returnId = await FlutterDownloader.enqueue(
        url: response.request!.url.toString(),
        headers: headers,
        savedDir: directory!.path,
        fileName: fileName,
        saveInPublicStorage: true,
        openFileFromNotification: true,
      );
      if (returnId != null) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> deleteWorkOrderAttachment({
    required int attachmentType,
    required String workorderReference,
    required int sequenceId,
  }) async {
    try {
      bool isDeleted = await client.attachmentApi.deleteAttachment(
        type: attachmentType,
        reference: workorderReference,
        sequenceId: sequenceId,
      );

      return isDeleted;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<List<WorkOrderSchedule>> getScheduleForEmployee() async {
    int employeeId = int.parse(sharedPreferences
        .getString(CachedLoginData.employeeIdString)
        .toString());
    try {
      final costTypes =
          await client.workOrderApi.getScheduleForEmployee(employeeId);
      return costTypes;
    } catch (e) {
      return <WorkOrderSchedule>[];
    }
  }
}
