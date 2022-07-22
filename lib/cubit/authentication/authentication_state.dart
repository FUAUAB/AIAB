part of 'authentication_cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {
  const AuthenticationInitial();
}

class AuthenticationLoading extends AuthenticationState {
  const AuthenticationLoading();
}

class AuthenticationUserFound extends AuthenticationState {
  final int responseCode;

  const AuthenticationUserFound(this.responseCode);

  @override
  List<Object> get props => [this.responseCode];
}

class AuthenticationUserNotFound extends AuthenticationState {
  final int responseCode;

  const AuthenticationUserNotFound(this.responseCode);

  @override
  List<Object> get props => [this.responseCode];
}

class AuthenticationFirstTime extends AuthenticationState {}

class AuthenticationLicensed extends AuthenticationState {}

class AuthenticationNotLicensed extends AuthenticationState {}

class AuthenticationError extends AuthenticationState {
  const AuthenticationError();
}
