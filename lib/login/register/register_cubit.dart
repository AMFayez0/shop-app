import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../network/cach_helper.dart';
import '../../network/dio_helper.dart';
import '../../network/end_points.dart';
import '../cubit/login_cubit.dart';
import '../login/login_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  static RegisterCubit get(context) => BlocProvider.of(context);
  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShow = true;

  LoginModel? registerModel;

  void userRegister({
    required String ?email,
    required dynamic password,
    required String ?name,
    required dynamic phone,
  }) {
    emit(RegisterLoading());
    
    DioHelper.postData(
      
      url: REGISTER,
      data: {
        'email': email,
        'password': password,
        'name': name,
        'phone': phone,
      },
    ).then((value) {
      // print(value.data);
      registerModel = LoginModel.fromJason(value.data);
  
      emit(RegisterSucsse(registerModel!));
    }).catchError((error,trace) {
       print(error.toString());
      print(trace);
      emit(RegisterError(error.toString()));
    });
  }

  void changePasswordVisibilityREG() {
    isPasswordShow = !isPasswordShow;
    if (isPasswordShow) {
      suffix = Icons.visibility_outlined;
      emit(RegisterchaneVisiablity());
    } else {
      suffix = Icons.visibility_off_outlined;
      emit(RegisterchaneVisiablity2());
    }
  }
}
