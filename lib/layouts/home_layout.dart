import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/cubit.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/modules/search/search_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'cubit/states.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = HomeCubit.get(context);
          return Scaffold(
            appBar: AppBar(
                title: Text(
                  'متجري',
                  style: TextStyle(color: Colors.black),
                ),
                actions: [
                  IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        navigateTo(context, SearchScreen());
                      }),
                  IconButton(
                      icon: Icon(Icons.logout),
                      onPressed: () {
                        CacheHelper.removeData(key: 'token').then((value) =>
                            navigateAndFinish(context, LoginScreen()));
                      }),
                ]),
            body: cubit.screens[cubit.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: (index) {
                cubit.changeBottom(index);
              },
              currentIndex: cubit.currentIndex,
              items: [
                BottomNavigationBarItem(
                    icon: Icon(Icons.home), label: 'الرئيسية'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.apps), label: 'الاقسام'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.favorite), label: 'المفضلة'),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: 'الاعدادات'),
              ],
            ),
          );
        },
      ),
    );
  }
}
