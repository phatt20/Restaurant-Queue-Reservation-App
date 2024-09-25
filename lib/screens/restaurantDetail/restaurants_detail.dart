import 'dart:ui';
import 'package:chat/models/restaurants.dart';
import 'package:chat/screens/home/buttoncustom.dart';
import 'package:chat/screens/home/rowdetail.dart';
import 'package:chat/screens/queue/queue.dart';
import 'package:chat/screens/restaurantDetail/ratingview.dart';
import 'package:chat/screens/restaurantDetail/summary_text.dart';
import 'package:chat/widgets/common_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Restaurantsdetail extends StatefulWidget {
  const Restaurantsdetail(
      {super.key, required this.resdata, required this.fooddata});

  final Restaurants resdata;
  final FoodDtail fooddata;
  @override
  State<Restaurantsdetail> createState() => _RestaurantsdetailState();
}

class _RestaurantsdetailState extends State<Restaurantsdetail>
    with TickerProviderStateMixin {
  late ScrollController scrollController;
  late AnimationController animationController;
  late AnimationController _animationController;
  late double imageHeight;

  bool isfav = false;
  bool showMoreDetails = false; // Track if more details is pressed

  @override
  void initState() {
    super.initState();
    scrollController = ScrollController(initialScrollOffset: 0);
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 0),
    );
    animationController.forward();
    scrollController.addListener(() {
      if (mounted) {
        if (scrollController.offset > 0.0 &&
            scrollController.offset < imageHeight) {
          if (scrollController.offset < (imageHeight / 1.2)) {
            _animationController.value =
                (scrollController.offset / imageHeight).clamp(0.0, 1.0);
          } else {
            _animationController.value =
                ((imageHeight / 1.2) / imageHeight).clamp(0.0, 1.0);
          }
        } else {
          _animationController.value = 0.0;
        }
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    _animationController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    imageHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          CommonCardState(
            radius: 0,
            color: Theme.of(context).scaffoldBackgroundColor,
            child: ListView(
              controller: scrollController,
              padding: EdgeInsets.only(top: 330 + imageHeight / 2),
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: getResDetail(true),
                ),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Divider(
                    height: 1,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24, right: 24),
                  child: Row(
                    children: [
                      Expanded(
                        child: SummaryText(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Ratingview(
                    restData: widget.resdata,
                    animationController: animationController,
                    fooddata: widget.fooddata,
                  ),
                ),
              ],
            ),
          ),
          _backgroundImageUI(widget.resdata),
          Padding(
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            child: Container(
              padding: const EdgeInsets.all(10),
              height: 50,
              child: Row(
                children: [
                  _getAppBarUi(
                    Theme.of(context).disabledColor.withOpacity(0.4),
                    Icons.arrow_back,
                    Colors.white,
                    () {
                      Navigator.pop(context);
                    },
                  ),
                  const Spacer(),
                  _getAppBarUi(
                    Theme.of(context).disabledColor.withOpacity(0.4),
                    isfav ? Icons.favorite : Icons.favorite_border,
                    Colors.red,
                    () {
                      setState(() {
                        isfav = !isfav;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getAppBarUi(
      Color color, IconData icon, Color? iconColor, VoidCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: const BorderRadius.all(
          Radius.circular(32.0),
        ),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(
            icon,
            color: iconColor, // Ensure you set correct color here
          ),
        ),
      ),
    );
  }

  Widget _backgroundImageUI(Restaurants resdata) {
    return Positioned(
        top: 0,
        left: 0,
        right: 0,
        child: AnimatedBuilder(
          animation: _animationController,
          builder: (BuildContext context, Widget? child) {
            double scrollOffset =
                scrollController.hasClients ? scrollController.offset : 0.0;
            double maxHeight = imageHeight * 0.8; // ตั้งความสูงสูงสุดของรูปภาพ
            double minHeight = 200; // ตั้งความสูงขั้นต่ำของรูปภาพ

            // คำนวณความสูงของรูปภาพตามการเลื่อน
            double height =
                (maxHeight - scrollOffset).clamp(minHeight, maxHeight);

            var opacity = 1.0 -
                (_animationController.value >=
                        ((imageHeight / 1.2) / imageHeight)
                    ? 1.0
                    : _animationController.value);

            return SizedBox(
              height: height,
              child: Stack(
                children: [
                  Positioned(
                    child: Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Opacity(
                            opacity: opacity,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Image.network(
                                resdata.BackGround_Res,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: MediaQuery.of(context).padding.bottom + 170,
                          left: 0,
                          right: 0,
                          child: Opacity(
                            opacity: opacity,
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.only(
                                    left: 24,
                                    right: 24,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(24)),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 10.0,
                                        sigmaY: 10.0,
                                      ),
                                      child: Container(
                                        color: Colors.black12,
                                        padding: const EdgeInsets.all(4.0),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 4),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 8,
                                              ),
                                              child: SizedBox(
                                                child: getResDetail(false),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                bottom: 16,
                                                top: 16,
                                              ),
                                              child: CustomButton(
                                                text: "จองคิว",
                                                backgroundColor:
                                                    Colors.blueAccent,
                                                textColor: Colors.white,
                                                width: 100,
                                                height: 40,
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          const QueueTest(),
                                                    ),
                                                  );
                                                },
                                                textStyle: null,
                                                minWidth: 100,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Center(
                                  child: ClipRect(
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 3.0,
                                        sigmaY: 3.0,
                                      ),
                                      child: Container(
                                        color: Colors.black12,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                            splashColor: Theme.of(context)
                                                .primaryColor
                                                .withOpacity(0.2),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            onTap: () {
                                              setState(() {
                                                showMoreDetails =
                                                    !showMoreDetails;
                                              });
                                              if (showMoreDetails) {
                                                scrollController.animateTo(
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height -
                                                      MediaQuery.of(context)
                                                              .size
                                                              .height /
                                                          5,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.fastOutSlowIn,
                                                );
                                              } else {
                                                scrollController.animateTo(
                                                  0,
                                                  duration: const Duration(
                                                      milliseconds: 500),
                                                  curve: Curves.fastOutSlowIn,
                                                );
                                              }
                                            },
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                left: 16,
                                                right: 16,
                                                top: 4,
                                                bottom: 4,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    showMoreDetails
                                                        ? 'less_details'
                                                        : 'more_details',
                                                    style: GoogleFonts
                                                        .notoSansThai(
                                                      fontSize: 14,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 2),
                                                    child: Icon(
                                                      showMoreDetails
                                                          ? Icons
                                                              .keyboard_arrow_up
                                                          : Icons
                                                              .keyboard_arrow_down,
                                                      color: Colors.white,
                                                      size: 24,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  getResDetail(bool isInList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.resdata.titleTxt,
                textAlign: TextAlign.left,
                style: GoogleFonts.notoSansThai(
                  fontSize: 21,
                  color:
                      isInList ? Theme.of(context).primaryColor : Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              isInList
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Row(
                        children: [
                          Rowdetail(
                            text: widget.resdata.dataTxt,
                            rating: widget.resdata.rating.toString(),
                            color: Colors.white,
                            star: true,
                          ),
                          const SizedBox(
                            width: 6,
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "หัวละ",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSansThai(
                  fontSize: 22,
                  color: isInList
                      ? Theme.of(context).textTheme.bodyLarge!.color
                      : Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "100",
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.notoSansThai(
                fontSize: 14,
                color: isInList
                    ? Theme.of(context).disabledColor.withOpacity(0.5)
                    : Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
