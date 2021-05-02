import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/cubit.dart';
import 'package:shop_app/layouts/cubit/states.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/color.dart';

class ProfileScreen extends StatelessWidget {
  var nameController = TextEditingController();
  var mailController = TextEditingController();
  var phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        var user = HomeCubit.get(context).userModel;
        var formKey = GlobalKey<FormState>();
        nameController.text = user.data.name;
        mailController.text = user.data.email;
        phoneController.text = user.data.phone;
        return SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 10.0,),
              Container(
                width: double.infinity,
                height: 150,
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: kPrimaryColor,
                      radius: 38,
                      child: CircleAvatar(
                        radius: 35,
                        backgroundImage: NetworkImage(user.data.image),
                      ),
                    ),
                    Text(
                      user.data.name,
                      style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.black),
                    ),
                    Text(
                      user.data.email,
                      style: TextStyle(fontSize: 14.0, color: Colors.black),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Expanded(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        if(state is UserLoadingUpdateDataState)
                        LinearProgressIndicator(),
                        SizedBox(height: 10.0),
                        defaultTextField(
                          controller: nameController,
                          type: TextInputType.name,
                          label: 'الاسم',
                          prefix: Icons.person,
                          validation: (String value) {
                            if (value.isEmpty)
                              return "هذا الحقل يجب الا يكون فارغاً";
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        defaultTextField(
                          controller: mailController,
                          type: TextInputType.emailAddress,
                          label: 'البريد الالكتروني',
                          prefix: Icons.mail_outline,
                          validation: (String value) {
                            if (value.isEmpty)
                              return "هذا الحقل يجب الا يكون فارغاً";
                            return null;
                          },
                        ),
                        SizedBox(height: 10.0),
                        defaultTextField(
                          controller: phoneController,
                          type: TextInputType.phone,
                          label: 'رقم الهاتف',
                          prefix: Icons.phone_android_outlined,
                          validation: (String value) {
                            if (value.isEmpty)
                              return "هذا الحقل يجب الا يكون فارغاً";
                            return null;
                          },
                        ),
                        SizedBox(height: 20.0),
                        defaultButton(text: 'update', function: (){
                          if(formKey.currentState.validate())
                            HomeCubit.get(context).updateUserData(
                                email : mailController.text,
                                phone :phoneController.text,
                                name : nameController.text,
                            );
                        }),
                        SizedBox(height: 20.0),
                        defaultButton(text: 'Logout', function: (){
                          CacheHelper.removeData(key: 'token').then((value) {
                            navigateAndFinish(context, LoginScreen());
                          }
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),

            ],
          ),
        );
      },
    );
  }
}
