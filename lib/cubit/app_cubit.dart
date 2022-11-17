// ignore_for_file: prefer_const_constructors

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../network/cach_helper.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  static AppCubit get(context) => BlocProvider.of(context);
 
  bool isdark = false;

  void changeMode({bool? fromShared}) {
    if (fromShared != null) {
      isdark = fromShared;
    } else {
      isdark = !isdark;
    }
    CachHelper.putBolean(key: 'isdark', value: isdark).then((value) {
      emit(Appchangemode());
    }).catchError((error){
      print(error.toString());
      emit(AppchangemodeError());
    });
  }
}
