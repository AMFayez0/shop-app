part of '../cubit/login_cubit.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSucsse extends LoginState {
  final LoginModel loginModel;

  LoginSucsse(this.loginModel);
}

class LoginError extends LoginState {
  final String erorr;

  LoginError(this.erorr);
}

class LoginchaneVisiablity extends LoginState {}

class LoginchaneVisiablity2 extends LoginState {}




