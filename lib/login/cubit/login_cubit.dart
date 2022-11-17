import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_app/login/login/login_model.dart';
import 'package:shop_app/network/dio_helper.dart';
import 'package:shop_app/network/end_points.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);
  LoginModel? loginModel;

  void userLogin({
    required String email,
    required String password,
  }) {
    emit(LoginLoading());
    DioHelper.postData(
      url: LOGIN,
      data: {'email': email, 'password': password},
    ).then((value) {
      // print(value.data);
      loginModel = LoginModel.fromJason(value.data);

      emit(LoginSucsse(loginModel!));
    }).catchError((error) {
      emit(LoginError(error.toString(print(error))));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShow = true;

  void changePasswordVisibility() {
    isPasswordShow = !isPasswordShow;
    if (isPasswordShow) {
      suffix = Icons.visibility_outlined;
      emit(LoginchaneVisiablity());
    } else {
      suffix = Icons.visibility_off_outlined;
      emit(LoginchaneVisiablity2());
    }
  }
  
  
  
  

}
