import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/shared/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialStates());

  static AppCubit get(context) => BlocProvider.of(context);

  bool isDark = false;

  int currentIndex = 0;

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
}