import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/bloc_observer.dart';
import 'package:shop_app/layout/home_layout.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/network/local/cache_helper.dart';
import 'package:shop_app/network/remote/dio_helper.dart';
import 'package:shop_app/shared/cubit.dart';
import 'package:shop_app/shared/states.dart';
import 'package:shop_app/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

  bool onBoarding = CacheHelper.getData(key: 'onBoarding');

  String token = CacheHelper.getData(key: 'token');

  if (onBoarding != null) {
    if (token != null)
      widget = HomeLayout();
    else
      widget = LoginScreen();
  } else {
    widget = OnBoardingScreen();
  }

  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;

  // final bool onBoarding;
  final Widget startWidget;

  const MyApp({
    this.isDark,
    this.startWidget,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => AppCubit()
        ..getHomeData()
        ..getCategoriesData()
        ..changeAppMode(
          fromShared: isDark,
        ),
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Flutter Demo',
            theme: lightTheme,
            // darkTheme: darkTheme,
            // themeMode:
            //     AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
            themeMode: ThemeMode.light,
            // home: onBoarding ? LoginScreen() : OnBoardingScreen(),
            home: startWidget,
            // home: false ? LoginScreen() : OnBoardingScreen(),
          );
        },
      ),
    );
  }
}