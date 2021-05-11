import 'package:shop_app/models/change_favorites_model.dart';

abstract class AppStates {}

class AppInitialStates extends AppStates {}

class AppChangeBottomNavAppBarState extends AppStates{}

class AppLoadingHomeDataState extends AppStates {}

class AppSuccessHomeDataState extends AppStates {}

class AppErrorHomeDataState extends AppStates {}

class AppSuccessCategoriesDataState extends AppStates {}

class AppErrorCategoriesDataState extends AppStates {}

class AppChangeFavoritesState extends AppStates {}

class AppSuccessChangeFavoritesState extends AppStates
{
  final ChangeFavoritesModel model;

  AppSuccessChangeFavoritesState(this.model);
}

class AppLoadingGetFavoritesState extends AppStates {}

class AppSuccessGetFavoritesState extends AppStates {}

class AppErrorGetFavoritesState extends AppStates {}

class AppErrorChangeFavoritesState extends AppStates {}

class AppChangeModeState extends AppStates {}