import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/cubit.dart';
import 'package:shop_app/layouts/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/color.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit,HomeStates>(
      listener: (context, state) {} ,
      builder: (context, state) {
        return ConditionalBuilder(
          condition: HomeCubit.get(context).categoriesModel != null,
          builder: (context) => ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildCatItem(HomeCubit.get(context).categoriesModel.data.data[index]),
              separatorBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  height: 1.0,
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadiusDirectional.circular(35.0),
                  ),
                ),
              ),
              itemCount: HomeCubit.get(context).categoriesModel.data.data.length),
          fallback: (context) => (Center(child: circularProgress())),
        );
      },
    );
  }
}

Widget buildCatItem(DataModel model) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: [
          Image(
            image: NetworkImage(model.image),
            width: 80.0,
            height: 80.0,
          ),
          SizedBox(width: 10.0,),
          Text(
            model.name,
            style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
