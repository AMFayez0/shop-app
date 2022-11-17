// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}

class ChangeBottomNavState extends HomeState {}

class LoadingHomeDataState extends HomeState {}

class SuccessHomeDataState extends HomeState {}

class ErrorHomeDataState extends HomeState {}

class SuccessCategoriesState extends HomeState {}

class ErrorCategoriesState extends HomeState {}

class SuccessChangeFavState extends HomeState {}

class SuccessAddRemoveFavState extends HomeState {}

class ErrorChangeFavState extends HomeState {
  String message;
  ErrorChangeFavState({
    required this.message,
  });
}

class SuccessGetFavState extends HomeState {}

class LoadingGetFavState extends HomeState {}

class ErrorGetFavState extends HomeState {}

class SuccessGetUserDataState extends HomeState {
  final LoginModel userModel;

  SuccessGetUserDataState(this.userModel);
}

class LoadingGetUserDataState extends HomeState {}

class ErrorGetUserDataState extends HomeState {}

class LoadingUpdateUserState extends HomeState {}

class SuccessUpdateUserState extends HomeState
{
  final LoginModel loginModel;

  SuccessUpdateUserState(this.loginModel);
}

class ErrorUpdateUserState extends HomeState {}



