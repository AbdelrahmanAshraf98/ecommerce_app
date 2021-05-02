import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/cubit.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/on_boarding/on_boarding_screen.dart';
import 'package:shop_app/shared/bloc_observer.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/network/remote/dio_helper.dart';
import 'package:shop_app/shared/styles/color.dart';
import 'layouts/home_layout.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();
  bool onBoarding = CacheHelper.getData(key: 'onBoard');
  token = CacheHelper.getData(key: 'token');
  Widget widgetScreen;
  if (onBoarding != null) {
    if (token != null)
      widgetScreen = Home();
    else
      widgetScreen = LoginScreen();
  } else
    widgetScreen = OnBoardingScreen();

  runApp(MyApp(
    Token:token,
    onBoarding: onBoarding,
    widgetScreen: widgetScreen,
  ));
}

class MyApp extends StatelessWidget {
  bool onBoarding;
  String Token;
  Widget widgetScreen;
  MyApp({this.onBoarding, this.widgetScreen,this.Token});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()
        ..getHomeData(Token)
        ..getCategoriesData(Token)
        ..getFavouritesData(Token)
        ..getUserData(Token),
      child: MaterialApp(
        theme: ThemeData(
            fontFamily: 'Jannah',
            scaffoldBackgroundColor: Colors.white,
            primaryColor: kPrimaryColor,
            appBarTheme: AppBarTheme(
              titleSpacing: 20.0,
              elevation: 0,
              backgroundColor: Colors.white,
              backwardsCompatibility: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
              ),
              iconTheme: IconThemeData(color: Colors.black,),

            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              elevation: 20,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: kPrimaryColor,
              unselectedItemColor: Colors.grey
            )),
        debugShowCheckedModeBanner: false,
        home: widgetScreen,
      ),
    );
  }
}
