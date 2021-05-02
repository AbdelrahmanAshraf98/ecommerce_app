import 'package:conditional/conditional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/home_layout.dart';
import 'package:shop_app/modules/register/cubit/states.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/register/cubit/cubit.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/color.dart';

class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocProvider(
        create: (context) => RegisterCubit(),
        child: BlocConsumer<RegisterCubit, RegisterStates>(
          listener: (context, state) {
            if(state is RegisterSuccessState){
              if(state.loginModel.status == true){
                print(state.loginModel.data.token);
                CacheHelper.saveData(key: 'token', value: state.loginModel.data.token)
                    .then((value) {
                  token = state.loginModel.data.token;
                  print(token);
                  navigateAndFinish(context, Home());
                });
              }else{
                showToast(msg: state.loginModel.message, state: ToastStates.error);
              }
            }
          },
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'إنشاء حساب',
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(color: Colors.black),
                          ),
                          Text(
                            'انشئ حسابك الآن لتحصل علي عروض مميزة',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.grey),
                          ),
                          SizedBox(height: 30.0),
                          defaultTextField(
                            controller: nameController,
                            validation: (String value) {
                              if (value.isEmpty)
                                return "هذا الحقل يجب الا يكون فارغاً";
                              return null;
                            },
                            type: TextInputType.text,
                            label: 'الاسم',
                            prefix: Icons.person,
                          ),
                          SizedBox(height: 15.0),
                          defaultTextField(
                            controller: emailController,
                            validation: (String value) {
                              if (value.isEmpty)
                                return "هذا الحقل يجب الا يكون فارغاً";
                              return null;
                            },
                            type: TextInputType.emailAddress,
                            label: 'البريد الالكتروني',
                            prefix: Icons.mail_outline,
                          ),
                          SizedBox(height: 15.0),
                          defaultTextField(
                            controller: passwordController,
                            validation: (String value) {
                              if (value.isEmpty)
                                return "هذا الحقل يجب الا يكون فارغاً";
                              return null;
                            },
                            type: TextInputType.visiblePassword,
                            label: 'كلمة السر',
                            prefix: Icons.lock_outlined,
                            isPassword: RegisterCubit.get(context).isPasswordShown,
                            suffix: RegisterCubit.get(context).suffix,
                            suffixPressed: () {
                              RegisterCubit.get(context).changePasswordVisibility();
                            },
                          ),
                          SizedBox(height: 15.0),
                          defaultTextField(
                            controller: phoneController,
                            validation: (String value) {
                              if (value.isEmpty)
                                return "هذا الحقل يجب الا يكون فارغاً";
                              return null;
                            },
                            type: TextInputType.phone,
                            label: 'رقم الهاتف',
                            prefix: Icons.phone_android_outlined,
                          ),
                          SizedBox(height: 30.0),
                          Conditional(
                            condition: state is RegisterLoadingState,
                            onConditionTrue: Center(
                              child: CircularProgressIndicator(
                                backgroundColor: kPrimaryColor,
                              ),
                            ),
                            onConditionFalse: defaultButton(
                                text: 'إنشاء حساب',
                                function: () {
                                  if (formKey.currentState.validate()) {
                                    RegisterCubit.get(context).userRegister(
                                      name: nameController.text,
                                      mail: emailController.text,
                                      password: passwordController.text,
                                      phone: phoneController.text,
                                      context: context,
                                    );
                                  }
                                }),
                          ),
                          SizedBox(height: 15.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('هل لديك حساب ؟'),
                              TextButton(
                                  onPressed: () {
                                    navigateAndFinish(context, LoginScreen());
                                  },
                                  child: Text(
                                    'سجل الآن',
                                    style: TextStyle(color: kPrimaryColor),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
