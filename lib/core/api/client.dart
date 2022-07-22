// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';

class Client {
  final SharedPreferences sharedPreferences;
  late ApiClient _apiClient;

  late AccountApi _accountApi;
  AccountApi get accountApi => _accountApi;

  late BranchApi _branchApi;
  BranchApi get branchApi => _branchApi;

  late CustomerApi _customerApi;
  CustomerApi get customerApi => _customerApi;

  late EmployeeApi _employeeApi;
  EmployeeApi get employeeApi => _employeeApi;

  late WorkOrderApi _workOrderApi;
  WorkOrderApi get workOrderApi => _workOrderApi;

  late CostTypeApi _costTypeApi;
  CostTypeApi get costTypeApi => _costTypeApi;

  late ProjectApi _projectAPi;
  ProjectApi get projectApi => _projectAPi;

  late ProductApi _productApi;
  ProductApi get productApi => _productApi;

  late AttachmentApi _attachmentApi;
  AttachmentApi get attachmentApi => _attachmentApi;

  Client({required this.sharedPreferences}) {
    _apiClient = ApiClient(
        basePath: sharedPreferences.getString(domainApiUrl) ?? ApiUrl.baseUrl);
    _accountApi = AccountApi(_apiClient);
    _branchApi = BranchApi(_apiClient);
    _customerApi = CustomerApi(_apiClient);
    _employeeApi = EmployeeApi(_apiClient);
    _workOrderApi = WorkOrderApi(_apiClient);
    _costTypeApi = CostTypeApi(_apiClient);
    _productApi = ProductApi(_apiClient);
    _projectAPi = ProjectApi(_apiClient);
    _attachmentApi = AttachmentApi(_apiClient);
  }

  void setToken() {
    _apiClient.addDefaultHeader(
      "Authorization",
      "Bearer " +
          sharedPreferences.getString(CachedLoginData.tokenResponse).toString(),
    );
  }
}
