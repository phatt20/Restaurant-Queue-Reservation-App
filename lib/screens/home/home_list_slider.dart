import 'dart:async';

import 'package:chat/models/restaurants.dart';
import 'package:chat/screens/home/smoothpage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeListSlider extends StatefulWidget {
  final double opValue;
  final VoidCallback click;

  const HomeListSlider({super.key, required this.opValue, required this.click});

  @override
  State<HomeListSlider> createState() => _HomeListSliderState();
}

class _HomeListSliderState extends State<HomeListSlider> {
  var pageController = PageController(initialPage: 0);
  List<PageViewData> pageViewData = [];
  late Timer sliderTimer;
  var currentShowIndex = 0;

  @override
  void initState() {
    super.initState();
    pageViewData.add(PageViewData(
        assetsImage: 'assets/images/res1.jpg',
        titleTextPageView: 'Burger God',
        subText: 'five_star ระดับเทพ อร้อยมกกกกกก'));
    pageViewData.add(PageViewData(
        assetsImage: 'assets/images/res2.jpg',
        titleTextPageView: 'KFC',
        subText: 'five_star'));
    pageViewData.add(
      PageViewData(
          assetsImage: 'assets/images/res3.jpg',
          titleTextPageView: 'Mac',
          subText: 'five_star'),
    );
    pageViewData.add(
      PageViewData(
          assetsImage: 'assets/images/res4.jpg',
          titleTextPageView: 'Mhuta',
          subText: 'five_star'),
    );

    sliderTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (mounted) {
        if (currentShowIndex < pageViewData.length - 1) {
          currentShowIndex++;
        } else {
          currentShowIndex = 0;
        }
        pageController.animateToPage(
          currentShowIndex,
          duration: const Duration(seconds: 1),
          curve: Curves.fastOutSlowIn,
        );
      }
    });
  }

  @override
  void dispose() {
    sliderTimer.cancel();
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          PageView.builder(
            controller: pageController,
            pageSnapping: true,
            onPageChanged: (index) {
              setState(() {
                currentShowIndex = index;
              });
            },
            scrollDirection: Axis.horizontal,
            itemCount: pageViewData.length,
            itemBuilder: (BuildContext context, int index) {
              return PagePopup(
                imageData: pageViewData[index],
                opValue: widget.opValue,
              );
            },
          ),
          Positioned(
            bottom: 15,
            left: 350,
            right: 0,
            child: SmoothPageIndicator(
              controller: pageController,
              count: pageViewData.length,
            ),
          ),
        ],
      ),
    );
  }
}

class PagePopup extends StatelessWidget {
  final PageViewData imageData;
  final double opValue;
  const PagePopup({super.key, required this.imageData, required this.opValue});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.width * 1.3,
          width: MediaQuery.of(context).size.width * 1.3,
          child: Image.asset(
            imageData.assetsImage,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: 100,
          left: 24,
          right: 24,
          child: Opacity(
            opacity: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(imageData.titleTextPageView,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.getFont('Lato',
                        fontSize: 28,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(
                  height: 8,
                ),
                Text(imageData.subText,
                    textAlign: TextAlign.left,
                    style: GoogleFonts.getFont('Lato',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
