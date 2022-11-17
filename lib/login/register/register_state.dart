part of 'register_cubit.dart';

@immutable
abstract class RegisterState {}

class RegisterInitial extends RegisterState {}
 

class RegisterLoading extends RegisterState {}

class RegisterSucsse extends RegisterState {
  final LoginModel RegisterModel;

  RegisterSucsse(this.RegisterModel);
}

class RegisterError extends RegisterState {
  final String erorr;

  RegisterError(this.erorr);
}

class RegisterchaneVisiablity extends RegisterState {}

class RegisterchaneVisiablity2 extends RegisterState {}