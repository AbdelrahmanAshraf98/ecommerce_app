import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional/conditional.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/cubit.dart';
import 'package:shop_app/layouts/cubit/states.dart';
import 'package:shop_app/models/categories_model.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/color.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
        listener: (context, state) {
          if(state is ChangeFavSuccessDataState){
            if(!state.model.status){
              showToast(msg: state.model.msg, state: ToastStates.error);
            }else
              showToast(msg: state.model.msg, state: ToastStates.success);
          }
        },
        builder: (context, state) {
          return ConditionalBuilder(
            condition: HomeCubit.get(context).homeModel != null &&
                HomeCubit.get(context).categoriesModel != null,
            builder: (context) => productsBuilder(
                HomeCubit.get(context).homeModel,
                context,
                HomeCubit.get(context).categoriesModel),
            fallback: (context) => (Center(child: circularProgress())),
          );
        });
  }
}

Widget productsBuilder(HomeModel model, context, CategoriesModel cModel) =>
    SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          slider(model),
          SizedBox(height: 10.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'الاقسام',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 10.0),
                Container(
                  height: 100.0,
                  child: ListView.separated(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) =>
                          buildCategoriesItem(cModel.data.data[index]),
                      separatorBuilder: (context, index) => SizedBox(
                            width: 10.0,
                          ),
                      itemCount: cModel.data.data.length),
                ),
                SizedBox(height: 10.0),
                Text(
                  'منتجات جديدة',
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            color: Colors.grey[300],
            child: GridView.count(
              mainAxisSpacing: 1.0,
              crossAxisSpacing: 1.0,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              childAspectRatio: 1 / 1.40,
              crossAxisCount: 2,
              children: List.generate(
                model.data.products.length,
                (index) => Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        alignment: AlignmentDirectional.bottomStart,
                        children: [
                          Image(
                            height: 150.0,
                            width: double.infinity,
                            image:
                                NetworkImage(model.data.products[index].image),
                          ),
                          if (model.data.products[index].discount != 0)
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              color: Colors.red,
                              child: Text(
                                'خصم',
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.white),
                              ),
                            )
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Text(
                              model.data.products[index].name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(fontSize: 14.0, height: 1.3),
                            ),
                            Row(
                              children: [
                                Text(
                                  model.data.products[index].price
                                          .round()
                                          .toString() +
                                      ' ج.م ',
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      height: 1.3,
                                      color: kPrimaryColor),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                if (model.data.products[index].discount != 0)
                                  Text(
                                    model.data.products[index].oldPrice
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
                                      backgroundColor:
                                          HomeCubit.get(context).fav[
                                                  model.data.products[index].id]
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
                                      HomeCubit.get(context).changeFav(model.data.products[index].id);
                                    })
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
Widget slider(HomeModel model) => CarouselSlider(
      items: model.data.banners
          .map(
            (e) => Image(
              image: NetworkImage(e.image),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          )
          .toList(),
      options: CarouselOptions(
        viewportFraction: 1.0,
        height: 250.0,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(seconds: 1),
        autoPlayCurve: Curves.fastOutSlowIn,
        scrollDirection: Axis.horizontal,
      ),
    );
Widget buildCategoriesItem(DataModel model) => Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: [
        Image(
          image: NetworkImage(model.image),
          height: 100,
          width: 100,
          fit: BoxFit.cover,
        ),
        Container(
          width: 100.0,
          child: Text(
            model.name,
            style: TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          color: Colors.black.withOpacity(0.8),
        ),
      ],
    );
