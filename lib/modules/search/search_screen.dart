import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/cubit.dart';
import 'package:shop_app/models/search_model.dart';
import 'package:shop_app/modules/search/cubit/cubit.dart';
import 'package:shop_app/modules/search/cubit/states.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/components/constants.dart';
import 'package:shop_app/shared/styles/color.dart';

class SearchScreen extends StatelessWidget {
  var searchController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: BlocConsumer<SearchCubit, SearchStates>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(),
            body: Padding(
              padding: const EdgeInsets.only(left: 20.0,top: 20.0,right: 20.0),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    defaultTextField(
                      controller: searchController,
                      type: TextInputType.text,
                      label: 'Search',
                      prefix: Icons.search_outlined,
                      validation: (String value) {
                        if (value.isEmpty)
                          return "هذا الحقل يجب الا يكون فارغاً";
                        return null;
                      },
                    onSubmit: (String value){
                      SearchCubit.get(context).search(value);
                    }
                    ),
                    SizedBox(height: 10.0),
                    if(state is SearchLoadingState)
                    LinearProgressIndicator(backgroundColor: kPrimaryColor,),
                    Expanded(
                      child: Container(
                        child: ConditionalBuilder(
                          condition: SearchCubit.get(context).searchModel != null,
                          builder: (context) => ListView.separated(
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context, index) => buildFavItem(
                                  SearchCubit.get(context).searchModel, index, context),
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
                              itemCount:
                              SearchCubit.get(context).searchModel.data.items.length),
                          fallback: (context) => emptyFav(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget emptyFav() => Center(
  child: Container(
    child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(image: AssetImage('assets/images/search.png')),
          Text('لا توجد نتائج بحث',style: TextStyle(fontSize: 18.0),),
          Text('ابحث الآن',style: TextStyle(color: kPrimaryColor),),
        ]),
  ),
);

Widget buildFavItem(SearchModel model, int index, context) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 120.0,
    child: Row(
      children: [
        Container(
          height: 120.0,
          width: 120.0,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              Image(
                height: 120,
                width: 120,
                image: NetworkImage(model.data.items[index].image),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.data.items[index].name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 14.0, height: 1.3),
              ),
              Row(
                children: [
                  Text(
                    model.data.items[index].price
                        .round()
                        .toString() +
                        ' ج.م ',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 12.0, height: 1.3, color: kPrimaryColor),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  // if (model.data.products[index].discount != 0)
                  Spacer(),
                  IconButton(
                      icon: CircleAvatar(
                        backgroundColor: HomeCubit.get(context)
                            .fav[model.data.items[index].id]
                            ? kPrimaryColor
                            : Colors.grey,
                        radius: 15,
                        child: Icon(
                          Icons.favorite_border_outlined,
                          size: 14.0,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        HomeCubit.get(context)
                            .changeFav(model.data.items[index].id,token);
                      })
                ],
              ),
            ],
          ),
        )
      ],
    ),
  ),
);