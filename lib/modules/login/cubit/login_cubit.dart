import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login/cubit/login_states.dart';
import 'package:shop_app/network/end_points.dart';
import 'package:shop_app/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  LoginModel loginModel;

  void userLogin({
    @required String email,
    @required String password,
  }) {
    emit(LoginLoadingState());

    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': email,
        'password': password,
      },
    ).then(
      (value) {
        // print(value.data);
        // print(value.data['message']);
        loginModel = LoginModel.fromJson(value.data);
        // print('token is: ${loginModel.data.token}');
        // print('status is: ${loginModel.status}');
        // print('message is: ${loginModel.message}');
        emit(LoginSuccessState(loginModel));
      },
    ).catchError((error) {
      print(error.toString());
      emit(
        LoginErrorState(
          error.toString()
        ),
      );
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPassword = true;

  void changePasswordVisibility() {
    isPassword = !isPassword;

    suffix =
    isPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined;

    emit(ChangePasswordVisibilityState());
  }
}