// ignore_for_file: prefer_const_constructors, avoid_print, non_constant_identifier_names

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shop_app/component/widgets.dart';
import 'package:shop_app/login/login/login_model.dart';
import 'package:shop_app/models/categoriesModel.dart';
import 'package:shop_app/models/changefavouritesModel.dart';
import 'package:shop_app/models/favouritesModel.dart';
import 'package:shop_app/models/homeModel.dart';
import 'package:shop_app/home_layout/screens/cateogries.dart';
import 'package:shop_app/home_layout/screens/favorites.dart';
import 'package:shop_app/home_layout/screens/products.dart';
import 'package:shop_app/home_layout/screens/settings.dart';
import 'package:shop_app/network/dio_helper.dart';
import 'package:shop_app/network/end_points.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  HomeCubit() : super(HomeInitial());
  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    Products(),
    Cateogries(),
    Favorites(),
    Settings(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(ChangeBottomNavState());
  }

  HomeModel? homeModel;

  Map<dynamic, dynamic> favorites = {};

  void getHomeData() {
    emit(LoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      //  token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      // print(homeModel!.data!.products[0].name);
      // print(homeModel!.status);

      homeModel!.data!.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });
      print(
        favorites.toString(),
      );

      emit(SuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorHomeDataState());
    });
  }

  CategoriesModel? categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      print('lol');
      emit(SuccessCategoriesState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorCategoriesState());
    });
  }

  ChangeFavoritesModel? changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId];
    emit(SuccessAddRemoveFavState());
    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);
      if (changeFavoritesModel!.status == false) {
        favorites[productId] = !favorites[productId];
        emit(ErrorChangeFavState(message: changeFavoritesModel!.message ?? ''));
      } else {
        emit(SuccessChangeFavState());
        getFavegories();
      }
    }).catchError((error, trace) {
      print(error.toString());
      print(trace);
      favorites[productId] = !favorites[productId];
      emit(
        ErrorChangeFavState(message: ' حدث خطأ  '),
      );
    });
  }

  FavoritesModel? favoritesModel;

  void getFavegories() {
    emit(LoadingGetFavState());
    DioHelper.getData(
      url: FAVORITES,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      print('lol');
      emit(SuccessGetFavState());
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetFavState());
    });
  }

  LoginModel? userModel;

  void getUserData() {
    emit(LoadingGetUserDataState());
    DioHelper.getData(
      url: PROFILE,
    ).then((value) {
      userModel = LoginModel.fromJason(value.data);
      print(userModel!.data!.name);
      emit(SuccessGetUserDataState(userModel!));
    }).catchError((error) {
      print(error.toString());
      emit(ErrorGetUserDataState());
    });
  }

  void updateUserData({
    required String name,
    required String email,
    required String phone,
  }) {
    emit(LoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      data: {
        'name': name,
        'email': email,
        'phone': phone,
      },
    ).then((value) {
      userModel = LoginModel.fromJason(value.data);
      print(userModel!.data!.name);
      if (userModel!.status == false) {
        emit(ErrorUpdateUserState());
      } else {
        emit(SuccessUpdateUserState(userModel!));
      }
    }).catchError((error) {
      print(error.toString());
      emit(ErrorUpdateUserState());
    });
  }

  
}
