import 'package:shop_app/models/favourites_model.dart';

abstract class HomeStates{}

class HomeInitialState extends HomeStates{}

class HomeChangeBottomNav extends HomeStates{}

class HomeSuccessDataState extends HomeStates{}

class HomeErrorDataState extends HomeStates{}

class HomeLoadingDataState extends HomeStates{}

class CategoriesSuccessDataState extends HomeStates{}

class CategoriesErrorDataState extends HomeStates{}

class CategoriesLoadingDataState extends HomeStates{}

class ChangeFavSuccessDataState extends HomeStates{
  final ChangeFavouritesModel model;
  ChangeFavSuccessDataState(this.model);
}

class ChangeFavErrorDataState extends HomeStates{}

class ChangeFavLoadingDataState extends HomeStates{}

class FavouritesSuccessDataState extends HomeStates{}

class FavouritesErrorDataState extends HomeStates{}

class FavouritesLoadingDataState extends HomeStates{}