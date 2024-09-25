import 'package:flutter/material.dart';

class PageViewData {
  PageViewData({
    required this.assetsImage,
    required this.titleTextPageView,
    required this.subText,
  });
  final String titleTextPageView;
  final String subText;
  final String assetsImage;
}

class FoodDtail {
  FoodDtail({
    required this.dataTxt,
    required this.rating,
    required this.imagePath,
    required this.titleTxt,
  });

  final String dataTxt;
  final String titleTxt;
  final String imagePath;
  final int rating;
}

class Restaurants {
  Restaurants(
    this.widget,  {
    required this.imagePath,
    required this.BackGround_Res,
    required this.fivetopersen_img,
    required this.titleTxt,
    required this.subTxt,
    required this.dataTxt,
    required this.isSelected,
    required this.rating,
  });
  final String BackGround_Res;
  final String fivetopersen_img;
  final String imagePath;
  final String titleTxt;
  final String subTxt;
  final String dataTxt;

  final int rating;

  final bool isSelected;
  final Widget? widget;

  get color => null;
}
