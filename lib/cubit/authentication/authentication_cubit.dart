import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:work_order_app/core/constants/constants.dart';
import 'package:work_order_app/data/services/authentication_service.dart';
import 'package:work_order_app/locator.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  var _authenticationService = locator<AuthenticationService>();

  Future<void> login(
      {required String username, required String password}) async {
    try {
      emit(AuthenticationLoading());
      var response = await _authenticationService.login(
        username: username,
        password: password,
      );

      if (response == HttpStatus.ok) {
        emit(AuthenticationUserFound(HttpStatus.ok));
      } else {
        emit(AuthenticationUserNotFound(HttpStatus.unauthorized));
      }
    } catch (e) {
      emit(AuthenticationError());
    }
  }

  Future<void> logout() async {
    try {
      _authenticationService.logout();
    } catch (e) {
      emit(AuthenticationError());
    }
  }

  Future<void> checkLoginStatus() async {
    bool hasShown = await _checkFirstSeen();
    if (!hasShown) return;
    try {
      emit(AuthenticationLoading());
      bool isValid = await _authenticationService.checkIfValidLogin();
      if (isValid == true) {
        emit(AuthenticationUserFound(HttpStatus.ok));
      } else {
        _authenticationService.logout();
        emit(AuthenticationUserNotFound(HttpStatus.unauthorized));
      }
    } catch (e) {
      emit(AuthenticationError());
    }
  }

  Future<void> saveEmail(String email) async {
    emit(AuthenticationLoading());
    bool isLicensed = _checkIfLicensed(email);
    if (isLicensed) {
      emit(AuthenticationLicensed());
      _authenticationService.saveEmail(email);
    } else {
      emit(AuthenticationNotLicensed());
    }
  }

  Future<bool> _checkFirstSeen() async {
    bool hasShown = await _authenticationService.checkIfFirstScreenWasShown();
    if (hasShown)
      return true;
    else {
      emit(AuthenticationFirstTime());
      return false;
    }
  }

  bool _checkIfLicensed(String email) {
    String domainOfEmail =
        email.substring(email.indexOf('@') + 1, email.indexOf('.'));
    switch (domainOfEmail) {
      case ApiDomains.BREUR:
      case ApiDomains.JRS:
      case ApiDomains.DIDATA:
      case ApiDomains.DOZON:
      case ApiDomains.BUS:
        return true;
      default:
        return false;
    }
  }
}
