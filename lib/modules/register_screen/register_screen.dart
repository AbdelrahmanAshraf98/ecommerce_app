import 'package:conditional/conditional.dart';
import 'package:flutter/material.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/color.dart';

class RegisterScreen extends StatelessWidget {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
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
                    'Register',
                    style: Theme.of(context)
                        .textTheme
                        .headline4
                        .copyWith(color: Colors.black),
                  ),
                  Text(
                    'Register now to browse our hot offers',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 30.0),
                  defaultTextField(
                    controller: nameController,
                    validation: (String value) {
                      if (value.isEmpty) return "This field mustn't be empty";
                      return null;
                    },
                    type: TextInputType.text,
                    label: 'Name',
                    prefix: Icons.person,
                  ),
                  SizedBox(height: 15.0),
                  defaultTextField(
                    controller: emailController,
                    validation: (String value) {
                      if (value.isEmpty) return "This field mustn't be empty";
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
                      if (value.isEmpty) return "This field mustn't be empty";
                      return null;
                    },
                    type: TextInputType.visiblePassword,
                    label: 'Password',
                    prefix: Icons.lock_outlined,
                    isPassword: true,
                    suffix: Icons.visibility_outlined,
                    suffixPressed: () {},
                  ),
                  SizedBox(height: 15.0),
                  defaultTextField(
                    controller: phoneController,
                    validation: (String value) {
                      if (value.isEmpty) return "This field mustn't be empty";
                      return null;
                    },
                    type: TextInputType.phone,
                    label: 'phone',
                    prefix: Icons.phone,
                  ),
                  SizedBox(height: 30.0),
                  Conditional(
                    condition: false,
                    onConditionTrue: Center(
                      child: CircularProgressIndicator(
                        backgroundColor: kPrimaryColor,
                      ),
                    ),
                    onConditionFalse:
                        defaultButton(text: 'Register', function: () {}),
                  ),
                  SizedBox(height: 15.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Have an account?'),
                      TextButton(
                          onPressed: () {
                            navigateAndFinish(context, LoginScreen());
                          },
                          child: Text(
                            'Login Now',
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
  }
}
