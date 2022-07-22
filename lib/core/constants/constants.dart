//Constants to remove the use of Magic String Values.

//----------------------API----------------------
import 'package:flutter/material.dart';
import 'package:mavis_api_client/api.dart';

class ApiUrl {
  static String baseUrl = 'http://145.128.242.7:7012';
  static const String jrsUrl = 'http://62.12.1.67:4452/';
}

class ApiDomains {
  static const String JRS = "jrs";
  static const String BREUR = "breur";
  static const String DIDATA = "didata";
  static const String BUS = "bus";
  static const String DOZON = "dozon";
}

const String domainApiUrl = 'domainApiUrl';

class CachedLoginData {
  static const String expirationResponse = 'expiration';
  static const String tokenResponse = 'token';
  static const String defaultCompanyIdString = 'defaultCompanyId';
  static const String defaultBranchIdString = 'defaultBranchId';
  static const String employeeIdString = 'employeeId';
  static const String storeIdString = 'storeId';
  static const String userEmail = 'userEmail';
  static const String hasShownFirstScreen = "hasShownFirstScreen";
}

class SearchType {
  static const String customer = 'customer';
  static const String project = 'project';
  static const String workorder = 'workorder';
}

//--------------------LOGIN CONSTANTS---------------------
// const String expirationResponse = 'expiration';
// const String tokenResponse = 'token';
// const String companyIdString = 'defaultCompanyId';
// const String employeeIdString = 'employeeId';
// const String storeIdString = 'storeId';
// const String userEmail = 'userEmail';
// const String hasShownFirstScreen = "hasShownFirstScreen";

//---------------------ROUTES---------------------

const String loadingRoute = '/';

//FirstTimeScreen
const String firstTimeRoute = '/firsttime';

//Home
const String homeRoute = '/home';

//Authentication
const String loginRoute = '/login';

//Planning
const String planningRoute = '/planning';
const String calendarDetailsRoute = 'calendar/details';

//Customers
const String customersRoute = '/customers';
const String customerDetailsRoute = '/customer/details';

//WorkOrders
const String workOrdersRoute = '/work_orders';
const String workOrdersSpecificDateRoute = '/work_orders/specific_date';
const String workOrdersEmployeeRoute = '/workOrdersEmployee';
const String workOrderDetailsRoute = '/work_orders/details';
const String workOrderAddHoursRoute = '/work_orders/details/addHours';
const String workOrderEditHoursRoute = '/work_orders/details/editHours';
const String workOrderAddTextRoute = '/work_orders/details/addText';
const String workOrderEditTextRoute = '/work_orders/details/editText';
const String workOrderAddProductRoute = '/work_orders/details/addProduct';
const String workOrdersAddWorkOrderPage = '/work_orders/addWorkOrder';
const String workOrderEditProductRoute = '/work_orders/details/editProduct';
const String workOrderAddCostRoute = '/work_orders/details/addCost';
const String workOrderEditCostRoute = '/work_orders/details/editCost';
const String workOrderPhotoRoute = '/work_orders/details/photo';

const String projectsRoute = '/projectsRoute';

const String search = '/search';

//Hours
const String declareHoursRoute = '/declareHours';
const String totalHoursDayRoute = '/totalHours';

//------------------------------OTHER---------------
const FETCH_LIMIT = 15;

const double TITLE_FONT_SIZE = 18.0;
const double BUTTON_FONT_SIZE = 15.0;
const double TEXT_FONT_SIZE = 14.0;

//------------------------------ENUMS----------------
enum ConnectivityType { Wifi, Mobile }

//------------------------------TYPES----------------
const String workOrderType =
    "v112workorder"; // don't change this name so came from api
const String customerType = "customer";
const String productType = "v13shopproduct";

int getexixcount(BuildContext context) {
  double wid = MediaQuery.of(context).size.width;
  if (wid < 600) {
    return 4;
  } else if (wid > 600 && wid < 900) {
    return 6;
  } else if (wid > 900 && wid < 1200) {
    return 8;
  } else {
    return 6;
  }
}

int getProjectGridcount(BuildContext context) {
  double wid = MediaQuery.of(context).size.width;
  if (wid < 600) {
    return 1;
  } else if (wid > 600 && wid < 900) {
    return 2;
  } else if (wid > 900 && wid < 1200) {
    return 3;
  } else {
    return 1;
  }
}

String getLineTypeEnum(int? lineType) {
  switch (lineType) {
    case 0:
      return "Article";
    case 1:
      return "Special";
    case 2:
      return "Costs";
    case 3:
      return "Text";
    case 4:
      return "Composition";
    case 5:
      return "Component";
    case 6:
      return "Hours";
    default:
      return "";
  }
}

enum ApiEnvironment {
  DidataCombipac,
  DidataMavis,
  Dimerce,
}

class WorkOrderDetailType {
  static const String Article = "0";
  static const String Special = "1";
  static const String Costs = "2";
  static const String Text = "3";
  static const String Composition = "4";
  static const String Component = "5";
  static const String Hours = "6";

  static List<String> selectedImage = [];
  static List<Project> projectsList = [];
  static List<Customer> customersList = [];
}

class EmployeeWorkOrdersType {
  static const String Day = "day";
  static const String Week = "week";
  static const String Month = "month";
  static const String SpecificDate = "specificDate";
}

class SearchTermType {
  static const String Customer = "klant";
  static const String WorkOrder = "werkorder";
  static const String Product = "product";
}
