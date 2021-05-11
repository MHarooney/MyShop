import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/change_favorites_model.dart';
import 'package:shop_app/models/favorites_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favourites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/states.dart';

import 'components/constants.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavAppBarState());
  }

  HomeModel homeModel;

  Map<int, bool> favorites = {};

  void getHomeData() {
    emit(AppLoadingHomeDataState());

    DioHelper.getData(
      url: HOME,
      token: token,
    ).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      //print(homeModel.data.banners[0].image);
      //print(homeModel.status);

      homeModel.data.products.forEach((element) {
        favorites.addAll({
          element.id: element.inFavorites,
        });
      });

      //print(favorites.toString());

      emit(AppSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorHomeDataState());
    });
  }

  CategoriesModel categoriesModel;

  void getCategories() {
    DioHelper.getData(
      url: GET_CATEGORIES,
    ).then((value) {
      categoriesModel = CategoriesModel.fromJson(value.data);

      emit(AppSuccessCategoriesDataState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorCategoriesDataState());
    });
  }

  ChangeFavoritesModel changeFavoritesModel;

  void changeFavorites(int productId) {
    favorites[productId] = !favorites[productId];

    emit(AppChangeFavoritesState());

    DioHelper.postData(
      url: FAVORITES,
      data: {
        'product_id': productId,
      },
      token: token,
    ).then((value) {
      changeFavoritesModel = ChangeFavoritesModel.fromJson(value.data);
      print(value.data);

      if (!changeFavoritesModel.status) {
        favorites[productId] = !favorites[productId];
      } else {
        getFavorites();
      }

      emit(AppSuccessChangeFavoritesState(changeFavoritesModel));
    }).catchError((error) {
      favorites[productId] = !favorites[productId];

      emit(AppErrorChangeFavoritesState());
    });
  }

  FavoritesModel favoritesModel;

  void getFavorites() {
    emit(AppLoadingGetFavoritesState());

    DioHelper.getData(
      url: FAVORITES,
      token: token,
    ).then((value) {
      favoritesModel = FavoritesModel.fromJson(value.data);
      //printFullText(value.data.toString());

      emit(AppSuccessGetFavoritesState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorGetFavoritesState());
    });
  }

  // AppLoginModel userModel;
  //
  // void getUserData() {
  //   emit(ShopLoadingUserDataState());
  //
  //   DioHelper.getData(
  //     url: PROFILE,
  //     token: token,
  //   ).then((value) {
  //     userModel = ShopLoginModel.fromJson(value.data);
  //     printFullText(userModel.data.name);
  //
  //     emit(ShopSuccessUserDataState(userModel));
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(ShopErrorUserDataState());
  //   });
  // }

  // void updateUserData({
  //   @required String name,
  //   @required String email,
  //   @required String phone,
  // }) {
  //   emit(ShopLoadingUpdateUserState());
  //
  //   DioHelper.putData(
  //     url: UPDATE_PROFILE,
  //     token: token,
  //     data: {
  //       'name': name,
  //       'email': email,
  //       'phone': phone,
  //     },
  //   ).then((value) {
  //     userModel = ShopLoginModel.fromJson(value.data);
  //     printFullText(userModel.data.name);
  //
  //     emit(ShopSuccessUpdateUserState(userModel));
  //   }).catchError((error) {
  //     print(error.toString());
  //     emit(ShopErrorUpdateUserState());
  //   });
  // }

  bool isDark = false;

  void changeAppMode({bool fromShared})
  {
    if (fromShared != null)
    {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else
    {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }
}