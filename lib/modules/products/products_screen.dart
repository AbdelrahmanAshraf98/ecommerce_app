import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional/conditional.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop_app/layouts/cubit/cubit.dart';
import 'package:shop_app/layouts/cubit/states.dart';
import 'package:shop_app/models/home_model.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/styles/color.dart';

class ProductScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeStates>(
      listener: (context, state) {},
      builder: (context, state) {
        return Conditional(
          condition: HomeCubit.get(context).homeModel != null,
          onConditionTrue: productsBuilder(HomeCubit.get(context).homeModel),
          onConditionFalse: (Center(child: circularProgress())),
        );
      },
    );
  }

  Widget productsBuilder(HomeModel model) => SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          children: [
            CarouselSlider(
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
                height: 200.0,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                autoPlayAnimationDuration: Duration(seconds: 1),
                autoPlayCurve: Curves.fastOutSlowIn,
                scrollDirection: Axis.horizontal,
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
                childAspectRatio: 1 / 1.45,
                crossAxisCount: 2,
                children: List.generate(
                  model.data.products.length,
                  (index) => Container(
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: AlignmentDirectional.bottomStart,
                          children: [
                            Image(
                              height: 150.0,
                              width: double.infinity,
                              image: NetworkImage(
                                  model.data.products[index].image),
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
                                          decoration:
                                              TextDecoration.lineThrough),
                                    ),
                                  Spacer(),
                                  IconButton(
                                      icon:Icon(Icons.favorite_border_outlined,size: 14.0,),
                                      onPressed: () {})
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
}
