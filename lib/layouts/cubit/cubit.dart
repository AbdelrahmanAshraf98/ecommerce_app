import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/favourites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favourites/favourites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/profile/profile_screen.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class HomeCubit extends Cubit<HomeStates> {
  HomeCubit() : super(HomeInitialState());

  static HomeCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> screens = [
    ProductScreen(),
    CategoriesScreen(),
    FavouritesScreen(),
    ProfileScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(HomeChangeBottomNav());
  }

  Map<int, bool> fav = {};
  HomeModel homeModel;

  void getHomeData(String token) {
    emit(HomeLoadingDataState());
    DioHelper.getData(
      url: 'home',
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);
      homeModel.data.products.forEach((element) {
        fav.addAll({
          element.id: element.inFavorites,
        });
      });
      emit(HomeSuccessDataState());
    }).catchError((error) {
      print(error.toString());
      emit(HomeErrorDataState());
    });
  }

  CategoriesModel categoriesModel;

  void getCategoriesData(String token) {
    emit(CategoriesLoadingDataState());
    DioHelper.getData(
      url: 'categories',
      token: token,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);
      emit(CategoriesSuccessDataState());
    }).catchError((error) {
      print(error.toString());
      emit(CategoriesErrorDataState());
    });
  }

  FavouritesModel favouritesModel;

  void getFavouritesData(String token) {
    emit(FavouritesLoadingDataState());
    DioHelper.getData(
      url: 'favorites',
      token: token,
    ).then((value) {
      favouritesModel = FavouritesModel.fromJson(value.data);
      emit(FavouritesSuccessDataState());
    }).catchError((error) {
      print(error.toString());
      emit(FavouritesErrorDataState());
    });
  }

  ChangeFavouritesModel favModel;

  void changeFav(int id,String token) {
    fav[id] =! fav[id];
    emit(ChangeFavLoadingDataState());
    DioHelper.postData(url: 'favorites', data: {'product_id': id}, token: token)
        .then((value) {
      favModel = ChangeFavouritesModel.fromJson(value.data);
      if(!favModel.status)
        fav[id] =! fav[id];
      getFavouritesData(token);
      emit(ChangeFavSuccessDataState(favModel));
    }).catchError((error) {
      fav[id] =! fav[id];
      print(error.toString());
      emit(ChangeFavErrorDataState());
    });
  }

  LoginModel userModel;
  void getUserData(String token) {
    emit(UserLoadingDataState());
    DioHelper.getData(
      url: 'profile',
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(UserSuccessDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(UserErrorDataState());
    });
  }

  void updateUserData({
    @required String name,
    @required String email,
    @required String phone,
    String token,
}) {
    emit(UserLoadingUpdateDataState());
    DioHelper.putData(
      url: 'update-profile',
      data: {
        'name':name,
        'email':email,
        'phone':phone,
      },
      token: token,
    ).then((value) {
      userModel = LoginModel.fromJson(value.data);
      emit(UserSuccessUpdateDataState(userModel));
    }).catchError((error) {
      print(error.toString());
      emit(UserErrorUpdateDataState());
    });
  }



}
