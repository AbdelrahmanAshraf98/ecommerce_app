import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/cubit.dart';
import 'package:shop_app/models/login_model.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';

class RegisterCubit extends Cubit<RegisterStates> {
  RegisterCubit() : super(RegisterInitialState());

  LoginModel registerModel;

  static RegisterCubit get(context) => BlocProvider.of(context);

  void userRegister(
      {@required String mail,
      @required String name,
      @required String phone,
      @required String password,
      BuildContext context}) {
    emit(RegisterLoadingState());
    DioHelper.postData(
      url: 'register',
      data: {
        'name': name,
        'email': mail,
        'password': password,
        'phone': phone,
      },
    ).then((value) {
      registerModel = LoginModel.fromJson(value.data);
      HomeCubit.get(context).changeBottom(0);
      print(registerModel.message);
      emit(RegisterSuccessState(registerModel));
    }).catchError((error) {
      emit(RegisterErrorState(error.toString()));
    });
  }

  IconData suffix = Icons.visibility_outlined;
  bool isPasswordShown = true;

  void changePasswordVisibility() {
    isPasswordShown = !isPasswordShown;
    if (isPasswordShown)
      suffix = Icons.visibility_outlined;
    else
      suffix = Icons.visibility_off_outlined;
    emit(RegisterChangePasswordVisibilityState());
  }
}
