import 'package:chat/models/restaurants.dart';
import 'package:chat/screens/home/title_view.dart';
import 'package:chat/screens/restaurantDetail/categoriUptoDown.dart';
import 'package:chat/widgets/common_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ratingview extends StatelessWidget {
  final AnimationController animationController;
  final Restaurants restData;
  final FoodDtail fooddata;
  const Ratingview({
    super.key,
    required this.restData,
    required this.animationController,
    required this.fooddata,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CommonCardState(
          radius: 16,
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        (restData.rating * 2).toStringAsFixed(1),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSansThai(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        (restData.rating * 2).toStringAsFixed(1),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSansThai(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SizedBox(
                      width: 60,
                      child: Text(
                        (restData.rating * 2).toStringAsFixed(1),
                        textAlign: TextAlign.left,
                        style: GoogleFonts.notoSansThai(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        TitleView(
            titleText: 'Popular Food',
            animationController: animationController,
            animation: animationController,
            click: () {},
            textColor: Colors.black),
        CategoriuptodownSinggle(
          data: restData,
          isHotDeal: false,
          fooddata: fooddata,
        )
      ],
    );
  }
}
