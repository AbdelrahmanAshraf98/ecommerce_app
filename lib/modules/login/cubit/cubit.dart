import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/cubit.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/shared/network/end_points.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  LoginModel loginModel ;


  static LoginCubit get(context) => BlocProvider.of(context);

  void userLogin({@required String mail, @required String password,BuildContext context}) {
    emit(LoginLoadingState());
    DioHelper.postData(
      url: LOGIN,
      data: {
        'email': mail,
        'password': password,
      },
    ).then((value) {
      loginModel = LoginModel.fromJson(value.data);
      HomeCubit.get(context).changeBottom(0);
      print(loginModel.message);
      emit(LoginSuccessState(loginModel));
      HomeCubit.get(context).getUserData();
    }).catchError((error){
      emit(LoginErrorState(error.toString()));
    });
  }

  IconData suffix  = Icons.visibility_outlined;
  bool isPasswordShown = true;

  void changePasswordVisibility(){
    isPasswordShown = !isPasswordShown;
    if(isPasswordShown)
      suffix = Icons.visibility_outlined;
    else
      suffix = Icons.visibility_off_outlined;
    emit(LoginChangePasswordVisibilityState());
  }

}
