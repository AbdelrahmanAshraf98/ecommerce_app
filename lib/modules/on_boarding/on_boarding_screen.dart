import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_app/modules/login/login_screen.dart';
import 'package:shop_app/shared/components/components.dart';
import 'package:shop_app/shared/network/local/cache_helper.dart';
import 'package:shop_app/shared/styles/color.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({
    @required this.title,
    @required this.body,
    @required this.image,
  });
}

class OnBoardingScreen extends StatelessWidget {
  List<BoardingModel> boarding = [
    BoardingModel(
      image: 'assets/images/empty_cart.png',
      title: 'On Board 1 Title',
      body: 'On Board 1 Body',
    ),
    BoardingModel(
      image: 'assets/images/online_groceries.png',
      title: 'On Board 2 Title',
      body: 'On Board 2 Body',
    ),
    BoardingModel(
      image: 'assets/images/shopping_app.png',
      title: 'On Board 3 Title',
      body: 'On Board 3 Body',
    )
  ];
  var boardController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
        ),
        backwardsCompatibility: false,
        actions :[
          TextButton(onPressed: () {
            CacheHelper.saveData(key: 'onBoard', value: true).then((value) =>
                navigateAndFinish(context, LoginScreen()));
          },
            child: Text('SKIP',style: TextStyle(color: kPrimaryColor),),),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: boardController,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) =>
                    buildBoardingItem(boarding[index]),
                itemCount: 3,
              ),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardController,
                  count: 3,
                  effect: ExpandingDotsEffect(
                      activeDotColor: kPrimaryColor,
                      dotColor: Colors.grey,
                      dotHeight: 10,
                      dotWidth: 10,
                      expansionFactor: 4),
                ),
                Spacer(),
                FloatingActionButton(
                  backgroundColor: kPrimaryColor,
                  onPressed: () {
                    if (boardController.page == 2){
                      CacheHelper.saveData(key: 'onBoard', value: true).then((value) =>
                          navigateAndFinish(context, LoginScreen()));
                    }
                    boardController.nextPage(
                      duration: Duration(milliseconds: 750),
                      curve: Curves.fastLinearToSlowEaseIn,
                    );
                  },
                  child: Icon(Icons.arrow_forward_ios),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

Widget buildBoardingItem(BoardingModel model) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Image(
            image: AssetImage(model.image),
          ),
        ),
        SizedBox(
          height: 30.0,
        ),
        Text(
          model.title,
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          model.body,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
      ],
    );
