// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:shop_app/login/login/login.dart';
import 'package:shop_app/network/cach_helper.dart';
import 'package:shop_app/component/widgets.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class BoardingModel {
  final String image;
  final String title;
  final String body;

  BoardingModel({required this.image, required this.title, required this.body});
}

class OnBordingScreen extends StatefulWidget {
  @override
  State<OnBordingScreen> createState() => _OnBordingScreenState();
}

class _OnBordingScreenState extends State<OnBordingScreen> {
  var boardController = PageController();

  List<BoardingModel> boarding = [
    BoardingModel(
        image:
            'https://elearningindustry.com/wp-content/uploads/2021/10/a-successful-remote-onboarding-guide.jpg',
        title: 'Onboard 1 title',
        body: 'Onboard 1 body'),
    BoardingModel(
        image:
            'https://elearningindustry.com/wp-content/uploads/2021/10/a-successful-remote-onboarding-guide.jpg',
        title: 'Onboard 2 title',
        body: 'Onboard 2 body'),
    BoardingModel(
        image:
            'https://elearningindustry.com/wp-content/uploads/2021/10/a-successful-remote-onboarding-guide.jpg',
        title: 'Onboard 3 title',
        body: 'Onboard 3 body'),
  ];

  void submit() {
    CachHelper.saveData(key: 'onBoarding', value: true).then((value) {
      if (value) {
        navigateAndReplace(context, LoginScreen());
      }
    });
  }

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      builder: (BuildContext context, Widget? child) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  onPageChanged: (int index) {
                    if (index == boarding.length - 1) {
                      setState(() {
                        isLast = true;
                      });
                    } else {
                      setState(() {
                        isLast = false;
                      });
                    }
                  
                  },
                  controller: boardController,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) =>
                      BordingItems(boarding[index]),
                  itemCount: boarding.length,
                ),
              ),
              SizedBox(
                height: 50.0.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: () {
                      //on boarding cach
                      CachHelper.putBolean(key: 'onBoarding', value: false);
                      navigateAndReplace(context, LoginScreen());
                    },
                    child: Text(
                      'Skip',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
                    ),
                  ),
                  SmoothPageIndicator(
                      effect: ExpandingDotsEffect(
                          activeDotColor: Colors.blue,
                          dotColor: Colors.grey,
                          dotHeight: 10.h,
                          dotWidth: 10.w,
                          expansionFactor: 2,
                          spacing: 5.w),
                      controller: boardController,
                      count: boarding.length),
                  TextButton(
                    onPressed: () {
                      if (isLast == true) {
                        //on boarding cach
                        CachHelper.putBolean(key: 'onBoarding', value: false);
                        navigateAndReplace(context, LoginScreen());
                      } else {
                        boardController.nextPage(
                            duration: Duration(milliseconds: 750),
                            curve: Curves.fastLinearToSlowEaseIn);
                      }
                    },
                    child: Text(
                      'Next',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget BordingItems(BoardingModel model) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Image(
              image: NetworkImage(model.image),
            ),
          ),
          SizedBox(
            height: 30.0.h,
          ),
          Text(
            model.title,
            style: TextStyle(fontSize: 24.0.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            model.body,
            style: TextStyle(fontSize: 15.0.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 15.h,
          )
        ],
      );
}
