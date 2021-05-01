import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/cubit.dart';
import 'package:shop_app/layouts/cubit/states.dart';
import 'package:shop_app/models/favourites_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/color.dart';

class FavouritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return ConditionalBuilder(
          condition: HomeCubit.get(context).favouritesModel != null,
          builder: (context) =>HomeCubit.get(context).favouritesModel.data.items.length==0
              ? emptyFav() : ListView.separated(
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) => buildFavItem(
                  HomeCubit.get(context).favouritesModel, index, context),
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
                  HomeCubit.get(context).favouritesModel.data.items.length),
          fallback: (context) => (Center(child: circularProgress())),
        );
      },
    );
  }
}

Widget emptyFav() => Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image(image: AssetImage('assets/images/love.png')),
              Text('لا توجد منتجات مفضلة',style: TextStyle(fontSize: 18.0),),
              Text('اضف البعض',style: TextStyle(color: kPrimaryColor),),
        ]),
      ),
    );
Widget buildFavItem(FavouritesModel model, int index, context) => Padding(
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
                    image: NetworkImage(model.data.items[index].product.image),
                  ),
                  // if (model.data.products[index].discount != 0)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 5.0),
                    color: Colors.red,
                    child: Text(
                      'خصم',
                      style: TextStyle(fontSize: 10.0, color: Colors.white),
                    ),
                  )
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
                    model.data.items[index].product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14.0, height: 1.3),
                  ),
                  Row(
                    children: [
                      Text(
                        model.data.items[index].product.price
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
                      Text(
                        model.data.items[index].product.oldPrice
                            .round()
                            .toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 10.0,
                            height: 1.3,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough),
                      ),
                      Spacer(),
                      IconButton(
                          icon: CircleAvatar(
                            backgroundColor: HomeCubit.get(context)
                                    .fav[model.data.items[index].product.id]
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
                                .changeFav(model.data.items[index].product.id);
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
