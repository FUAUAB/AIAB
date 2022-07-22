import 'dart:convert';
import 'dart:io';

// ignore: import_of_legacy_library_into_null_safe
import 'package:mavis_api_client/api.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/api/client.dart';
import '../../core/constants/constants.dart';

class AuthenticationService {
  late SharedPreferences sharedPreferences;
  final Client client;

  AuthenticationService({
    required this.client,
    required this.sharedPreferences,
  });

  Future<int> login(
      {required String username, required String password}) async {
    var userinfo = new Login();
    userinfo.password = password;
    userinfo.userName = username;

    try {
      var response = await client.accountApi.token(model: userinfo);

      var data = jsonDecode(response.body);

      if (data != null) {
        _setUserLogin(
          data[CachedLoginData.tokenResponse],
          data[CachedLoginData.expirationResponse],
        );
        _setAccountInfo();
        return HttpStatus.ok;
      } else
        return HttpStatus.notFound;
    } catch (e) {
      return HttpStatus.notFound;
    }
  }

  Future<AccountInfo> getAccountFromApi() async {
    try {
      final response = await client.accountApi.getInfo();
      final account = response;

      return account;
    } catch (e) {
      throw HttpException('404');
    }
  }

  Future<bool> checkIfValidLogin() async {
    bool isExpired = await this._isUserTokenExpired();
    if (!isExpired) {
      client.setToken();
      return true;
    } else {
      if (sharedPreferences.getString(CachedLoginData.tokenResponse) == null ||
          sharedPreferences.getString(CachedLoginData.expirationResponse) ==
              null) {
        this.logout();
      }
      return false;
    }
  }

  Future<bool> checkIfFirstScreenWasShown() async {
    bool hasShown =
        sharedPreferences.getBool(CachedLoginData.hasShownFirstScreen) ?? false;
    if (!hasShown) return false;

    return true;
  }

  Future<void> saveEmail(String email) async {
    sharedPreferences.setString(CachedLoginData.userEmail, email);
    sharedPreferences.setBool(CachedLoginData.hasShownFirstScreen, true);
    _switchApiBasedOnEmail(email);
  }

  Future<void> _setUserLogin(String token, String expiration) async {
    SharedPreferences loginData = await SharedPreferences.getInstance();

    loginData.setString(CachedLoginData.tokenResponse, token);
    loginData.setString(CachedLoginData.expirationResponse, expiration);
    client.setToken();
  }

  Future<void> _setAccountInfo() async {
    SharedPreferences loginData = await SharedPreferences.getInstance();

    final account = await this.getAccountFromApi();

    loginData.setString(CachedLoginData.defaultCompanyIdString,
        account.defaultCompanyId.toString());
    loginData.setString(
        CachedLoginData.employeeIdString, account.employeeId.toString());
    loginData.setString(CachedLoginData.defaultBranchIdString, "3");
  }

  Future<void> setToken() async {
    client.setToken();
  }

  Future<bool> _isUserTokenExpired() async {
    String expireDate =
        sharedPreferences.getString(CachedLoginData.expirationResponse) ?? "";

    final now = DateTime.now();
    var expiration = DateTime(now.year, now.month, now.day - 1);

    if (expireDate != "") {
      expiration = DateTime.parse(expireDate);
    }
    bool isExpired = expiration.isBefore(now);

    return isExpired;
  }

  Future<void> logout() async {
    sharedPreferences.remove(CachedLoginData.tokenResponse);
    sharedPreferences.remove(CachedLoginData.expirationResponse);
    sharedPreferences.remove(CachedLoginData.defaultCompanyIdString);
    sharedPreferences.remove(CachedLoginData.employeeIdString);
  }

  void _switchApiBasedOnEmail(String email) {
    String domainOfEmail =
        email.substring(email.indexOf('@') + 1, email.indexOf('.'));
    switch (domainOfEmail) {
      case ApiDomains.JRS:
        sharedPreferences.setString(domainApiUrl, ApiUrl.jrsUrl);
        break;
      case ApiDomains.BREUR:
        print('breur api');
        break;
      default:
    }
  }
}
