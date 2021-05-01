import 'package:conditional/conditional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/layouts/home_layout.dart';
import 'package:shop_app/modules/login/cubit/cubit.dart';
import 'package:shop_app/modules/login/cubit/states.dart';
import 'package:shop_app/modules/register_screen/register_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/color.dart';

class LoginScreen extends StatelessWidget {

  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool isPassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: BlocConsumer<LoginCubit, LoginStates>(
        listener: (context, state) {
          if(state is LoginSuccessState){
            if(state.loginModel.status == true){
              print('tmam');
              CacheHelper.saveData(key: 'token', value: state.loginModel.data.token)
                  .then((value) =>  navigateAndFinish(context,Home()));
            }else{
              print('msh tmam');
              showToast(msg: state.loginModel.message, state: ToastStates.error);
            }
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
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
                          'LOGIN',
                          style: Theme.of(context)
                              .textTheme
                              .headline4
                              .copyWith(color: Colors.black),
                        ),
                        Text(
                          'Login now to browse our hot offers',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 30.0),
                        defaultTextField(
                          controller: emailController,
                          validation: (String value) {
                            if (value.isEmpty)
                              return "This field mustn't be empty";
                            return null;
                          },
                          type: TextInputType.emailAddress,
                          label: 'Email',
                          prefix: Icons.mail_outline,
                        ),
                        SizedBox(height: 15.0),
                        defaultTextField(
                            controller: passwordController,
                            validation: (String value) {
                              if (value.isEmpty)
                                return "This field mustn't be empty";
                              return null;
                            },
                            type: TextInputType.visiblePassword,
                            label: 'Password',
                            prefix: Icons.lock_outlined,
                            isPassword: LoginCubit.get(context).isPasswordShown,
                            suffix: LoginCubit.get(context).suffix,
                            suffixPressed: () {
                              LoginCubit.get(context).changePasswordVisibility();
                            },
                        ),
                        SizedBox(height: 30.0),
                        Conditional(
                          condition: state is LoginLoadingState,
                          onConditionTrue: Center(
                            child: circularProgress(),
                          ),
                          onConditionFalse: defaultButton(
                              text: 'Login',
                              function: () {
                                if (formKey.currentState.validate()) {
                                  LoginCubit.get(context).userLogin(
                                    mail: emailController.text,
                                    password: passwordController.text,
                                  );
                                }
                              }),
                        ),
                        SizedBox(height: 15.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Don\'t have an account?'),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, RegisterScreen());
                                },
                                child: Text(
                                  'Register Now',
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
    );
  }
}
