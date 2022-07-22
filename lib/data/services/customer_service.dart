// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:work_order_app/core/api/client.dart';

class CustomerService {
  final Client client;

  CustomerService({required this.client});

  late SharedPreferences sharedPreferences;

  Future<List<V111CustomerEnhanced>> getCustomersEnhanced() async {
    try {
      List<V111CustomerEnhanced> customers =
          await client.customerApi.getCustomerEnhanced();
      return customers;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<V111CustomerEnhanced> getCustomerEnhancedById(
      {required int customerId}) async {
    try {
      V111CustomerEnhanced v111CustomerEnhanced = await client.customerApi
          .getCustomerEnhancedV111ById(customerId: customerId);

      return v111CustomerEnhanced;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<List<Customer>> getCustomers() async {
    try {
      List<Customer> customers = await client.customerApi.getAllCustomers();
      return customers;
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<Customer> getCustomerById({required int customerId}) async {
    try {
      V12Customer v12Customer =
          await client.customerApi.getCustomerById(customerId);

      Customer customer = new Customer();
      var contactInformation = ContactInformation();
      contactInformation.email = v12Customer.contactInformation.email;
      contactInformation.fax = v12Customer.contactInformation.fax;
      contactInformation.mobile = v12Customer.contactInformation.mobile;
      contactInformation.phone = v12Customer.contactInformation.phone;
      contactInformation.website = v12Customer.contactInformation.website;
      customer.address = v12Customer.address;
      customer.contactInformation = contactInformation;
      customer.currencyCode = v12Customer.currencyCode;
      customer.customerId = v12Customer.customerId;
      customer.debtorMonitoringCode = v12Customer.debtorMonitoringCode;
      customer.debtorMonitoringText = v12Customer.debtorMonitoringText;
      customer.gln = v12Customer.gln;
      customer.name = v12Customer.name;
      customer.postOfficeBox = v12Customer.postOfficeBox;
      customer.searchKey = v12Customer.searchKey;
      customer.secondName = v12Customer.secondName;
      return customer;
    } catch (e) {
      throw Exception(e);
    }
  }
}
