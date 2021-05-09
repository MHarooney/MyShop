import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/modules/categories/categories_screen.dart';
import 'package:shop_app/modules/favorites/favourites_screen.dart';
import 'package:shop_app/modules/products/products_screen.dart';
import 'package:shop_app/modules/settings/settings_screen.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    ProductsScreen(),
    CategoriesScreen(),
    FavoritesScreen(),
    SettingsScreen(),
  ];

  void changeBottomIndex(int index) {
    currentIndex = index;
    // if (index == 1) getSports();
    // if (index == 2) getScience();
    emit(AppChangeBottomNavAppBarState());
  }

  void changeAppMode({bool fromShared}) {
    if (fromShared != null) {
      isDark = fromShared;
      emit(AppChangeModeState());
    } else {
      isDark = !isDark;
      CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value) {
        emit(AppChangeModeState());
      });
    }
  }

  HomeModel homeModel;

  void getHomeData(){
    emit(AppLoadingHomeDataState());

    DioHelper.getData(url: HOME).then((value) {
      homeModel = HomeModel.fromJson(value.data);

      print(homeModel.data.banners[0].image);
      print(homeModel.status);

      emit(AppSuccessHomeDataState());
    }).catchError((error) {
      print(error.toString());
      emit(AppErrorHomeDataState());
    });
  }
}